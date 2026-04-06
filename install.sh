#!/bin/bash

# ============================================================
#  Your Name (Kimi No Na wa) — Dotfiles Installer
#  Arch Linux + Hyprland (Intel iGPU)
# ============================================================

set -e

DOTFILES_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
CONFIG_DIR="$HOME/.config"

# ============================================================
# COLORS
# ============================================================
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
PURPLE='\033[0;35m'
CYAN='\033[0;36m'
NC='\033[0m' # No Color

# ============================================================
# HELPERS
# ============================================================
info()    { echo -e "${CYAN}[INFO]${NC} $1"; }
success() { echo -e "${GREEN}[OK]${NC} $1"; }
warning() { echo -e "${YELLOW}[WARN]${NC} $1"; }
error()   { echo -e "${RED}[ERROR]${NC} $1"; exit 1; }
section() { echo -e "\n${PURPLE}══════════════════════════════════════${NC}"; echo -e "${PURPLE} $1${NC}"; echo -e "${PURPLE}══════════════════════════════════════${NC}\n"; }

# ============================================================
# CEK JALANKAN SEBAGAI USER BIASA (BUKAN ROOT)
# ============================================================
if [ "$EUID" -eq 0 ]; then
    error "Jangan jalankan install.sh sebagai root! Jalankan sebagai user biasa."
fi

# ============================================================
# CEK KONEKSI INTERNET
# ============================================================
section "Cek Koneksi Internet"
if ! ping -c 1 archlinux.org &>/dev/null; then
    error "Tidak ada koneksi internet! Sambungkan dulu sebelum melanjutkan."
fi
success "Koneksi internet OK"

# ============================================================
# 1. UPDATE SISTEM
# ============================================================
section "Update Sistem"
info "Menjalankan pacman -Syu..."
sudo pacman -Syu --noconfirm
success "Sistem berhasil diupdate"

# ============================================================
# 2. INSTALL YAY (AUR HELPER)
# ============================================================
section "Install Yay (AUR Helper)"
if command -v yay &>/dev/null; then
    warning "yay sudah terinstall, skip..."
else
    info "Menginstall yay..."
    sudo pacman -S --noconfirm git base-devel
    cd /tmp
    rm -rf yay
    git clone https://aur.archlinux.org/yay.git
    cd yay
    makepkg -si --noconfirm
    cd "$DOTFILES_DIR"
    success "yay berhasil diinstall"
fi

# ============================================================
# 3. INSTALL HYPRLAND & WAYLAND STACK
# ============================================================
section "Install Hyprland & Wayland Stack"

WAYLAND_PKGS=(
    # --- Hyprland & Wayland Core ---
    hyprland
    wayland
    wayland-protocols
    xorg-xwayland
    xdg-desktop-portal-hyprland
    xdg-utils

    # --- Qt Wayland Support ---
    qt5-wayland
    qt6-wayland

    # --- Audio (PipeWire Stack) ---
    pipewire
    pipewire-alsa
    pipewire-pulse
    pipewire-jack
    wireplumber
    pavucontrol

    # --- System Services ---
    polkit-kde-agent
    networkmanager
    network-manager-applet

    # --- Graphics (Intel) ---
    mesa
    intel-media-driver
    vulkan-intel
)

info "Menginstall Hyprland & Wayland stack..."
sudo pacman -S --noconfirm "${WAYLAND_PKGS[@]}"

info "Mengaktifkan NetworkManager..."
sudo systemctl enable NetworkManager
success "Hyprland & Wayland stack berhasil diinstall"

# ============================================================
# 4. INSTALL KOMPONEN DESKTOP
# ============================================================
section "Install Komponen Desktop"

PACMAN_PKGS=(
    # --- Bar & Notifications ---
    waybar
    dunst
    libnotify

    # --- Launcher & Display Manager ---
    rofi-wayland
    sddm

    # --- Terminal & File Manager ---
    kitty
    thunar
    thunar-archive-plugin
    thunar-volman
    gvfs
    gvfs-mtp

    # --- Keyring & Secrets ---
    gnome-keyring
    libsecret
    seahorse

    # --- Thumbnails & Previews ---
    tumbler
    ffmpegthumbnailer

    # --- Screenshot & Clipboard ---
    grim
    slurp
    swappy
    wl-clipboard
    cliphist

    # --- Idle & Theming ---
    hypridle
    nwg-look

    # --- Fonts ---
    ttf-jetbrains-mono-nerd
    ttf-nerd-fonts-symbols
    noto-fonts
    noto-fonts-emoji
    ttf-font-awesome

    # --- GTK Theme ---
    materia-gtk-theme

    # --- Hardware Control ---
    brightnessctl
    tlp

    # --- Bluetooth ---
    bluez
    bluez-utils
    blueman

    # --- Media ---
    imv
    mpv
    playerctl

    # --- System Monitor & Eye Candy ---
    btop
    fastfetch
    cmatrix

    # --- Portals ---
    xdg-desktop-portal-gtk

    # --- Archive & File Utils ---
    file-roller
    gnome-font-viewer
    zip
    unzip
    p7zip

    # --- Network & Download ---
    wget
    curl

    # --- Qt Theming ---
    qt5ct
)

info "Menginstall komponen desktop via pacman..."
sudo pacman -S --noconfirm "${PACMAN_PKGS[@]}"

AUR_PKGS=(
    awww
    neovim
    google-chrome
    hyprlock
    wlogout
    papirus-icon-theme
    bibata-cursor-theme
    sddm-theme-corners-git
    otf-departure-mono-nerd
)

info "Menginstall komponen desktop via yay (AUR)..."
yay -S --noconfirm "${AUR_PKGS[@]}"

info "Mengaktifkan service..."
sudo systemctl enable sddm
sudo systemctl enable bluetooth
success "Semua komponen desktop berhasil diinstall"

# ============================================================
# 5. COPY CONFIG FILES
# ============================================================
section "Copy Config Files"

# Buat direktori yang dibutuhkan
mkdir -p "$CONFIG_DIR/hypr"
mkdir -p "$CONFIG_DIR/waybar"
mkdir -p "$CONFIG_DIR/dunst"
mkdir -p "$CONFIG_DIR/rofi"
mkdir -p "$CONFIG_DIR/kitty"
mkdir -p "$CONFIG_DIR/wlogout"
mkdir -p "$CONFIG_DIR/gtk-3.0"
mkdir -p "$CONFIG_DIR/gtk-4.0"
mkdir -p "$HOME/.icons/default"
mkdir -p "$HOME/Pictures/Wallpapers"

# Hyprland
info "Copy config Hyprland..."
mkdir -p "$CONFIG_DIR/hypr/scripts"
cp "$DOTFILES_DIR/hypr/hyprland.conf"          "$CONFIG_DIR/hypr/hyprland.conf"
cp "$DOTFILES_DIR/hypr/hyprlock.conf"          "$CONFIG_DIR/hypr/hyprlock.conf"
cp "$DOTFILES_DIR/hypr/hypridle.conf"          "$CONFIG_DIR/hypr/hypridle.conf"
cp "$DOTFILES_DIR/hypr/scripts/screenshot.sh"  "$CONFIG_DIR/hypr/scripts/screenshot.sh"
chmod +x "$CONFIG_DIR/hypr/scripts/screenshot.sh"
success "Hyprland config OK"

# Waybar
info "Copy config Waybar..."
cp "$DOTFILES_DIR/waybar/config.jsonc" "$CONFIG_DIR/waybar/config.jsonc"
cp "$DOTFILES_DIR/waybar/style.css"    "$CONFIG_DIR/waybar/style.css"
success "Waybar config OK"

# Dunst
info "Copy config Dunst..."
cp "$DOTFILES_DIR/dunst/dunstrc"       "$CONFIG_DIR/dunst/dunstrc"
success "Dunst config OK"

# Rofi
info "Copy config Rofi..."
cp "$DOTFILES_DIR/rofi/config.rasi"         "$CONFIG_DIR/rofi/config.rasi"
cp "$DOTFILES_DIR/rofi/your-name.rasi"  "$CONFIG_DIR/rofi/your-name.rasi"
success "Rofi config OK"

# Kitty
info "Copy config Kitty..."
cp "$DOTFILES_DIR/kitty/kitty.conf"    "$CONFIG_DIR/kitty/kitty.conf"
success "Kitty config OK"

# Wlogout
info "Copy config Wlogout..."
cp "$DOTFILES_DIR/wlogout/layout"      "$CONFIG_DIR/wlogout/layout"
cp "$DOTFILES_DIR/wlogout/style.css"   "$CONFIG_DIR/wlogout/style.css"
success "Wlogout config OK"

# GTK
info "Copy config GTK..."
cp "$DOTFILES_DIR/gtk-3.0/settings.ini" "$CONFIG_DIR/gtk-3.0/settings.ini"
cp "$DOTFILES_DIR/gtk-4.0/settings.ini" "$CONFIG_DIR/gtk-4.0/settings.ini"
success "GTK config OK"

# Cursor theme
info "Setup cursor theme..."
cat > "$HOME/.icons/default/index.theme" <<EOF
[Icon Theme]
Name=Default
Comment=Default Cursor Theme
Inherits=Bibata-Modern-Classic
EOF
success "Cursor theme OK"

# ============================================================
# 6. COPY WALLPAPERS
# ============================================================
section "Copy Wallpapers"
info "Copy wallpapers..."
cp "$DOTFILES_DIR"/Wallpapers/*.jpg "$HOME/Pictures/Wallpapers/" 2>/dev/null || true
cp "$DOTFILES_DIR"/Wallpapers/*.png "$HOME/Pictures/Wallpapers/" 2>/dev/null || true
success "Wallpapers OK"

# ============================================================
# 7. SETUP SDDM
# ============================================================
section "Setup SDDM"
info "Konfigurasi SDDM theme corners..."
sudo mkdir -p /etc/sddm.conf.d
sudo bash -c 'cat > /etc/sddm.conf.d/10-hyprland.conf <<EOF
[Theme]
Current=corners

[General]
HaltCommand=/usr/bin/systemctl poweroff
RebootCommand=/usr/bin/systemctl reboot
EOF'
success "SDDM config OK"

# ============================================================
# 8. SETUP FONT CACHE
# ============================================================
section "Rebuild Font Cache"
info "Menjalankan fc-cache..."
fc-cache -fv &>/dev/null
success "Font cache OK"

# ============================================================
# 9. SETUP PIPEWIRE (USER SERVICE)
# ============================================================
section "Aktifkan PipeWire"
info "Mengaktifkan PipeWire user services..."
systemctl --user enable pipewire pipewire-pulse wireplumber 2>/dev/null || true
success "PipeWire OK"

# ============================================================
# 10. AKTIFKAN SERVICE TLP
# ============================================================
section "Aktifkan TLP Service"
info "Mematikan konflik service & mengaktifkan TLP..."
# Mencegah konflik dengan power-profiles-daemon (bawaan GNOME/KDE/GDBus)
sudo systemctl mask power-profiles-daemon.service > /dev/null 2>&1
# Aktivasi TLP
sudo systemctl enable tlp.service
sudo systemctl start tlp.service
success "Aktivasi TLP OK"

# ============================================================
# 11. CLONE NVCHAD & AUTO-INSTALL PLUGINS
# ============================================================
section "Clone NvChad dan instalasi plugin"
if [ ! -d "$HOME/.config/nvim" ]; then
    info "Cloning NvChad..."
    git clone https://github.com/NvChad/starter ~/.config/nvim --depth 1

    info "Installing plugins (Headless mode)..."
    # Menjalankan nvim tanpa UI, sync plugin, lalu quit
    nvim --headless "+Lazy! sync" +qa
    
    info "NvChad setup complete!"
else
    info "Directory ~/.config/nvim already exists. Skipping."
fi

# ============================================================
# 12. INSTALL HYPREMOJI (YAY)
# ============================================================
section "Instalasi HyprEmoji"
info "Installing Hypremoji..."

# --noconfirm: Skip semua pertanyaan dan pilih opsi default
# --needed: Jangan install ulang kalau aplikasinya sudah ada
yay -S --noconfirm --needed hypremoji

# ============================================================
# SELESAI
# ============================================================

echo -e "\n${PURPLE}╔══════════════════════════════════════════╗${NC}"
echo -e "${PURPLE}║   Your Name Desktop — Setup Selesai!     ║${NC}"
echo -e "${PURPLE}╚══════════════════════════════════════════╝${NC}\n"
echo -e "${GREEN}Semua package terinstall dan config sudah di-copy.${NC}"
echo -e "${YELLOW}Silakan reboot untuk masuk ke Hyprland via SDDM.${NC}\n"
echo -e "  ${CYAN}sudo reboot${NC}\n"
