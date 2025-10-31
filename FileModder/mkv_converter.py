#!/usr/bin/env python3
import os
import subprocess
import sys
import time
from datetime import datetime

# =======================
# CONFIGURATION
# =======================
default_folder = os.path.expanduser("~/Downloads")
output_ext = ".mkv"

# GPU encoder settings
gpu_encoder = "h264_vaapi"
low_power = 0  # 0 = full GPU speed
tiles = "4x4"  # optional, parallelism

# Preset fixed to high_quality
video_presets = {
    "high_quality": {"qp": 22},  # adjust QP to control file size
}

audio_bitrate = "256k"

# Delete original after successful conversion? 'y' or 'n'
delete_original = "n"

# =======================
# FUNCTIONS
# =======================
def human_time(seconds):
    h = int(seconds // 3600)
    m = int((seconds % 3600) // 60)
    s = int(seconds % 60)
    return f"{h:02}:{m:02}:{s:02}"

def progress_bar(percent, width=40):
    filled = int(width * percent / 100)
    bar = "█" * filled + "-" * (width - filled)
    return f"[{bar}] {percent:6.2f}%"

def build_ffmpeg_command(input_file, output_file, preset):
    v_opts = video_presets[preset]
    cmd = [
        "ffmpeg",
        "-y",
        "-hwaccel", "vaapi",
        "-vaapi_device", "/dev/dri/renderD128",
        "-i", input_file,
        "-vf", "format=nv12,hwupload",
        "-c:v", gpu_encoder,
        "-qp", str(v_opts["qp"]),
        "-low_power", str(low_power),
        "-tiles", tiles,
        "-c:a", "aac",
        "-b:a", audio_bitrate,
        output_file,
        "-progress", "pipe:1",
        "-nostats"
    ]
    return cmd

def get_video_duration(file_path):
    """Returns duration in seconds"""
    result = subprocess.run(
        ["ffprobe", "-v", "error", "-select_streams", "v:0",
         "-show_entries", "format=duration", "-of", "default=noprint_wrappers=1:nokey=1", file_path],
        stdout=subprocess.PIPE, stderr=subprocess.PIPE, text=True
    )
    return float(result.stdout.strip())

# =======================
# MAIN PROCESS
# =======================
def convert_folder(folder):
    print(f"=== Starting processing folder: {folder} ===")
    for file in os.listdir(folder):
        if not file.lower().endswith((".mp4", ".mov", ".mkv")):
            continue

        input_path = os.path.join(folder, file)
        output_file = os.path.splitext(input_path)[0] + output_ext
        log_file = os.path.splitext(input_path)[0] + ".txt"

        start_time = datetime.now()
        print(f"\nStarting {start_time.strftime('%Y-%m-%d %H:%M:%S')}: {input_path}")

        # write start info to log
        with open(log_file, "w") as f:
            f.write(f"{'='*60}\n")
            f.write(f"Conversion started: {start_time.strftime('%Y-%m-%d %H:%M:%S')}\n")
            f.write(f"\nInput file: {input_path}\n")
            f.write(f"\nOutput file: {output_file}\n")

        ffmpeg_cmd = build_ffmpeg_command(input_path, output_file, "high_quality")
        process = subprocess.Popen(ffmpeg_cmd, stdout=subprocess.PIPE, stderr=subprocess.STDOUT, universal_newlines=True, bufsize=1)

        total_seconds = get_video_duration(input_path)

        # Parse ffmpeg progress
        while True:
            line = process.stdout.readline()
            if not line:
                if process.poll() is not None:
                    break
                continue
            line = line.strip()
            if line.startswith("out_time_ms="):
                out_ms = int(line.split('=')[1])
                elapsed_sec = out_ms / 1_000_000
                percent = min((elapsed_sec / total_seconds) * 100, 100)
                print(f"\r{progress_bar(percent)} {human_time(elapsed_sec)} / {human_time(total_seconds)}", end="", flush=True)

        process.wait()
        end_time = datetime.now()
        duration = (end_time - start_time).total_seconds()
        print(f"\n✅ Finished conversion: {input_path} at {end_time.strftime('%Y-%m-%d %H:%M:%S')}")
        print(f"Duration: {human_time(duration)}")

        # write end info to log
        with open(log_file, "a") as f:
            f.write(f"\nConversion ended:   {end_time.strftime('%Y-%m-%d %H:%M:%S')}\n")
            f.write(f"Total duration:    {human_time(duration)}\n")
            f.write(f"{'='*60}\n")

        # Delete original if configured
        if delete_original.lower() == "y":
            try:
                os.remove(input_path)
                print(f"🗑 Deleted original: {input_path}")
            except Exception as e:
                print(f"⚠ Could not delete {input_path}: {e}")

    print("\n=== All applicable files have been converted ===")

# =======================
# RUN SCRIPT
# =======================
if __name__ == "__main__":
    folder = input(f"Default folder {default_folder}:\n") or default_folder
    if not os.path.exists(folder):
        print("Folder does not exist:", folder)
        sys.exit(1)

    convert_folder(folder)
