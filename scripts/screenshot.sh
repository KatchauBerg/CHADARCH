#!/usr/bin/env bash
# Screenshot utility using grim + slurp
# Usage:
#   screenshot.sh                  - Fullscreen → clipboard
#   screenshot.sh --area           - Select area → clipboard
#   screenshot.sh --save           - Fullscreen → ~/Pictures/Screenshots/
#   screenshot.sh --area --save    - Select area → file
#   screenshot.sh --monitor        - Active monitor → clipboard
#   screenshot.sh --freeze         - Freeze screen, then area select → clipboard

set -euo pipefail

DOTFILES_DIR="$(cd "$(dirname "$(realpath "$0")")/.." && pwd)"
source "$DOTFILES_DIR/scripts/globalcontrol.sh"

SCREENSHOT_DIR="$HOME/Pictures/Screenshots"
mkdir -p "$SCREENSHOT_DIR"

TIMESTAMP=$(date +%Y%m%d_%H%M%S)
FILENAME="$SCREENSHOT_DIR/screenshot_$TIMESTAMP.png"

AREA=false
SAVE=false
MONITOR=false
FREEZE=false

for arg in "$@"; do
    case "$arg" in
        --area)    AREA=true ;;
        --save)    SAVE=true ;;
        --monitor) MONITOR=true ;;
        --freeze)  FREEZE=true ;;
    esac
done

# --monitor: capture the currently focused monitor
if $MONITOR; then
    GEOM=$(hyprctl monitors -j | \
        jq -r '.[] | select(.focused == true) | "\(.x),\(.y) \(.width)x\(.height)"')
    if $SAVE; then
        grim -g "$GEOM" "$FILENAME"
        wl-copy < "$FILENAME"
        notify-send "Screenshot saved" "$FILENAME" -i "$FILENAME"
    else
        grim -g "$GEOM" - | wl-copy
        notify-send "Screenshot" "Monitor copied to clipboard"
    fi
    exit 0
fi

# --freeze: capture full screen first, then let user select area from it
if $FREEZE; then
    FROZEN="/tmp/screenshot-freeze-$$.png"
    grim "$FROZEN"
    GEOMETRY=$(slurp 2>/dev/null) || { rm -f "$FROZEN"; exit 0; }
    if $SAVE; then
        grim -g "$GEOMETRY" "$FILENAME"
        wl-copy < "$FILENAME"
        notify-send "Screenshot saved" "$FILENAME" -i "$FILENAME"
    else
        grim -g "$GEOMETRY" "$FROZEN" - 2>/dev/null || grim -g "$GEOMETRY" - | wl-copy
        # Crop from the frozen capture
        magick "$FROZEN" -crop "$(echo "$GEOMETRY" | sed 's/,/+/; s/ /+/')" +repage - | wl-copy 2>/dev/null || \
            grim -g "$GEOMETRY" - | wl-copy
        notify-send "Screenshot" "Area copied to clipboard"
    fi
    rm -f "$FROZEN"
    exit 0
fi

# Standard modes
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
