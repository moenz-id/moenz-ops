# Deploy Portainer on Armbian

## Summary

Dokumentasi instalasi Portainer CE menggunakan Docker Compose pada Armbian.

Portainer digunakan sebagai web interface untuk mengelola:

- Container
- Images
- Volumes
- Networks
- Docker Compose Stack

Panduan ini mengikuti standar homelab repository:

- Docker Root berada di SD Card (opsional)
- Data aplikasi berada di /data/appdata
- Stack berada di /data/stacks
- Menggunakan network internal_net

---

# Prerequisites

Pastikan Docker sudah berjalan.

Verifikasi:

```bash
docker version
docker compose version
```

Pastikan network internal_net tersedia:

```bash
docker network ls
```

Jika belum ada:

```bash
docker network create internal_net
```

---

# Struktur Direktori

```text
/data
├── appdata
│   └── portainer
└── stacks
    └── portainer
```

Buat direktori:

```bash
mkdir -p /data/appdata/portainer
mkdir -p /data/stacks/portainer
```

---

# Docker Compose

Buat file:

```bash
nano /data/stacks/portainer/compose.yaml
```

Isi:

```yaml
services:

  portainer:
    container_name: portainer
    image: portainer/portainer-ce:latest

    restart: unless-stopped

    ports:
      - "9000:9000"
      - "9443:9443"

    networks:
      - internal_net

    volumes:
      - /var/run/docker.sock:/var/run/docker.sock
      - /data/appdata/portainer:/data

networks:
  internal_net:
    external: true
```

---

# Validasi Compose

```bash
cd /data/stacks/portainer

docker compose config
```

---

# Download Image

```bash
cd /data/stacks/portainer

docker compose pull
```

---

# Deploy Container

```bash
cd /data/stacks/portainer

docker compose up -d
```

---

# Verifikasi

```bash
docker ps
```

Harus muncul:

```text
portainer
```

---

# Akses Web UI

Buka browser:

```text
https://IP-STB:9443
```

Contoh:

```text
https://192.168.1.100:9443
```

Portainer akan meminta pembuatan akun administrator pada login pertama.

---

# Hubungkan Local Docker Environment

Pada wizard pertama:

```text
Environment
└── Docker Standalone
```

Pilih:

```text
Get Started
```

Karena Portainer menggunakan:

```text
/var/run/docker.sock
```

Portainer dapat langsung mengelola Docker lokal.

---

# Mengelola Stack Home Assistant

Jika Home Assistant dideploy menggunakan Docker Compose:

```text
/data/stacks/homeassistant
```

Maka Portainer dapat digunakan untuk:

- Melihat container
- Melihat log
- Restart service
- Pull image baru
- Update stack

---

# Network internal_net

Standar homelab repository ini menggunakan:

```text
internal_net
```

Sebagian besar container non-host mode direkomendasikan menggunakan network tersebut.

Contoh:

- Mosquitto
- ESPHome
- Portainer
- AdGuard Home
- n8n

Home Assistant tetap menggunakan:

```text
network_mode: host
```

untuk mempermudah discovery perangkat lokal.

---

# Backup Data Penting

Direktori yang perlu dibackup:

```text
/data/appdata/portainer
/data/stacks/portainer
```

---

# Update Portainer

Masuk ke direktori stack:

```bash
cd /data/stacks/portainer
```

Update image:

```bash
docker compose pull
```

Recreate container:

```bash
docker compose up -d
```

Opsional:

```bash
docker image prune -f
```

---

# Notes

Portainer bukan kebutuhan wajib untuk Docker.

Namun Portainer sangat membantu ketika jumlah container mulai bertambah dan menjadi dashboard utama untuk pengelolaan homelab berbasis Docker.