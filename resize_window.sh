#!/bin/bash

# ----------------
# - by @k4rkarov -
# ----------------

handle_error() {
    echo "Error: $1"
    exit 1
}

install_package() {
    read -p "Do you want to install $1? [Y/n] " choice
    case "$choice" in
        [Yy]|"") sudo apt update && sudo apt install -y "$1" || handle_error "Failed to install $1." ;;
        [Nn]) handle_error "$1 is required but not installed." ;;
        *) echo "Invalid input. Assuming 'No'."; handle_error "$1 is required but not installed." ;;
    esac
}

command -v xwininfo >/dev/null 2>&1 || install_package "x11-utils"
command -v xdotool >/dev/null 2>&1 || install_package "xdotool"

winId=$(xwininfo | awk '/Window id:/ {print $4}')

if [ -z "$winId" ]; then
    handle_error "Failed to get the window ID."
fi

xdotool windowsize "$winId" 800 600

if [ $? -ne 0 ]; then
    handle_error "Failed to resize the window."
fi

echo "Window resized successfully."
