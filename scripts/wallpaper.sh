#!/usr/bin/env bash
# Wallpaper manager using swww
# Usage:
#   wallpaper.sh <path>      - Set specific wallpaper
#   wallpaper.sh --random    - Random wallpaper from current theme
#   wallpaper.sh --select    - Open rofi picker with previews

set -euo pipefail

DOTFILES_DIR="$(cd "$(dirname "$(realpath "$0")")/.." && pwd)"
source "$DOTFILES_DIR/scripts/globalcontrol.sh"

THUMB_DIR="$XDG_CACHE_HOME/wallpaper-thumbs"
WALLPAPER_SAVE_DIR="$XDG_CACHE_HOME/theme-wallpaper"

set_wallpaper() {
    local wallpaper="$1"

    if [[ ! -f "$wallpaper" ]]; then
        echo "Wallpaper not found: $wallpaper" >&2
        exit 1
    fi

    wallpaper="$(realpath "$wallpaper")"

    # Ensure swww daemon is running
    swww query &>/dev/null || swww-daemon &>/dev/null &

    # Set wallpaper with transition
    swww img "$wallpaper" \
        --transition-type grow \
        --transition-duration 1.5 \
        --transition-fps 60

    # Save choice for current theme
    mkdir -p "$WALLPAPER_SAVE_DIR"
    echo "$wallpaper" > "$WALLPAPER_SAVE_DIR/$(get_current_theme)"

    echo "Wallpaper set: $(basename "$wallpaper")"
}

# Generate thumbnail for rofi icon (prefixed by theme to avoid collisions)
make_thumb() {
    local src="$1"
    local theme
    theme="$(get_current_theme)"
    local name
    name="$(basename "$src" | sed 's/\.[^.]*$//')"
    local thumb="$THUMB_DIR/${theme}--${name}.png"

    if [[ ! -f "$thumb" ]] || [[ "$src" -nt "$thumb" ]]; then
        magick "$src" -thumbnail 200x200^ -gravity center -extent 200x200 "$thumb" 2>/dev/null
    fi
    echo "$thumb"
}

select_wallpaper() {
    local wallpaper_dir
    wallpaper_dir="$(get_wallpaper_dir)"

    if [[ ! -d "$wallpaper_dir" ]]; then
        echo "No wallpapers directory for theme: $(get_current_theme)" >&2
        exit 1
    fi

    mkdir -p "$THUMB_DIR"

    # Build rofi entries: "filename\0icon\x1f/path/to/thumb"
    local entries=""
    local -a paths=()

    while IFS= read -r img; do
        local name
        name="$(basename "$img")"
        local thumb
        thumb="$(make_thumb "$img")"
        entries+="${name}\0icon\x1f${thumb}\n"
        paths+=("$img")
    done < <(find "$wallpaper_dir" -maxdepth 1 -type f \( -name "*.png" -o -name "*.jpg" -o -name "*.jpeg" -o -name "*.webp" \) | sort)

    # Add random option at the top
    entries="🎲 Random\n${entries}"

    if [[ ${#paths[@]} -eq 0 ]]; then
        echo "No wallpapers found in $wallpaper_dir" >&2
        exit 1
    fi

    # Show rofi picker
    local rofi_theme="$HOME/.config/rofi/selector.rasi"
    local -a rofi_args=(-dmenu -i -p "Wallpaper" -show-icons)
    [[ -f "$rofi_theme" ]] && rofi_args+=(-theme "$rofi_theme")

    local choice
    choice=$(echo -en "$entries" | rofi "${rofi_args[@]}") || exit 0

    if [[ "$choice" == "🎲 Random" ]]; then
        local random_wp
        random_wp=$(printf '%s\n' "${paths[@]}" | shuf -n 1)
        set_wallpaper "$random_wp"
    else
        # Find matching path
        for img in "${paths[@]}"; do
            if [[ "$(basename "$img")" == "$choice" ]]; then
                set_wallpaper "$img"
                return
            fi
        done
        echo "Wallpaper not found: $choice" >&2
        exit 1
    fi
}

cycle_wallpaper() {
    local direction="$1"  # next or prev
    local wallpaper_dir
    wallpaper_dir="$(get_wallpaper_dir)"

    mapfile -t wallpapers < <(find "$wallpaper_dir" -maxdepth 1 -type f \
        \( -name "*.png" -o -name "*.jpg" -o -name "*.jpeg" -o -name "*.webp" \) | sort)

    if [[ ${#wallpapers[@]} -eq 0 ]]; then
        echo "No wallpapers found in $wallpaper_dir" >&2
        exit 1
    fi

    local current=""
    local save_file="$WALLPAPER_SAVE_DIR/$(get_current_theme)"
    [[ -f "$save_file" ]] && current="$(cat "$save_file")"

    local target=""
    local count=${#wallpapers[@]}

    for i in "${!wallpapers[@]}"; do
        if [[ "${wallpapers[$i]}" == "$current" ]]; then
            if [[ "$direction" == "next" ]]; then
                target="${wallpapers[$(( (i + 1) % count ))]}"
            else
                target="${wallpapers[$(( (i - 1 + count) % count ))]}"
            fi
            break
        fi
    done

    # Current wallpaper not found in list — start from beginning/end
    if [[ -z "$target" ]]; then
        if [[ "$direction" == "next" ]]; then
            target="${wallpapers[0]}"
        else
            target="${wallpapers[$(( count - 1 ))]}"
        fi
    fi

    set_wallpaper "$target"
}

case "${1:-}" in
    --random)
        WALLPAPER_DIR="$(get_wallpaper_dir)"
        WALLPAPER=$(find "$WALLPAPER_DIR" -maxdepth 1 -type f \( -name "*.png" -o -name "*.jpg" -o -name "*.jpeg" -o -name "*.webp" \) | shuf -n 1)
        if [[ -z "$WALLPAPER" ]]; then
            echo "No wallpapers found" >&2
            exit 1
        fi
        set_wallpaper "$WALLPAPER"
        ;;
    --next)
        cycle_wallpaper next
        ;;
    --prev)
        cycle_wallpaper prev
        ;;
    --select)
        select_wallpaper
        ;;
    "")
        echo "Usage: $(basename "$0") <path> | --random | --next | --prev | --select"
        exit 1
        ;;
    *)
        set_wallpaper "$1"
        ;;
esac
