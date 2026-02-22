#!/usr/bin/env bash
# waybar-layout.sh — Cycle between waybar layout configs
# Usage:
#   waybar-layout.sh next       — next layout
#   waybar-layout.sh prev       — previous layout
#   waybar-layout.sh <n>        — switch to specific layout number

set -euo pipefail

source "$(dirname "$(realpath "$0")")/globalcontrol.sh"

LAYOUTS_DIR="$DOTFILES_DIR/templates/waybar/layouts"

# Count available layouts
count_layouts() {
    local count=0
    for d in "$LAYOUTS_DIR"/*/; do
        [[ -d "$d" ]] && (( count++ )) || true
    done
    echo "$count"
}

# Apply a layout: process its templates with current theme colors, restart waybar
apply_layout() {
    local n="$1"
    local layout_dir="$LAYOUTS_DIR/$n"

    if [[ ! -d "$layout_dir" ]]; then
        print_log -err "Layout $n not found at $layout_dir"
        exit 1
    fi

    # Build perl substitution from current theme's colors.sh
    local colors_file
    colors_file="$(get_colors_file)"

    if [[ ! -f "$colors_file" ]]; then
        print_log -err "Colors file not found: $colors_file"
        exit 1
    fi

    local replacements=""
    while IFS= read -r line; do
        if [[ "$line" =~ ^export\ ([A-Z_][A-Z0-9_]*)=\"(.*)\"$ ]]; then
            local var="${BASH_REMATCH[1]}"
            local val="${BASH_REMATCH[2]}"
            val=$(eval echo "$val")
            replacements+="s|\Q{{${var}}}\E|${val}|g;"
        fi
    done < "$colors_file"

    # Process templates
    mkdir -p "$XDG_CONFIG_HOME/waybar"
    [[ -f "$layout_dir/config.jsonc" ]] && \
        perl -pe "$replacements" "$layout_dir/config.jsonc" > "$XDG_CONFIG_HOME/waybar/config.jsonc"
    [[ -f "$layout_dir/style.css" ]] && \
        perl -pe "$replacements" "$layout_dir/style.css" > "$XDG_CONFIG_HOME/waybar/style.css"

    # Save state
    set_waybar_layout "$n"

    # Restart waybar
    if pgrep -x waybar >/dev/null 2>&1; then
        killall waybar 2>/dev/null || true
        sleep 0.3
    fi
    waybar &>/dev/null &
    disown

    print_log -ok "Waybar layout: $n"
    notify-send -i "preferences-desktop" -t 2000 "Waybar" "Layout $n applied" 2>/dev/null || true
}

total="$(count_layouts)"

if [[ "$total" -eq 0 ]]; then
    print_log -err "No waybar layouts found in $LAYOUTS_DIR"
    exit 1
fi

current="$(get_waybar_layout)"

case "${1:-next}" in
    next)
        new=$(( (current % total) + 1 ))
        apply_layout "$new"
        ;;
    prev)
        new=$(( (current - 2 + total) % total + 1 ))
        apply_layout "$new"
        ;;
    [0-9]*)
        n="$1"
        if [[ "$n" -lt 1 || "$n" -gt "$total" ]]; then
            print_log -err "Layout $n out of range (1-$total)"
            exit 1
        fi
        apply_layout "$n"
        ;;
    *)
        echo "Usage: $(basename "$0") [next|prev|<n>]"
        exit 1
        ;;
esac
