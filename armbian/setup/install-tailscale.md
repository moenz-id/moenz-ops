# Install Tailscale on Armbian

## Summary

Dokumentasi instalasi Tailscale secara native pada Armbian.

Pada homelab ini Tailscale direkomendasikan berjalan langsung di host dan bukan di dalam Docker.

Alasan:

- Tetap aktif walaupun Docker bermasalah
- Dapat digunakan untuk remote troubleshooting
- Dapat digunakan untuk Tailscale SSH
- Lebih sederhana dibanding menjalankan container Tailscale
- Cocok untuk always-on node

---

# Posisi Tailscale dalam Homelab

```text
Armbian Host
├── Tailscale
└── Docker
    ├── Cloudflared
    ├── Portainer
    ├── Home Assistant
    ├── Mosquitto
    ├── AdGuard Home
    └── n8n
```

Tailscale dianggap sebagai bagian dari management layer dan bukan service aplikasi.

---

# Install Tailscale

Jalankan:

```bash
curl -fsSL https://tailscale.com/install.sh | sh
```

Verifikasi:

```bash
tailscale version
```

---

# Enable Saat Boot

Cek service:

```bash
systemctl status tailscaled
```

Enable:

```bash
sudo systemctl enable tailscaled
sudo systemctl start tailscaled
```

Verifikasi:

```bash
systemctl status tailscaled
```

---

# Login ke Tailscale

Jalankan:

```bash
sudo tailscale up
```

Akan muncul URL login.

Contoh:

```text
https://login.tailscale.com/...
```

Buka URL tersebut dan login menggunakan akun Tailscale.

---

# DNS Override (Rekomendasi Homelab)

Secara default Tailscale dapat mengambil pengaturan DNS dari dashboard Tailscale.

Hal ini kadang membuat node menggunakan DNS Tailscale dan bukan DNS lokal yang sudah dikonfigurasi pada jaringan.

Gejala yang sering muncul:

- DNS tiba-tiba berubah
- Query tidak melewati AdGuard Home lokal
- Bingung karena hasil DNS berbeda dari perangkat lain

Untuk tetap menggunakan DNS lokal, jalankan:

```bash
sudo tailscale up --accept-dns=false
```

Verifikasi:

```bash
tailscale status
```

Atau cek konfigurasi:

```bash
tailscale debug prefs
```

Pada homelab ini direkomendasikan menggunakan:

```bash
sudo tailscale up --accept-dns=false
```

agar DNS tetap mengikuti konfigurasi lokal atau AdGuard Home.

---

# Verifikasi Koneksi

Cek status:

```bash
tailscale status
```

Cek IP Tailscale:

```bash
tailscale ip -4
```

Contoh:

```text
100.x.x.x
```

---

# Mengakses Node dari Perangkat Lain

Gunakan IP Tailscale:

```text
100.x.x.x
```

Contoh:

```bash
ssh moenz@100.x.x.x
```

---

# Tailscale SSH (Opsional)

Aktifkan:

```bash
sudo tailscale up --ssh --accept-dns=false
```

Verifikasi:

```bash
tailscale status
```

Konfigurasi izin SSH dilakukan melalui dashboard Tailscale.

---

# Update Tailscale

Update package:

```bash
sudo apt update
sudo apt upgrade tailscale
```

Verifikasi:

```bash
tailscale version
```

---

# Troubleshooting

Cek status service:

```bash
systemctl status tailscaled
```

Lihat log:

```bash
journalctl -u tailscaled -f
```

Restart service:

```bash
sudo systemctl restart tailscaled
```

---

# Notes

Pada homelab ini Tailscale direkomendasikan dipasang pada setiap node penting.

Contoh:

- OpenWrt Gateway
- Armbian STB
- Mini PC
- NAS

Dengan pendekatan ini setiap node tetap dapat diakses walaupun Cloudflared atau Docker sedang mengalami masalah.

Tailscale menjadi jalur akses manajemen utama, sedangkan Cloudflared digunakan untuk publikasi layanan ke internet.