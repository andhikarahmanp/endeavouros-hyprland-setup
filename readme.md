# 🐉 Shadow Dragon — Hyprland Setup Guide
### EndeavourOS (No DE) · Intel iGPU · Full Custom Desktop

---

## 📋 Daftar Isi

1. [Referensi Warna](#1-referensi-warna)
2. [Install EndeavourOS](#2-install-endeavouros)
3. [Clone Repo & Jalanin install.sh](#3-clone-repo--jalanin-installsh)
4. [Proses Manual Setelah install.sh](#4-proses-manual-setelah-installsh)
5. [Komponen Desktop](#5-komponen-desktop)
6. [Struktur Config](#6-struktur-config)
7. [Troubleshooting](#7-troubleshooting)

---

## 1. Referensi Warna

Tema **Shadow Dragon** diambil dari wallpaper — dark navy dengan aksen violet dan magenta.

| Peran | Hex | Keterangan |
|---|---|---|
| Background | `#0a0b14` | Near black navy |
| Primary | `#1e1b4b` | Deep indigo |
| Surface | `#2d2b5e` | Overlay/surface |
| Accent 1 | `#7c3aed` | Violet/purple |
| Accent 2 | `#d946ef` | Magenta/fuchsia |
| Text | `#e2e8f0` | Soft white |
| Subtext | `#94a3b8` | Muted slate |

---

## 2. Install EndeavourOS

### Proses Instalasi

1. Boot dari USB EndeavourOS
2. Pilih **"Online Installation"**
3. Di halaman **Desktop Environment**, pilih **"No Desktop"** (paling bawah)
4. Isi partisi, username, password, timezone seperti biasa
5. Klik Install, tunggu selesai, lalu reboot

> ⚠️ Setelah reboot lo akan masuk ke **TTY** (layar hitam, no GUI). Ini normal. Login dengan username & password yang dibuat saat install.

### Pastikan Internet Tersambung

```bash
ping -c 3 archlinux.org
```

Kalau tidak ada response, sambungkan WiFi dulu:

```bash
# Cek interface WiFi
ip link

# Konek ke WiFi
nmcli device wifi connect "NamaWiFi" password "passwordwifi"
```

---

## 3. Clone Repo & Jalanin install.sh

Setelah masuk TTY dan internet tersambung, jalankan:

```bash
# Install git dulu (minimal)
sudo pacman -S git

# Clone dotfiles
git clone https://github.com/username/dotfiles.git ~/dotfiles

# Masuk ke folder
cd ~/dotfiles

# Beri izin eksekusi
chmod +x install.sh

# Jalankan installer
./install.sh
```

`install.sh` akan otomatis menangani:
- Update sistem
- Install yay (AUR helper)
- Install semua package (Hyprland, Waybar, Dunst, Rofi, Kitty, dll)
- Enable semua service (NetworkManager, SDDM, Bluetooth, PipeWire)
- Copy semua config ke `~/.config/`
- Copy wallpapers ke `~/Pictures/Wallpapers/`
- Setup SDDM theme corners
- Rebuild font cache

Setelah `install.sh` selesai, lanjut ke proses manual di bawah sebelum reboot.

---

## 4. Proses Manual Setelah install.sh

### 4.1 Thunar — Custom Action "Open Terminal Here"

`install.sh` tidak bisa mengotomasi ini karena membutuhkan GUI.

1. Buka Thunar
2. Pergi ke **Edit → Configure Custom Actions → klik tombol +**
3. Isi sebagai berikut:

| Field | Value |
|---|---|
| Name | Open Terminal |
| Command | `kitty --working-directory %f` |
| Icon | `utilities-terminal` |
| File Pattern | `*` |
| Appears if selection contains | Directories |

### 4.2 GTK Theme — nwg-look

`nwg-look` adalah GUI untuk apply GTK theme, icon, dan cursor secara konsisten ke semua aplikasi.

1. Buka terminal, jalankan:
```bash
nwg-look
```
2. Set pilihan berikut:

| Setting | Value |
|---|---|
| GTK Theme | Materia-dark |
| Icon Theme | Papirus-Dark |
| Cursor Theme | Bibata-Modern-Classic |
| Cursor Size | 24 |
| Font | Noto Sans 11 |

3. Klik **Apply**

### 4.3 Reboot

Setelah semua proses manual selesai, reboot:

```bash
sudo reboot
```

SDDM akan muncul, login, dan Hyprland akan start otomatis.

---

## 5. Komponen Desktop

### Hyprland
Window manager utama berbasis Wayland. Config ada di `~/.config/hypr/hyprland.conf`.

- **Tiling layout:** Dwindle (otomatis tile window secara spiral)
- **Border:** Gradient violet → magenta, 2px
- **Gaps:** 4px dalam, 10px luar
- **Blur:** Enabled, 8 size, 2 passes
- **Shadow:** Warna violet `rgba(7c3aed66)`
- **Animasi:** Bezier curve `dragon` — smooth dengan slight overshoot

### Waybar
Status bar di bagian atas. Config ada di `~/.config/waybar/`.

- **Posisi:** Top, floating dengan margin
- **Modul kiri:** Workspaces, Window title
- **Modul tengah:** Clock + kalender
- **Modul kanan:** CPU, RAM, Backlight, Battery, Network, Bluetooth, Volume, Tray, Power button

### Dunst
Notification daemon. Config ada di `~/.config/dunst/dunstrc`.

- **Posisi:** Top-right, offset 12x50
- **Urgency low:** Border indigo
- **Urgency normal:** Border violet
- **Urgency critical:** Border magenta, tidak auto-dismiss

### Rofi
App launcher. Config ada di `~/.config/rofi/`.

- `config.rasi` — konfigurasi utama (mode, icon theme, terminal)
- `shadow-dragon.rasi` — tema visual (warna, layout, ukuran)
- Ukuran window: 540px lebar, 8 item tampil

### Kitty
Terminal emulator. Config ada di `~/.config/kitty/kitty.conf`.

- **Font:** JetBrainsMono Nerd Font 12.5px
- **Opacity:** 0.92
- **Cursor:** Beam, blink interval 0.5s
- **Tab bar:** Powerline style, slanted

### Hyprlock
Screen locker. Config ada di `~/.config/hypr/hyprlock.conf`.

- Background: wallpaper dengan blur + brightness 30%
- Tampil jam besar di tengah
- Input field password di bawah jam

### Hypridle
Auto-lock daemon. Config ada di `~/.config/hypr/hypridle.conf`.

| Timeout | Aksi |
|---|---|
| 5 menit | Dim brightness ke 20% |
| 6 menit | Lock screen (hyprlock) |
| 10 menit | Matikan display (DPMS off) |

### Wlogout
Power menu. Config ada di `~/.config/wlogout/`.

- Tombol: Lock, Hibernate, Logout, Shutdown, Sleep, Reboot
- Trigger: `Super + Shift + Q`

### SDDM
Login manager dengan tema **corners**.

- Config ada di `/etc/sddm.conf.d/10-hyprland.conf`
- Session: Hyprland (otomatis terpilih)

### awww
Wallpaper daemon (pengganti swww). Dijalankan otomatis saat Hyprland start.

```bash
# Ganti wallpaper manual
awww img ~/Pictures/Wallpapers/wallpaper.jpg --transition-type wipe --transition-fps 60
```

---

## 6. Struktur Config

```
~/.config/
├── hypr/
│   ├── hyprland.conf    — config utama Hyprland
│   ├── hyprlock.conf    — config lock screen
│   └── hypridle.conf    — config auto lock & dim
├── waybar/
│   ├── config.jsonc     — modul & layout waybar
│   └── style.css        — tema visual waybar
├── dunst/
│   └── dunstrc          — config notifikasi
├── rofi/
│   ├── config.rasi      — config utama rofi
│   └── shadow-dragon.rasi — tema visual rofi
├── kitty/
│   └── kitty.conf       — config terminal
├── wlogout/
│   ├── layout           — tombol power menu
│   └── style.css        — tema visual power menu
├── gtk-3.0/
│   └── settings.ini     — GTK3 theme settings
└── gtk-4.0/
    └── settings.ini     — GTK4 theme settings

~/.icons/
└── default/
    └── index.theme      — cursor theme default

~/Pictures/
└── Wallpapers/
    └── wallpaper.jpg    — wallpaper default
```

---

## 7. Troubleshooting

### Hyprland Tidak Start / Crash

```bash
# Cek log Hyprland
cat ~/.local/share/hyprland/hyprland.log | tail -50

# Jalankan manual dari TTY untuk lihat error langsung
Hyprland
```

### Waybar Tidak Muncul

```bash
# Test manual
waybar &

# Lihat error
waybar 2>&1 | head -30
```

### Audio Tidak Berfungsi

```bash
# Cek status PipeWire
systemctl --user status pipewire pipewire-pulse wireplumber

# Restart jika perlu
systemctl --user restart pipewire pipewire-pulse wireplumber
```

### Network Tidak Konek

```bash
systemctl status NetworkManager
sudo systemctl restart NetworkManager
```

### Screen Tearing (Intel iGPU)

Tambahkan ke `/etc/environment`:

```bash
sudo nvim /etc/environment
```

```
LIBVA_DRIVER_NAME=iHD
```

### Aplikasi Tidak Bisa Buka File (Portal Error)

```bash
systemctl --user restart xdg-desktop-portal xdg-desktop-portal-hyprland xdg-desktop-portal-gtk
```

### Bluetooth Tidak Aktif

```bash
sudo systemctl enable --now bluetooth
```

---

> 🐉 **Shadow Dragon Desktop** — Built with EndeavourOS + Hyprland  
> Designed for power, elegance, and speed.
