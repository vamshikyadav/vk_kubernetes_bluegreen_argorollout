#!/bin/bash

# Usage: ./copy_as_values.sh <partial_filename> <new_filename>
# Example: ./copy_as_values.sh puppy values.txt

PARTIAL_NAME="$1"
NEW_NAME="$2"

if [[ -z "$PARTIAL_NAME" || -z "$NEW_NAME" ]]; then
  echo "Usage: $0 <partial_filename> <new_filename>"
  echo "Example: $0 puppy values.txt"
  exit 1
fi

# Search for matching files
find . -type f -name "*$PARTIAL_NAME*" | while read -r file; do
  dir=$(dirname "$file")
  dest="$dir/$NEW_NAME"

  if [[ -f "$dest" ]]; then
    echo "Skipped: $dest already exists"
  else
    cp "$file" "$dest"
    echo "Copied: $file -> $dest"
  fi
done
