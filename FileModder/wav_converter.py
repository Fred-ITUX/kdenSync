import os
import subprocess


userInput = str(input("1. Wav to Mp3\t 2. Mp3 to Wav:  ")).strip()

if userInput == "1":
    #### WAV to MP3
    old_extension = "wav"
    new_extension = "mp3"

elif userInput == "2":
    #### MP3 to WAV
    old_extension = "mp3"
    new_extension = "wav"
else:
    print(f'Invalid choice')
    exit()



def convert_files_in_folder(folder_path, recursive, delete_original):
    try:
        # Check if recursive is enabled
        if recursive == "Yes":
            # Walk through all directories and subdirectories
            for dirpath, dirnames, filenames in os.walk(folder_path):
                print(f"\nProcessing folder: {dirpath}")  # Print the current folder
                for file_name in filenames:
                    process_file(dirpath, file_name, delete_original)
        else:
            # Only process the files in the given folder (non-recursive)
            files = os.listdir(folder_path)
            for file_name in files:
                process_file(folder_path, file_name, delete_original)

        print("\nAll applicable files have been converted.")
    except Exception as e:
        print(f"\nAn error occurred: {e}")




def process_file(folder_path, file_name, delete_original):
    name, extension = os.path.splitext(file_name)
    old_path = os.path.join(folder_path, file_name)

    # Determine the conversion based on file extension
    if extension.lower() == f".{old_extension}":
        new_name = f"{name}.{new_extension}"
        new_path = os.path.join(folder_path, new_name)
        if convert_file(old_path, new_path, new_extension) and delete_original == "Yes":
            delete_file(old_path)



def convert_file(input_path, output_path, format):
    try:
        # Use ffmpeg for conversion and show progress in the terminal
        subprocess.run(
            ["ffmpeg", "-y", "-i", input_path, output_path],
            check=True
        )
        print(f"Converted: {input_path} -> {output_path}")
        return True
    except subprocess.CalledProcessError as e:
        print(f"Failed to convert {input_path}. Error: {e}")
        return False




def delete_file(file_path):
    try:
        os.remove(file_path)
        print(f"Deleted original file: {file_path}")
    except Exception as e:
        print(f"Failed to delete {file_path}. Error: {e}")






####################################################################
####################################################################
####################################################################


defaultFolder   = "/home/federico/Downloads"
folder_path     = input(f"Default folder {defaultFolder}:\n").strip()

if folder_path == '':
    folder_path = "/home/federico/Downloads"


#### Lower cpu priority to avoid 100% CPU usage
#### nice -n 18 python3 /home/federico/Nextcloud/Python/scripts/FileModder/wav_converter.py

if __name__ == "__main__":

    recursive = "No"            # "Yes" / "No"
    delete_original = "Yes"     # "Yes" / "No"

    # Check if the folder exists
    if os.path.isdir(folder_path):
        convert_files_in_folder(folder_path, recursive, delete_original)
    else:
        print("The provided folder path does not exist")
