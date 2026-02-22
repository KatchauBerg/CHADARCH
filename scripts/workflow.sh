#!/usr/bin/env bash
# workflow.sh — Switch Hyprland workflow profiles
# Profiles live in templates/hypr/workflows/ and define decoration, blur,
# animation, and gap overrides. Active profile is sourced by hyprland.conf.
#
# Usage:
#   workflow.sh --select              rofi picker
#   workflow.sh <name>                apply named workflow
#   workflow.sh                       same as --select

set -euo pipefail

source "$(dirname "$(realpath "$0")")/globalcontrol.sh"

WORKFLOWS_DIR="$DOTFILES_DIR/templates/hypr/workflows"
WORKFLOWS_CONF="$XDG_CONFIG_HOME/hypr/workflows.conf"

list_workflows() {
    for f in "$WORKFLOWS_DIR"/*.conf; do
        [[ -f "$f" ]] && basename "$f" .conf
    done
}

get_workflow_meta() {
    local name="$1" field="$2"
    grep "^\$${field}=" "$WORKFLOWS_DIR/${name}.conf" 2>/dev/null \
        | head -1 | cut -d= -f2- | tr -d '"' | sed 's/^[[:space:]]*//'
}

apply_workflow() {
    local name="$1"
    local src="$WORKFLOWS_DIR/${name}.conf"

    if [[ ! -f "$src" ]]; then
        print_log -err "Workflow not found: $name"
        print_log -info "Available: $(list_workflows | tr '\n' ' ')"
        exit 1
    fi

    local icon desc
    icon="$(get_workflow_meta "$name" WORKFLOW_ICON)"
    desc="$(get_workflow_meta "$name" WORKFLOW_DESCRIPTION)"

    # Write loader file — hyprland.conf sources this
    cat > "$WORKFLOWS_CONF" << EOF
# workflows.conf — Active workflow profile
# Managed by dotfiles — use: dotfiles-shell workflow --select
# DO NOT edit manually — this file is rewritten by workflow.sh

\$WORKFLOW             = ${name}
\$WORKFLOW_ICON        = ${icon}
\$WORKFLOW_DESCRIPTION = ${desc}
\$WORKFLOW_PATH        = ~/.config/hypr/workflows/${name}.conf

source = \$WORKFLOW_PATH
EOF
    set_conf WORKFLOW "$name"

    hyprctl reload 2>/dev/null && print_log -ok "Workflow: $name" \
        || print_log -warn "hyprctl reload failed"
    notify-send "${icon} Workflow" "${desc:-$name}" -t 2000 2>/dev/null || true
}

select_workflow() {
    local current
    current="$(get_conf WORKFLOW "default")"

    local entries=""
    while IFS= read -r name; do
        local icon desc label
        icon="$(get_workflow_meta "$name" WORKFLOW_ICON)"
        desc="$(get_workflow_meta "$name" WORKFLOW_DESCRIPTION)"
        label="${icon} ${name}"
        [[ -n "$desc" ]] && label="${label}  —  ${desc}"
        [[ "$name" == "$current" ]] && label="${label} (active)"
        entries+="${label}\n"
    done < <(list_workflows)

    local rofi_theme="$XDG_CONFIG_HOME/rofi/clipboard.rasi"
    local choice
    choice=$(printf '%b' "$entries" | \
        rofi -dmenu -i -p "Workflow" \
        ${rofi_theme:+-theme "$rofi_theme"} 2>/dev/null) || exit 0

    # Extract workflow name (first word after icon)
    local chosen
    chosen=$(echo "$choice" | awk '{print $2}' | sed 's/[[:space:]].*$//')
    # Fallback: try first word directly if second word not found
    [[ -z "$chosen" || ! -f "$WORKFLOWS_DIR/${chosen}.conf" ]] && \
        chosen=$(echo "$choice" | grep -oP '^\S+\s+\K\S+' || echo "$choice" | awk '{print $1}')
    # Final fallback: strip icon
    [[ ! -f "$WORKFLOWS_DIR/${chosen}.conf" ]] && \
        chosen=$(echo "$choice" | sed 's/ (active)$//' | awk '{print $NF}' | tr -d ' ')

    if [[ -z "$chosen" || ! -f "$WORKFLOWS_DIR/${chosen}.conf" ]]; then
        print_log -err "Could not determine workflow from: $choice"
        exit 1
    fi

    apply_workflow "$chosen"
}

case "${1:-}" in
    --select|"") select_workflow ;;
    *) apply_workflow "$1" ;;
esac
