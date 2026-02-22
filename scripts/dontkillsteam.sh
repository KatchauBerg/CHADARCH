#!/usr/bin/env bash
# dontkillsteam.sh — Graceful window close
# If the active window is Steam, hide it to tray instead of killing it.
# For all other windows, send WM_DELETE_WINDOW (hyprctl killactive).

set -euo pipefail

source "$(dirname "$(realpath "$0")")/globalcontrol.sh"

active_class=$(hyprctl activewindow -j 2>/dev/null | jq -r '.class // ""')

if [[ "$active_class" == "steam" || "$active_class" == "Steam" ]]; then
    # Hide Steam to tray instead of killing
    if has_cmd xdotool; then
        active_id=$(hyprctl activewindow -j 2>/dev/null | jq -r '.pid // 0')
        if [[ "$active_id" -gt 0 ]]; then
            win_id=$(xdotool search --pid "$active_id" --name "Steam" 2>/dev/null | head -1 || true)
            if [[ -n "$win_id" ]]; then
                xdotool windowunmap "$win_id" 2>/dev/null || hyprctl dispatch killactive
            else
                hyprctl dispatch killactive
            fi
        else
            hyprctl dispatch killactive
        fi
    else
        print_log -warn "xdotool not found — falling back to killactive for Steam"
        hyprctl dispatch killactive
    fi
else
    hyprctl dispatch killactive
fi
