#!/bin/bash

if [ $# -eq 0 ]; then
    echo "Usage: $0 <filename>"
    echo "Please provide the filename containing the list of domains as an argument."
    exit 1
fi

file=$1

if [ ! -f "$file" ]; then
    echo "The file $file does not exist."
    exit 1
fi

none_color=$(tput setaf 1)   # Red color for p=none
bold=$(tput bold)            # Bold text
reset=$(tput sgr0)           # Reset to default settings

while IFS= read -r domain; do
    if [ -n "$domain" ]; then
        dmarc=$(dig +short TXT _dmarc."$domain" | grep -o '"v=.*"')
        if [ -n "$dmarc" ]; then
            echo -e "DMARC for the domain $domain:"
            if [[ "$dmarc" == *"p=none"* ]]; then
                echo "Policy: None"
            else
                echo "$dmarc"
            fi
            echo "=========================================="
        else
            echo -e "DMARC not found for the domain $domain."
            echo "=========================================="
        fi
    fi
done < "$file"

