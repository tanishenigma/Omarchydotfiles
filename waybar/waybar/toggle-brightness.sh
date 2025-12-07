#!/bin/bash

# Get the current and maximum brightness
current=$(brightnessctl g)
max=$(brightnessctl m)

# Check if brightness is already at 100% (or very close)
if [ "$current" -eq "$max" ]; then
  # If at 100%, set to 50%
  brightnessctl set 0%
else
  # Otherwise, set to 100%
  brightnessctl set 100%
fi