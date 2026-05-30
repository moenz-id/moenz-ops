# Deploy Cloudflared on Armbian

## Summary

Dokumentasi instalasi Cloudflared menggunakan Docker Compose pada Armbian.

Cloudflared digunakan untuk membuat Cloudflare Tunnel sehingga layanan internal dapat diakses tanpa membuka port pada router.

Panduan ini mengikuti standar homelab repository:

- Docker Compose
- /data/appdata
- /data/stacks
- internal_net

---

# Prerequisites

Pastikan Docker sudah berjalan.

```bash
docker version
docker compose version
```

Pastikan network internal_net tersedia.

```bash
docker network ls
```

Jika belum ada:

```bash
docker network create internal_net
```

---

# Membuat Tunnel di Cloudflare

Login ke Cloudflare Dashboard.

Masuk ke:

```text
Zero Trust
└── Networks
    └── Tunnels
```

Buat tunnel baru.

Contoh nama:

```text
homelab
```

Pilih:

```text
Cloudflared
```

Cloudflare akan memberikan token tunnel.

Contoh:

```text
eyJhIjoi....
```

Simpan token tersebut.

---

# Struktur Direktori

```text
/data
├── appdata
│   └── cloudflared
└── stacks
    └── cloudflared
```

Buat direktori:

```bash
mkdir -p /data/appdata/cloudflared
mkdir -p /data/stacks/cloudflared
```

---

# Docker Compose

Buat file:

```bash
nano /data/stacks/cloudflared/compose.yaml
```

Isi:

```yaml
services:

  cloudflared:
    container_name: cloudflared
    image: cloudflare/cloudflared:latest

    restart: unless-stopped

    command: tunnel run

    environment:
      - TUNNEL_TOKEN=PASTE_TOKEN_DISINI

    networks:
      - internal_net

networks:
  internal_net:
    external: true
```

---

# Validasi Compose

```bash
cd /data/stacks/cloudflared

docker compose config
```

---

# Download Image

```bash
cd /data/stacks/cloudflared

docker compose pull
```

---

# Deploy Container

```bash
cd /data/stacks/cloudflared

docker compose up -d
```

---

# Verifikasi

```bash
docker ps
```

Harus muncul:

```text
cloudflared
```

---

# Cek Log

```bash
docker logs -f cloudflared
```

Jika berhasil biasanya akan muncul informasi tunnel telah terkoneksi ke Cloudflare.

---

# Menambahkan Public Hostname

Di Cloudflare Zero Trust:

```text
Tunnel
└── Public Hostname
```

Contoh Home Assistant:

```text
ha.domain.com
```

Service:

```text
http://IP-STB:8123
```

Atau:

```text
http://192.168.1.100:8123
```

---

# Contoh Service yang Dipublish

Contoh penggunaan tunnel:

```text
ha.domain.com
→ Home Assistant

n8n.domain.com
→ n8n

adguard.domain.com
→ AdGuard Home
```

---

# Network internal_net

Cloudflared menggunakan:

```text
internal_net
```

agar tetap konsisten dengan standar homelab repository.

Container lain seperti:

- Mosquitto
- ESPHome
- Portainer
- AdGuard Home
- n8n

juga direkomendasikan menggunakan network yang sama.

---

# Backup Data Penting

Direktori yang perlu dibackup:

```text
/data/stacks/cloudflared
```

Karena konfigurasi tunnel berada di Cloudflare Dashboard, biasanya cukup menyimpan compose file dan token tunnel.

---

# Update Cloudflared

```bash
cd /data/stacks/cloudflared

docker compose pull
docker compose up -d
```

Opsional:

```bash
docker image prune -f
```

---

# Notes

Cloudflared adalah salah satu service yang direkomendasikan untuk selalu aktif karena menjadi jalur akses remote ke homelab.

Pada homelab kecil, Cloudflared sering dipasang bersama:

- Tailscale
- Portainer
- Home Assistant

sebagai fondasi akses dan manajemen jarak jauh.