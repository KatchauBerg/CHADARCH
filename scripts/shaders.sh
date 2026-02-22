#!/usr/bin/env bash
# shaders.sh — Apply/toggle Hyprland screen shaders
# Shaders from HyDE project, adapted for this dotfiles.
# Applied live via hyprctl keyword — no config reload needed.
#
# Usage:
#   shaders.sh --select                  rofi picker
#   shaders.sh <name>                    apply shader (blue-light-filter, grayscale, etc.)
#   shaders.sh --off                     disable current shader

set -euo pipefail

source "$(dirname "$(realpath "$0")")/globalcontrol.sh"

SHADERS_DIR="$HOME/.config/hypr/shaders"
SHADERS_CONF="$HOME/.config/hypr/shaders.conf"

SHADER_NAMES=(
    "disable"
    "blue-light-filter"
    "grayscale"
    "invert-colors"
    "oled-saver"
    "paper"
    "vibrance"
)

apply_shader() {
    local name="$1"
    local frag="$SHADERS_DIR/${name}.frag"

    if [[ ! -f "$frag" ]]; then
        print_log -err "Shader not found: $name"
        print_log -info "Available: ${SHADER_NAMES[*]}"
        exit 1
    fi

    local shader_path
    if [[ "$name" == "disable" ]]; then
        shader_path="~/.config/hypr/shaders/disable.frag"
        hyprctl keyword decoration:screen_shader "" 2>/dev/null || true
    else
        shader_path="~/.config/hypr/shaders/${name}.frag"
        hyprctl keyword decoration:screen_shader "$frag" 2>/dev/null || true
    fi

    # Write shaders.conf so the shader persists across Hyprland reloads
    cat > "$SHADERS_CONF" << EOF
# shaders.conf — Screen shader configuration
# Managed by dotfiles — use: dotfiles-shell shaders --select
# DO NOT edit manually — this file is rewritten by shaders.sh

\$SCREEN_SHADER      = ${name}
\$SCREEN_SHADER_PATH = ${shader_path}

decoration {
    screen_shader = \$SCREEN_SHADER_PATH
}
EOF

    set_conf SHADER "$name"
    if [[ "$name" == "disable" ]]; then
        print_log -ok "Shader disabled"
        notify-send "Shader" "Disabled" -t 1500 2>/dev/null || true
    else
        print_log -ok "Shader: $name"
        notify-send "Shader" "$name" -t 1500 2>/dev/null || true
    fi
}

select_shader() {
    local current
    current="$(get_conf SHADER "disable")"

    local entries=""
    for name in "${SHADER_NAMES[@]}"; do
        if [[ "$name" == "$current" ]]; then
            entries+="  ${name} (active)\n"
        else
            entries+="  ${name}\n"
        fi
    done

    local rofi_theme="$XDG_CONFIG_HOME/rofi/clipboard.rasi"
    local choice
    choice=$(printf '%b' "$entries" | \
        rofi -dmenu -i -p "Shader" \
        ${rofi_theme:+-theme "$rofi_theme"} 2>/dev/null) || exit 0

    local chosen
    chosen=$(echo "$choice" | sed 's/^[[:space:]]*//' | sed 's/ (active)$//')
    apply_shader "$chosen"
}

case "${1:-}" in
    --select|"") select_shader ;;
    --off)       apply_shader "disable" ;;
    *)           apply_shader "$1" ;;
esac
