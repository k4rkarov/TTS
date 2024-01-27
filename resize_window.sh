#!/bin/bash

# Function to display error message and exit
handle_error() {
    echo "Error: $1"
    exit 1
}

# Check if xwininfo and xdotool are installed
command -v xwininfo >/dev/null 2>&1 || handle_error "xwininfo is not installed. Please install it."
command -v xdotool >/dev/null 2>&1 || handle_error "xdotool is not installed. Please install it."

# Get the window ID
winId=$(xwininfo | awk '/Window id:/ {print $4}')

# Check if window ID is obtained successfully
if [ -z "$winId" ]; then
    handle_error "Failed to get the window ID."
fi

# Resize the window
xdotool windowsize "$winId" 800 1000

# Check if xdotool command was successful
if [ $? -ne 0 ]; then
    handle_error "Failed to resize the window."
fi

echo "Window resized successfully."

