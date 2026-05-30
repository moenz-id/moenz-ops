# Docker Backup & Restore Notes

Dokumentasi ini berisi catatan operasional terkait backup, restore, migrasi Docker ke SD Card, serta recovery setelah kegagalan sistem.

---

# Docker Storage Layout

## Docker Root

Docker data disimpan pada SD Card:

```bash
/data/docker-data
```

Direkomendasikan untuk memindahkan Docker Root dari eMMC ke SD Card agar image dan layer container tidak menghabiskan ruang penyimpanan internal.

---

# Bind Mount vs Named Volume

Standar homelab ini menggunakan bind mount.

Contoh:

```yaml
volumes:
  - /data/appdata/homeassistant:/config
```

Artinya data aplikasi berada di luar container dan tetap aman saat container dihapus atau dibuat ulang.

---

# Backup Yang Direkomendasikan

Backup direktori berikut:

```text
/data/appdata
/data/stacks
```

Berisi:

- Konfigurasi aplikasi
- Docker Compose
- Database aplikasi
- Data persisten container

---

# Recovery Workflow

Restart layanan:

```bash
sudo systemctl restart containerd
sudo systemctl restart docker
```

Kemudian deploy ulang:

```bash
docker compose up -d
```

---

# Common Issues

## RWLayer Error

Jika muncul error RWLayer atau metadata container rusak, biasanya data aplikasi masih aman selama direktori bind mount tidak hilang.

## Nested Docker Directory

Pastikan hasil restore tidak membuat struktur seperti:

```text
/var/lib/docker/docker
```

Karena Docker tidak dapat membaca metadata dengan benar.

---

# Final Lesson

Data terpenting bukan container Docker, melainkan direktori bind mount yang menyimpan konfigurasi dan state aplikasi.

Dengan backup yang baik, container dapat dibuat ulang menggunakan Docker Compose dalam hitungan menit.