#!/usr/bin/env python3
"""Transcribe a video file using faster-whisper.

Outputs JSON (with segment timestamps) and plain text to a temp directory.

Usage: python3 transcribe.py <video_file_path> [--model medium]
Returns: Path to output directory containing transcript files.
"""

import json
import os
import sys
import tempfile
from pathlib import Path


def format_timestamp(seconds: float) -> str:
    """Convert seconds to M:SS or H:MM:SS format for YouTube chapters."""
    hours = int(seconds // 3600)
    minutes = int((seconds % 3600) // 60)
    secs = int(seconds % 60)
    if hours > 0:
        return f"{hours}:{minutes:02d}:{secs:02d}"
    return f"{minutes}:{secs:02d}"


def main():
    if len(sys.argv) < 2:
        print("ERROR: No video file path provided.")
        print("Usage: python3 transcribe.py <video_file_path> [--model medium]")
        sys.exit(1)

    video_path = sys.argv[1]
    model_size = "medium"

    # Parse optional --model flag
    if "--model" in sys.argv:
        idx = sys.argv.index("--model")
        if idx + 1 < len(sys.argv):
            model_size = sys.argv[idx + 1]

    if not os.path.isfile(video_path):
        print(f"ERROR: File not found: {video_path}")
        sys.exit(1)

    try:
        from faster_whisper import WhisperModel
    except ImportError:
        print("ERROR: faster-whisper is not installed.")
        print("")
        print("Install with: pip3 install faster-whisper")
        print("")
        print("Also requires ffmpeg:")
        print("  macOS: brew install ffmpeg")
        print("  Ubuntu: sudo apt install ffmpeg")
        sys.exit(1)

    # Create output directory
    output_dir = tempfile.mkdtemp()
    basename = Path(video_path).stem

    print(f"Transcribing: {video_path}")
    print(f"Model: {model_size}")
    print(f"Output directory: {output_dir}")
    print("")

    # Load model and transcribe
    model = WhisperModel(model_size, device="cpu", compute_type="int8")
    segments_iter, info = model.transcribe(video_path, beam_size=5)

    print(f"Detected language: {info.language} (probability: {info.language_probability:.2f})")
    print("Processing segments...")

    segments = []
    full_text_parts = []

    for segment in segments_iter:
        seg_data = {
            "start": round(segment.start, 2),
            "end": round(segment.end, 2),
            "text": segment.text.strip(),
            "start_formatted": format_timestamp(segment.start),
        }
        segments.append(seg_data)
        full_text_parts.append(segment.text.strip())

    # Write JSON with timestamps
    json_path = os.path.join(output_dir, f"{basename}.json")
    json_output = {
        "language": info.language,
        "duration": round(info.duration, 2),
        "segments": segments,
    }
    with open(json_path, "w") as f:
        json.dump(json_output, f, indent=2)

    # Write plain text
    txt_path = os.path.join(output_dir, f"{basename}.txt")
    with open(txt_path, "w") as f:
        f.write(" ".join(full_text_parts))

    print("")
    print("Transcription complete.")
    print(f"JSON (with timestamps): {json_path}")
    print(f"Plain text: {txt_path}")
    print(f"Segments: {len(segments)}")
    print(f"Duration: {format_timestamp(info.duration)}")
    print(f"OUTPUT_DIR={output_dir}")


if __name__ == "__main__":
    main()
