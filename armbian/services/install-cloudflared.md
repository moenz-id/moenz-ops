# Install Cloudflared on Armbian (APT)

Panduan ini memasang **cloudflared** langsung sebagai paket sistem menggunakan repositori APT resmi Cloudflare. Metode ini berbeda dari deployment Docker Compose yang dibahas di [cloudflared.md](./cloudflared.md).

## Prerequisites

- Armbian atau distribusi berbasis Debian/Ubuntu.
- Koneksi internet untuk mengakses repositori Cloudflare.
- Akun Cloudflare dan akses ke Zero Trust untuk membuat Tunnel.
- Hak akses `sudo`.

## Install

Unduh script dari repository:

```bash
curl -fsSLO https://raw.githubusercontent.com/moenz-id/moenz-ops/main/armbian/services/install-cloudflared.sh
```

Jalankan:

```bash
sudo bash install-cloudflared.sh
```

Script akan:

1. Memeriksa hak akses root dan distribusi Linux.
2. Memasang dependensi `ca-certificates` dan `curl`.
3. Mengunduh GPG key resmi Cloudflare ke `/usr/share/keyrings/`.
4. Menambahkan repositori APT Cloudflare.
5. Memasang paket `cloudflared`.
6. Memverifikasi instalasi dengan `cloudflared --version`.

## Configure Cloudflare Tunnel

Buat atau pilih Tunnel melalui Cloudflare Zero Trust Dashboard. Salin token Tunnel yang diberikan Cloudflare, lalu jalankan perintah berikut di server:

```bash
sudo cloudflared service install '<TUNNEL_TOKEN>'
```

Ganti `<TUNNEL_TOKEN>` dengan token milik Tunnel Anda. Jangan menyimpan token di script, dokumentasi publik, atau repository Git.

## Verify Service

Periksa status service:

```bash
sudo systemctl status cloudflared
```

Pantau log:

```bash
sudo journalctl -u cloudflared -f
```

Periksa versi:

```bash
cloudflared --version
```

## Update

Perbarui paket menggunakan APT:

```bash
sudo apt-get update
sudo apt-get install --only-upgrade cloudflared
```

## Uninstall

Untuk menghapus service dan paket:

```bash
sudo cloudflared service uninstall
sudo apt-get remove cloudflared
```

Opsional, hapus file repositori dan key jika tidak lagi digunakan:

```bash
sudo rm -f /etc/apt/sources.list.d/cloudflared.list
sudo rm -f /usr/share/keyrings/cloudflare-main.gpg
sudo apt-get update
```

## References

- [Cloudflare Packages](https://pkg.cloudflare.com/)
- [Cloudflare Tunnel documentation](https://developers.cloudflare.com/cloudflare-one/connections/connect-networks/)
