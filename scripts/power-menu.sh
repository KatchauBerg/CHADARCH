#!/usr/bin/env bash
# Power Menu - lock, logout, reboot, shutdown (HyDE grid style)

set -euo pipefail

DOTFILES_DIR="$(cd "$(dirname "$(realpath "$0")")/.." && pwd)"
source "$DOTFILES_DIR/scripts/globalcontrol.sh"

options="\n󰗽\n\n"

chosen=$(echo -e "$options" | rofi -dmenu -theme "$HOME/.config/rofi/power-menu.rasi" -p "" -no-custom)

case "$chosen" in
    "")  hyprlock ;;
    "󰗽") hyprctl dispatch exit ;;
    "")  systemctl reboot ;;
    "")  systemctl poweroff ;;
esac
