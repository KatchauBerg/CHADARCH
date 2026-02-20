#!/usr/bin/env bash
# Screenshot utility using grim + slurp
# Usage:
#   screenshot.sh           - Full screen → clipboard
#   screenshot.sh --area    - Select area → clipboard
#   screenshot.sh --save    - Full screen → ~/Pictures/Screenshots/
#   screenshot.sh --area --save  - Select area → file

set -euo pipefail

SCREENSHOT_DIR="$HOME/Pictures/Screenshots"
mkdir -p "$SCREENSHOT_DIR"

TIMESTAMP=$(date +%Y%m%d_%H%M%S)
FILENAME="$SCREENSHOT_DIR/screenshot_$TIMESTAMP.png"

AREA=false
SAVE=false

for arg in "$@"; do
    case "$arg" in
        --area) AREA=true ;;
        --save) SAVE=true ;;
    esac
done

if $AREA; then
    GEOMETRY=$(slurp 2>/dev/null) || exit 0
    if $SAVE; then
        grim -g "$GEOMETRY" "$FILENAME"
        wl-copy < "$FILENAME"
        notify-send "Screenshot saved" "$FILENAME" -i "$FILENAME"
    else
        grim -g "$GEOMETRY" - | wl-copy
        notify-send "Screenshot" "Area copied to clipboard"
    fi
else
    if $SAVE; then
        grim "$FILENAME"
        wl-copy < "$FILENAME"
        notify-send "Screenshot saved" "$FILENAME" -i "$FILENAME"
    else
        grim - | wl-copy
        notify-send "Screenshot" "Screen copied to clipboard"
    fi
fi
