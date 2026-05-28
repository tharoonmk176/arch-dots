#!/usr/bin/env bash

set -euo pipefail

WALLPAPER_DIR="$HOME/Pictures/wallpapers"
CACHE_DIR="$HOME/.cache/matugen"
WALLPAPER_CACHE="$HOME/.cache/wallpaper"
CURRENT_WALLPAPER="$HOME/.config/hypr/current_wallpaper"
COLORS_JSON="$CACHE_DIR/colors.json"
PALETTE_MODE_FILE="$CACHE_DIR/palette-mode"

WAYBAR_STYLE="$HOME/.config/waybar/style.css"
WAYBAR_COLORS="$HOME/.config/waybar/colors.css"
KITTY_CONF="$HOME/.config/kitty/kitty.conf"
KITTY_COLORS="$HOME/.config/kitty/matugen-colors.conf"
HYPR_COLORS="$HOME/.config/hypr/colors.conf"

die() {
    notify-send -u critical "Theme switcher" "$1" 2>/dev/null || true
    printf 'theme-switcher: %s\n' "$1" >&2
    exit 1
}

need() {
    command -v "$1" >/dev/null 2>&1 || die "Missing dependency: $1"
}

prepare_dirs() {
    mkdir -p "$CACHE_DIR" "$WALLPAPER_CACHE"
    mkdir -p "$(dirname "$CURRENT_WALLPAPER")"
    mkdir -p "$(dirname "$WAYBAR_STYLE")" "$(dirname "$KITTY_COLORS")"

    if [ ! -f "$HOME/.config/rofi/colors.rasi" ]; then
        mkdir -p "$HOME/.config/rofi"
        cat >"$HOME/.config/rofi/colors.rasi" <<'EOF'
* {
    matugen-background: #11111b;
    matugen-surface: #181825;
    matugen-foreground: #cdd6f4;
    matugen-accent: #89b4fa;
    matugen-on-accent: #11111b;
}

window {
    background-color: @matugen-background;
    border-color: @matugen-accent;
}

mainbox,
listview,
inputbar {
    background-color: @matugen-background;
}

element {
    text-color: @matugen-foreground;
}

element normal normal,
element selected normal,
element alternate normal {
    text-color: @matugen-foreground;
}

element selected {
    background-color: @matugen-accent;
    text-color: @matugen-on-accent;
}

entry {
    text-color: @matugen-foreground;
}

prompt,
textbox-prompt-colon {
    text-color: @matugen-accent;
}
EOF
    fi
}

choose_wallpaper() {
    local selected
    mapfile -t wallpapers < <(
        find "$WALLPAPER_DIR" -type f \
            \( -iname '*.jpg' -o -iname '*.jpeg' -o -iname '*.png' -o -iname '*.webp' \) \
            2>/dev/null | sort
    )

    ((${#wallpapers[@]} > 0)) || die "No wallpapers found in $WALLPAPER_DIR"

    if command -v rofi >/dev/null 2>&1; then
        selected=$(
            for wallpaper in "${wallpapers[@]}"; do
                printf '%s\0icon\x1f%s\n' "$(basename "$wallpaper")" "$wallpaper"
            done | rofi -dmenu -i -show-icons -p "Wallpaper" \
                -theme "$HOME/.config/rofi/wallpaper-switcher.rasi"
        ) || return 1

        [ -n "$selected" ] || return 1
        for wallpaper in "${wallpapers[@]}"; do
            if [ "$(basename "$wallpaper")" = "$selected" ]; then
                printf '%s\n' "$wallpaper"
                return
            fi
        done
        return 1
    fi

    if command -v zenity >/dev/null 2>&1; then
        selected=$(
            zenity --list --title="Wallpaper" --width=900 --height=620 \
                --text="Select wallpaper" --column="Wallpaper" \
                "${wallpapers[@]}"
        ) || return 1
        [ -n "$selected" ] && printf '%s\n' "$selected"
        return
    fi

    if command -v fzf >/dev/null 2>&1 && [ -t 0 ]; then
        printf '%s\n' "${wallpapers[@]}" | fzf --prompt="Wallpaper> " --height=40% --reverse --border
        return
    fi

    printf '%s\n' "${wallpapers[0]}"
}

palette_definitions() {
    cat <<'EOF'
Dominant
Vibrant
Accent
Soft
EOF
}

choose_palette() {
    local wallpaper=$1
    local selected
    local selected_index
    local label
    local source
    local i
    local -a displays=()
    local -a metadata=()

    while IFS= read -r label; do
        [ -n "$label" ] || continue

        if source=$(extract_palette_color "$wallpaper" "$label" 2>/dev/null); then
            local color_info="<span foreground=\"$source\">■</span>"
            displays+=("$(printf '%-15s %s  %s' "$label" "$color_info" "$source")")
            metadata+=("$label")
        fi
    done < <(palette_definitions)

    ((${#displays[@]} > 0)) || die "Could not build palette candidates"

    if command -v rofi >/dev/null 2>&1; then
        selected_index=$(printf '%s\n' "${displays[@]}" | rofi -dmenu -i -p "Palette" -markup-rows -format i) || return 1
        [[ "$selected_index" =~ ^[0-9]+$ ]] || return 1
        printf '%s\n' "${metadata[$selected_index]}"
        return
    elif command -v fzf >/dev/null 2>&1 && [ -t 0 ]; then
        selected=$(printf '%s\n' "${displays[@]}" | fzf --prompt="Palette> " --height=40% --reverse --border) || return 1
        for i in "${!displays[@]}"; do
            if [ "${displays[$i]}" = "$selected" ]; then
                printf '%s\n' "${metadata[$i]}"
                return
            fi
        done
        return 1
    else
        printf '%s\n' "${metadata[0]}"
        return
    fi
}

palette_by_name() {
    local wanted=$1
    local label

    while IFS= read -r label; do
        if [ "$label" = "$wanted" ]; then
            printf '%s\n' "$label"
            return 0
        fi
    done < <(palette_definitions)

    return 1
}

current_palette() {
    local saved="Dominant"

    if [ -f "$PALETTE_MODE_FILE" ]; then
        saved=$(sed -n '1p' "$PALETTE_MODE_FILE")
    fi

    palette_by_name "$saved" || palette_by_name "Dominant"
}

next_palette() {
    local current="Dominant"
    local label
    local first=""
    local use_next=0

    if [ -f "$PALETTE_MODE_FILE" ]; then
        current=$(sed -n '1p' "$PALETTE_MODE_FILE")
    fi

    while IFS= read -r label; do
        [ -n "$first" ] || first="$label"

        if [ "$use_next" -eq 1 ]; then
            printf '%s\n' "$label"
            return 0
        fi

        [ "$label" = "$current" ] && use_next=1
    done < <(palette_definitions)

    printf '%s\n' "$first"
}

save_palette_mode() {
    printf '%s\n' "$PALETTE_NAME" >"$PALETTE_MODE_FILE"
}

generate_palette() {
    local wallpaper=$1
    local palette_choice=${2:-}
    local palette_label
    local tmp_json

    [ -n "$palette_choice" ] || palette_choice=$(current_palette)
    palette_label=$palette_choice
    SOURCE_COLOR=$(extract_palette_color "$wallpaper" "$palette_label") ||
        die "Could not extract $palette_label color from wallpaper"

    tmp_json=$(mktemp)
    trap 'rm -f "$tmp_json"' RETURN

    matugen --type scheme-content color hex "${SOURCE_COLOR#\#}" --json hex >"$tmp_json"
    jq -e '.colors and .base16' "$tmp_json" >/dev/null ||
        die "Matugen did not produce a usable palette"

    mv "$tmp_json" "$COLORS_JSON"
    PALETTE_NAME=$palette_label
    save_palette_mode
    trap - RETURN
}

extract_palette_color() {
    local wallpaper=$1
    local mode=$2

    python3 - "$wallpaper" "$mode" <<'PY'
import colorsys
import math
import sys
from PIL import Image

path, mode = sys.argv[1], sys.argv[2]
img = Image.open(path).convert("RGB")
img.thumbnail((260, 260))
quantized = img.quantize(colors=96, method=Image.Quantize.MEDIANCUT).convert("RGB")
colors = quantized.getcolors(260 * 260) or []

swatches = []
total = max(1, sum(count for count, _ in colors))
for count, (r, g, b) in colors:
    h, l, s = colorsys.rgb_to_hls(r / 255, g / 255, b / 255)
    if l < 0.08 or l > 0.94:
        continue
    weight = count / total
    swatches.append({
        "rgb": (r, g, b),
        "h": h,
        "l": l,
        "s": s,
        "weight": weight,
    })

if not swatches:
    swatches = [{"rgb": rgb, "h": 0, "l": 0.5, "s": 0, "weight": count / total} for count, rgb in colors]

visible_swatches = [c for c in swatches if 0.22 <= c["l"] <= 0.86]
if not visible_swatches:
    visible_swatches = swatches

def color_distance(a, b):
    return math.sqrt(sum((x - y) ** 2 for x, y in zip(a["rgb"], b["rgb"])))

def readable_score(c):
    return 1 - abs(c["l"] - 0.56)

def dominant_score(c):
    return c["weight"] * (0.55 + c["s"]) * readable_score(c)

def vibrant_score(c):
    saturation = c["s"] ** 2.4
    presence = c["weight"] ** 0.08
    lightness = 1 - abs(c["l"] - 0.52) * 0.72
    return presence * saturation * max(0.05, lightness)

def soft_score(c):
    return c["weight"] * (1 - abs(c["s"] - 0.35)) * readable_score(c)

ordered = sorted(visible_swatches, key=dominant_score, reverse=True)
choice = ordered[0]

if mode == "Vibrant":
    vibrant_pool = [c for c in visible_swatches if 0.24 <= c["l"] <= 0.80 and c["s"] >= 0.14]
    choice = max(vibrant_pool or visible_swatches, key=vibrant_score)
elif mode == "Accent":
    vibrant_pool = [c for c in visible_swatches if 0.24 <= c["l"] <= 0.82 and c["s"] >= 0.12]
    base = max(vibrant_pool or visible_swatches, key=vibrant_score)
    distinct = [c for c in visible_swatches if color_distance(c, base) > 48]
    choice = max(distinct or visible_swatches, key=lambda c: vibrant_score(c) * (0.65 + min(color_distance(c, base), 180) / 180))
elif mode == "Soft":
    soft_pool = [c for c in visible_swatches if 0.30 <= c["l"] <= 0.84]
    choice = max(soft_pool or visible_swatches, key=soft_score)

r, g, b = choice["rgb"]
print(f"#{r:02x}{g:02x}{b:02x}")
PY
}

json_color() {
    jq -er "$1" "$COLORS_JSON"
}

load_colors() {
    BACKGROUND=$(json_color '.colors.background.dark.color // .colors.background.default.color // .colors.surface.dark.color // .colors.surface.default.color')
    SURFACE=$(json_color '.colors.surface.dark.color // .colors.surface.default.color // .colors.background.dark.color // .colors.background.default.color')
    SURFACE_CONTAINER=$(json_color '.colors.surface_container.dark.color // .colors.surface_container.default.color // .colors.surface_variant.dark.color // .colors.surface_variant.default.color // .colors.surface.dark.color // .colors.surface.default.color')
    READABLE_TEXT=$(json_color '.colors.on_surface.dark.color // .colors.on_surface.default.color // .colors.on_background.dark.color // .colors.on_background.default.color')

    VIBRANT_TEXT=${SOURCE_COLOR:-$(json_color '.colors.primary.dark.color // .colors.primary.default.color')}
    ON_VIBRANT=$(json_color '.colors.on_primary.dark.color // .colors.on_primary.default.color // .colors.background.dark.color // .colors.background.default.color')
    SECONDARY=$(json_color '.colors.secondary.dark.color // .colors.secondary.default.color // .colors.primary.dark.color // .colors.primary.default.color')
    TERTIARY=$(json_color '.colors.tertiary.dark.color // .colors.tertiary.default.color // .colors.primary.dark.color // .colors.primary.default.color')
    ERROR=$(json_color '.colors.error.dark.color // .colors.error.default.color')
    WARNING=$(json_color '.colors.tertiary.dark.color // .colors.tertiary.default.color // .colors.error.dark.color')
    SUCCESS=$(json_color '.colors.secondary.dark.color // .colors.secondary.default.color')
    PRIMARY="$VIBRANT_TEXT"
}

write_waybar_theme() {
    cat >"$WAYBAR_COLORS" <<EOF
@define-color background $BACKGROUND;
@define-color surface $SURFACE;
@define-color surface_container $SURFACE_CONTAINER;
@define-color text $VIBRANT_TEXT;
@define-color primary $VIBRANT_TEXT;
@define-color readable_text $READABLE_TEXT;
@define-color on_text $ON_VIBRANT;
@define-color secondary $SECONDARY;
@define-color tertiary $TERTIARY;
@define-color error $ERROR;
@define-color warning $WARNING;
@define-color success $SUCCESS;
@define-color chip $SURFACE_CONTAINER;
@define-color chip_border $SURFACE;
EOF
}

write_kitty_theme() {
    {
        printf '# Generated by theme-switcher.sh\n'
        printf 'background %s\n' "$BACKGROUND"
        printf 'foreground %s\n' "$VIBRANT_TEXT"
        printf 'selection_background %s\n' "$VIBRANT_TEXT"
        printf 'selection_foreground %s\n' "$ON_VIBRANT"
        printf 'cursor %s\n' "$VIBRANT_TEXT"
        printf 'cursor_text_color %s\n\n' "$BACKGROUND"

        for i in {0..15}; do
            base=$(printf 'base%02x' "$i")
            value=$(jq -er ".base16.$base.dark.color // .base16.$base.default.color" "$COLORS_JSON")
            printf 'color%s %s\n' "$i" "$value"
        done
    } >"$KITTY_COLORS"

    if [ -f "$KITTY_CONF" ] && ! grep -qxF "include matugen-colors.conf" "$KITTY_CONF"; then
        printf '\n# Matugen wallpaper palette\ninclude matugen-colors.conf\n' >>"$KITTY_CONF"
    fi
}

write_hypr_theme() {
    cat >"$HYPR_COLORS" <<EOF
# Generated by theme-switcher.sh
\$wallpaper = $SELECTED_WALLPAPER
\$palette = $PALETTE_NAME
\$source_color = rgba(${SOURCE_COLOR#\#}ff)
\$background = rgba(${BACKGROUND#\#}ff)
\$surface = rgba(${SURFACE#\#}ff)
\$foreground = rgba(${VIBRANT_TEXT#\#}ff)
\$readable_foreground = rgba(${READABLE_TEXT#\#}ff)
\$primary = rgba(${VIBRANT_TEXT#\#}ff)
\$secondary = rgba(${SECONDARY#\#}ff)
\$tertiary = rgba(${TERTIARY#\#}ff)
\$error = rgba(${ERROR#\#}ff)
EOF
}

hex_to_rgb_csv() {
    local hex=${1#\#}
    printf '%d, %d, %d' "0x${hex:0:2}" "0x${hex:2:2}" "0x${hex:4:2}"
}

replace_managed_css_block() {
    local file=$1
    local content=$2

    touch "$file"
    sed -i '/\/\* BEGIN MATUGEN THEME \*\//,/\/\* END MATUGEN THEME \*\//d' "$file"
    printf '%s\n' "$content" >>"$file"
}

write_rofi_theme() {
    mkdir -p "$HOME/.config/rofi"

    cat >"$HOME/.config/rofi/colors.rasi" <<EOF
* {
    matugen-background: $BACKGROUND;
    matugen-surface: $SURFACE_CONTAINER;
    matugen-foreground: $READABLE_TEXT;
    matugen-accent: $VIBRANT_TEXT;
    matugen-on-accent: $ON_VIBRANT;

    background: @matugen-background;
    background-color: @matugen-background;
    foreground: @matugen-foreground;
    text-color: @matugen-foreground;
    border-color: @matugen-accent;
    selected-normal-background: @matugen-accent;
    selected-normal-foreground: @matugen-on-accent;
    selected-active-background: @matugen-accent;
    selected-active-foreground: @matugen-on-accent;
    selected-urgent-background: @error;
    selected-urgent-foreground: @matugen-background;
}

window {
    background-color: @matugen-background;
    border-color: @matugen-accent;
}

mainbox,
listview,
inputbar {
    background-color: @matugen-background;
}

element {
    text-color: @matugen-foreground;
}

element normal normal,
element selected normal,
element alternate normal {
    text-color: @matugen-foreground;
}

element selected {
    background-color: @matugen-accent;
    text-color: @matugen-on-accent;
}

entry {
    text-color: @matugen-foreground;
}

prompt,
textbox-prompt-colon {
    text-color: @matugen-accent;
}
EOF

    if [ -f "$HOME/.config/rofi/config.rasi" ] &&
        ! grep -qxF '@import "colors.rasi"' "$HOME/.config/rofi/config.rasi"; then
        printf '\n@import "colors.rasi"\n' >>"$HOME/.config/rofi/config.rasi"
    fi
}

write_swaync_theme() {
    mkdir -p "$HOME/.config/swaync"
    mkdir -p "$HOME/.config/eww"
    local bg_rgb surface_rgb accent_rgb fg_rgb
    bg_rgb=$(hex_to_rgb_csv "$BACKGROUND")
    surface_rgb=$(hex_to_rgb_csv "$SURFACE")
    accent_rgb=$(hex_to_rgb_csv "$VIBRANT_TEXT")
    fg_rgb=$(hex_to_rgb_csv "$READABLE_TEXT")

    # SwayNC colors
    cat >"$HOME/.config/swaync/colors.css" <<EOF
@define-color cc-bg rgba(${bg_rgb}, 0.85);
@define-color noti-border-color rgba(${accent_rgb}, 0.2);
@define-color noti-bg rgba(${surface_rgb}, 0.95);
@define-color noti-bg-opaque rgb(${surface_rgb});
@define-color noti-bg-darker rgb(${bg_rgb});
@define-color noti-bg-hover rgba(${accent_rgb}, 0.15);
@define-color noti-bg-focus rgba(${accent_rgb}, 0.25);
@define-color noti-close-bg rgba(${accent_rgb}, 0.16);
@define-color noti-close-bg-hover rgba(${accent_rgb}, 0.28);
@define-color text-color rgb(${fg_rgb});
@define-color text-color-disabled rgba(${fg_rgb}, 0.5);
@define-color bg-selected rgb(${accent_rgb});
EOF

    # Eww colors
    cat >"$HOME/.config/eww/colors.css" <<EOF
@define-color background rgb(${bg_rgb});
@define-color surface rgb(${surface_rgb});
@define-color primary rgb(${accent_rgb});
@define-color secondary rgb(${accent_rgb});
@define-color text rgb(${fg_rgb});
@define-color readable_text rgb(${fg_rgb});
@define-color error rgb(255, 100, 100);
@define-color success rgb(100, 255, 100);
EOF

    cat >"$HOME/.config/eww/_colors.scss" <<EOF
\$accent: rgb(${accent_rgb});
\$fg: rgb(${fg_rgb});
\$bg: rgba(${bg_rgb}, 0.6);
EOF
}


write_wlogout_theme() {
    local bg_rgb surface_rgb accent_rgb
    bg_rgb=$(hex_to_rgb_csv "$BACKGROUND")
    surface_rgb=$(hex_to_rgb_csv "$SURFACE_CONTAINER")
    accent_rgb=$(hex_to_rgb_csv "$VIBRANT_TEXT")

    mkdir -p "$HOME/.config/wlogout"
    if [ ! -f "$HOME/.config/wlogout/layout" ] &&
        [ -d "$HOME/arch-hyprland/.config/wlogout" ]; then
        cp -rn "$HOME/arch-hyprland/.config/wlogout/." "$HOME/.config/wlogout/"
    fi

    cat >"$HOME/.config/wlogout/style.css" <<EOF
* {
    font-family: "JetBrainsMono Nerd Font", "JetBrains Mono", sans-serif;
    font-size: 18px;
}

window {
    background-color: rgba($bg_rgb, 0.55);
}

button {
    margin: 10px;
    padding: 20px 28px;
    border-radius: 16px;
    border: 1px solid transparent;
    color: $READABLE_TEXT;
    background-color: rgba($surface_rgb, 0.7);
}

button:hover {
    border-color: $VIBRANT_TEXT;
    background-color: $VIBRANT_TEXT;
    color: rgba($bg_rgb, 1);
}
EOF
}

write_gtk_theme() {
    for dir in "$HOME/.config/gtk-3.0" "$HOME/.config/gtk-4.0"; do
        mkdir -p "$dir"
        cat >"$dir/gtk.css" <<EOF
@define-color theme_bg_color $BACKGROUND;
@define-color theme_fg_color $READABLE_TEXT;
@define-color theme_base_color $SURFACE;
@define-color theme_selected_bg_color $VIBRANT_TEXT;
@define-color theme_selected_fg_color $ON_VIBRANT;
@define-color accent_color $VIBRANT_TEXT;
@define-color accent_bg_color $VIBRANT_TEXT;
@define-color accent_fg_color $ON_VIBRANT;
EOF
        cp "$dir/gtk.css" "$dir/gtk-dark.css"
    done
}

write_vscode_theme() {
    local settings="$HOME/.config/Code/User/settings.json"
    local tmp

    [ -f "$settings" ] || return 0
    tmp=$(mktemp)
    jq \
        --arg bg "$BACKGROUND" \
        --arg surface "$SURFACE_CONTAINER" \
        --arg fg "$READABLE_TEXT" \
        --arg accent "$VIBRANT_TEXT" \
        --arg onaccent "$ON_VIBRANT" \
        '. + {
          "workbench.colorCustomizations": ((."workbench.colorCustomizations" // {}) + {
            "activityBar.background": $bg,
            "activityBar.foreground": $accent,
            "activityBarBadge.background": $accent,
            "activityBarBadge.foreground": $onaccent,
            "sideBar.background": $bg,
            "sideBar.foreground": $fg,
            "sideBarTitle.foreground": $accent,
            "statusBar.background": $surface,
            "statusBar.foreground": $fg,
            "statusBarItem.hoverBackground": $accent,
            "statusBarItem.hoverForeground": $onaccent,
            "titleBar.activeBackground": $bg,
            "titleBar.activeForeground": $fg,
            "editor.background": $bg,
            "editor.foreground": $fg,
            "editorCursor.foreground": $accent,
            "editor.selectionBackground": ($accent + "55"),
            "focusBorder": $accent,
            "progressBar.background": $accent,
            "terminal.foreground": $fg,
            "terminal.background": $bg
          })
        }' "$settings" >"$tmp" && mv "$tmp" "$settings"
}

write_cava_theme() {
    local tmp
    local tmp_clean
    mkdir -p "$HOME/.config/cava/themes"
    cat >"$HOME/.config/cava/themes/matugen" <<EOF
[color]
background = '$BACKGROUND'
foreground = '$VIBRANT_TEXT'
gradient = 1
gradient_color_1 = '$VIBRANT_TEXT'
gradient_color_2 = '$SECONDARY'
gradient_color_3 = '$TERTIARY'
gradient_color_4 = '$ERROR'
EOF

    if [ -f "$HOME/.config/cava/config" ]; then
        tmp=$(mktemp)
        awk '
            BEGIN { wrote = 0 }
            /^[[:space:]]*;?[[:space:]]*theme[[:space:]]*=/ {
                if (!wrote) {
                    print "theme = '\''matugen'\''"
                    wrote = 1
                }
                next
            }
            { print }
            END {
                if (!wrote) {
                    print ""
                    print "[color]"
                    print "theme = '\''matugen'\''"
                }
            }
        ' "$HOME/.config/cava/config" >"$tmp" && mv "$tmp" "$HOME/.config/cava/config"

        tmp_clean=$(mktemp)
        awk '
            function flush_color() {
                if (color_has_content) {
                    printf "%s", color_buffer
                }
                color_buffer = ""
                color_has_content = 0
                in_color = 0
            }

            /^\[color\][[:space:]]*$/ {
                if (in_color) {
                    flush_color()
                }
                in_color = 1
                color_has_content = 0
                color_buffer = $0 ORS
                next
            }

            in_color && /^\[[^]]+\][[:space:]]*$/ {
                flush_color()
                print
                next
            }

            in_color {
                color_buffer = color_buffer $0 ORS
                if ($0 !~ /^[[:space:]]*$/) {
                    color_has_content = 1
                }
                next
            }

            { print }

            END {
                if (in_color) {
                    flush_color()
                }
            }
        ' "$HOME/.config/cava/config" >"$tmp_clean" && mv "$tmp_clean" "$HOME/.config/cava/config"
    fi
}

write_btop_theme() {
    mkdir -p "$HOME/.config/btop/themes"
    cat >"$HOME/.config/btop/themes/matugen.theme" <<EOF
theme[main_bg]="$BACKGROUND"
theme[main_fg]="$READABLE_TEXT"
theme[title]="$VIBRANT_TEXT"
theme[hi_fg]="$VIBRANT_TEXT"
theme[selected_bg]="$VIBRANT_TEXT"
theme[selected_fg]="$ON_VIBRANT"
theme[inactive_fg]="$SURFACE_CONTAINER"
theme[graph_text]="$SECONDARY"
theme[meter_bg]="$SURFACE_CONTAINER"
theme[proc_misc]="$TERTIARY"
theme[cpu_box]="$VIBRANT_TEXT"
theme[mem_box]="$SECONDARY"
theme[net_box]="$TERTIARY"
theme[proc_box]="$VIBRANT_TEXT"
theme[div_line]="$SURFACE_CONTAINER"
theme[temp_start]="$SECONDARY"
theme[temp_mid]="$TERTIARY"
theme[temp_end]="$ERROR"
theme[cpu_start]="$VIBRANT_TEXT"
theme[cpu_mid]="$SECONDARY"
theme[cpu_end]="$TERTIARY"
theme[free_start]="$SECONDARY"
theme[free_mid]=""
theme[free_end]="$VIBRANT_TEXT"
theme[cached_start]="$TERTIARY"
theme[cached_mid]=""
theme[cached_end]="$SECONDARY"
theme[available_start]="$SECONDARY"
theme[available_mid]=""
theme[available_end]="$VIBRANT_TEXT"
theme[used_start]="$ERROR"
theme[used_mid]="$TERTIARY"
theme[used_end]="$VIBRANT_TEXT"
theme[download_start]="$SECONDARY"
theme[download_mid]="$TERTIARY"
theme[download_end]="$VIBRANT_TEXT"
theme[upload_start]="$VIBRANT_TEXT"
theme[upload_mid]="$TERTIARY"
theme[upload_end]="$ERROR"
EOF

    if [ -f "$HOME/.config/btop/btop.conf" ]; then
        sed -i 's/^color_theme = .*/color_theme = "matugen"/' "$HOME/.config/btop/btop.conf"
    fi
}

write_spicetify_theme() {
    local dir="$HOME/.config/spicetify/Themes/matugen"
    mkdir -p "$dir"
    cat >"$dir/color.ini" <<EOF
[default]
text               = ${READABLE_TEXT#\#}
subtext            = ${SECONDARY#\#}
main               = ${BACKGROUND#\#}
sidebar            = ${SURFACE#\#}
player             = ${SURFACE_CONTAINER#\#}
card               = ${SURFACE_CONTAINER#\#}
shadow             = ${BACKGROUND#\#}
selected-row       = ${VIBRANT_TEXT#\#}
button             = ${VIBRANT_TEXT#\#}
button-active      = ${TERTIARY#\#}
button-disabled    = ${SURFACE_CONTAINER#\#}
tab-active         = ${VIBRANT_TEXT#\#}
notification       = ${VIBRANT_TEXT#\#}
notification-error = ${ERROR#\#}
misc               = ${SURFACE_CONTAINER#\#}
EOF
}

hyprlock_rgb() {
    local hex=${1#\#}
    [ "${#hex}" -eq 8 ] && hex=${hex:0:6}
    printf 'rgb(%d, %d, %d)' "0x${hex:0:2}" "0x${hex:2:2}" "0x${hex:4:2}"
}

write_hyprlock_theme() {
    local bg_rgb fg_rgb accent_rgb surface_rgb tertiary_rgb dim_rgb
    bg_rgb=$(hyprlock_rgb "$BACKGROUND")
    fg_rgb=$(hyprlock_rgb "$READABLE_TEXT")
    accent_rgb=$(hyprlock_rgb "$VIBRANT_TEXT")
    surface_rgb=$(hyprlock_rgb "$SURFACE_CONTAINER")
    tertiary_rgb=$(hyprlock_rgb "$TERTIARY")
    dim_rgb=$(hyprlock_rgb "$SECONDARY")

    cat >"$HOME/.config/hypr/hyprlock.conf" <<EOF
# Generated by theme-switcher.sh — synced with active palette

background {
    path = \$HOME/.config/hypr/current_wallpaper
    blur_size = 8
    blur_passes = 4
    contrast = 0.85
    brightness = 0.55
    vibrancy = 0.28
    vibrancy_darkness = 0.15
}

input-field {
    monitor =
    size = 320, 58
    outline_thickness = 3
    dots_size = 0.28
    dots_spacing = 0.45
    dots_center = true
    outer_color = $accent_rgb
    inner_color = $surface_rgb
    font_color = $fg_rgb
    fade_on_empty = true
    placeholder_text = Enter password
    hide_input = true
    position = 0, -80
    halign = center
    valign = center
}

label {
    monitor =
    text = cmd[update:1000] date '+%H:%M'
    color = $fg_rgb
    font_size = 88
    font_family = JetBrainsMono Nerd Font
    position = 0, 120
    halign = center
    valign = center
}

label {
    monitor =
    text = cmd[update:1000] date '+%A · %d %B'
    color = $dim_rgb
    font_size = 17
    font_family = JetBrainsMono Nerd Font
    position = 0, 55
    halign = center
    valign = center
}

label {
    monitor =
    text = cmd[update:1000] echo "\$(whoami)@\$(hostname -s)"
    color = $tertiary_rgb
    font_size = 15
    font_family = JetBrainsMono Nerd Font
    position = 0, 20
    halign = center
    valign = center
}

label {
    monitor =
    text = cmd[update:30000] echo "󰁹  \$(cat /sys/class/power_supply/BAT1/capacity 2>/dev/null || echo '—')%"
    color = $dim_rgb
    font_size = 14
    font_family = JetBrainsMono Nerd Font
    position = 0, -20
    halign = center
    valign = center
}
EOF
}

write_app_themes() {
    write_rofi_theme
    write_swaync_theme
    write_wlogout_theme
    write_gtk_theme
    write_vscode_theme
    write_cava_theme
    write_btop_theme
    write_spicetify_theme
    write_hyprlock_theme
}

apply_theme() {
    ln -sf "$SELECTED_WALLPAPER" "$CURRENT_WALLPAPER"
    cp "$SELECTED_WALLPAPER" "$WALLPAPER_CACHE/current_wallpaper"

    awww img "$CURRENT_WALLPAPER" \
        --transition-type grow \
        --transition-pos 0.5,0.5 \
        --transition-duration 1.0 >/dev/null 2>&1 &

    pkill -SIGUSR1 kitty 2>/dev/null || true
    pkill -SIGUSR2 waybar 2>/dev/null || {
        pkill waybar 2>/dev/null || true
        waybar >/dev/null 2>&1 &
    }

    hyprctl reload >/dev/null 2>&1 || true
    hyprctl eval "hl.config({ general = { col = { active_border = 'rgba(${VIBRANT_TEXT#\#}ff) rgba(${TERTIARY#\#}ff) 45deg', inactive_border = 'rgba(${SURFACE_CONTAINER#\#}aa)' } } })" >/dev/null 2>&1 || true
    swaync-client -rs >/dev/null 2>&1 || true
    pkill -USR1 cava 2>/dev/null || true
}

main() {
    need matugen
    need jq
    need python3
    need awww
    prepare_dirs

    case "${1:-}" in
        --cycle-mode)
            SELECTED_WALLPAPER=$(readlink -f "$CURRENT_WALLPAPER" 2>/dev/null || true)
            if [ -z "$SELECTED_WALLPAPER" ] || [ ! -f "$SELECTED_WALLPAPER" ]; then
                SELECTED_WALLPAPER=$(choose_wallpaper) || exit 0
            fi
            PALETTE_CHOICE=$(next_palette)
            ;;
        --pick-mode)
            SELECTED_WALLPAPER=$(readlink -f "$CURRENT_WALLPAPER" 2>/dev/null || true)
            if [ -z "$SELECTED_WALLPAPER" ] || [ ! -f "$SELECTED_WALLPAPER" ]; then
                SELECTED_WALLPAPER=$(choose_wallpaper) || exit 0
            fi
            PALETTE_CHOICE=$(choose_palette "$SELECTED_WALLPAPER") || exit 0
            ;;
        --apply-current)
            SELECTED_WALLPAPER=$(readlink -f "$CURRENT_WALLPAPER" 2>/dev/null || true)
            [ -n "$SELECTED_WALLPAPER" ] && [ -f "$SELECTED_WALLPAPER" ] || die "No current wallpaper to apply"
            PALETTE_CHOICE=$(current_palette)
            ;;
        "")
            SELECTED_WALLPAPER=$(choose_wallpaper) || exit 0
            PALETTE_CHOICE=$(current_palette)
            ;;
        *)
            die "Unknown option: $1"
            ;;
    esac

    [ -n "$SELECTED_WALLPAPER" ] || exit 0
    [ -f "$SELECTED_WALLPAPER" ] || die "Selected wallpaper does not exist"

    generate_palette "$SELECTED_WALLPAPER" "$PALETTE_CHOICE"
    load_colors
    write_waybar_theme
    write_kitty_theme
    write_hypr_theme
    write_app_themes
    apply_theme

    notify-send "Theme updated" "$(basename "$SELECTED_WALLPAPER") · $PALETTE_NAME" -i "$SELECTED_WALLPAPER" 2>/dev/null || \
        notify-send "Theme updated" "$(basename "$SELECTED_WALLPAPER") · $PALETTE_NAME" 2>/dev/null || true
    printf 'Theme updated from %s\n' "$SELECTED_WALLPAPER"
    printf 'Palette: %s\nSource: %s\nBackground: %s\nText: %s\nSecondary: %s\n' "$PALETTE_NAME" "$SOURCE_COLOR" "$BACKGROUND" "$VIBRANT_TEXT" "$SECONDARY"
}

main "$@"
