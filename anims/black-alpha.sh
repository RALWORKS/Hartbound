#!/bin/bash

# Ensure ImageMagick is installed
if ! command -v magick &> /dev/null && ! command -v mogrify &> /dev/null; then
    echo "Error: ImageMagick is not installed."
    exit 1
fi

# Use 'magick mogrify' for ImageMagick v7+, fall back to 'mogrify' for v6
MAGICK_CMD="magick mogrify"
if ! command -v magick &> /dev/null; then
    MAGICK_CMD="mogrify"
fi

echo "Processing PNGs to remove black background..."

# -fuzz 5% accounts for near-black compression artifacts
$MAGICK_CMD -fuzz 5% -transparent black *.png

echo "Done! All PNGs processed in place."
