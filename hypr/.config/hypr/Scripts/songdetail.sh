#!/bin/bash

# Only show Spotify
song_info=$(playerctl -p spotify metadata --format '{{title}}     {{artist}}' 2>/dev/null)

if [ -z "$song_info" ]; then
    echo "No music playing"
else
    echo "$song_info"
fi