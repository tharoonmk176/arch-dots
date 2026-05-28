# Hyprland Preconfigured Themes

This directory contains preconfigured color themes for Hyprland. Each theme provides a complete color palette that gets applied to your Hyprland configuration.

## Usage

### Using the Theme Preset Switcher

Run the interactive theme picker:
```bash
~/.config/hypr/scripts/theme-preset-switcher.sh
```

### Command Line Options

List all available themes:
```bash
~/.config/hypr/scripts/theme-preset-switcher.sh list
```

Get the current theme:
```bash
~/.config/hypr/scripts/theme-preset-switcher.sh current
```

Apply a specific theme:
```bash
~/.config/hypr/scripts/theme-preset-switcher.sh apply tokyo-night
```

### Add to Keybindings

Add a keybinding to quickly access the theme picker in your `keybindings.lua`:
```lua
hl.bind(mainMod .. " + SHIFT + CTRL + T", hl.dsp.exec_cmd("~/.config/hypr/scripts/theme-preset-switcher.sh"))
```

## Available Themes (54 total)

### Originals
- **catppuccin** - Modern, pastel color palette (smooth)
- **dracula** - Dark, high-contrast color scheme (vibrant)
- **gruvbox** - Retro warm color palette (earthy tones)
- **nord** - Arctic, north-bluish color palette (cool tones)

### Classics & Heritage
- **tokyo-night** - Deep blue nocturnal city vibes
- **tokyo-night-storm** - Luminous nocturnal storm variant
- **everforest** - Warm earthy green forest palette
- **rose-pine** - Soft rose and pine forest tones
- **kanagawa** - Japanese ink wash painting tones
- **one-dark** - Clean dark bluish-gray palette
- **monokai-pro** - Vibrant high-contrast rich palette
- **solarized-dark** - Science-based color accuracy
- **ayu-dark** - Warm dark with orange and teal accents
- **synthwave** - Retro neon cyberpunk sunset

### Editor-Inspired
- **vscode-dark** - Classic VS Code Dark+ editor theme
- **night-owl** - Deep focus dark with bright accents
- **palenight** - Material dark with purple richness
- **oceanic-next** - Deep ocean blue-green tones
- **material-ocean** - Deep marine abyss with neon glow
- **oxocarbon** - IBM Carbon design dark palette
- **github-dark** - Clean dark with GitHub accents
- **github-light** - Clean bright GitHub-inspired workspace

### Nature & Environment
- **forest-deep** - Ancient woodland emerald depths
- **ocean-deep** - Abyssal marine darkness
- **aurora** - Northern lights color symphony
- **sunset** - Warm twilight glow
- **autumn** - Warm fall harvest colors
- **spring** - Fresh pastel spring awakening
- **winter** - Icy cool arctic minimalism
- **desert** - Warm sandy amber tones
- **tropical** - Vibrant island getaway

### Flora & Fauna
- **lavender** - Soft purple floral serenity
- **mint** - Fresh cool green tranquility
- **coral** - Vibrant underwater coral warmth
- **sakura** - Cherry blossom pink elegance
- **midnight** - Deepest blue-black minimalism
- **mirage** - Deep purple twilight haze

### Gemstone Collection
- **amethyst** - Royal purple gemstone depth
- **emerald** - Rich green jewel tones
- **ruby** - Deep red gemstone passion
- **sapphire** - Royal blue gemstone clarity
- **topaz** - Warm golden amber radiance
- **obsidian** - Volcanic dark with molten accents

### Tech & Cyberpunk
- **cyberpunk** - Neon-drenched future dystopia
- **outrun** - Retro wave synth nostalgia
- **matrix** - Digital rain green on black
- **arch-linux** - Rolling release blue energy
- **ubuntu** - African warmth and community
- **nordic** - Scandinavian cool minimalism

### Light Themes
- **latte** - Warm creamy light tones
- **papercolor** - Soothing paper-like light theme
- **monochrome** - Elegant pure grayscale minimalism
- **nebula** - Cosmic space dust and starlight
- **blood-moon** - Crimson lunar eclipse
- **sakura** - Cherry blossom pink elegance

## Creating Custom Themes

To create a custom theme:

1. Create a new `.conf` file in this directory with your color palette
2. Use the same format as the existing theme files
3. The theme colors will be applied to your Hyprland configuration

Example: `~/.config/hypr/themes/mytheme.conf`

```conf
# My Custom Theme
$background = rgba(1a1a2eff)
$surface = rgba(262641ff)
$foreground = rgba(e8e9f3ff)
$readable_foreground = rgba(f5f5f5ff)
$primary = rgba(7aa2f7ff)
$secondary = rgba(9ece6aff)
$tertiary = rgba(c084fcff)
$error = rgba(f7768eff)
$accent = rgba(7aa2f7ff)
$success = rgba(9ece6aff)
$warning = rgba(ffe66dff)
```

Then apply it with:
```bash
~/.config/hypr/scripts/theme-preset-switcher.sh apply mytheme
```

## Color Variable Guide

- **$background** - Main window/desktop background color
- **$surface** - Panel, menu background colors
- **$foreground** - Default text color
- **$readable_foreground** - High-contrast text for better readability
- **$primary** - Primary accent color (borders, highlights)
- **$secondary** - Secondary accent color
- **$tertiary** - Tertiary accent color
- **$error** - Error/alert color
- **$accent** - Main accent color (same as primary typically)
- **$success** - Success/positive color
- **$warning** - Warning/caution color

## Theme Integration

These themes integrate with:
- Hyprland window manager (borders, decorations)
- Waybar (bar colors and styles)
- Rofi (launcher and menus)
- Wlogout (logout menu)
- Kitty terminal (through color schemes)
- Swaync (notification center)
- GTK3/GTK4 (application theme)

Colors are automatically applied to `~/.config/hypr/colors.conf` when you switch themes.
