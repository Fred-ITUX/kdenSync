#!/usr/bin/env python3
from datetime import timedelta
from typing import List, Tuple

def to_seconds(time_str: str) -> int:
    """Convert 'MM:SS' or 'H:MM:SS' to total seconds."""
    parts = list(map(int, time_str.split(':')))
    if len(parts) == 2:
        m, s = parts
        return m * 60 + s
    elif len(parts) == 3:
        h, m, s = parts
        return h * 3600 + m * 60 + s
    raise ValueError(f"Unsupported time format: {time_str}")

def format_mm_ss(seconds: int) -> str:
    """Format total seconds as 'MM:SS' (or 'H:MM:SS' if >1h)."""
    td = timedelta(seconds=seconds)
    total_secs = int(td.total_seconds())
    h, remainder = divmod(total_secs, 3600)
    m, s = divmod(remainder, 60)
    if h:
        return f"{h:d}:{m:02d}:{s:02d}"
    return f"{m:02d}:{s:02d}"

def merge_timestamps(
    video_lengths: List[str],
    raw_timestamps: List[List[Tuple[str, str]]],
    reduction_seconds: int = 0
) -> List[Tuple[str, str]]:
    """
    Merge timestamp lists into one continuous timeline.

    Args:
        video_lengths: List of part durations as 'MM:SS'.
        raw_timestamps: List of lists of (timestamp, label).
        reduction_seconds: Seconds to subtract from each timestamp (clamped to 0).

    Returns:
        List of (merged_timestamp, label) in 'MM:SS' format.
    """
    # Convert video lengths to seconds
    lengths_sec = [to_seconds(t) for t in video_lengths]
    
    merged = []
    offset = 0
    for part_index, part in enumerate(raw_timestamps):
        for ts, label in part:
            orig = to_seconds(ts)
            adjusted = max(0, orig - reduction_seconds) + offset
            merged.append((format_mm_ss(adjusted), label))
        offset += lengths_sec[part_index]
    return merged




######################################################################################
######################################################################################
######################################################################################




if __name__ == "__main__":



    #### Total video lengths (Ex.: "27:09", "24:18" )
    video_lengths = [  ]
    




    
    #### Timestamps for each video (Ex.: ("00:00","Timesamp name"), ....   )
    raw = [ 

            []

    ]
    
    
    
    #### time removed by the total of each video (~7s from the removed intro)
    reduction = 15

    result = merge_timestamps(video_lengths, raw, reduction)
    for ts, label in result:
        print(f"{ts}  {label}")
