#!/usr/bin/env bash
# Theme Switch Engine
# Usage: theme-switch.sh <theme-name>
# Example: theme-switch.sh catppuccin-mocha

set -euo pipefail

DOTFILES_DIR="$(cd "$(dirname "$0")/.." && pwd)"
THEME_ID="${1:-}"

# Colors for output
info() { printf '\033[1;34m[INFO]\033[0m %s\n' "$1"; }
ok()   { printf '\033[1;32m[ OK ]\033[0m %s\n' "$1"; }
err()  { printf '\033[1;31m[ERR]\033[0m %s\n' "$1" >&2; }

# Validate theme
if [[ -z "$THEME_ID" ]]; then
    echo "Usage: $(basename "$0") <theme-name>"
    echo ""
    echo "Available themes:"
    for dir in "$DOTFILES_DIR"/themes/*/; do
        [[ -d "$dir" ]] && echo "  - $(basename "$dir")"
    done
    exit 1
fi

THEME_DIR="$DOTFILES_DIR/themes/$THEME_ID"
COLORS_FILE="$THEME_DIR/colors.sh"

if [[ ! -f "$COLORS_FILE" ]]; then
    err "Theme '$THEME_ID' not found at $THEME_DIR"
    exit 1
fi

info "Switching to theme: $THEME_ID"

# Source the color palette
# shellcheck source=/dev/null
source "$COLORS_FILE"

# Build perl substitution from all exported variables
build_replacements() {
    local replacements=""
    while IFS= read -r line; do
        if [[ "$line" =~ ^export\ ([A-Z_][A-Z0-9_]*)=\"(.*)\"$ ]]; then
            local var="${BASH_REMATCH[1]}"
            local val="${BASH_REMATCH[2]}"
            # Resolve variable references (e.g., $MAUVE)
            val=$(eval echo "$val")
            replacements+="s|\Q{{${var}}}\E|${val}|g;"
        fi
    done < "$COLORS_FILE"
    echo "$replacements"
}

REPLACEMENTS=$(build_replacements)

# Process a template file → output file
process_template() {
    local template="$1"
    local output="$2"

    mkdir -p "$(dirname "$output")"
    perl -pe "$REPLACEMENTS" "$template" > "$output"
    ok "$(basename "$output")"
}

# Process all templates
info "Processing templates..."

process_template "$DOTFILES_DIR/templates/hypr/hyprland-theme.conf" \
    "$HOME/.config/hypr/theme-current.conf"

process_template "$DOTFILES_DIR/templates/hypr/hyprlock.conf" \
    "$HOME/.config/hypr/hyprlock.conf"

process_template "$DOTFILES_DIR/templates/hypr/hypridle.conf" \
    "$HOME/.config/hypr/hypridle.conf"

process_template "$DOTFILES_DIR/templates/waybar/config.jsonc" \
    "$HOME/.config/waybar/config.jsonc"

process_template "$DOTFILES_DIR/templates/waybar/style.css" \
    "$HOME/.config/waybar/style.css"

process_template "$DOTFILES_DIR/templates/kitty/theme.conf" \
    "$HOME/.config/kitty/theme.conf"

process_template "$DOTFILES_DIR/templates/wofi/config" \
    "$HOME/.config/wofi/config"

process_template "$DOTFILES_DIR/templates/wofi/style.css" \
    "$HOME/.config/wofi/style.css"

process_template "$DOTFILES_DIR/templates/dunst/dunstrc" \
    "$HOME/.config/dunst/dunstrc"

process_template "$DOTFILES_DIR/templates/rofi/theme.rasi" \
    "$HOME/.config/rofi/theme.rasi"

process_template "$DOTFILES_DIR/templates/rofi/power-menu.rasi" \
    "$HOME/.config/rofi/power-menu.rasi"

process_template "$DOTFILES_DIR/templates/cava/config" \
    "$HOME/.config/cava/config"

process_template "$DOTFILES_DIR/templates/zellij/theme.kdl" \
    "$HOME/.config/zellij/themes/current.kdl"

# Starship: each theme has its own complete starship.toml
STARSHIP_THEME="$THEME_DIR/starship.toml"
if [[ -f "$STARSHIP_THEME" ]]; then
    cp "$STARSHIP_THEME" "$HOME/.config/starship.toml"
    ok "starship.toml"
fi

# Fastfetch: config + logo image from theme
mkdir -p "$HOME/.config/fastfetch"
process_template "$DOTFILES_DIR/templates/fastfetch/config.jsonc" \
    "$HOME/.config/fastfetch/config.jsonc"
LOGO_FILE=$(find "$THEME_DIR/fastfetch" -maxdepth 1 -type f \( -name "*.png" -o -name "*.jpg" -o -name "*.jpeg" -o -name "*.webp" \) 2>/dev/null | head -1)
LOGO_SCRIPT="$THEME_DIR/fastfetch/logo.py"
if [[ -n "$LOGO_FILE" ]]; then
    magick "$LOGO_FILE" -resize 300x300 "$HOME/.config/fastfetch/logo.png"
    ok "fastfetch logo"
elif [[ -f "$LOGO_SCRIPT" ]]; then
    python3 "$LOGO_SCRIPT" > "$HOME/.config/fastfetch/logo.txt"
    sed -i \
        -e 's|"type": "kitty-direct"|"type": "raw"|' \
        -e 's|"source": "[^"]*"|"source": "'"$HOME"'/.config/fastfetch/logo.txt"|' \
        -e 's|"width": [0-9]*|"width": 26|' \
        "$HOME/.config/fastfetch/config.jsonc"
    ok "fastfetch logo (text art)"
else
    rm -f "$HOME/.config/fastfetch/logo.png"
    sed -i 's/"type": "kitty-direct"/"type": "auto"/; s/"source": ".*"/"source": "auto"/' "$HOME/.config/fastfetch/config.jsonc"
    ok "fastfetch logo (distro default)"
fi

# Neovim: update colorscheme file
NVIM_THEME_FILE="$HOME/.config/nvim/colorscheme.lua"
if [[ -n "${NVIM_COLORSCHEME:-}" ]]; then
    echo "return \"$NVIM_COLORSCHEME\"" > "$NVIM_THEME_FILE"
    ok "Neovim colorscheme"
fi

# Save current theme (before wallpaper so wallpaper.sh reads the correct theme)
echo "$THEME_ID" > "$DOTFILES_DIR/.theme-current"

# Set wallpaper — restore saved choice or fallback to first
WALLPAPER_SAVE="$HOME/.cache/theme-wallpaper/$THEME_ID"
WALLPAPER=""
if [[ -f "$WALLPAPER_SAVE" ]]; then
    saved="$(cat "$WALLPAPER_SAVE")"
    [[ -f "$saved" ]] && WALLPAPER="$saved"
fi
if [[ -z "$WALLPAPER" ]]; then
    WALLPAPER_DIR="$THEME_DIR/wallpapers"
    if [[ -d "$WALLPAPER_DIR" ]]; then
        WALLPAPER=$(find "$WALLPAPER_DIR" -maxdepth 1 -type f \( -name "*.png" -o -name "*.jpg" -o -name "*.jpeg" -o -name "*.webp" \) | head -1)
    fi
fi
if [[ -n "$WALLPAPER" ]]; then
    "$DOTFILES_DIR/scripts/wallpaper.sh" "$WALLPAPER" 2>/dev/null || true
fi

# Reload components
info "Reloading components..."

# Hyprland - reload config
hyprctl reload 2>/dev/null && ok "Hyprland" || true

# Waybar - restart
if pgrep -x waybar >/dev/null 2>&1; then
    killall waybar 2>/dev/null || true
    sleep 0.3
fi
waybar &>/dev/null &
disown
ok "Waybar"

# Dunst - restart
if pgrep -x dunst >/dev/null 2>&1; then
    killall dunst 2>/dev/null || true
    sleep 0.3
fi
dunst &>/dev/null &
disown
ok "Dunst"

# Kitty - reload via remote control
if pgrep -x kitty >/dev/null 2>&1; then
    kitty @ set-colors --all "$HOME/.config/kitty/theme.conf" 2>/dev/null || true
    ok "Kitty"
fi

# Neovim - reload colorscheme in running instances
if [[ -n "${NVIM_COLORSCHEME:-}" ]]; then
    for sock in /run/user/$(id -u)/nvim.*.0 /tmp/nvim.*/0; do
        nvim --server "$sock" --remote-send ":colorscheme $NVIM_COLORSCHEME<CR>" 2>/dev/null || true
    done
    ok "Neovim"
fi

info "Theme '$THEME_ID' applied!"
