#!/usr/bin/env bash
# globalcontrol.sh — Shared library for all dotfiles scripts
# Source this file at the top of every script:
#   source "$(dirname "$(realpath "$0")")/globalcontrol.sh"

# ---------------------------------------------------------------------------
# Core paths
# ---------------------------------------------------------------------------
export DOTFILES_DIR
DOTFILES_DIR="$(cd "$(dirname "$(realpath "${BASH_SOURCE[0]}")")/.." && pwd)"

export DOTFILES_STATE="$HOME/.local/state/dotfiles"
export XDG_CONFIG_HOME="${XDG_CONFIG_HOME:-$HOME/.config}"
export XDG_CACHE_HOME="${XDG_CACHE_HOME:-$HOME/.cache}"
export XDG_STATE_HOME="${XDG_STATE_HOME:-$HOME/.local/state}"

# Ensure state dir exists
mkdir -p "$DOTFILES_STATE"

# ---------------------------------------------------------------------------
# Logging helpers
# ---------------------------------------------------------------------------
print_log() {
    local level="$1"
    shift
    local msg="$*"
    case "$level" in
        -info)  printf '\033[1;34m[INFO]\033[0m %s\n'    "$msg" ;;
        -ok)    printf '\033[1;32m[ OK ]\033[0m %s\n'    "$msg" ;;
        -err)   printf '\033[1;31m[ERR ]\033[0m %s\n'    "$msg" >&2 ;;
        -warn)  printf '\033[1;33m[WARN]\033[0m %s\n'    "$msg" ;;
        -debug) [[ "${DOTFILES_DEBUG:-0}" == "1" ]] && printf '\033[1;35m[DBG ]\033[0m %s\n' "$msg" ;;
        *)      printf '%s\n' "$msg" ;;
    esac
}
export -f print_log

# Convenience aliases kept for backward compat inside scripts
info() { print_log -info "$@"; }
ok()   { print_log -ok   "$@"; }
err()  { print_log -err  "$@"; }
warn() { print_log -warn "$@"; }
export -f info ok err warn

# ---------------------------------------------------------------------------
# Theme helpers
# ---------------------------------------------------------------------------
get_current_theme() {
    local theme_file="$DOTFILES_DIR/.theme-current"
    if [[ -f "$theme_file" && -s "$theme_file" ]]; then
        cat "$theme_file"
    else
        echo "catppuccin-mocha"
    fi
}
export -f get_current_theme

get_theme_dir() {
    local theme="${1:-$(get_current_theme)}"
    echo "$DOTFILES_DIR/themes/$theme"
}
export -f get_theme_dir

get_colors_file() {
    local theme="${1:-$(get_current_theme)}"
    echo "$DOTFILES_DIR/themes/$theme/colors.sh"
}
export -f get_colors_file

get_wallpaper_dir() {
    local theme="${1:-$(get_current_theme)}"
    echo "$DOTFILES_DIR/themes/$theme/wallpapers"
}
export -f get_wallpaper_dir

# ---------------------------------------------------------------------------
# Key=value state in ~/.local/state/dotfiles/staterc
# ---------------------------------------------------------------------------
STATERC="$DOTFILES_STATE/staterc"

set_conf() {
    local key="$1"
    local val="$2"
    mkdir -p "$(dirname "$STATERC")"
    touch "$STATERC"
    # Replace existing key or append
    if grep -q "^${key}=" "$STATERC" 2>/dev/null; then
        sed -i "s|^${key}=.*|${key}=${val}|" "$STATERC"
    else
        echo "${key}=${val}" >> "$STATERC"
    fi
}
export -f set_conf

get_conf() {
    local key="$1"
    local default="${2:-}"
    local val=""
    if [[ -f "$STATERC" ]]; then
        val=$(grep "^${key}=" "$STATERC" 2>/dev/null | cut -d= -f2- | head -1)
    fi
    echo "${val:-$default}"
}
export -f get_conf

# ---------------------------------------------------------------------------
# Animation preset state
# ---------------------------------------------------------------------------
get_animation_preset() {
    get_conf "ANIMATION_PRESET" "default"
}
export -f get_animation_preset

set_animation_preset() {
    set_conf "ANIMATION_PRESET" "$1"
}
export -f set_animation_preset

# ---------------------------------------------------------------------------
# Waybar layout state
# ---------------------------------------------------------------------------
get_waybar_layout() {
    get_conf "WAYBAR_LAYOUT" "1"
}
export -f get_waybar_layout

set_waybar_layout() {
    set_conf "WAYBAR_LAYOUT" "$1"
}
export -f set_waybar_layout

# ---------------------------------------------------------------------------
# Workflow state
# ---------------------------------------------------------------------------
get_workflow() {
    get_conf "WORKFLOW" "default"
}
export -f get_workflow

set_workflow() {
    set_conf "WORKFLOW" "$1"
}
export -f set_workflow

# ---------------------------------------------------------------------------
# Shader state
# ---------------------------------------------------------------------------
get_shader() {
    get_conf "SHADER" "disable"
}
export -f get_shader

set_shader() {
    set_conf "SHADER" "$1"
}
export -f set_shader

# ---------------------------------------------------------------------------
# Utility: check if a command exists
# ---------------------------------------------------------------------------
has_cmd() {
    command -v "$1" &>/dev/null
}
export -f has_cmd
