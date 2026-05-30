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

# Struktur Direktori

```text
/data
├── appdata
│   └── portainer
└── stacks
    └── portainer
```

---

# Akses Web UI

```text
https://IP-STB:9443
```

Portainer akan meminta pembuatan akun administrator pada login pertama.

---

# Backup Data Penting

```text
/data/appdata/portainer
/data/stacks/portainer
```

---

# Notes

Portainer bukan kebutuhan wajib untuk Docker, namun sangat membantu ketika jumlah container mulai bertambah dan menjadi dashboard utama pengelolaan homelab berbasis Docker.