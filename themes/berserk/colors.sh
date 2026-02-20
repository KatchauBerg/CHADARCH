#!/usr/bin/env bash
# Berserk - Dark fantasy: scorched earth, blood crimson, hawk gold, moonlit steel

# ─── Base colors (scorched earth / old parchment backgrounds) ─────────────────
export BASE="0d0906"
export MANTLE="080402"
export CRUST="030201"

export SURFACE0="1e1208"
export SURFACE1="2e1b0d"
export SURFACE2="3d2415"

export OVERLAY0="5c3d28"
export OVERLAY1="7a5640"
export OVERLAY2="9e7860"

# ─── Text (parchment / cursed manuscript) ─────────────────────────────────────
export TEXT="e8d8c4"
export SUBTEXT0="c9b89a"
export SUBTEXT1="dccaad"

# ─── Accent colors (Berserk thematic palette) ─────────────────────────────────
export ROSEWATER="f5ede0"
export FLAMINGO="e8d8c4"
export PINK="e74c3c"
export MAUVE="c0392b"
export RED="c0392b"
export MAROON="8b1a1a"
export PEACH="c98327"
export YELLOW="c9a227"
export GREEN="8fa4b8"
export TEAL="9e6535"
export SKY="8fa4b8"
export SAPPHIRE="7a8fa6"
export BLUE="6b8fa6"
export LAVENDER="e8d8c4"

# ─── Functional aliases ───────────────────────────────────────────────────────
export ACCENT="$MAUVE"
export ACCENT_ALT="$YELLOW"
export WARN="$PEACH"
export ERROR="$RED"
export SUCCESS="$GREEN"

# ─── Transparency variants (for Hyprland rgba()) ──────────────────────────────
export BASE_ALPHA="${BASE}ee"
export SURFACE0_ALPHA="${SURFACE0}cc"
export ACCENT_ALPHA="${MAUVE}ee"
export ACCENT_ALT_ALPHA="${YELLOW}ee"

# ─── Theme metadata ───────────────────────────────────────────────────────────
export THEME_NAME="Berserk"
export THEME_WALLPAPER="main.png"
export LOGO_PATH="$HOME/.config/fastfetch/logo.png"
export ACCENT_COLOR="red"
export NVIM_COLORSCHEME="chadarch-berserk"
