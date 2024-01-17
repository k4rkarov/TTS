#!/bin/bash

winId=$(xwininfo | tr -d '\n' | sed -e 's/.*Window id: \(.*\) ".*/\1/')
xdotool windowsize $winId 800 1000
