# Install Docker on Armbian (STB Homelab)

## Summary

Dokumentasi instalasi Docker pada Armbian untuk kebutuhan homelab STB.

Panduan ini mencakup:

- Install Docker Engine
- Install Docker Compose Plugin
- Verifikasi instalasi Docker
- Setup direktori data homelab
- Setup mount SD Card untuk data Docker
- Pembuatan network internal_net (opsional)

Panduan ini tidak mencakup instalasi aplikasi seperti Home Assistant, Mosquitto, AdGuard Home, ESPHome, maupun n8n.

---

# Environment

Contoh environment:

- Armbian 26.x
- Kernel OPhub
- ARM64 / AArch64
- eMMC untuk sistem operasi
- SD Card untuk data homelab

---

# Update Sistem

```bash
sudo apt update
sudo apt upgrade -y
```

---

# Install Dependency

```bash
sudo apt install -y ca-certificates curl
```

---

# Tambahkan Repository Docker

```bash
sudo install -m 0755 -d /etc/apt/keyrings
sudo curl -fsSL https://download.docker.com/linux/debian/gpg -o /etc/apt/keyrings/docker.asc
sudo chmod a+r /etc/apt/keyrings/docker.asc
```

Tambahkan repository dan lanjutkan sesuai dokumentasi utama.

---

# Install Docker Engine

```bash
sudo apt install -y docker-ce docker-ce-cli containerd.io docker-buildx-plugin docker-compose-plugin
```

---

# Verifikasi Instalasi

```bash
docker version
docker compose version
docker info
docker ps
```

---

# Setup SD Card dan Struktur Homelab

```text
/data
├── appdata
├── backups
└── stacks
```

---

# Network internal_net

```bash
docker network create internal_net
```

Verifikasi:

```bash
docker network ls
```
