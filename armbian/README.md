# Armbian Documentation

Dokumentasi operasional homelab berbasis Armbian STB.

Repository ini menggunakan struktur dokumentasi yang dipisahkan berdasarkan fungsi agar lebih mudah dicari saat rebuild, migrasi, maupun troubleshooting.

---

# Documentation Structure

```text
armbian/
├── setup/
├── services/
└── maintenance/
```

---

# Setup

Dokumentasi instalasi dan konfigurasi dasar sistem.

- setup/install-docker.md
- setup/install-tailscale.md
- setup/migrate-docker-root-to-sdcard.md

Topik:
- Instalasi Docker
- Konfigurasi Docker Compose
- Network internal_net
- Instalasi Tailscale
- Migrasi Docker Root ke SD Card

---

# Services

Dokumentasi deployment layanan yang digunakan pada homelab.

- services/homeassistant.md
- services/portainer.md
- services/cloudflared.md

Topik:
- Home Assistant + Mosquitto
- Portainer CE
- Cloudflare Tunnel

---

# Maintenance

Dokumentasi pemeliharaan, backup, recovery, dan troubleshooting.

- maintenance/backup-restore-docker.md
- maintenance/troubleshooting.md

Topik:
- Backup dan Restore Docker
- Recovery setelah kegagalan sistem
- Docker Storage Layout
- Troubleshooting jaringan
- Catatan operasional homelab

---

# Current Architecture

## OpenWrt

Role:
- Gateway
- DHCP Server
- DNS Server
- Internet Routing

## Armbian STB

Role:
- Docker Host
- Home Assistant
- Mosquitto
- Portainer
- Cloudflared

## Network Standard

Sebagian besar container menggunakan:

```text
internal_net
```

Sedangkan Home Assistant menggunakan:

```text
network_mode: host
```

untuk mempermudah discovery perangkat lokal.

---

# Notes

Dokumentasi lama akan dihapus secara bertahap setelah seluruh konten berhasil dimigrasikan ke struktur baru.