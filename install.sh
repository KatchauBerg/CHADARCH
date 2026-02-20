#!/usr/bin/env bash
# Dotfiles installer
# Installs packages, creates config dirs, and applies default theme

set -euo pipefail

DOTFILES_DIR="$(cd "$(dirname "$0")" && pwd)"
DEFAULT_THEME="catppuccin-mocha"

info() { printf '\033[1;34m[INFO]\033[0m %s\n' "$1"; }
ok()   { printf '\033[1;32m[ OK ]\033[0m %s\n' "$1"; }
err()  { printf '\033[1;31m[ERR]\033[0m %s\n' "$1" >&2; }

# Install packages
info "Installing packages..."
PACKAGES=(
    hyprlock
    hypridle
    swww
    waybar
    kitty
    rofi-wayland
    dunst
    grim
    slurp
    wl-clipboard
    jq
    brightnessctl
    rofi
    imagemagick
    fastfetch
    starship
    perl
    cava
    neovim
    playerctl
    dolphin
    libnotify
)

sudo pacman -S --needed --noconfirm "${PACKAGES[@]}"
ok "Packages installed"

# Create config directories
info "Creating config directories..."
mkdir -p "$HOME/.config/hypr"
mkdir -p "$HOME/.config/waybar"
mkdir -p "$HOME/.config/kitty"
mkdir -p "$HOME/.config/wofi"
mkdir -p "$HOME/.config/dunst"
mkdir -p "$HOME/.config/rofi"
mkdir -p "$HOME/.config/fastfetch"
mkdir -p "$HOME/.config/cava"
mkdir -p "$HOME/.config/nvim"
mkdir -p "$HOME/.cache/wallpaper-thumbs"
mkdir -p "$HOME/.cache/theme-thumbs"
mkdir -p "$HOME/.cache/theme-wallpaper"
mkdir -p "$HOME/Pictures/Screenshots"
ok "Directories created"

# Add theme source to hyprland.conf if not present
HYPR_CONF="$HOME/.config/hypr/hyprland.conf"
if [[ -f "$HYPR_CONF" ]]; then
    if ! grep -q "theme-current.conf" "$HYPR_CONF"; then
        info "Adding theme source to hyprland.conf..."
        sed -i '1s/^/source = ~\/.config\/hypr\/theme-current.conf\n\n/' "$HYPR_CONF"
        ok "Theme source added"
    fi

    # Add autostart if not present
    if ! grep -q "exec-once = waybar" "$HYPR_CONF"; then
        info "Adding autostart to hyprland.conf..."
        cat >> "$HYPR_CONF" << 'EOF'

# Autostart (managed by dotfiles)
exec-once = waybar
exec-once = dunst
exec-once = hypridle
exec-once = swww-daemon
EOF
        ok "Autostart added"
    fi

    # Update terminal and menu
    sed -i 's/^\$terminal =.*/$terminal = kitty/' "$HYPR_CONF"
    sed -i 's/^\$menu =.*/$menu = rofi -show drun -theme ~\/.config\/rofi\/theme.rasi/' "$HYPR_CONF"

    # Add keybinds if not present
    if ! grep -q "hyprlock" "$HYPR_CONF"; then
        info "Adding keybinds to hyprland.conf..."
        cat >> "$HYPR_CONF" << 'EOF'

# Keybinds (managed by dotfiles)
bind = $mainMod, L, exec, hyprlock
bind = , Print, exec, ~/dotfiles/scripts/screenshot.sh
bind = SHIFT, Print, exec, ~/dotfiles/scripts/screenshot.sh --area
bind = $mainMod, Print, exec, ~/dotfiles/scripts/screenshot.sh --save
bind = $mainMod SHIFT, Print, exec, ~/dotfiles/scripts/screenshot.sh --area --save
bind = $mainMod, W, exec, ~/dotfiles/scripts/wallpaper.sh --select
bind = $mainMod SHIFT, W, exec, ~/dotfiles/scripts/wallpaper.sh --random
bind = $mainMod, D, exec, ~/dotfiles/scripts/theme-select.sh
bind = $mainMod, X, exec, ~/dotfiles/scripts/power-menu.sh
EOF
        ok "Keybinds added"
    fi
fi

# Add theme include to kitty.conf if not present
KITTY_CONF="$HOME/.config/kitty/kitty.conf"
if [[ -f "$KITTY_CONF" ]]; then
    if ! grep -q "include ./theme.conf" "$KITTY_CONF"; then
        info "Adding theme include to kitty.conf..."
        echo -e "\n# Theme (managed by dotfiles)\ninclude ./theme.conf" >> "$KITTY_CONF"
        ok "Kitty theme include added"
    fi
fi

# Setup .zshrc
ZSHRC="$HOME/.zshrc"
if [[ -f "$ZSHRC" ]]; then
    # Add fastfetch (direct call) if not present
    if ! grep -q "fastfetch" "$ZSHRC"; then
        info "Adding fastfetch to .zshrc..."
        cat >> "$ZSHRC" << 'EOF'

# Fastfetch on terminal open
fastfetch
EOF
        ok "Fastfetch added to .zshrc"
    fi

    # Add starship init if not present
    if ! grep -q "starship init" "$ZSHRC"; then
        info "Adding starship to .zshrc..."
        sed -i '1s/^/eval "$(starship init zsh)"\n/' "$ZSHRC"
        ok "Starship added to .zshrc"
    fi
fi

# Apply default theme
info "Applying default theme: $DEFAULT_THEME"
"$DOTFILES_DIR/scripts/theme-switch.sh" "$DEFAULT_THEME"

ok "Installation complete!"
echo ""
echo "Keybinds:"
echo "  Super+D         → Theme selector"
echo "  Super+W         → Wallpaper selector"
echo "  Super+Shift+W   → Random wallpaper"
echo "  Super+X         → Power menu"
echo "  Super+L         → Lock screen"
echo "  Print           → Screenshot (clipboard)"
echo "  Shift+Print     → Screenshot area (clipboard)"
echo ""
echo "Don't forget to:"
echo "  1. Add wallpapers to ~/dotfiles/themes/<theme>/wallpapers/"
echo "  2. Add fastfetch image to ~/dotfiles/themes/<theme>/fastfetch/"
echo "  3. Configure Neovim to read ~/.config/nvim/colorscheme.lua"
echo "  4. Reload Hyprland: hyprctl reload"
