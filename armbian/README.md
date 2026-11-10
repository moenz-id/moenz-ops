# Armbian Documentation

Dokumentasi operasional homelab berbasis Armbian STB. Materi dipisahkan berdasarkan fungsi agar mudah ditemukan saat instalasi ulang, migrasi, maupun troubleshooting.

## Struktur dokumentasi

```text
armbian/
├── setup/
│   ├── install-docker.md
│   ├── install-docker.sh
│   ├── install-tailscale.md
│   └── migrate-docker-root-to-sdcard.md
├── services/
│   ├── cloudflared.md
│   ├── homeassistant.md
│   ├── portainer.md
│   └── searxng.md
└── maintenance/
    ├── backup-restore-docker.md
    └── troubleshooting.md
```

## Peran perangkat

### OpenWrt

- Gateway dan routing jaringan
- DHCP server
- DNS server

### Armbian STB

- Host Docker
- Home Assistant
- Mosquitto
- Portainer
- Cloudflared dan layanan homelab lainnya

## Standar jaringan

Sebagian container dapat menggunakan Docker bridge network bersama seperti `internal_net`. Home Assistant dapat menggunakan `network_mode: host` bila diperlukan untuk discovery perangkat lokal. Pilihan network harus disesuaikan dengan kebutuhan dan keamanan setiap layanan.

## Navigasi

### Setup dan instalasi

| Dokumen | Kegunaan |
|---|---|
| [Install Docker](setup/install-docker.md) | Panduan utama instalasi Docker; menjelaskan metode otomatis dan manual |
| [Installer Docker](setup/install-docker.sh) | Script instalasi dari repository APT resmi Docker |
| [Install Tailscale](setup/install-tailscale.md) | Instalasi Tailscale |
| [Migrate Docker Root to SD Card](setup/migrate-docker-root-to-sdcard.md) | Migrasi penyimpanan Docker ke SD Card |

### Services

- [Home Assistant](services/homeassistant.md)
- [Portainer](services/portainer.md)
- [Cloudflared](services/cloudflared.md)
- [SearXNG](services/searxng.md)

### Maintenance

- [Docker Backup & Restore](maintenance/backup-restore-docker.md)
- [Troubleshooting](maintenance/troubleshooting.md)

### Docker Compose

- [Docker Compose Overview](../docker/README.md)
- [Home Assistant](../docker/homeassistant.yaml)
- [Portainer](../docker/portainer.yaml)
- [Cloudflared](../docker/cloudflared.yaml)
- [SearXNG](../docker/searxng.yaml)

## Catatan

- Mulai dari dokumen panduan sebelum menjalankan script.
- Periksa target mount dan kapasitas storage sebelum menyimpan data container di SD Card.
- Backup data dan konfigurasi sebelum melakukan migrasi atau perubahan besar.
- Dokumentasi ini mencerminkan konfigurasi homelab yang digunakan dan dapat berubah seiring perkembangan sistem.
