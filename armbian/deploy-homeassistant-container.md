# Deploy Home Assistant Container on Armbian

## Summary

Dokumentasi deployment Home Assistant Container dan Mosquitto menggunakan Docker Compose pada Armbian.

Dokumen ini diasumsikan menggunakan environment yang telah mengikuti panduan:

- install-docker-armbian.md

---

# Prerequisites

Pastikan Docker sudah berjalan normal.

Verifikasi:

```bash
docker version
docker compose version
docker ps
```

Pastikan network internal_net sudah tersedia:

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
│   ├── homeassistant
│   └── mosquitto
│       ├── config
│       ├── data
│       └── log
└── stacks
    └── homeassistant
        └── compose.yaml
```

Buat direktori:

```bash
mkdir -p /data/stacks/homeassistant

mkdir -p /data/appdata/homeassistant

mkdir -p /data/appdata/mosquitto/config
mkdir -p /data/appdata/mosquitto/data
mkdir -p /data/appdata/mosquitto/log
```

---

# Konfigurasi Mosquitto

Buat file:

```bash
nano /data/appdata/mosquitto/config/mosquitto.conf
```

Isi:

```conf
listener 1883
allow_anonymous true

persistence true
persistence_location /mosquitto/data/
```

---

# Docker Compose

Buat file:

```bash
nano /data/stacks/homeassistant/compose.yaml
```

Isi:

```yaml
services:

  homeassistant:
    container_name: homeassistant
    image: ghcr.io/home-assistant/home-assistant:stable
    restart: unless-stopped
    network_mode: host

    volumes:
      - /data/appdata/homeassistant:/config
      - /etc/localtime:/etc/localtime:ro

    environment:
      - TZ=Asia/Jakarta

  mosquitto:
    container_name: mosquitto
    image: eclipse-mosquitto:latest
    restart: unless-stopped

    ports:
      - "1883:1883"

    networks:
      - internal_net

    volumes:
      - /data/appdata/mosquitto/config:/mosquitto/config
      - /data/appdata/mosquitto/data:/mosquitto/data
      - /data/appdata/mosquitto/log:/mosquitto/log

networks:
  internal_net:
    external: true
```

---

# Validasi Compose

```bash
cd /data/stacks/homeassistant

docker compose config
```

Jika tidak ada error maka file compose valid.

---

# Download Image

```bash
cd /data/stacks/homeassistant

docker compose pull
```

---

# Deploy Container

```bash
cd /data/stacks/homeassistant

docker compose up -d
```

---

# Verifikasi

Cek container:

```bash
docker ps
```

Cek image:

```bash
docker images
```

Cek penggunaan storage Docker:

```bash
docker system df
```

---

# Log Home Assistant

```bash
docker logs -f homeassistant
```

---

# Akses Home Assistant

Buka browser:

```text
http://IP-STB:8123
```

Contoh:

```text
http://192.168.1.100:8123
```

---

# MQTT Integration

Karena Home Assistant menggunakan host network dan Mosquitto membuka port 1883, broker MQTT dapat diakses menggunakan:

```text
IP_STB:1883
```

Contoh:

```text
192.168.1.100:1883
```

---

# Update Container

Masuk ke direktori stack:

```bash
cd /data/stacks/homeassistant
```

Update image:

```bash
docker compose pull
```

Recreate container:

```bash
docker compose up -d
```

Opsional membersihkan image lama:

```bash
docker image prune -f
```

---

# Backup Data Penting

Direktori yang perlu dibackup:

```text
/data/appdata/homeassistant
/data/appdata/mosquitto
/data/stacks/homeassistant
```

Direktori tersebut berisi:

- Konfigurasi Home Assistant
- Database Home Assistant
- Konfigurasi MQTT
- Docker Compose

Dengan backup direktori tersebut, deployment dapat dipulihkan dengan cepat setelah reinstall Armbian atau migrasi perangkat.