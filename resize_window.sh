#!/bin/bash

# ----------------
# - by @k4rkarov -
# ----------------

handle_error() {
    echo "Error: $1"
    exit 1
}

command -v xwininfo >/dev/null 2>&1 || handle_error "xwininfo is not installed. Please install it."
command -v xdotool >/dev/null 2>&1 || handle_error "xdotool is not installed. Please install it."

winId=$(xwininfo | awk '/Window id:/ {print $4}')

if [ -z "$winId" ]; then
    handle_error "Failed to get the window ID."
fi

xdotool windowsize "$winId" 800 600

if [ $? -ne 0 ]; then
    handle_error "Failed to resize the window."
fi

echo "Window resized successfully."

