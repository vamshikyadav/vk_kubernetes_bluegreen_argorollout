#!/bin/bash

# Usage: ./copy_as_values.sh <partial_filename> <new_filename> <search_directory>
# Example: ./copy_as_values.sh puppy values.txt /home/user/data

PARTIAL_NAME="$1"
NEW_NAME="$2"
SEARCH_DIR="$3"

if [[ -z "$PARTIAL_NAME" || -z "$NEW_NAME" || -z "$SEARCH_DIR" ]]; then
  echo "Usage: $0 <partial_filename> <new_filename> <search_directory>"
  echo "Example: $0 puppy values.txt /home/user/data"
  exit 1
fi

# Ensure the directory exists
if [[ ! -d "$SEARCH_DIR" ]]; then
  echo "Error: Directory '$SEARCH_DIR' does not exist."
  exit 2
fi

# Find matching files recursively
find "$SEARCH_DIR" -type f -name "*$PARTIAL_NAME*" | while read -r file; do
  dir=$(dirname "$file")
  dest="$dir/$NEW_NAME"

  if [[ -f "$dest" ]]; then
    echo "❌ Skipped (exists): $dest"
  else
    cp "$file" "$dest"
    echo "✅ Copied: $file → $dest"
  fi
done
