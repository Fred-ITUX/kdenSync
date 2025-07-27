import os
import subprocess


def convert_images_in_folder(folder_path, recursive, delete_original):
    try:
       
       
        #### Check recursive
        if recursive == "Yes":
            
            #### Walk through all directories and subdirectories
            for dirpath, dirnames, filenames in os.walk(folder_path):
                print(f"\nProcessing folder: {dirpath}")
                for file_name in filenames:
                    process_image(dirpath, file_name, delete_original)
        

        else:
            # Only process the files in the given folder (non-recursive)
            files = os.listdir(folder_path)
            print(f'\nProcessing folder:{folder_path}')
            for file_name in files:
                process_image(folder_path, file_name, delete_original)


        #print("\nAll applicable images have been converted.")
    except Exception as e:
        print(f"\nAn error occurred: {e}")

####################################################################

def process_image(folder_path, file_name, delete_original):
    name, extension = os.path.splitext(file_name)
    old_path = os.path.join(folder_path, file_name)

    # Determine the conversion based on file extension
    if extension.lower() == ".webp":
        new_name = name + ".png"
        new_path = os.path.join(folder_path, new_name)
        if convert_image(old_path, new_path, "png") and delete_original == "Yes":
            delete_file(old_path)

####################################################################

def convert_image(input_path, output_path, format):
    try:
        # Use ffmpeg for conversion and show progress in the terminal
        subprocess.run(
            ["ffmpeg", "-y", "-i", input_path, output_path],
            check=True
        )
        #print(f"Converted: {input_path} -> {output_path}")
        return True
    except subprocess.CalledProcessError as e:
        print(f"Failed to convert {input_path}. Error: {e}")
        return False

####################################################################

def delete_file(file_path):
    try:
        os.remove(file_path)
        #print(f"Deleted original file: {file_path}")
    except Exception as e:
        None
        #print(f"Failed to delete {file_path}. Error: {e}")





####################################################################
####################################################################
####################################################################





defaultFolder   = "/home/federico/Downloads"
folder_path     = input(f"Default folder {defaultFolder}:\n").strip()

if folder_path == '':
    folder_path = "/home/federico/Downloads"


if __name__ == "__main__":
    
    recursive           = "No"      # "Yes" / "No"
    delete_original     = "Yes"     # "Yes" / "No"

    #### Dir check
    if os.path.isdir(folder_path):
        convert_images_in_folder(folder_path, recursive, delete_original)
    else:
        print("The folder path does not exist")
