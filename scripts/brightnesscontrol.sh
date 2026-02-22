#!/usr/bin/env bash
# Brightness control with OSD notification
# Usage:
#   brightnesscontrol.sh -o i   — Increase brightness by 5%
#   brightnesscontrol.sh -o d   — Decrease brightness by 5%

set -euo pipefail

DOTFILES_DIR="$(cd "$(dirname "$(realpath "$0")")/.." && pwd)"
source "$DOTFILES_DIR/scripts/globalcontrol.sh"

STEP=5
action=""

while getopts "o:" opt; do
    case "$opt" in
        o) action="$OPTARG" ;;
        *) ;;
    esac
done

notify_brightness() {
    local level
    level=$(brightnessctl -m | awk -F',' '{print $4}' | tr -d '%')
    notify-send \
        -h string:synchronize:brightness \
        -h int:value:"$level" \
        -i "display-brightness" \
        -t 1500 \
        "Brightness" "${level}%"
}

case "$action" in
    i)
        brightnessctl set "${STEP}%+"
        notify_brightness
        ;;
    d)
        brightnessctl set "${STEP}%-"
        notify_brightness
        ;;
    *)
        echo "Usage: $(basename "$0") -o [i|d]"
        echo "  i = increase, d = decrease"
        exit 1
        ;;
esac
