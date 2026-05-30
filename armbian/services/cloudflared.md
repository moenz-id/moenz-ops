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

# Struktur Direktori

```text
/data
├── appdata
│   └── cloudflared
└── stacks
    └── cloudflared
```

---

# Membuat Tunnel di Cloudflare

Cloudflare Dashboard → Zero Trust → Networks → Tunnels.

Buat tunnel baru dan simpan TUNNEL_TOKEN.

---

# Network internal_net

Cloudflared menggunakan internal_net agar tetap konsisten dengan standar homelab repository.

---

# Backup Data Penting

```text
/data/stacks/cloudflared
```

Jangan menyimpan token tunnel ke repository publik.

---

# Notes

Cloudflared adalah salah satu service yang direkomendasikan untuk selalu aktif karena menjadi jalur akses remote ke homelab.