# Install Docker Engine di Armbian / Debian

Panduan ini adalah entry point instalasi Docker Engine untuk host Armbian STB. Instalasi menggunakan **repository APT resmi Docker**, bukan convenience script pihak ketiga.

## Pilih metode instalasi

| Metode | File / langkah | Kapan digunakan |
|---|---|---|
| Otomatis (disarankan) | [install-docker.sh](./install-docker.sh) | Instalasi cepat dan konsisten |
| Manual | Ikuti [dokumentasi resmi Docker](https://docs.docker.com/engine/install/debian/) | Jika ingin menjalankan dan memeriksa setiap perintah sendiri |

> Script otomatis hanya memasang Docker Engine dan plugin resminya. Pengaturan direktori data, migrasi ke SD Card, dan deployment aplikasi dilakukan terpisah.

---

## 1. Environment dan prasyarat

Panduan ini ditujukan untuk:

- Armbian berbasis Debian (contoh: Debian 13 Trixie).
- Debian 12 Bookworm atau Debian 13 Trixie.
- Arsitektur yang didukung script: `arm64`, `armhf`, `amd64`, dan `ppc64el`.
- Akses internet sementara untuk mengambil paket APT dan Docker image saat pengujian.
- Hak akses `sudo`.

Periksa sistem sebelum instalasi:

```bash
cat /etc/os-release
dpkg --print-architecture
```

Pastikan codename yang terdeteksi adalah `bookworm` atau `trixie`.

## 2. Instalasi otomatis (disarankan)

Jalankan dari Armbian:

```bash
curl -fsSLO https://raw.githubusercontent.com/moenz-id/moenz-ops/main/armbian/setup/install-docker.sh
chmod +x install-docker.sh
sudo ./install-docker.sh
```

Script akan:

1. Memeriksa OS, codename Debian, arsitektur, dan hak akses root.
2. Memasang dependensi `ca-certificates` dan `curl`.
3. Mengunduh GPG key resmi Docker ke `/etc/apt/keyrings/docker.asc`.
4. Membuat repository APT Docker di `/etc/apt/sources.list.d/docker.sources`.
5. Menghapus paket konflik yang disebutkan dalam dokumentasi Docker.
6. Memasang Docker Engine, CLI, containerd, Buildx, dan Compose Plugin.
7. Mengaktifkan serta menjalankan service Docker.
8. Menampilkan versi komponen untuk verifikasi.

### Perhatian sebelum menjalankan

- Jika sebelumnya menggunakan paket Docker dari distro atau runtime lain, proses penghapusan paket konflik dapat menghentikan service terkait.
- Script **tidak menjalankan** `rm -rf` dan tidak sengaja menghapus `/var/lib/docker` atau `/var/lib/containerd`. Namun, tetap buat backup sebelum mengganti instalasi Docker yang sudah digunakan.
- Script tidak menjalankan `apt upgrade`, tidak menambahkan user ke grup `docker`, dan tidak mengubah Docker data-root.
- Keanggotaan grup `docker` memberikan hak akses setara root. Aktifkan hanya jika memahami implikasi keamanannya.

## 3. Verifikasi instalasi

Periksa service:

```bash
sudo systemctl is-active docker
sudo systemctl status docker --no-pager
```

Periksa versi:

```bash
docker --version
docker compose version
docker buildx version
containerd --version
```

Jalankan pengujian:

```bash
sudo docker run --rm hello-world
```

Perintah `hello-world` membutuhkan akses internet untuk mengunduh image jika image belum tersedia secara lokal.

Periksa kondisi Docker:

```bash
sudo docker info
sudo docker ps -a
```

## 4. Menjalankan Docker tanpa sudo (opsional)

Secara default, gunakan `sudo docker ...`. Jika ingin menjalankan Docker sebagai user biasa:

```bash
sudo usermod -aG docker "$USER"
```

Logout lalu login kembali, kemudian periksa:

```bash
docker ps
```

**Peringatan:** user yang menjadi anggota grup `docker` pada dasarnya memiliki hak istimewa setara root pada host.

## 5. Langkah setelah instalasi

Instalasi Docker tidak otomatis menyiapkan struktur direktori homelab. Tentukan lokasi penyimpanan terlebih dahulu.

Contoh struktur direktori aplikasi:

```text
/data/
├── appdata/
├── backups/
└── stack/
```

Buat direktori tersebut hanya setelah memastikan `/data` memang merupakan filesystem atau mount point penyimpanan yang diinginkan:

```bash
sudo mkdir -p /data/appdata /data/backups /data/stack
```

### Menggunakan SD Card sebagai Docker data-root

Jika ingin memindahkan data Docker dari eMMC ke SD Card, **jangan hanya mengubah `data-root` pada instalasi Docker yang sudah berisi container dan image**. Ikuti prosedur migrasi yang mencakup penghentian Docker dan penyalinan data:

- [Migrate Docker Root to SD Card](./migrate-docker-root-to-sdcard.md)

### Docker network

Network bersama seperti `internal_net` bersifat opsional. Buat hanya jika stack Compose memang akan menggunakannya:

```bash
sudo docker network create internal_net
sudo docker network ls
```

## 6. Troubleshooting dasar

### APT tidak menemukan paket Docker

Periksa codename dan arsitektur:

```bash
. /etc/os-release
printf 'Codename: %s\\n' "$VERSION_CODENAME"
dpkg --print-architecture
```

Periksa repository:

```bash
cat /etc/apt/sources.list.d/docker.sources
sudo apt update
```

Pastikan codename dan arsitektur didukung oleh repository Docker.

### Service Docker gagal berjalan

```bash
sudo systemctl status docker --no-pager
sudo journalctl -u docker -n 100 --no-pager
```

### Butuh bantuan lebih lanjut

- [Docker Engine installation on Debian (official)](https://docs.docker.com/engine/install/debian/)
- [Docker Engine post-installation steps (official)](https://docs.docker.com/engine/install/linux-postinstall/)

---

## Ringkasan file terkait

- [Installer otomatis](./install-docker.sh)
- [Migrasi Docker data-root ke SD Card](./migrate-docker-root-to-sdcard.md)
- [Panduan instalasi Tailscale](./install-tailscale.md)
