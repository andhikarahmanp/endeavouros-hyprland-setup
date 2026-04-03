# 🐉 Shadow Dragon — Hyprland Setup Guide
### Arch Linux (Base Install) · Intel iGPU · Full Custom Desktop

---

## 📋 Daftar Isi

1. [Referensi Warna](#1-referensi-warna)
2. [Install Arch Linux](#2-install-arch-linux)
3. [Clone Repo & Jalanin install.sh](#3-clone-repo--jalanin-installsh)
4. [Proses Manual Setelah Masuk Hyprland](#4-proses-manual-setelah-masuk-hyprland)
5. [Komponen Desktop](#5-komponen-desktop)
6. [Struktur Config](#6-struktur-config)
7. [Testing](#7-testing)
   - [7.1 Hyprland & Display](#71-hyprland--display)
   - [7.2 Keybinding Dasar](#72-keybinding-dasar)
   - [7.3 Waybar](#73-waybar)
   - [7.4 Audio](#74-audio)
   - [7.5 Notifikasi (Dunst)](#75-notifikasi-dunst)
   - [7.6 Screenshot](#76-screenshot)
   - [7.7 Clipboard](#77-clipboard)
   - [7.8 Bluetooth & Network](#78-bluetooth--network)
   - [7.9 GTK Theme & Tampilan](#79-gtk-theme--tampilan)
   - [7.10 Lock Screen & Idle](#710-lock-screen--idle)
8. [Troubleshooting](#8-troubleshooting)

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

## 2. Install Arch Linux

> Setup ini menggunakan **archinstall** — script installer resmi Arch yang interaktif. Jauh lebih mudah dari manual install tapi tetap memberikan sistem Arch murni.

### 2.1 Persiapan USB Bootable

1. Download ISO terbaru dari [archlinux.org/download](https://archlinux.org/download/)
2. Flash ke USB dengan [Balena Etcher](https://etcher.balena.io/) atau `dd`:
   ```bash
   dd if=archlinux-*.iso of=/dev/sdX bs=4M status=progress
   ```
3. Boot dari USB (pastikan UEFI mode aktif, Secure Boot off)

### 2.2 Sambungkan Internet di Live Environment

```bash
# Cek koneksi (ethernet biasanya langsung konek)
ping -c 3 archlinux.org

# Kalau WiFi, gunakan iwctl:
iwctl
[iwd]# device list
[iwd]# station wlan0 scan
[iwd]# station wlan0 get-networks
[iwd]# station wlan0 connect "NamaWiFi"
[iwd]# exit
```

### 2.3 Jalankan archinstall

```bash
archinstall
```

Isi pilihan berikut di menu archinstall:

| Setting | Value |
|---|---|
| **Mirrors** | Pilih mirror terdekat (ID/SG) |
| **Locales** | `en_US.UTF-8` |
| **Disk configuration** | Best-effort default partition (atau manual) |
| **Filesystem** | `ext4` atau `btrfs` |
| **Bootloader** | `systemd-boot` (UEFI) atau `grub` |
| **Swap** | True (otomatis buat swapfile) |
| **Hostname** | Terserah, misal `shadow-dragon` |
| **Root password** | Set password root |
| **User account** | Buat user baru, **centang sudo** |
| **Profile** | **Minimal** — jangan pilih desktop environment apapun |
| **Audio** | `pipewire` |
| **Kernels** | `linux` (atau `linux-zen` untuk performance) |
| **Additional packages** | `git` `base-devel` `networkmanager` |
| **Network configuration** | `NetworkManager` |
| **Timezone** | `Asia/Jakarta` (atau sesuai lokasi) |

Setelah semua diisi, pilih **Install** dan tunggu hingga selesai, lalu reboot.

### 2.4 Setelah Reboot

Login dengan username & password yang dibuat tadi (masuk ke TTY, ini normal), lalu:

```bash
# Aktifkan NetworkManager
sudo systemctl enable --now NetworkManager

# Sambungkan WiFi kalau perlu
nmcli device wifi connect "NamaWiFi" password "passwordwifi"

# Verifikasi internet
ping -c 3 archlinux.org
```

> ⚠️ **Catatan Hibernate:** Fitur hibernate di wlogout membutuhkan swap yang cukup (minimal sebesar RAM) dan kernel parameter `resume=`. Setup hibernate manual jika dibutuhkan — lihat [Arch Wiki: Hibernation](https://wiki.archlinux.org/title/Hibernation).

---

## 3. Clone Repo & Jalanin install.sh

Setelah internet tersambung dari TTY, jalankan:

```bash
# Clone dotfiles
git clone https://github.com/andhikarahmanp/endeavouros-hyprland-setup.git ~/shadow-dragon-setup

# Masuk ke folder
cd ~/shadow-dragon-setup

# Beri izin eksekusi
chmod +x install.sh

# Jalankan installer
./install.sh
```

`install.sh` akan otomatis menangani:
- Update sistem (`pacman -Syu`)
- Install yay (AUR helper)
- Install semua package (Hyprland, Waybar, Dunst, Rofi, Kitty, dll)
- Enable semua service (NetworkManager, SDDM, Bluetooth, PipeWire)
- Copy semua config ke `~/.config/`
- Copy wallpapers ke `~/Pictures/Wallpapers/`
- Setup SDDM theme corners
- Rebuild font cache

Setelah `install.sh` selesai, langsung reboot:

```bash
sudo reboot
```

SDDM akan muncul, login, dan Hyprland akan start otomatis. Lanjut ke proses manual di bawah dari dalam Hyprland.

---

## 4. Proses Manual Setelah Masuk Hyprland

> Buka terminal dulu dengan `Super + Enter` sebelum memulai.

### 4.1 GTK Theme — nwg-look

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

### 4.2 Thunar — Custom Action "Open Terminal Here"

1. Buka Thunar dengan `Super + E`
2. Pergi ke **Edit → Configure Custom Actions → klik tombol +**
3. Isi sebagai berikut:

| Field | Value |
|---|---|
| Name | Open Terminal |
| Command | `kitty --working-directory %f` |
| Icon | `utilities-terminal` |
| File Pattern | `*` |
| Appears if selection contains | Directories |

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

- **Font:** JetBrainsMono Nerd Font 12px
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

> ⚠️ **Hibernate** membutuhkan konfigurasi swap tambahan. Lihat [Arch Wiki: Hibernation](https://wiki.archlinux.org/title/Hibernation).

### SDDM
Login manager dengan tema **corners**.

- Config ada di `/etc/sddm.conf.d/10-hyprland.conf`
- Session: Hyprland (otomatis terpilih)

### swww
Wallpaper daemon. Dijalankan otomatis saat Hyprland start.

```bash
# Ganti wallpaper manual
swww img ~/Pictures/Wallpapers/wallpaper.jpg --transition-type wipe --transition-fps 60
```

---

## 6. Struktur Config

```
~/.config/
├── hypr/
│   ├── hyprland.conf    — config utama Hyprland
│   ├── hyprlock.conf    — config lock screen
│   ├── hypridle.conf    — config auto lock & dim
│   └── scripts/
│       └── screenshot.sh — screenshot helper
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

## 7. Testing

Jalankan semua test ini setelah setup selesai. Kalau ada yang gagal, langsung cek section 8 Troubleshooting.

### 7.1 Hyprland & Display

| Test | Cara | Hasil yang diharapkan |
|---|---|---|
| Hyprland jalan | Lihat desktop | Wallpaper muncul, waybar tampil di atas |
| Wallpaper | Lihat desktop | Wallpaper Shadow Dragon muncul |
| Animasi window | Buka & tutup terminal | Ada animasi slide smooth |
| Border aktif | Buka 2 window | Border gradient violet-magenta di window aktif |
| Blur | Buka Rofi | Background blur terlihat |

### 7.2 Keybinding Dasar

| Test | Shortcut | Hasil yang diharapkan |
|---|---|---|
| Buka terminal | `Super + Enter` | Kitty terbuka |
| Buka launcher | `Super + Shift + Enter` | Rofi muncul |
| Buka file manager | `Super + E` | Thunar terbuka |
| Tutup window | `Super + Q` | Window tertutup |
| Fullscreen | `Super + F` | Window fullscreen |
| Toggle float | `Super + Shift + F` | Window jadi floating |
| Pindah workspace | `Super + 2` | Pindah ke workspace 2 |
| Pindah window | `Super + Shift + 2` | Window pindah ke workspace 2 |
| Lock screen | `Super + Escape` | Hyprlock muncul |
| Power menu | `Super + Shift + Q` | Wlogout muncul |

### 7.3 Waybar

| Test | Cara | Hasil yang diharapkan |
|---|---|---|
| Waybar tampil | Lihat bar atas | Bar floating dengan modul lengkap |
| Clock | Lihat tengah bar | Jam tampil format HH:MM |
| Klik clock | Klik jam | Kalender popup muncul |
| Workspace indicator | Buka app di beberapa workspace | Nomor workspace aktif ter-highlight |
| Volume | Scroll di icon volume | Volume naik/turun |
| Klik volume | Klik icon volume | Pavucontrol terbuka |
| Brightness | Scroll di icon brightness | Brightness berubah |
| Klik power | Klik icon ⏻ di kanan | Wlogout muncul |

### 7.4 Audio

```bash
# Test speaker
speaker-test -t wav -c 2

# Cek device terdeteksi
pactl list sinks short
```

| Test | Cara | Hasil yang diharapkan |
|---|---|---|
| Speaker | Jalankan perintah di atas | Suara keluar dari speaker |
| Volume key | Tekan tombol Vol+ / Vol- | Volume berubah, notif muncul |
| Mute | Tekan tombol Mute | Audio mute, icon waybar berubah |

### 7.5 Notifikasi (Dunst)

```bash
# Test notifikasi manual
notify-send "Test" "Notifikasi berfungsi!"
notify-send -u critical "Critical" "Ini notifikasi penting!"
```

| Test | Hasil yang diharapkan |
|---|---|
| Notifikasi normal | Muncul di kanan atas, border violet |
| Notifikasi critical | Muncul dengan border magenta, tidak auto-dismiss |
| Klik notifikasi | Notifikasi hilang |

### 7.6 Screenshot

| Test | Shortcut | Hasil yang diharapkan |
|---|---|---|
| Screenshot area | `Print` | Crosshair muncul, pilih area, Swappy terbuka |
| Screenshot full | `Super + Print` | Swappy terbuka dengan screenshot fullscreen |
| Screenshot ke clipboard | `Super + Shift + P` | Crosshair muncul, pilih area, tersimpan ke clipboard |

### 7.7 Clipboard

| Test | Shortcut | Hasil yang diharapkan |
|---|---|---|
| Clipboard history | `Super + V` | Rofi muncul dengan daftar history clipboard |

### 7.8 Bluetooth & Network

| Test | Cara | Hasil yang diharapkan |
|---|---|---|
| Network indicator | Lihat waybar | Icon WiFi + nama SSID tampil |
| Klik network | Klik icon network | nm-connection-editor terbuka |
| Bluetooth | Klik icon bluetooth | Blueman terbuka |

### 7.9 GTK Theme & Tampilan

| Test | Cara | Hasil yang diharapkan |
|---|---|---|
| Thunar theme | Buka Thunar | Tampilan dark, icon Papirus |
| Cursor | Gerakin mouse | Cursor Bibata-Modern-Classic |
| Pavucontrol theme | Buka pavucontrol | Tampilan dark |

### 7.10 Lock Screen & Idle

| Test | Cara | Hasil yang diharapkan |
|---|---|---|
| Manual lock | `Super + Escape` | Hyprlock muncul, wallpaper blur |
| Unlock | Ketik password + Enter | Kembali ke desktop |
| Auto dim | Diamkan 5 menit | Brightness turun otomatis |
| Auto lock | Diamkan 6 menit | Hyprlock aktif otomatis |

---

## 8. Troubleshooting

### Hyprland Tidak Start / Crash

```bash
# Cek log Hyprland
cat ~/.local/share/hyprland/hyprland.log | tail -50

# Jalankan manual dari TTY untuk lihat error langsung
Hyprland
```

### Waybar Tidak Muncul

```bash
waybar &
waybar 2>&1 | head -30
```

### Audio Tidak Berfungsi

```bash
systemctl --user status pipewire pipewire-pulse wireplumber
systemctl --user restart pipewire pipewire-pulse wireplumber
```

### Network Tidak Konek

```bash
systemctl status NetworkManager
sudo systemctl restart NetworkManager
```

### Screen Tearing (Intel iGPU)

Tambahkan ke `/etc/environment`:

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

### Hibernate Tidak Berfungsi

```bash
# Cek swap yang tersedia
swapon --show

# Tambahkan resume parameter ke bootloader
# Untuk systemd-boot, edit /boot/loader/entries/*.conf:
# tambahkan di baris options: resume=UUID=<uuid-swap-partition>
```

Referensi lengkap: [Arch Wiki — Hibernation](https://wiki.archlinux.org/title/Hibernation)

---

> 🐉 **Shadow Dragon Desktop** — Built with Arch Linux + Hyprland  
> Designed for power, elegance, and speed.
