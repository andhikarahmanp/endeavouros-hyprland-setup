# 🐉 Shadow Dragon — Hyprland Setup Guide
### EndeavourOS (No DE) · Intel iGPU · Full Custom Desktop

> **Tema:** Dark Navy · Deep Purple · Magenta Accent · Clean & Powerful  
> **Referensi Warna dari Wallpaper:**
> - Background: `#0a0b14` (near black navy)
> - Primary: `#1e1b4b` (deep indigo)
> - Accent 1: `#7c3aed` (violet/purple)
> - Accent 2: `#d946ef` (magenta/fuchsia)
> - Text: `#e2e8f0` (soft white)
> - Subtle: `#334155` (muted slate)

---

## 📋 DAFTAR ISI

1. [Install EndeavourOS (No DE)](#1-install-endeavouros-no-de)
2. [Post-Install: Update & Setup Dasar](#2-post-install-update--setup-dasar)
3. [Install Hyprland & Wayland Stack](#3-install-hyprland--wayland-stack)
4. [Install Semua Komponen Desktop](#4-install-semua-komponen-desktop)
5. [Konfigurasi Hyprland](#5-konfigurasi-hyprland)
6. [Konfigurasi Waybar](#6-konfigurasi-waybar)
7. [Konfigurasi Dunst](#7-konfigurasi-dunst)
8. [Konfigurasi Rofi](#8-konfigurasi-rofi)
9. [Konfigurasi Kitty Terminal](#9-konfigurasi-kitty-terminal)
10. [Konfigurasi SDDM](#10-konfigurasi-sddm)
11. [Konfigurasi Thunar & File Manager](#11-konfigurasi-thunar--file-manager)
12. [Komponen Tambahan (Power, Clipboard, Screenshot)](#12-komponen-tambahan)
13. [GTK & Icon Theme](#13-gtk--icon-theme)
14. [Wallpaper & Swww](#14-wallpaper--swww)
15. [Fonts](#15-fonts)
16. [Final Check & Troubleshooting](#16-final-check--troubleshooting)

---

## 1. Install EndeavourOS (No DE)

### Saat Proses Instalasi:
1. Boot dari USB EndeavourOS
2. Pilih **"Online Installation"**
3. Di halaman **Desktop Environment**, pilih **"No Desktop"** (paling bawah)
4. Lanjutkan instalasi seperti biasa (partisi, user, timezone, dll)
5. Selesai install, reboot — lo akan masuk ke **TTY** (terminal hitam, no GUI)

> ⚠️ Jangan panik saat masuk TTY. Ini normal. Login dengan username & password yang lo buat saat install.

---

## 2. Post-Install: Update & Setup Dasar

Login ke TTY, lalu jalankan perintah berikut satu per satu:

```bash
# Update sistem dulu
sudo pacman -Syu

# Install tools penting
sudo pacman -S git base-devel wget curl neovim

# Install yay (AUR helper) — penting untuk install paket dari AUR
cd /tmp
git clone https://aur.archlinux.org/yay.git
cd yay
makepkg -si
cd ~

# Verifikasi yay terinstall
yay --version
```

---

## 3. Install Hyprland & Wayland Stack

```bash
# Install Hyprland (versi stable terbaru dari official repo)
sudo pacman -S hyprland

# Wayland essentials
sudo pacman -S \
  wayland \
  wayland-protocols \
  xorg-xwayland \
  xdg-desktop-portal-hyprland \
  xdg-utils \
  qt5-wayland \
  qt6-wayland

# Audio stack (PipeWire — wajib untuk modern desktop)
sudo pacman -S \
  pipewire \
  pipewire-alsa \
  pipewire-pulse \
  pipewire-jack \
  wireplumber \
  pavucontrol

# Polkit (untuk permission dialog)
sudo pacman -S polkit-kde-agent

# Network manager
sudo pacman -S networkmanager network-manager-applet
sudo systemctl enable NetworkManager

# Intel UHD Graphics driver (wajib untuk Intel integrated GPU)
sudo pacman -S mesa intel-media-driver vulkan-intel
```

---

## 4. Install Semua Komponen Desktop

```bash
# === STATUS BAR ===
sudo pacman -S waybar

# === NOTIFICATION DAEMON ===
sudo pacman -S dunst libnotify

# === APP LAUNCHER ===
sudo pacman -S rofi-wayland

# === LOGIN MANAGER ===
sudo pacman -S sddm
sudo systemctl enable sddm

# === TERMINAL ===
sudo pacman -S kitty

# === FILE MANAGER ===
sudo pacman -S thunar thunar-archive-plugin thunar-volman gvfs gvfs-mtp

# === WALLPAPER DAEMON ===
sudo pacman -S swww

# === SCREENSHOT ===
sudo pacman -S grim slurp swappy

# === CLIPBOARD ===
sudo pacman -S wl-clipboard cliphist

# === SCREEN LOCK ===
yay -S hyprlock

# === IDLE DAEMON (auto lock) ===
sudo pacman -S hypridle

# === LOGOUT / POWER MENU ===
yay -S wlogout

# === GTK THEME ENGINE ===
sudo pacman -S nwg-look

# === FONTS ===
sudo pacman -S \
  ttf-jetbrains-mono-nerd \
  ttf-nerd-fonts-symbols \
  noto-fonts \
  noto-fonts-emoji \
  ttf-font-awesome

# === ICON THEME ===
yay -S papirus-icon-theme

# === GTK DARK THEME ===
sudo pacman -S materia-gtk-theme

# === BRIGHTNESS CONTROL (Intel iGPU) ===
sudo pacman -S brightnessctl

# === BLUETOOTH (opsional) ===
sudo pacman -S bluez bluez-utils blueman
sudo systemctl enable bluetooth

# === IMAGE VIEWER ===
sudo pacman -S imv

# === MEDIA PLAYER ===
sudo pacman -S mpv

# === SYSTEM MONITOR ===
sudo pacman -S btop

# === APP PORTAL (untuk file picker di browser, dll) ===
sudo pacman -S xdg-desktop-portal-gtk
```

---

## 5. Konfigurasi Hyprland

Buat direktori konfigurasi:

```bash
mkdir -p ~/.config/hypr
nvim ~/.config/hypr/hyprland.conf
```

Paste konfigurasi berikut:

```ini
# ██╗  ██╗██╗   ██╗██████╗ ██████╗ ██╗      █████╗ ███╗   ██╗██████╗
# ██║  ██║╚██╗ ██╔╝██╔══██╗██╔══██╗██║     ██╔══██╗████╗  ██║██╔══██╗
# ███████║ ╚████╔╝ ██████╔╝██████╔╝██║     ███████║██╔██╗ ██║██║  ██║
# ██╔══██║  ╚██╔╝  ██╔═══╝ ██╔══██╗██║     ██╔══██║██║╚██╗██║██║  ██║
# ██║  ██║   ██║   ██║     ██║  ██║███████╗██║  ██║██║ ╚████║██████╔╝
# Shadow Dragon Theme

# ===== MONITOR =====
monitor=,preferred,auto,1

# ===== AUTOSTART =====
exec-once = dbus-update-activation-environment --systemd WAYLAND_DISPLAY XDG_CURRENT_DESKTOP
exec-once = systemctl --user import-environment WAYLAND_DISPLAY XDG_CURRENT_DESKTOP
exec-once = /usr/lib/polkit-kde-authentication-agent-1
exec-once = waybar
exec-once = dunst
exec-once = swww-daemon
exec-once = swww img ~/Pictures/Wallpapers/wallpaper.jpg --transition-type wipe --transition-fps 60
exec-once = wl-paste --type text --watch cliphist store
exec-once = wl-paste --type image --watch cliphist store
exec-once = hypridle
exec-once = nm-applet --indicator

# ===== ENVIRONMENT VARIABLES =====
env = XCURSOR_SIZE,24
env = XCURSOR_THEME,Bibata-Modern-Classic
env = QT_QPA_PLATFORM,wayland
env = QT_QPA_PLATFORMTHEME,qt5ct
env = QT_WAYLAND_DISABLE_WINDOWDECORATION,1
env = GDK_BACKEND,wayland
env = MOZ_ENABLE_WAYLAND,1
env = XDG_CURRENT_DESKTOP,Hyprland
env = XDG_SESSION_TYPE,wayland
env = XDG_SESSION_DESKTOP,Hyprland

# ===== LOOK AND FEEL =====
general {
    gaps_in = 4
    gaps_out = 10
    border_size = 2
    col.active_border = rgba(7c3aedff) rgba(d946efff) 45deg
    col.inactive_border = rgba(1e1b4baa)
    resize_on_border = true
    allow_tearing = false
    layout = dwindle
}

decoration {
    rounding = 10
    active_opacity = 1.0
    inactive_opacity = 0.92
    fullscreen_opacity = 1.0

    blur {
        enabled = true
        size = 8
        passes = 2
        new_optimizations = true
        xray = false
        ignore_opacity = false
        vibrancy = 0.2
        vibrancy_darkness = 0.5
        popups = true
    }

    shadow {
        enabled = true
        range = 20
        render_power = 3
        color = rgba(7c3aed66)
        color_inactive = rgba(0a0b1466)
    }
}

animations {
    enabled = true

    bezier = dragon, 0.05, 0.9, 0.1, 1.05
    bezier = smooth, 0.4, 0, 0.2, 1
    bezier = overshot, 0.7, 0.3, 0.2, 1.3
    bezier = linear, 0, 0, 1, 1

    animation = windows, 1, 5, dragon, slide
    animation = windowsOut, 1, 5, smooth, slide
    animation = windowsMove, 1, 4, smooth, slide
    animation = border, 1, 8, smooth
    animation = borderangle, 1, 40, linear, loop
    animation = fade, 1, 5, smooth
    animation = fadeDim, 1, 5, smooth
    animation = workspaces, 1, 5, dragon, slide
    animation = specialWorkspace, 1, 5, dragon, slidefadevert
}

dwindle {
    pseudotile = true
    preserve_split = true
    smart_split = false
    smart_resizing = true
}

master {
    new_status = master
}

misc {
    force_default_wallpaper = 0
    disable_hyprland_logo = true
    disable_splash_rendering = true
    mouse_move_enables_dpms = true
    key_press_enables_dpms = true
    enable_swallow = true
    swallow_regex = ^(kitty)$
    focus_on_activate = false
}

# ===== INPUT =====
input {
    kb_layout = us
    kb_options = caps:escape
    follow_mouse = 1
    sensitivity = 0
    touchpad {
        natural_scroll = true
        tap-to-click = true
        drag_lock = true
        disable_while_typing = true
    }
}

gestures {
    workspace_swipe = true
    workspace_swipe_fingers = 3
    workspace_swipe_distance = 300
    workspace_swipe_cancel_ratio = 0.5
}

# ===== WINDOW RULES =====
windowrulev2 = float, class:^(pavucontrol)$
windowrulev2 = float, class:^(blueman-manager)$
windowrulev2 = float, class:^(nm-connection-editor)$
windowrulev2 = float, class:^(file-roller)$
windowrulev2 = float, title:^(Picture-in-Picture)$
windowrulev2 = float, class:^(imv)$
windowrulev2 = size 900 600, class:^(thunar)$
windowrulev2 = float, class:^(thunar)$
windowrulev2 = center, class:^(thunar)$
windowrulev2 = opacity 0.95, class:^(thunar)$
windowrulev2 = opacity 0.9, class:^(kitty)$
windowrulev2 = noblur, class:^(firefox)$
windowrulev2 = workspace 2, class:^(firefox)$
windowrulev2 = workspace 3, class:^(Code)$
windowrulev2 = workspace 3, class:^(code-oss)$
windowrulev2 = workspace 4, class:^(Spotify)$

# ===== LAYER RULES =====
layerrule = blur, rofi
layerrule = blur, waybar
layerrule = ignorezero, waybar

# ===== KEYBINDINGS =====
$mainMod = SUPER

# -- Application Launchers --
bind = $mainMod, Return, exec, kitty
bind = $mainMod, E, exec, thunar
bind = $mainMod, B, exec, firefox
bind = $mainMod SHIFT, Return, exec, rofi -show drun
bind = $mainMod, V, exec, cliphist list | rofi -dmenu | cliphist decode | wl-copy

# -- Screenshot --
bind = , Print, exec, grim -g "$(slurp)" - | swappy -f -
bind = $mainMod, Print, exec, grim - | swappy -f -
bind = $mainMod SHIFT, P, exec, grim -g "$(slurp)" - | wl-copy

# -- Power / Session --
bind = $mainMod SHIFT, Q, exec, wlogout
bind = $mainMod SHIFT, L, exec, hyprlock

# -- Window Management --
bind = $mainMod, Q, killactive
bind = $mainMod, F, fullscreen
bind = $mainMod SHIFT, F, togglefloating
bind = $mainMod, P, pseudo
bind = $mainMod, J, togglesplit

# -- Focus Navigation (Vim-style) --
bind = $mainMod, h, movefocus, l
bind = $mainMod, l, movefocus, r
bind = $mainMod, k, movefocus, u
bind = $mainMod, j, movefocus, d

# -- Arrow key navigation --
bind = $mainMod, left, movefocus, l
bind = $mainMod, right, movefocus, r
bind = $mainMod, up, movefocus, u
bind = $mainMod, down, movefocus, d

# -- Move Windows --
bind = $mainMod SHIFT, h, movewindow, l
bind = $mainMod SHIFT, l, movewindow, r
bind = $mainMod SHIFT, k, movewindow, u
bind = $mainMod SHIFT, j, movewindow, d

# -- Resize Windows --
binde = $mainMod ALT, h, resizeactive, -30 0
binde = $mainMod ALT, l, resizeactive, 30 0
binde = $mainMod ALT, k, resizeactive, 0 -30
binde = $mainMod ALT, j, resizeactive, 0 30

# -- Workspaces --
bind = $mainMod, 1, workspace, 1
bind = $mainMod, 2, workspace, 2
bind = $mainMod, 3, workspace, 3
bind = $mainMod, 4, workspace, 4
bind = $mainMod, 5, workspace, 5
bind = $mainMod, 6, workspace, 6
bind = $mainMod, 7, workspace, 7
bind = $mainMod, 8, workspace, 8
bind = $mainMod, 9, workspace, 9
bind = $mainMod, 0, workspace, 10

# Move window to workspace
bind = $mainMod SHIFT, 1, movetoworkspace, 1
bind = $mainMod SHIFT, 2, movetoworkspace, 2
bind = $mainMod SHIFT, 3, movetoworkspace, 3
bind = $mainMod SHIFT, 4, movetoworkspace, 4
bind = $mainMod SHIFT, 5, movetoworkspace, 5
bind = $mainMod SHIFT, 6, movetoworkspace, 6
bind = $mainMod SHIFT, 7, movetoworkspace, 7
bind = $mainMod SHIFT, 8, movetoworkspace, 8
bind = $mainMod SHIFT, 9, movetoworkspace, 9
bind = $mainMod SHIFT, 0, movetoworkspace, 10

# -- Special Workspace (scratchpad) --
bind = $mainMod, S, togglespecialworkspace, magic
bind = $mainMod SHIFT, S, movetoworkspace, special:magic

# -- Scroll through workspaces --
bind = $mainMod, mouse_down, workspace, e+1
bind = $mainMod, mouse_up, workspace, e-1

# -- Mouse window management --
bindm = $mainMod, mouse:272, movewindow
bindm = $mainMod, mouse:273, resizewindow

# -- Media Keys --
bindel = , XF86AudioRaiseVolume, exec, wpctl set-volume @DEFAULT_AUDIO_SINK@ 5%+
bindel = , XF86AudioLowerVolume, exec, wpctl set-volume @DEFAULT_AUDIO_SINK@ 5%-
bindl = , XF86AudioMute, exec, wpctl set-mute @DEFAULT_AUDIO_SINK@ toggle
bindl = , XF86AudioMicMute, exec, wpctl set-mute @DEFAULT_AUDIO_SOURCE@ toggle
bindel = , XF86MonBrightnessUp, exec, brightnessctl set 5%+
bindel = , XF86MonBrightnessDown, exec, brightnessctl set 5%-
bindl = , XF86AudioPlay, exec, playerctl play-pause
bindl = , XF86AudioPrev, exec, playerctl previous
bindl = , XF86AudioNext, exec, playerctl next
```

---

## 6. Konfigurasi Waybar

```bash
mkdir -p ~/.config/waybar
```

### `~/.config/waybar/config.jsonc`

```bash
nvim ~/.config/waybar/config.jsonc
```

```jsonc
{
  "layer": "top",
  "position": "top",
  "height": 36,
  "spacing": 0,
  "margin-top": 6,
  "margin-left": 10,
  "margin-right": 10,
  "modules-left": [
    "hyprland/workspaces",
    "hyprland/window"
  ],
  "modules-center": [
    "clock"
  ],
  "modules-right": [
    "pulseaudio",
    "network",
    "bluetooth",
    "backlight",
    "battery",
    "cpu",
    "memory",
    "tray",
    "custom/power"
  ],

  "hyprland/workspaces": {
    "format": "{icon}",
    "format-icons": {
      "1": "󰎤",
      "2": "󰎧",
      "3": "󰎪",
      "4": "󰎭",
      "5": "󰎱",
      "urgent": "",
      "active": "",
      "default": ""
    },
    "persistent-workspaces": {
      "*": 5
    }
  },

  "hyprland/window": {
    "format": "  {}",
    "max-length": 40,
    "separate-outputs": true
  },

  "clock": {
    "format": "  {:%H:%M}",
    "format-alt": "  {:%A, %d %B %Y}",
    "tooltip-format": "<tt><small>{calendar}</small></tt>",
    "calendar": {
      "mode": "month",
      "on-scroll": 1,
      "format": {
        "months": "<span color='#d946ef'><b>{}</b></span>",
        "days": "<span color='#e2e8f0'><b>{}</b></span>",
        "weeks": "<span color='#7c3aed'><b>W{}</b></span>",
        "weekdays": "<span color='#94a3b8'><b>{}</b></span>",
        "today": "<span color='#d946ef'><b><u>{}</u></b></span>"
      }
    }
  },

  "cpu": {
    "format": "󰻠  {usage}%",
    "tooltip": false,
    "interval": 2
  },

  "memory": {
    "format": "󰍛  {}%",
    "interval": 5
  },

  "backlight": {
    "format": "{icon}  {percent}%",
    "format-icons": ["󰋙", "󰫃", "󰫄", "󰫅", "󰫆", "󰫇", "󰫈"],
    "on-scroll-up": "brightnessctl set 5%+",
    "on-scroll-down": "brightnessctl set 5%-"
  },

  "battery": {
    "states": {
      "good": 95,
      "warning": 30,
      "critical": 15
    },
    "format": "{icon}  {capacity}%",
    "format-charging": "󰂄  {capacity}%",
    "format-plugged": "󰚥  {capacity}%",
    "format-icons": ["󰁺", "󰁻", "󰁼", "󰁽", "󰁾", "󰁿", "󰂀", "󰂁", "󰂂", "󰁹"]
  },

  "network": {
    "format-wifi": "󰤨  {essid}",
    "format-ethernet": "󰈀  Connected",
    "format-disconnected": "󰤭  Offline",
    "tooltip-format": "󰤨 {essid} ({signalStrength}%)\n󰩟 {ipaddr}",
    "on-click": "nm-connection-editor"
  },

  "bluetooth": {
    "format": "󰂯",
    "format-connected": "󰂱  {device_alias}",
    "format-connected-battery": "󰂱  {device_alias} {device_battery_percentage}%",
    "tooltip-format": "{controller_alias}\t{controller_address}\n\n{num_connections} connected",
    "tooltip-format-connected": "{controller_alias}\t{controller_address}\n\n{num_connections} connected\n\n{device_enumerate}",
    "tooltip-format-enumerate-connected": "{device_alias}\t{device_address}",
    "tooltip-format-enumerate-connected-battery": "{device_alias}\t{device_address}\t{device_battery_percentage}%",
    "on-click": "blueman-manager"
  },

  "pulseaudio": {
    "format": "{icon}  {volume}%",
    "format-muted": "󰖁  Muted",
    "format-icons": {
      "headphone": "󰋋",
      "default": ["󰕿", "󰖀", "󰕾"]
    },
    "on-click": "pavucontrol",
    "on-scroll-up": "wpctl set-volume @DEFAULT_AUDIO_SINK@ 5%+",
    "on-scroll-down": "wpctl set-volume @DEFAULT_AUDIO_SINK@ 5%-"
  },

  "tray": {
    "icon-size": 16,
    "spacing": 8
  },

  "custom/power": {
    "format": "⏻",
    "tooltip": false,
    "on-click": "wlogout"
  }
}
```

### `~/.config/waybar/style.css`

```bash
nvim ~/.config/waybar/style.css
```

```css
/* ======= Shadow Dragon Theme — Waybar ======= */

@define-color bg       #0a0b14;
@define-color bg-alt   #111827;
@define-color surface  #1e1b4b;
@define-color overlay  #2d2b5e;
@define-color accent1  #7c3aed;
@define-color accent2  #d946ef;
@define-color text     #e2e8f0;
@define-color subtext  #94a3b8;
@define-color red      #f43f5e;
@define-color yellow   #eab308;
@define-color green    #22c55e;

* {
    font-family: "JetBrainsMono Nerd Font", "Font Awesome 7 Free";
    font-size: 13px;
    border: none;
    border-radius: 0;
    min-height: 0;
}

window#waybar {
    background-color: transparent;
    color: @text;
}

.modules-left,
.modules-center,
.modules-right {
    background-color: alpha(@bg, 0.85);
    border: 1px solid alpha(@accent1, 0.3);
    border-radius: 12px;
    padding: 0 6px;
}

/* ======= Workspaces ======= */
#workspaces {
    padding: 0 4px;
}

#workspaces button {
    padding: 2px 8px;
    color: @subtext;
    background: transparent;
    border-radius: 8px;
    transition: all 0.25s ease;
}

#workspaces button:hover {
    background: alpha(@accent1, 0.2);
    color: @text;
}

#workspaces button.active {
    background: linear-gradient(90deg, @accent1, @accent2);
    color: @text;
    border-radius: 8px;
    padding: 2px 12px;
}

#workspaces button.urgent {
    background: @red;
    color: @text;
}

/* ======= Window title ======= */
#window {
    color: @subtext;
    padding: 0 10px;
    font-size: 12px;
}

/* ======= Clock ======= */
#clock {
    color: @accent2;
    font-weight: bold;
    padding: 0 12px;
}

/* ======= Modules ======= */
#cpu,
#memory,
#battery,
#network,
#pulseaudio,
#backlight,
#bluetooth,
#tray,
#custom-power {
    padding: 0 10px;
    color: @text;
}

#cpu { color: #a78bfa; }
#memory { color: #60a5fa; }
#network { color: #34d399; }
#pulseaudio { color: #f9a8d4; }
#backlight { color: @yellow; }
#bluetooth { color: #60a5fa; }

#battery {
    color: @green;
}

#battery.warning {
    color: @yellow;
}

#battery.critical {
    color: @red;
    animation-name: blink;
    animation-duration: 0.5s;
    animation-timing-function: linear;
    animation-iteration-count: infinite;
    animation-direction: alternate;
}

@keyframes blink {
    to { color: @text; }
}

#custom-power {
    color: @accent2;
    font-size: 16px;
    padding-right: 12px;
}

#tray {
    padding: 0 6px;
}

#tray > .passive {
    -gtk-icon-effect: dim;
}

#tray > .needs-attention {
    -gtk-icon-effect: highlight;
    background-color: alpha(@red, 0.2);
    border-radius: 4px;
}

/* ======= Tooltip ======= */
tooltip {
    background: @bg-alt;
    border: 1px solid alpha(@accent1, 0.4);
    border-radius: 8px;
    color: @text;
}

tooltip label {
    color: @text;
    padding: 4px;
}
```

---

## 7. Konfigurasi Dunst

```bash
mkdir -p ~/.config/dunst
nvim ~/.config/dunst/dunstrc
```

```ini
[global]
    monitor = 0
    follow = mouse
    width = 320
    height = 100
    origin = top-right
    offset = 12x50
    scale = 0
    notification_limit = 5
    progress_bar = true
    progress_bar_height = 6
    progress_bar_frame_width = 0
    progress_bar_min_width = 280
    progress_bar_max_width = 320
    progress_bar_corner_radius = 4
    indicate_hidden = yes
    transparency = 0
    separator_height = 2
    padding = 12
    horizontal_padding = 14
    text_icon_padding = 10
    frame_width = 1
    frame_color = "#7c3aed"
    separator_color = frame
    sort = yes
    idle_threshold = 120
    font = JetBrainsMono Nerd Font 11
    line_height = 0
    markup = full
    format = "<b>%s</b>\n%b"
    alignment = left
    vertical_alignment = center
    show_age_threshold = 60
    word_wrap = yes
    ellipsize = middle
    ignore_newline = no
    stack_duplicates = true
    hide_duplicate_count = false
    show_indicators = yes
    enable_recursive_icon_lookup = true
    icon_theme = Papirus-Dark
    icon_position = left
    min_icon_size = 32
    max_icon_size = 48
    sticky_history = yes
    history_length = 20
    browser = /usr/bin/firefox
    always_run_script = true
    title = Dunst
    class = Dunst
    corner_radius = 10
    ignore_dbusclose = false
    force_xwayland = false
    force_xinerama = false
    mouse_left_click = close_current
    mouse_middle_click = do_action, close_current
    mouse_right_click = close_all

[urgency_low]
    background = "#0a0b14"
    foreground = "#e2e8f0"
    frame_color = "#1e1b4b"
    timeout = 4
    icon = dialog-information

[urgency_normal]
    background = "#0f0d2a"
    foreground = "#e2e8f0"
    frame_color = "#7c3aed"
    timeout = 6

[urgency_critical]
    background = "#1a0520"
    foreground = "#f43f5e"
    frame_color = "#d946ef"
    timeout = 0
    icon = dialog-error
```

---

## 8. Konfigurasi Rofi

```bash
mkdir -p ~/.config/rofi
nvim ~/.config/rofi/config.rasi
```

```rasi
configuration {
    modi:                       "drun,run,window";
    show-icons:                 true;
    drun-display-format:        "{name}";
    window-format:              "{w} · {c} · {t}";
    display-drun:               "  Apps";
    display-run:                "  Run";
    display-window:             "  Windows";
    icon-theme:                 "Papirus-Dark";
    terminal:                   "kitty";
}

@import "shadow-dragon.rasi"
```

```bash
nvim ~/.config/rofi/shadow-dragon.rasi
```

```rasi
/* ======= Shadow Dragon — Rofi Theme ======= */

* {
    bg:         #0a0b14;
    bg-alt:     #111827;
    surface:    #1e1b4b;
    overlay:    #2d2b5e;
    accent1:    #7c3aed;
    accent2:    #d946ef;
    text:       #e2e8f0;
    subtext:    #94a3b8;
    red:        #f43f5e;

    background-color:   transparent;
    text-color:         @text;
}

window {
    transparency:           "real";
    location:               center;
    anchor:                 center;
    fullscreen:             false;
    width:                  540px;
    x-offset:               0px;
    y-offset:               0px;
    enabled:                true;
    border-radius:          14px;
    border:                 1px solid;
    border-color:           @accent1;
    background-color:       @bg;
    cursor:                 "default";
}

mainbox {
    enabled:    true;
    spacing:    0px;
    background-color: transparent;
    orientation: vertical;
    children:   [ "inputbar", "listview" ];
}

inputbar {
    enabled:        true;
    spacing:        8px;
    padding:        12px 14px;
    background-color: @surface;
    border-radius:  12px 12px 0 0;
    border:         0 0 1px 0;
    border-color:   @overlay;
    children:       [ "prompt", "textbox-prompt-colon", "entry" ];
}

prompt {
    enabled:        true;
    background-color: transparent;
    text-color:     @accent2;
    font:           "JetBrainsMono Nerd Font Bold 12";
}

textbox-prompt-colon {
    enabled:        true;
    expand:         false;
    str:            "›";
    background-color: transparent;
    text-color:     @subtext;
}

entry {
    enabled:        true;
    background-color: transparent;
    text-color:     @text;
    cursor:         text;
    placeholder:    "Search...";
    placeholder-color: @subtext;
}

listview {
    enabled:        true;
    columns:        1;
    lines:          8;
    cycle:          true;
    dynamic:        true;
    scrollbar:      false;
    layout:         vertical;
    spacing:        4px;
    padding:        8px;
    background-color: transparent;
}

element {
    enabled:        true;
    spacing:        10px;
    padding:        8px 10px;
    border-radius:  8px;
    background-color: transparent;
    text-color:     @text;
    cursor:         pointer;
    orientation:    horizontal;
}

element.normal.normal { background-color: transparent; }
element.normal.urgent { background-color: @red; }
element.normal.active { background-color: @surface; }

element.selected.normal {
    background-color: linear-gradient(#7c3aed22, #d946ef22);
    border:           1px solid;
    border-color:     @accent1;
    text-color:       @text;
}

element.selected.urgent { background-color: @red; }
element.selected.active { background-color: @accent1; }

element-icon {
    background-color: transparent;
    text-color:     inherit;
    size:           28px;
    cursor:         inherit;
}

element-text {
    background-color: transparent;
    text-color:     inherit;
    cursor:         inherit;
    vertical-align: 0.5;
}

message {
    padding:        8px 14px;
    background-color: @surface;
    border-radius:  0 0 12px 12px;
    text-color:     @subtext;
}
```

---

## 9. Konfigurasi Kitty Terminal

```bash
mkdir -p ~/.config/kitty
nvim ~/.config/kitty/kitty.conf
```

```conf
# ======= Shadow Dragon — Kitty ======= 

# Font
font_family         JetBrainsMono Nerd Font
bold_font           JetBrainsMono Nerd Font Bold
italic_font         JetBrainsMono Nerd Font Italic
bold_italic_font    JetBrainsMono Nerd Font Bold Italic
font_size           12.5

# Cursor
cursor_shape            beam
cursor_beam_thickness   1.5
cursor_blink_interval   0.5
cursor_stop_blinking_after 15.0

# Scrollback
scrollback_lines 10000

# Window
window_padding_width    14
window_margin_width     0
placement_strategy      center
remember_window_size    yes
initial_window_width    900
initial_window_height   600

# Tabs
tab_bar_style               powerline
tab_powerline_style         slanted
tab_title_template          " {index}: {title} "
active_tab_font_style       bold
inactive_tab_font_style     normal

# Misc
enable_audio_bell       no
visual_bell_duration    0.0
confirm_os_window_close 0
background_opacity      0.92
dynamic_background_opacity yes

# ======= Colors: Shadow Dragon =======

# Background / Foreground
background              #0a0b14
foreground              #e2e8f0
selection_background    #7c3aed
selection_foreground    #e2e8f0
cursor                  #d946ef
cursor_text_color       #0a0b14

# URL
url_color               #7c3aed
url_style               curly

# Tab bar
active_tab_background   #7c3aed
active_tab_foreground   #e2e8f0
inactive_tab_background #1e1b4b
inactive_tab_foreground #94a3b8
tab_bar_background      #0a0b14

# Black
color0  #0f0d1a
color8  #334155

# Red
color1  #f43f5e
color9  #fb7185

# Green
color2  #22c55e
color10 #4ade80

# Yellow
color3  #eab308
color11 #facc15

# Blue
color4  #3b82f6
color12 #60a5fa

# Magenta / Purple
color5  #7c3aed
color13 #d946ef

# Cyan
color6  #06b6d4
color14 #22d3ee

# White
color7  #e2e8f0
color15 #f8fafc

# Keybindings
map ctrl+shift+c    copy_to_clipboard
map ctrl+shift+v    paste_from_clipboard
map ctrl+shift+t    new_tab_with_cwd
map ctrl+shift+w    close_tab
map ctrl+shift+l    next_tab
map ctrl+shift+h    previous_tab
map ctrl+equal      increase_font_size
map ctrl+minus      decrease_font_size
map ctrl+0          restore_font_size
map ctrl+shift+f5   load_config_file
```

---

## 10. Konfigurasi SDDM

```bash
# Install tema SDDM
yay -S sddm-theme-corners-git

# Buat direktori config
sudo mkdir -p /etc/sddm.conf.d
sudo nvim /etc/sddm.conf.d/10-hyprland.conf
```

```ini
[Autologin]
# Hapus tanda # dan isi username lo kalau mau auto-login
# User=yourusername
# Session=hyprland

[Theme]
Current=corners

[General]
HaltCommand=/usr/bin/systemctl poweroff
RebootCommand=/usr/bin/systemctl reboot

[Wayland]
CompositorCommand=kwin_wayland --drm --no-lockscreen
```

> 💡 **Tips:** Kalau lo mau tampilan SDDM tetap simpel, bisa juga pakai tema `sugar-dark`:
> ```bash
> yay -S sddm-sugar-dark
> ```
> Lalu ganti `Current=corners` → `Current=sugar-dark`

---

## 11. Konfigurasi Thunar & File Manager

```bash
# Pastikan semua sudah terinstall
sudo pacman -S thunar gvfs gvfs-mtp tumbler ffmpegthumbnailer

# Buka Thunar dan set preferences via GUI (tampil otomatis saat launch)
# Atau set via terminal:
xfconf-query -c thunar -p /misc-show-delete-action -s true
```

**Fitur Thunar yang diaktifkan:**
- Custom Actions (klik kanan → Open Terminal Here)

```bash
# Tambah custom action "Open Terminal Here":
# Thunar → Edit → Configure Custom Actions → Add
# Name: Open Terminal
# Command: kitty --working-directory %f
# Icon: utilities-terminal
# File Pattern: *
# Appears if selection contains: Directories
```

---

## 12. Komponen Tambahan

### Hyprlock (Screen Locker)

```bash
mkdir -p ~/.config/hypr
nvim ~/.config/hypr/hyprlock.conf
```

```ini
background {
    monitor =
    path = ~/Pictures/Wallpapers/wallpaper.jpg
    blur_passes = 3
    blur_size = 7
    brightness = 0.3
}

input-field {
    monitor =
    size = 280, 50
    outline_thickness = 2
    dots_size = 0.25
    dots_spacing = 0.3
    outer_color = rgb(7c3aed)
    inner_color = rgb(0a0b14)
    font_color = rgb(e2e8f0)
    fade_on_empty = false
    placeholder_text = <span foreground="##94a3b8">🔑 Password...</span>
    hide_input = false
    check_color = rgb(d946ef)
    fail_color = rgb(f43f5e)
    fail_text = <i>$FAIL</i>
    capslock_color = rgb(eab308)
    position = 0, -80
    halign = center
    valign = center
}

label {
    monitor =
    text = cmd[update:1000] echo "<span foreground='##e2e8f0' font_desc='JetBrainsMono Nerd Font Bold 42'>$(date +"%H:%M")</span>"
    color = rgba(e2e8f0ff)
    font_size = 42
    font_family = JetBrainsMono Nerd Font Bold
    position = 0, 80
    halign = center
    valign = center
}

label {
    monitor =
    text = $USER
    color = rgba(d946efcc)
    font_size = 14
    font_family = JetBrainsMono Nerd Font
    position = 0, -140
    halign = center
    valign = center
}
```

### Hypridle (Auto Lock)

```bash
nvim ~/.config/hypr/hypridle.conf
```

```ini
general {
    lock_cmd = pidof hyprlock || hyprlock
    before_sleep_cmd = loginctl lock-session
    after_sleep_cmd = hyprctl dispatch dpms on
}

listener {
    timeout = 300
    on-timeout = brightnessctl -s set 20%
    on-resume = brightnessctl -r
}

listener {
    timeout = 360
    on-timeout = loginctl lock-session
}

listener {
    timeout = 600
    on-timeout = hyprctl dispatch dpms off
    on-resume = hyprctl dispatch dpms on
}
```

### Wlogout (Power Menu)

```bash
mkdir -p ~/.config/wlogout
nvim ~/.config/wlogout/layout
```

```
{
    "label" : "lock",
    "action" : "hyprlock",
    "text" : "Lock",
    "keybind" : "l"
}
{
    "label" : "hibernate",
    "action" : "systemctl hibernate",
    "text" : "Hibernate",
    "keybind" : "h"
}
{
    "label" : "logout",
    "action" : "hyprctl dispatch exit 0",
    "text" : "Logout",
    "keybind" : "e"
}
{
    "label" : "shutdown",
    "action" : "systemctl poweroff",
    "text" : "Shutdown",
    "keybind" : "s"
}
{
    "label" : "suspend",
    "action" : "systemctl suspend",
    "text" : "Sleep",
    "keybind" : "u"
}
{
    "label" : "reboot",
    "action" : "systemctl reboot",
    "text" : "Reboot",
    "keybind" : "r"
}
```

```bash
nvim ~/.config/wlogout/style.css
```

```css
* {
    background-image: none;
    font-family: "JetBrainsMono Nerd Font";
}

window {
    background-color: rgba(10, 11, 20, 0.9);
}

button {
    color: #e2e8f0;
    background-color: rgba(30, 27, 75, 0.6);
    border-style: solid;
    border-width: 1px;
    border-color: rgba(124, 58, 237, 0.4);
    border-radius: 12px;
    background-repeat: no-repeat;
    background-position: center;
    background-size: 50px;
    font-size: 14px;
    margin: 10px;
}

button:focus, button:active, button:hover {
    background-color: rgba(124, 58, 237, 0.3);
    border-color: #d946ef;
    outline-style: none;
}

#lock     { background-image: image(url("/usr/share/wlogout/icons/lock.png")); }
#logout   { background-image: image(url("/usr/share/wlogout/icons/logout.png")); }
#suspend  { background-image: image(url("/usr/share/wlogout/icons/suspend.png")); }
#hibernate{ background-image: image(url("/usr/share/wlogout/icons/hibernate.png")); }
#shutdown { background-image: image(url("/usr/share/wlogout/icons/shutdown.png")); }
#reboot   { background-image: image(url("/usr/share/wlogout/icons/reboot.png")); }
```

---

## 13. GTK & Icon Theme

```bash
mkdir -p ~/.config/gtk-3.0 ~/.config/gtk-4.0

# GTK 3
nvim ~/.config/gtk-3.0/settings.ini
```

```ini
[Settings]
gtk-theme-name=Materia-dark
gtk-icon-theme-name=Papirus-Dark
gtk-font-name=Noto Sans 11
gtk-cursor-theme-name=Bibata-Modern-Classic
gtk-cursor-theme-size=24
gtk-toolbar-style=GTK_TOOLBAR_BOTH_HORIZ
gtk-toolbar-icon-size=GTK_ICON_SIZE_SMALL_TOOLBAR
gtk-button-images=0
gtk-menu-images=0
gtk-enable-event-sounds=0
gtk-enable-input-feedback-sounds=0
gtk-xft-antialias=1
gtk-xft-hinting=1
gtk-xft-hintstyle=hintfull
gtk-xft-rgba=rgb
gtk-application-prefer-dark-theme=1
```

```bash
# GTK 4
nvim ~/.config/gtk-4.0/settings.ini
```

```ini
[Settings]
gtk-theme-name=Materia-dark
gtk-icon-theme-name=Papirus-Dark
gtk-font-name=Noto Sans 11
gtk-cursor-theme-name=Bibata-Modern-Classic
gtk-cursor-theme-size=24
gtk-application-prefer-dark-theme=1
```

```bash
# Install cursor tema
yay -S bibata-cursor-theme

# Set cursor via nwg-look (GUI)
nwg-look

# Atau manual
mkdir -p ~/.icons/default
nvim ~/.icons/default/index.theme
```

```ini
[Icon Theme]
Name=Default
Comment=Default Cursor Theme
Inherits=Bibata-Modern-Classic
```

---

## 14. Wallpaper & Swww

```bash
# Buat folder wallpaper
mkdir -p ~/Pictures/Wallpapers

# Copy wallpaper lo ke sana
cp /path/to/wallpaper.jpg ~/Pictures/Wallpapers/wallpaper.jpg

# Test swww (jalankan setelah masuk Hyprland):
swww-daemon &
swww img ~/Pictures/Wallpapers/wallpaper.jpg \
  --transition-type wipe \
  --transition-fps 60 \
  --transition-duration 1.5
```

---

## 15. Fonts

```bash
# Rebuild font cache setelah install semua font
fc-cache -fv

# Verifikasi JetBrainsMono tersedia
fc-list | grep -i jetbrains
```

---

## 16. Final Check & Troubleshooting

### Masuk ke Hyprland Pertama Kali

Setelah semua config selesai, **reboot** sistem:

```bash
sudo reboot
```

SDDM akan muncul. Login, dan Hyprland akan start otomatis.

### Jika Hyprland Crash / Tidak Start

Boot ke TTY (Ctrl+Alt+F2), lalu cek log:

```bash
# Cek error log Hyprland
cat ~/.local/share/hyprland/hyprland.log | tail -50

# Atau jalankan Hyprland manual dari TTY untuk lihat error langsung:
Hyprland
```

### Cek Semua Service

```bash
# Cek PipeWire
systemctl --user status pipewire pipewire-pulse wireplumber

# Restart jika perlu
systemctl --user restart pipewire pipewire-pulse wireplumber

# Cek NetworkManager
systemctl status NetworkManager
```

### Waybar Tidak Muncul

```bash
# Test waybar manual dari terminal (Mod+Return untuk buka kitty)
waybar &

# Lihat error
waybar 2>&1 | head -30
```

### Screen Tearing (Intel iGPU)

Buat file:

```bash
sudo nvim /etc/environment
```

Tambahkan:
```
LIBVA_DRIVER_NAME=iHD
```

### Aplikasi Tidak Bisa Buka File (Portal Error)

```bash
# Pastikan xdg-desktop-portal jalan
systemctl --user status xdg-desktop-portal
systemctl --user status xdg-desktop-portal-hyprland

# Restart jika error
systemctl --user restart xdg-desktop-portal xdg-desktop-portal-hyprland xdg-desktop-portal-gtk
```

---

## ⌨️ CHEAT SHEET KEYBINDING

| Shortcut | Action |
|---|---|
| `Super + Enter` | Buka terminal (Kitty) |
| `Super + Shift + Enter` | App launcher (Rofi) |
| `Super + E` | File manager (Thunar) |
| `Super + B` | Browser (Firefox) |
| `Super + Q` | Tutup window |
| `Super + F` | Fullscreen |
| `Super + Shift + F` | Toggle float |
| `Super + H/J/K/L` | Pindah fokus (vim) |
| `Super + Shift + H/J/K/L` | Pindah window |
| `Super + Alt + H/J/K/L` | Resize window |
| `Super + 1-0` | Switch workspace |
| `Super + Shift + 1-0` | Move window ke workspace |
| `Super + S` | Scratchpad toggle |
| `Super + V` | Clipboard history |
| `Super + Shift + L` | Lock screen |
| `Super + Shift + Q` | Power menu |
| `Print` | Screenshot area |
| `Super + Print` | Screenshot fullscreen |
| `Super + Shift + S` | Screenshot → clipboard |

---

> 🐉 **Shadow Dragon Desktop** — Built with EndeavourOS + Hyprland  
> Designed for power, elegance, and speed.
