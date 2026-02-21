#!/bin/bash


####        IF AUDIO TRACKS ARE NOT LABELED
#### mpv --aid=1 input.mkv --- mpv --aid=2 input.mkv  ... 


read -p 'Audio track to keep (all other tracks will be eliminated): ' KEEP_AID
TMP_SUFFIX=".tmp.mkv"
SUFFIX="zzz_" 

for f in *.mkv; do

    [ -e "$f" ] || continue

    echo "Processing: $f"

    mv -n "$f" "${SUFFIX}${f}" || {
        echo "⚠️ Backup already exists, skipping." #### Rename original as backup
        continue
    }

    mkvmerge -o "$f" -a "$KEEP_AID" "${SUFFIX}${f}" || {
        echo "  ❌ mkvmerge failed, restoring original."  #### Create new file with original name
        mv -f "${SUFFIX}${f}" "$f"
        continue
    }

    echo "  ✔ Done"
done
