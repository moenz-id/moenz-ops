# Deploy Home Assistant Container on Armbian

## Summary

Dokumentasi deployment Home Assistant Container dan Mosquitto menggunakan Docker Compose pada Armbian.

Dokumen ini diasumsikan menggunakan environment yang telah mengikuti panduan:

- setup/install-docker.md

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

---

# Backup Data Penting

Direktori yang perlu dibackup:

```text
/data/appdata/homeassistant
/data/appdata/mosquitto
/data/stacks/homeassistant
```

Dengan backup direktori tersebut, deployment dapat dipulihkan dengan cepat setelah reinstall Armbian atau migrasi perangkat.