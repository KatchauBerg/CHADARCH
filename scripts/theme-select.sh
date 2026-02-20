#!/usr/bin/env bash
# Theme selector using rofi with wallpaper preview thumbnails
# Usage: theme-select.sh

set -euo pipefail

DOTFILES_DIR="$(cd "$(dirname "$0")/.." && pwd)"
CURRENT_THEME="$(cat "$DOTFILES_DIR/.theme-current" 2>/dev/null || echo "")"
THUMB_DIR="$HOME/.cache/theme-thumbs"

mkdir -p "$THUMB_DIR"

# Generate thumbnail from theme wallpaper
make_thumb() {
    local theme_dir="$1"
    local name
    name="$(basename "$theme_dir")"
    local thumb="$THUMB_DIR/${name}.png"

    # Find first wallpaper in theme
    local wallpaper
    wallpaper=$(find "$theme_dir/wallpapers" -maxdepth 1 -type f \( -name "*.png" -o -name "*.jpg" -o -name "*.jpeg" -o -name "*.webp" \) 2>/dev/null | head -1)

    if [[ -n "$wallpaper" ]]; then
        if [[ ! -f "$thumb" ]] || [[ "$wallpaper" -nt "$thumb" ]]; then
            magick "$wallpaper" -thumbnail 200x200^ -gravity center -extent 200x200 "$thumb" 2>/dev/null
        fi
        echo "$thumb"
    fi
}

# Build rofi entries
entries=""
for dir in "$DOTFILES_DIR"/themes/*/; do
    [[ ! -d "$dir" ]] && continue
    name="$(basename "$dir")"

    # Source theme name for display
    display="$name"
    if [[ -f "$dir/colors.sh" ]]; then
        theme_label=$(grep '^export THEME_NAME=' "$dir/colors.sh" | cut -d'"' -f2)
        [[ -n "$theme_label" ]] && display="$theme_label"
    fi

    # Generate thumbnail
    thumb=$(make_thumb "$dir")

    # Mark current theme
    if [[ "$name" == "$CURRENT_THEME" ]]; then
        label="  $display (current)"
    else
        label="  $display"
    fi

    if [[ -n "$thumb" ]]; then
        entries+="${label}\0icon\x1f${thumb}\n"
    else
        entries+="${label}\n"
    fi
done

if [[ -z "$entries" ]]; then
    notify-send "Theme Selector" "No themes found"
    exit 1
fi

# Show rofi picker
rofi_theme="$HOME/.config/rofi/theme.rasi"
rofi_args=(-dmenu -i -p "Theme" -show-icons)
[[ -f "$rofi_theme" ]] && rofi_args+=(-theme "$rofi_theme")

choice=$(echo -en "$entries" | rofi "${rofi_args[@]}") || exit 0

# Extract theme directory name from choice
theme_dir=""
for dir in "$DOTFILES_DIR"/themes/*/; do
    [[ ! -d "$dir" ]] && continue
    name="$(basename "$dir")"
    theme_label=""
    if [[ -f "$dir/colors.sh" ]]; then
        theme_label=$(grep '^export THEME_NAME=' "$dir/colors.sh" | cut -d'"' -f2)
    fi
    if [[ "$choice" == *"$theme_label"* ]] || [[ "$choice" == *"$name"* ]]; then
        theme_dir="$name"
        break
    fi
done

if [[ -z "$theme_dir" ]]; then
    notify-send "Theme Selector" "Theme not found"
    exit 1
fi

# Apply theme
"$DOTFILES_DIR/scripts/theme-switch.sh" "$theme_dir"
notify-send "Theme Applied" "$theme_dir"
