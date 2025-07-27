import os
from mutagen.easyid3 import EasyID3

def remove_strings_and_edit_metadata(folder_path, strings_to_remove, artist, album, title_case_title):
    try:
        # Process all files in the folder
        files = os.listdir(folder_path)
        for file_name in files:
            process_file(folder_path, file_name, strings_to_remove, artist, album, title_case_title)

        print("All applicable files have been renamed and metadata updated.")
    except Exception as e:
        print(f"An error occurred: {e}")

def process_file(folder_path, file_name, strings_to_remove, artist, album, title_case_title):
    # Separate the file name and extension
    name, extension = os.path.splitext(file_name.strip())  # Strip spaces around the filename
    original_name = name + extension  # Keep the original name for comparison (including the extension)

    # Remove specified strings from the name
    for string_to_remove in strings_to_remove:
        stripped_string = string_to_remove.strip().title()
        name = name.title().replace(stripped_string, "")

    # Apply a final .strip() to ensure no leading/trailing spaces remain
    name = name.strip()

    # Reassemble the cleaned filename with the extension
    new_name_with_extension = name + extension.strip()

    # Rename the file if the name has changed
    if new_name_with_extension != original_name:
        old_path = os.path.join(folder_path, original_name)
        new_path = os.path.join(folder_path, new_name_with_extension)
        os.rename(old_path, new_path)
        print(f"Renamed: {original_name} -> {new_name_with_extension}")
    else:
        new_path = os.path.join(folder_path, new_name_with_extension)  # Use the current path if unchanged

    # If the file is an MP3, update its metadata
    if extension.lower() == ".mp3":
        edit_metadata(new_path, name, artist, album, title_case_title)

def edit_metadata(file_path, title, artist, album, title_case_title):
    try:
        # Apply .title() to title if title_case_title is enabled
        if title_case_title == "Yes":
            title = title.title()

        # Load the MP3 file
        audio = EasyID3(file_path)

        # Set metadata
        audio["title"] = title
        audio["artist"] = artist
        audio["album"] = album

        # Save the changes
        audio.save()
        print(f"Updated metadata for: {file_path}")
    except Exception as e:
        print(f"Failed to update metadata for {file_path}: {e}")



####################################################################
####################################################################
####################################################################



if __name__ == "__main__":
    # Declare variables
    folder_path = ""
    strings_to_remove = [""]

    artist = ""                                 # Replace with desired Artist name
    #album = "My Album Name"                    # Replace with desired Album name
    album = artist
    title_case_title = "Yes"                    # Set to "Yes" to title-case the metadata title

    # Check if the folder exists
    if os.path.isdir(folder_path):
        remove_strings_and_edit_metadata(folder_path, strings_to_remove, artist, album, title_case_title)
    else:
        print("The provided folder path does not exist. Please check and try again.")
