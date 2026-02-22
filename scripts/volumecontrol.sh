#!/usr/bin/env bash
# Volume control with OSD notification
# Usage:
#   volumecontrol.sh -o i   — Increase volume by 5%
#   volumecontrol.sh -o d   — Decrease volume by 5%
#   volumecontrol.sh -o m   — Toggle mute

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

notify_volume() {
    local vol muted icon hint
    vol=$(wpctl get-volume @DEFAULT_AUDIO_SINK@ | awk '{printf "%.0f", $2 * 100}')
    muted=$(wpctl get-volume @DEFAULT_AUDIO_SINK@ | grep -c "MUTED" || true)

    if [[ "$muted" -gt 0 ]]; then
        icon="audio-volume-muted"
        hint=0
    elif [[ "$vol" -gt 70 ]]; then
        icon="audio-volume-high"
        hint=$vol
    elif [[ "$vol" -gt 30 ]]; then
        icon="audio-volume-medium"
        hint=$vol
    else
        icon="audio-volume-low"
        hint=$vol
    fi

    if [[ "$muted" -gt 0 ]]; then
        notify-send \
            -h string:synchronize:volume \
            -h int:value:"$hint" \
            -i "$icon" \
            -t 1500 \
            "Volume" "Muted"
    else
        notify-send \
            -h string:synchronize:volume \
            -h int:value:"$hint" \
            -i "$icon" \
            -t 1500 \
            "Volume" "${vol}%"
    fi
}

case "$action" in
    i)
        wpctl set-volume -l 1.5 @DEFAULT_AUDIO_SINK@ "${STEP}%+"
        notify_volume
        ;;
    d)
        wpctl set-volume @DEFAULT_AUDIO_SINK@ "${STEP}%-"
        notify_volume
        ;;
    m)
        wpctl set-mute @DEFAULT_AUDIO_SINK@ toggle
        notify_volume
        ;;
    *)
        echo "Usage: $(basename "$0") -o [i|d|m]"
        echo "  i = increase, d = decrease, m = mute toggle"
        exit 1
        ;;
esac
