#!/bin/bash

if [ $# -eq 0 ]; then
    echo "Please provide the filename as an argument."
    exit 1
fi

file=$1

if [ ! -f "$file" ]; then
    echo "The file $file does not exist."
    exit 1
fi

if ! command -v host &> /dev/null; then
    echo "Error: 'host' command is not installed. Please install it and try again."
    exit 1
fi

while IFS= read -r line; do
    if [ -n "$line" ]; then
        result=$(host -t cname "$line")

        if [ $? -eq 0 ]; then
            echo "Query for: $line"
            echo "$result"
            echo "=========================================="
        else
            echo "Error querying $line with 'host' command."
            echo "=========================================="
        fi
    fi
done < "$file"
