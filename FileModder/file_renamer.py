import os

def remove_strings_from_filenames(folder_path, strings_to_remove, recursive):
    try:
        # Check if recursive is enabled
        if recursive == "Yes":
            # Walk through all directories and subdirectories
            for dirpath, dirnames, filenames in os.walk(folder_path):
                print(f"\nProcessing folder: {dirpath}")  # Print the current folder
              
                for file_name in filenames:
                    process_file(dirpath, file_name, strings_to_remove)
        else:
            # Only process the files in the given folder (non-recursive)
            files = os.listdir(folder_path)
            for file_name in files:
                process_file(folder_path, file_name, strings_to_remove)

        print("\nAll applicable files have been renamed.")
    except Exception as e:
        print(f"\n\n\nAn error occurred: {e}")

def process_file(folder_path, file_name, strings_to_remove):
    # Strip spaces from the file name first, even if no modifications will be done
    name, extension = os.path.splitext(file_name.strip())  # Strip spaces around the entire filename
    original_name = name + extension  # Keep the original name for comparison (including the extension)

    # Check if any of the strings to remove exist in the file name (case insensitive)
    for string_to_remove in strings_to_remove:
        # Strip spaces from the string to remove and make it case-insensitive
        stripped_string = string_to_remove.strip().lower()
        
        # Remove the string (case insensitive) and replace with empty string
        name = name.lower().replace(stripped_string, "")
    
    # Replace double underscores with a single underscore
    name = name.replace("__", "_")
    
    # Apply a final .strip() to ensure no leading/trailing spaces remain before renaming
    name = name.strip()

    # Ensure no trailing spaces before the extension
    new_name_with_extension = name.rstrip() + extension.strip()

    # If the name changed, rename the file
    if new_name_with_extension != original_name:
        old_path = os.path.join(folder_path, original_name)
        new_path = os.path.join(folder_path, new_name_with_extension)
        os.rename(old_path, new_path)
        print(f"Renamed: {original_name} -> {new_name_with_extension}")


####################################################################
####################################################################
####################################################################


if __name__ == "__main__":


    folder_path = "/home/federico/Downloads" 

    # folder_path = "/home/federico/Downloads/Playlist"
    # folder_path = "/home/federico/Downloads/YTDownloads" 
    

    strings_to_remove = [ '＂' , '"' , "[" , "]" , "#" , "," , ":","：","”" , '”', "“",

    "live", "w⧸sabaku maratona" , "Review Blind Run" , "w⧸Sabaku"  
                    
                        ] 



    # Set recursive option
    recursive = "Yes"  # "Yes" / "No"

    # Check if the folder exists
    if os.path.isdir(folder_path):
        remove_strings_from_filenames(folder_path, strings_to_remove, recursive)
    else:
        print("The provided folder path does not exist. Please check and try again.")
