#!/usr/bin/env bash
# batch_ocrmypdf.sh
# Run ocrmypdf on all PDF files in the current directory.
# Output files are saved to ./output/ with the same filename.
#
# Dependencies: ocrmypdf
#   Install: pip install ocrmypdf  OR  brew install ocrmypdf
#
# Usage: cd /your/pdf/folder && bash /path/to/batch_ocrmypdf.sh

set -euo pipefail

OUTPUT_DIR="$(pwd)/output"
mkdir -p "$OUTPUT_DIR"

shopt -s nullglob
pdf_files=(*.pdf)

if [ ${#pdf_files[@]} -eq 0 ]; then
  echo "No PDF files found in $(pwd)"
  exit 0
fi

echo "Found ${#pdf_files[@]} PDF file(s). Starting OCR..."

for f in "${pdf_files[@]}"; do
  echo "  Processing: $f"
  ocrmypdf \
    --language chi_sim+eng \
    --rotate-pages \
    --deskew \
    --output-type pdfa \
    "$f" "$OUTPUT_DIR/$f" && echo "  Done: output/$f" || echo "  FAILED: $f"
done

echo "\nAll done. Output saved to: $OUTPUT_DIR"
