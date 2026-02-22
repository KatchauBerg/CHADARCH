#!/usr/bin/env bash
# gamemode.sh — Toggle game mode (disable blur/shadows/animations for performance)
# Usage: gamemode.sh [on|off]   (no arg = toggle)

set -euo pipefail

source "$(dirname "$(realpath "$0")")/globalcontrol.sh"

GAMEMODE_FILE="$DOTFILES_STATE/gamemode-active"

is_active() {
    [[ -f "$GAMEMODE_FILE" ]]
}

enable_gamemode() {
    touch "$GAMEMODE_FILE"
    hyprctl --batch \
        "keyword animations:enabled false ; \
         keyword decoration:blur:enabled false ; \
         keyword decoration:shadow:enabled false ; \
         keyword decoration:rounding 0" \
        2>/dev/null || true
    print_log -ok "Game mode enabled (blur/shadows/animations off)"
    notify-send -i "applications-games" -t 2000 "Game Mode" "Enabled — effects disabled" 2>/dev/null || true
}

disable_gamemode() {
    rm -f "$GAMEMODE_FILE"
    # Restore via full reload (robust — picks up current theme settings)
    hyprctl reload 2>/dev/null || true
    print_log -ok "Game mode disabled (reloading Hyprland)"
    notify-send -i "applications-games" -t 2000 "Game Mode" "Disabled — effects restored" 2>/dev/null || true
}

case "${1:-toggle}" in
    on)     enable_gamemode ;;
    off)    disable_gamemode ;;
    toggle)
        if is_active; then
            disable_gamemode
        else
            enable_gamemode
        fi
        ;;
    *)
        echo "Usage: $(basename "$0") [on|off|toggle]"
        exit 1
        ;;
esac
