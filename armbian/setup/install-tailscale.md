# Install Tailscale on Armbian

Dokumentasi instalasi Tailscale secara native pada Armbian.

## Rekomendasi

Tailscale dijalankan langsung pada host Armbian, bukan di dalam Docker.

Keuntungan:
- Tetap aktif walaupun Docker bermasalah
- Dapat digunakan untuk remote troubleshooting
- Mendukung Tailscale SSH

## Instalasi

```bash
curl -fsSL https://tailscale.com/install.sh | sh
```

Verifikasi:

```bash
tailscale version
```

## Login

```bash
sudo tailscale up --accept-dns=false
```

## DNS Override

Pada homelab ini direkomendasikan:

```bash
sudo tailscale up --accept-dns=false
```

agar DNS tetap menggunakan DNS lokal atau AdGuard Home.

## Verifikasi

```bash
tailscale status
tailscale ip -4
```
