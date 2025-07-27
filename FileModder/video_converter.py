import os
import subprocess
import shutil
from datetime import datetime

def log_message(log_file, message):
    """Logs messages to Progress.txt"""
    with open(log_file, "a") as log:
        log.write(message + "\n")

def convert_to_1080p60(input_file, output_file, log_file):
    """
    Converts an MKV video to 1080p 60fps while preserving MKV format.
    Logs progress in Progress.txt.
    """
    start_time = datetime.now()
    log_message(log_file, f"\n[{start_time}] 🎬 Starting conversion: {os.path.basename(input_file)} → {os.path.basename(output_file)}")


    command = [
    "ffmpeg", "-i", input_file,

    #### Resize to 1080p 60fps
    "-vf", "scale=-1:1080,fps=60",
    
    #### H.264 engine -- compression level (optimal range 18-23) -- ultrafast faster encoding, bigger file size
    "-c:v", "libx264", "-crf", "18", "-preset", "ultrafast",    

    #### File size control
    "-b:v", "6M", "-maxrate", "8M", "-bufsize", "12M",          
    
    #### High-quality AAC audio (192k or 256k)
    "-c:a", "aac", "-b:a", "256k",     

    #### Optimize playback start                         
    "-movflags", "+faststart",  
    
    #### Overwrite existing output file
    "-y", output_file,


    #### Suppress FFmpeg console output
    "-loglevel", "quiet" 
]

    
    process = subprocess.run(command)

    end_time = datetime.now()
    if process.returncode == 0:
        log_message(log_file, f"[{end_time}] ✅ Conversion complete: {os.path.basename(output_file)}")
    else:
        log_message(log_file, f"[{end_time}] ❌ Conversion failed for: {os.path.basename(input_file)}")


#############################################################################################

if __name__ == "__main__":

    input_path = input("Path: ").strip()
    #input_path = "/home/federico/Downloads"

    output_folder = os.path.join(input_path, "1080p60_converted")
    done_folder = os.path.join(input_path, "done")
    log_file = os.path.join(input_path, "Progress.txt")

    # Create necessary folders
    os.makedirs(output_folder, exist_ok=True)
    os.makedirs(done_folder, exist_ok=True)

    # Clear previous log
    with open(log_file, "w") as log:
        log.write(f"Conversion Log - {datetime.now()}\n\n")

    # Loop through all files in the folder
    for file_name in os.listdir(input_path):
        input_file = os.path.join(input_path, file_name)

        # Only process .mkv files
        if os.path.isfile(input_file) and file_name.lower().endswith('.mkv'):
            output_file = os.path.join(output_folder, os.path.splitext(file_name)[0] + "_1080p60.mkv")
            
            convert_to_1080p60(input_file, output_file, log_file)

            # Move the processed file to the "done" folder
            shutil.move(input_file, os.path.join(done_folder, file_name))
            log_message(log_file, f"📂 Moved original file to: {done_folder}/{file_name}")










