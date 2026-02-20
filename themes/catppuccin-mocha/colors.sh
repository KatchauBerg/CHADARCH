#!/usr/bin/env bash
# Catppuccin Mocha - https://catppuccin.com/palette

# Base colors
export BASE="1e1e2e"
export MANTLE="181825"
export CRUST="11111b"
export SURFACE0="313244"
export SURFACE1="45475a"
export SURFACE2="585b70"
export OVERLAY0="6c7086"
export OVERLAY1="7f849c"
export OVERLAY2="9399b2"

# Text
export TEXT="cdd6f4"
export SUBTEXT0="a6adc8"
export SUBTEXT1="bac2de"

# Accent colors
export ROSEWATER="f5e0dc"
export FLAMINGO="f2cdcd"
export PINK="f5c2e7"
export MAUVE="cba6f7"
export RED="f38ba8"
export MAROON="eba0ac"
export PEACH="fab387"
export YELLOW="f9e2af"
export GREEN="a6e3a1"
export TEAL="94e2d5"
export SKY="89dceb"
export SAPPHIRE="74c7ec"
export BLUE="89b4fa"
export LAVENDER="b4befe"

# Functional aliases
export ACCENT="$MAUVE"
export ACCENT_ALT="$BLUE"
export WARN="$YELLOW"
export ERROR="$RED"
export SUCCESS="$GREEN"

# Transparency variants (for Hyprland rgba)
export BASE_ALPHA="${BASE}ee"
export SURFACE0_ALPHA="${SURFACE0}cc"
export ACCENT_ALPHA="${MAUVE}ee"
export ACCENT_ALT_ALPHA="${BLUE}ee"

# Theme metadata
export THEME_NAME="Catppuccin Mocha"
export THEME_WALLPAPER="main.png"
export LOGO_PATH="$HOME/.config/fastfetch/logo.png"
export ACCENT_COLOR="magenta"
export NVIM_COLORSCHEME="catppuccin-mocha"
