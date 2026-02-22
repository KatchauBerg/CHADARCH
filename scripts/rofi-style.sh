#!/usr/bin/env bash
# rofi-style.sh — Select active rofi launcher style
# Usage: rofi-style.sh [--select|<style_number>]
#        rofi-style.sh --select     → open picker
#        rofi-style.sh 3            → apply style 3 directly

set -euo pipefail

DOTFILES_DIR="$(cd "$(dirname "$(realpath "$0")")/.." && pwd)"
source "$DOTFILES_DIR/scripts/globalcontrol.sh"

STYLES_DIR="$HOME/.config/rofi/styles"
LAUNCHER="$HOME/.config/rofi/launcher.rasi"

# Ensure styles are deployed
if [[ ! -d "$STYLES_DIR" ]]; then
    err "Rofi styles not found at $STYLES_DIR — run install.sh first"
    exit 1
fi

# Extract style description from file comment header
get_style_desc() {
    local f="$1"
    grep -m1 "Style [0-9]*:" "$f" 2>/dev/null \
        | sed 's/.*Style [0-9]*: //' \
        | tr -d '*/' \
        | xargs
}

apply_style() {
    local style_n="$1"
    local style_file="$STYLES_DIR/style_${style_n}.rasi"

    if [[ ! -f "$style_file" ]]; then
        err "Style $style_n not found: $style_file"
        exit 1
    fi

    echo "@theme \"$style_file\"" > "$LAUNCHER"
    set_conf ROFI_STYLE "$style_n"
    ok "Rofi launcher style set to: style_${style_n}"
}

select_style() {
    # Build list: "style_N  —  Description"
    declare -A style_map
    local labels=()

    for f in "$STYLES_DIR"/style_*.rasi; do
        [[ -f "$f" ]] || continue
        local name
        name="$(basename "$f" .rasi)"
        local desc
        desc="$(get_style_desc "$f")"
        local label="${name}  —  ${desc:-$name}"
        labels+=("$label")
        style_map["$label"]="${name##*_}"
    done

    if [[ ${#labels[@]} -eq 0 ]]; then
        err "No styles found in $STYLES_DIR"
        exit 1
    fi

    local selected
    selected=$(printf '%s\n' "${labels[@]}" \
        | rofi -dmenu \
               -p " Launcher Style" \
               -theme "$HOME/.config/rofi/clipboard.rasi") || exit 0

    [[ -z "$selected" ]] && exit 0

    local style_n="${style_map["$selected"]:-}"
    if [[ -z "$style_n" ]]; then
        err "Could not resolve style from selection"
        exit 1
    fi

    apply_style "$style_n"
}

cmd="${1:-}"
case "$cmd" in
    --select|"")
        select_style
        ;;
    [0-9]*)
        apply_style "$cmd"
        ;;
    *)
        echo "Usage: rofi-style.sh [--select|<style_number>]"
        echo "Styles available: $(ls "$STYLES_DIR"/style_*.rasi 2>/dev/null | xargs -n1 basename | tr '\n' ' ')"
        exit 1
        ;;
esac
