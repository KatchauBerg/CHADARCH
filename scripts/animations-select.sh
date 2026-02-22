#!/usr/bin/env bash
# animations-select.sh — Select animation preset via rofi or apply directly
# Usage:
#   animations-select.sh --select          Open rofi picker
#   animations-select.sh <preset>          Apply preset (default|minimal|dynamic|disabled)

set -euo pipefail

source "$(dirname "$(realpath "$0")")/globalcontrol.sh"

PRESETS_DIR="$DOTFILES_DIR/templates/hypr/animations"
ANIM_CONFIG_DIR="$XDG_CONFIG_HOME/hypr/animations"
ANIM_CONF="$XDG_CONFIG_HOME/hypr/animations.conf"

# Ensure animation config dir exists
mkdir -p "$ANIM_CONFIG_DIR"

# Sync preset files from templates to config dir
sync_presets() {
    for src in "$PRESETS_DIR"/*.conf; do
        [[ -f "$src" ]] || continue
        cp "$src" "$ANIM_CONFIG_DIR/$(basename "$src")"
    done
}

apply_preset() {
    local preset="$1"
    local preset_file="$PRESETS_DIR/${preset}.conf"

    if [[ ! -f "$preset_file" ]]; then
        print_log -err "Preset not found: $preset"
        print_log -info "Available: $(ls "$PRESETS_DIR" | sed 's/\.conf//' | tr '\n' ' ')"
        exit 1
    fi

    sync_presets
    # Write source directive
    echo "source = $ANIM_CONFIG_DIR/${preset}.conf" > "$ANIM_CONF"
    set_animation_preset "$preset"
    hyprctl reload 2>/dev/null && print_log -ok "Animation preset: $preset" || \
        print_log -warn "hyprctl reload failed (Hyprland may not be running)"
}

select_preset() {
    local current
    current="$(get_animation_preset)"

    # Build rofi entries from available presets
    local entries=""
    local -a presets=()
    for f in "$PRESETS_DIR"/*.conf; do
        [[ -f "$f" ]] || continue
        local name
        name="$(basename "$f" .conf)"
        presets+=("$name")
        if [[ "$name" == "$current" ]]; then
            entries+="  ${name} (current)\n"
        else
            entries+="  ${name}\n"
        fi
    done

    if [[ ${#presets[@]} -eq 0 ]]; then
        print_log -err "No animation presets found in $PRESETS_DIR"
        exit 1
    fi

    local rofi_theme="$XDG_CONFIG_HOME/rofi/clipboard.rasi"
    local choice
    choice=$(printf '%b' "$entries" | \
        rofi -dmenu -i -p "Animations" \
        ${rofi_theme:+-theme "$rofi_theme"} 2>/dev/null) || exit 0

    # Extract preset name (strip leading whitespace and " (current)" suffix)
    local chosen_preset
    chosen_preset=$(echo "$choice" | sed 's/^[[:space:]]*//' | sed 's/ (current)$//')

    apply_preset "$chosen_preset"
    notify-send -i "preferences-desktop" -t 2000 "Animations" "Preset: ${chosen_preset}" 2>/dev/null || true
}

case "${1:-}" in
    --select)
        select_preset
        ;;
    "")
        select_preset
        ;;
    *)
        apply_preset "$1"
        ;;
esac
