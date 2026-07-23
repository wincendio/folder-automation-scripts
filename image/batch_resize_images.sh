#!/usr/bin/env bash
# batch_resize_images.sh
# Resize all JPG and PNG images in the current directory to a given width.
# Aspect ratio is preserved. Output goes to ./resized/
#
# Dependencies: imagemagick
#   Install: sudo apt install imagemagick  OR  brew install imagemagick
#
# Usage:
#   cd /your/image/folder
#   bash /path/to/batch_resize_images.sh [WIDTH]
#   Example: bash batch_resize_images.sh 1920

set -euo pipefail

WIDTH=${1:-1920}
OUTPUT_DIR="$(pwd)/resized"
mkdir -p "$OUTPUT_DIR"

shopt -s nullglob
img_files=(*.jpg *.jpeg *.png *.JPG *.JPEG *.PNG)

if [ ${#img_files[@]} -eq 0 ]; then
  echo "No image files found in $(pwd)"
  exit 0
fi

echo "Found ${#img_files[@]} image(s). Resizing to width=${WIDTH}px..."

for f in "${img_files[@]}"; do
  echo "  $f -> resized/$f"
  convert "$f" -resize "${WIDTH}>" "$OUTPUT_DIR/$f"
done

echo "\nDone. Resized images saved to: $OUTPUT_DIR"
