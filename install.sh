#!/usr/bin/env bash
# Dotfiles installer
# Installs packages, deploys all config modules, and applies default theme.

set -euo pipefail

DOTFILES_DIR="$(cd "$(dirname "$0")" && pwd)"
DEFAULT_THEME="catppuccin-mocha"
HYPR_CONF="$HOME/.config/hypr/hyprland.conf"
HYPR_TEMPLATES="$DOTFILES_DIR/templates/hypr"

source "$DOTFILES_DIR/scripts/globalcontrol.sh"

# ---------------------------------------------------------------------------
# PACKAGES
# ---------------------------------------------------------------------------
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
    cliphist        # clipboard history manager (Super+V)
    wireplumber     # audio session manager (required by volumecontrol)
    xdotool         # used by dontkillsteam.sh to hide Steam to tray
    # hyprpicker   # color picker (AUR) — install manually: yay -S hyprpicker
)
sudo pacman -S --needed --noconfirm "${PACKAGES[@]}"
ok "Packages installed"

# ---------------------------------------------------------------------------
# SCRIPT SYMLINKS  (~/.local/bin)
# ---------------------------------------------------------------------------
info "Installing scripts to ~/.local/bin..."
mkdir -p "$HOME/.local/bin"
for script in "$DOTFILES_DIR/scripts/"*.sh; do
    name="$(basename "$script" .sh)"
    ln -sf "$script" "$HOME/.local/bin/$name"
    chmod +x "$script"
done
ln -sf "$DOTFILES_DIR/scripts/dotfiles-shell" "$HOME/.local/bin/dotfiles-shell"
chmod +x "$DOTFILES_DIR/scripts/dotfiles-shell"
ok "Scripts symlinked to ~/.local/bin"

# ---------------------------------------------------------------------------
# DIRECTORIES
# ---------------------------------------------------------------------------
info "Creating config directories..."
mkdir -p "$HOME/.config/hypr/animations"
mkdir -p "$HOME/.config/hypr/workflows"
mkdir -p "$HOME/.config/hypr/shaders"
mkdir -p "$HOME/.config/waybar"
mkdir -p "$HOME/.config/kitty"
mkdir -p "$HOME/.config/wofi"
mkdir -p "$HOME/.config/dunst"
mkdir -p "$HOME/.config/rofi/styles"
mkdir -p "$HOME/.config/fastfetch"
mkdir -p "$HOME/.config/cava"
mkdir -p "$HOME/.config/nvim"
mkdir -p "$HOME/.cache/wallpaper-thumbs"
mkdir -p "$HOME/.cache/theme-thumbs"
mkdir -p "$HOME/.cache/theme-wallpaper"
mkdir -p "$HOME/.local/state/dotfiles"
mkdir -p "$HOME/Pictures/Screenshots"
ok "Directories created"

# ---------------------------------------------------------------------------
# HYPRLAND CONFIG — modular deployment
# ---------------------------------------------------------------------------
info "Deploying Hyprland config modules..."

# hyprland.conf — entry point (always managed, safe to overwrite)
cp "$HYPR_TEMPLATES/hyprland.conf" "$HYPR_CONF"

# Managed modules — always deployed (overwrite safe)
for module in env nvidia monitors apps autostart layouts windowrules keybindings; do
    cp "$HYPR_TEMPLATES/${module}.conf" "$HOME/.config/hypr/${module}.conf"
done
ok "Managed modules deployed"

# userprefs.conf — deployed ONCE, never overwritten
if [[ ! -f "$HOME/.config/hypr/userprefs.conf" ]]; then
    cp "$HYPR_TEMPLATES/userprefs.conf" "$HOME/.config/hypr/userprefs.conf"
    ok "userprefs.conf deployed"
else
    ok "userprefs.conf already exists — skipped"
fi

# Animation presets
for preset in "$HYPR_TEMPLATES/animations/"*.conf; do
    [[ -f "$preset" ]] && cp "$preset" "$HOME/.config/hypr/animations/$(basename "$preset")"
done
# Write animations.conf loader (only if not already customized)
if [[ ! -f "$HOME/.config/hypr/animations.conf" ]]; then
    echo "source = $HOME/.config/hypr/animations/default.conf" > "$HOME/.config/hypr/animations.conf"
fi
ok "Animation presets deployed"

# Workflow presets
for wf in "$HYPR_TEMPLATES/workflows/"*.conf; do
    [[ -f "$wf" ]] && cp "$wf" "$HOME/.config/hypr/workflows/$(basename "$wf")"
done
# Write workflows.conf loader (only if not already customized)
if [[ ! -f "$HOME/.config/hypr/workflows.conf" ]]; then
    cat > "$HOME/.config/hypr/workflows.conf" << 'EOF'
# workflows.conf — Active workflow profile
# Managed by dotfiles — use: dotfiles-shell workflow --select

$WORKFLOW             = default
$WORKFLOW_ICON        =
$WORKFLOW_DESCRIPTION = Default — normal desktop settings
$WORKFLOW_PATH        = ~/.config/hypr/workflows/default.conf

source = $WORKFLOW_PATH
EOF
fi
ok "Workflow presets deployed"

# Shaders
for shader in "$HYPR_TEMPLATES/shaders/"*.frag; do
    [[ -f "$shader" ]] && cp "$shader" "$HOME/.config/hypr/shaders/$(basename "$shader")"
done
# Write shaders.conf (only if not already customized)
if [[ ! -f "$HOME/.config/hypr/shaders.conf" ]]; then
    cp "$HYPR_TEMPLATES/shaders.conf" "$HOME/.config/hypr/shaders.conf"
fi
ok "Shaders deployed"

# ---------------------------------------------------------------------------
# ROFI STYLES
# ---------------------------------------------------------------------------
info "Deploying rofi styles..."
ROFI_STYLES_SRC="$DOTFILES_DIR/templates/rofi/styles"
if [[ -d "$ROFI_STYLES_SRC" ]]; then
    for style in "$ROFI_STYLES_SRC"/*.rasi; do
        [[ -f "$style" ]] && cp "$style" "$HOME/.config/rofi/styles/$(basename "$style")"
    done
fi
# Deploy utility themes
for util in clipboard selector; do
    src="$DOTFILES_DIR/templates/rofi/$util.rasi"
    [[ -f "$src" ]] && cp "$src" "$HOME/.config/rofi/$util.rasi"
done
# Create launcher.rasi (points to style 1 by default)
if [[ ! -f "$HOME/.config/rofi/launcher.rasi" ]]; then
    echo "@theme \"$HOME/.config/rofi/styles/style_1.rasi\"" > "$HOME/.config/rofi/launcher.rasi"
fi
ok "Rofi styles deployed"

# ---------------------------------------------------------------------------
# KITTY
# ---------------------------------------------------------------------------
KITTY_CONF="$HOME/.config/kitty/kitty.conf"
if [[ -f "$KITTY_CONF" ]]; then
    if ! grep -q "include ./theme.conf" "$KITTY_CONF"; then
        info "Adding theme include to kitty.conf..."
        echo -e "\n# Theme (managed by dotfiles)\ninclude ./theme.conf" >> "$KITTY_CONF"
        ok "Kitty theme include added"
    fi
fi

# ---------------------------------------------------------------------------
# ZSHRC
# ---------------------------------------------------------------------------
ZSHRC="$HOME/.zshrc"
if [[ -f "$ZSHRC" ]]; then
    if ! grep -q "fastfetch" "$ZSHRC"; then
        info "Adding fastfetch to .zshrc..."
        printf '\n# Fastfetch on terminal open\nfastfetch\n' >> "$ZSHRC"
        ok "Fastfetch added to .zshrc"
    fi
    if ! grep -q "starship init" "$ZSHRC"; then
        info "Adding starship to .zshrc..."
        sed -i '1s/^/eval "$(starship init zsh)"\n/' "$ZSHRC"
        ok "Starship added to .zshrc"
    fi
fi

# ---------------------------------------------------------------------------
# APPLY DEFAULT THEME
# ---------------------------------------------------------------------------
info "Applying default theme: $DEFAULT_THEME"
"$DOTFILES_DIR/scripts/theme-switch.sh" "$DEFAULT_THEME"

ok "Installation complete!"
echo ""
echo "=== Keybinds ==="
echo "  Window:     Super+Q=close  Super+W=float  Super+L=lock  Shift+F11=fullscreen"
echo "  Focus:      Super+Arrows   Super+1-9=workspace  Super+Tab=window list"
echo "  Apps:       Super+T=terminal  Super+E=files  Super+B=browser  Super+A=launcher"
echo "              Super+V=clipboard  Super+P=screenshot  Print=fullscreen shot"
echo "  Theming:    Super+D=themes  Super+Shift+W=wallpaper  Super+R=random wall"
echo "              Super+Shift+Y=animations  Super+Shift+F=shaders  Super+F1=shader off"
echo "  Workflow:   Super+Shift+X=profile  Super+Alt+G=game mode"
echo "  Waybar:     Super+Alt+Up/Down=cycle layouts"
echo "  Media:      F10=mute  F11=vol-  F12=vol+  XF86Brightness keys"
echo ""
echo "Don't forget to:"
echo "  1. Add wallpapers to ~/dotfiles/themes/<theme>/wallpapers/"
echo "  2. Comment out nvidia.conf source in hyprland.conf if not on NVIDIA"
echo "  3. Set your monitor in ~/.config/hypr/monitors.conf"
echo "  4. Set your apps in ~/.config/hypr/apps.conf"
echo "  5. Install color picker (AUR): yay -S hyprpicker"
