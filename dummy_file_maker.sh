#!/bin/bash

read -p 'Enter path: ' source_path
fileExt="mkv"
dest_path="$HOME/Downloads/"$fileExt"_dummy" 

mkdir -p "$dest_path"

if [ "$source_path" == "" ]; then
    echo -e "Path error"
else 
    #### Find all .mkv files in the directory and create dummy to keep filenames
    find "$source_path" -maxdepth 1 -type f -name "*.$fileExt" -print0 | while IFS= read -r -d '' file; do
        filename=$(basename "$file")
        dummy="$dest_path/$filename"
        touch "$dummy"
    done
    echo "Created dummys into: $dest_path"
fi