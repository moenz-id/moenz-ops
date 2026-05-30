# Migrate Docker Root to SD Card

## Summary

Panduan memindahkan Docker Root Directory dari eMMC ke SD Card.

Dokumentasi ini berguna untuk perangkat dengan kapasitas eMMC kecil seperti STB Armbian yang hanya memiliki storage 8 GB atau 16 GB.

Tujuan:

- Mengurangi penggunaan eMMC
- Menyediakan ruang lebih besar untuk image Docker
- Menghindari error 'no space left on device'
- Menyimpan image dan layer container di SD Card

---

# Kapan Perlu Migrasi?

Indikasi umum:

```bash
df -h /
```

Contoh:

```text
/dev/mmcblk2p2  6.5G  5.4G  1.1G  84%
```

Atau ketika:

- Home Assistant image sudah berukuran beberapa GB
- Update container mulai gagal
- eMMC sering penuh
- Akan menambah banyak service Docker

---

# Prerequisites

Pastikan SD Card sudah ter-mount.

Contoh:

```bash
df -h /data
```

Output:

```text
/dev/mmcblk1p1   59G   ...   /data
```

---

# Stop Container

Masuk ke direktori stack dan stop container.

```bash
docker compose down
```

Verifikasi:

```bash
docker ps
```

---

# Stop Docker Service

```bash
sudo systemctl stop docker
sudo systemctl stop containerd
```

Verifikasi:

```bash
systemctl status docker
```

Status yang diharapkan:

```text
inactive (dead)
```

---

# Buat Direktori Docker Baru

```bash
mkdir -p /data/docker-data
```

---

# Salin Docker Root Lama

```bash
sudo rsync -aHAXx /var/lib/docker/ /data/docker-data/
```

Tunggu hingga proses selesai.

---

# Konfigurasi Docker

Buat direktori konfigurasi:

```bash
sudo mkdir -p /etc/docker
```

Buat file:

```bash
sudo nano /etc/docker/daemon.json
```

Isi:

```json
{
  "data-root": "/data/docker-data"
}
```

---

# Start Docker Kembali

```bash
sudo systemctl start containerd
sudo systemctl start docker
```

---

# Verifikasi Docker Root Baru

```bash
docker info | grep "Docker Root Dir"
```

Output yang diharapkan:

```text
Docker Root Dir: /data/docker-data
```

---

# Verifikasi Image dan Container

Cek image:

```bash
docker images
```

Cek container:

```bash
docker ps
```

Jika image dan container masih muncul maka migrasi berhasil.

---

# Jalankan Stack Kembali

```bash
docker compose up -d
```

Verifikasi:

```bash
docker ps
```

---

# Cek Penggunaan Storage

```bash
df -h /
df -h /data
```

Cek ukuran Docker Root baru:

```bash
sudo du -sh /data/docker-data
```

---

# Verifikasi Home Assistant

Jika menggunakan Home Assistant:

```bash
docker logs -f homeassistant
```

Pastikan container kembali berjalan normal.

---

# Catatan Penting

Jangan langsung menghapus:

```text
/var/lib/docker
```

setelah migrasi.

Biarkan sistem berjalan normal terlebih dahulu dan lakukan reboot untuk memastikan Docker benar-benar menggunakan lokasi baru.

Verifikasi:

```bash
docker info | grep "Docker Root Dir"
```

Jika sudah menunjuk ke:

```text
/data/docker-data
```

maka migrasi berhasil.

---

# Layout Akhir

```text
eMMC
├── Armbian
├── Docker Engine
└── System Files

SD Card
├── docker-data
├── appdata
├── backups
└── stacks
```

Dengan layout ini, pertumbuhan image Docker tidak lagi membebani eMMC dan lebih cocok untuk homelab jangka panjang.