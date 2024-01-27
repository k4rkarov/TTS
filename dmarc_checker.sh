#!/bin/bash

show_help() {
    echo "Usage: $0 -f <domains_file>"
    echo "  -f    Specifies the file containing the list of domains"
    exit 1
}

command_exists() {
    command -v "$1" >/dev/null 2>&1
}

if ! command_exists nslookup; then
    echo -e "${red_color}Error: nslookup command not found. Please install dnsutils (Debian, Ubuntu).${reset_color}"
    exit 1
fi

red_color='\033[0;31m'
green_color='\033[0;32m'
reset_color='\033[0m'

if [ $# -eq 0 ]; then
    show_help
fi

while getopts "f:h" option; do
    case $option in
        f)
            domains_file="$OPTARG"
            ;;
        h)
            show_help
            ;;
        \?)
            echo "Invalid option: -$OPTARG"
            show_help
            ;;
    esac
done

if [ -z "$domains_file" ]; then
    echo -e "${red_color}Error: You need to provide the domains file.${reset_color}"
    show_help
fi

if [ ! -f "$domains_file" ]; then
    echo -e "${red_color}The file $domains_file does not exist.${reset_color}"
    exit 1
fi

while IFS= read -r domain; do
    result=$(nslookup -type=txt "_dmarc.$domain" 2>&1)
    
    if echo "$result" | grep -q "server can't find _dmarc."; then
        echo -e "${red_color}vulnerable [no DMARC record]${reset_color}: $domain"
    elif echo "$result" | grep -q "v=DMARC1;.*p=none"; then
        echo -e "${red_color}vulnerable [p=none]${reset_color}: $domain"
    else
        echo -e "${green_color}not vulnerable${reset_color}: $domain"
    fi
done < "$domains_file"

echo -e ""

