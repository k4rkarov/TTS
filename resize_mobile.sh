#!/bin/bash

display_help() {
    echo "Usage: $0 [-h|--help] [file_path]"
    echo "  -h, --help    Display this help menu"
    echo "  file_path     Path to the image file"
    exit 1
}

if [[ "$1" == "-h" || "$1" == "--help" ]]; then
    display_help
fi

if [ -z "$1" ]; then
    echo "Error: Please provide a file path."
    display_help
fi

file_path="$1"

if [ ! -e "$file_path" ]; then
    echo "Error: File not found."
    display_help
fi

h=$(identify -format "%[fx:h]" "$file_path")

if [[ $h -gt 700 ]]; then
    echo "Resizing to 800x600 >> $file_path"
    convert -border 2x2 "$file_path" "$file_path"
    montage -background '#FFFFFF' -geometry '800x600' "$file_path" "$file_path"
fi

