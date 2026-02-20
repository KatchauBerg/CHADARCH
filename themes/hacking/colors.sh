#!/usr/bin/env bash
# Hacking - Black & Red, terminal hacker aesthetic

# Base colors
export BASE="0a0a0a"
export MANTLE="060606"
export CRUST="000000"
export SURFACE0="1a1a1a"
export SURFACE1="252525"
export SURFACE2="333333"
export OVERLAY0="4a4a4a"
export OVERLAY1="5c5c5c"
export OVERLAY2="6e6e6e"

# Text
export TEXT="d0d0d0"
export SUBTEXT0="a0a0a0"
export SUBTEXT1="b8b8b8"

# Accent colors
export ROSEWATER="ff6b6b"
export FLAMINGO="ff5252"
export PINK="ff4081"
export MAUVE="ff1744"
export RED="ff0000"
export MAROON="d50000"
export PEACH="ff3d00"
export YELLOW="ff6e40"
export GREEN="ff1744"
export TEAL="b71c1c"
export SKY="e53935"
export SAPPHIRE="c62828"
export BLUE="d32f2f"
export LAVENDER="ef5350"

# Functional aliases
export ACCENT="$RED"
export ACCENT_ALT="$MAUVE"
export WARN="$PEACH"
export ERROR="$RED"
export SUCCESS="$GREEN"

# Transparency variants (for Hyprland rgba)
export BASE_ALPHA="${BASE}ee"
export SURFACE0_ALPHA="${SURFACE0}cc"
export ACCENT_ALPHA="${RED}ee"
export ACCENT_ALT_ALPHA="${MAUVE}ee"

# Theme metadata
export THEME_NAME="Hacking"
export THEME_WALLPAPER="main.png"
export LOGO_PATH="$HOME/.config/fastfetch/logo.png"
export ACCENT_COLOR="red"
export NVIM_COLORSCHEME="tokyonight-night"
