#!/bin/bash

# Colors for output
red_color='\033[0;31m'
green_color='\033[0;32m'
reset_color='\033[0m'

# Help message
show_help() {
    echo -e "${green_color}Usage: $0 [options] [domain]${reset_color}"
    echo "  -f      Specifies the file containing the list of domains"
    echo "  domain  A single domain to check"
    echo "  -h      Show this help message"
    exit 0
}

# Check if command exists
command_exists() {
    command -v "$1" >/dev/null 2>&1
}

# Validate domain format
is_valid_domain() {
    [[ "$1" =~ ^(([a-zA-Z0-9](-*[a-zA-Z0-9])*)\.)+[a-zA-Z]{2,}$ ]]
}

# Ensure nslookup is installed
if ! command_exists nslookup; then
    echo -e "${red_color}Error: nslookup command not found. Please install dnsutils.${reset_color}"
    exit 1
fi

# Variables
domains_file=""
single_domain=""

# Parse arguments
if [ $# -eq 0 ]; then
    show_help
else
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
    shift $((OPTIND - 1))
    if [ -z "$domains_file" ] && [ $# -gt 0 ]; then
        single_domain="$1"
    fi
fi

# Function to check DMARC record
check_dmarc() {
    local domain="$1"
    local result

    # Validate the domain
    if ! is_valid_domain "$domain"; then
        echo -e "${red_color}Invalid domain:${reset_color} $domain"
        return
    fi

    result=$(nslookup -type=txt "_dmarc.$domain" 2>&1)
    if echo "$result" | grep -q "server can't find _dmarc."; then
        echo -e "${red_color}vulnerable [no DMARC record]${reset_color}: $domain"
    elif echo "$result" | grep -q "v=DMARC1;.*p=none"; then
        echo -e "${red_color}vulnerable [p=none]${reset_color}: $domain"
    else
        echo -e "${green_color}not vulnerable${reset_color}: $domain"
    fi
}

# Process domains
if [ -n "$domains_file" ]; then
    if [ ! -f "$domains_file" ]; then
        echo -e "${red_color}Error: The file $domains_file does not exist.${reset_color}"
        exit 1
    fi

    while IFS= read -r domain; do
        check_dmarc "$domain"
    done < "$domains_file"
elif [ -n "$single_domain" ]; then
    check_dmarc "$single_domain"
else
    echo -e "${red_color}Error: No domain or file specified.${reset_color}"
    show_help
fi

