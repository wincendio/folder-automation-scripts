#!/usr/bin/env bash
# batch_extract_audio.sh
# Extract audio from all .mkv files in the current directory to .aac files.
#
# Dependencies: ffmpeg
#   Install: sudo apt install ffmpeg  OR  brew install ffmpeg
#
# Usage: cd /your/video/folder && bash /path/to/batch_extract_audio.sh

set -euo pipefail

OUTPUT_DIR="$(pwd)/audio_output"
mkdir -p "$OUTPUT_DIR"

shopt -s nullglob
mkv_files=(*.mkv)

if [ ${#mkv_files[@]} -eq 0 ]; then
  echo "No .mkv files found in $(pwd)"
  exit 0
fi

echo "Found ${#mkv_files[@]} MKV file(s). Extracting audio..."

for f in "${mkv_files[@]}"; do
  base="${f%.mkv}"
  out="$OUTPUT_DIR/${base}.aac"
  echo "  $f -> audio_output/${base}.aac"
  ffmpeg -i "$f" -vn -acodec copy "$out" -y -loglevel error
done

echo "\nDone. Audio files saved to: $OUTPUT_DIR"
