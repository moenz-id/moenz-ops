# Troubleshooting

Dokumentasi troubleshooting umum untuk node Armbian homelab.

## Docker Tidak Bisa Start

Cek status:

```bash
systemctl status docker
journalctl -u docker -n 100
```

## eMMC Penuh

Cek penggunaan storage:

```bash
df -h /
sudo du -xh / --max-depth=1 | sort -h
```

## Docker Root Dir Salah

Verifikasi:

```bash
docker info | grep "Docker Root Dir"
```

## Permission Denied pada /data

Periksa ownership dan mount:

```bash
ls -ld /data
df -h /data
```

## Tailscale Override DNS

Gunakan:

```bash
sudo tailscale up --accept-dns=false
```

## Cloudflared Tunnel Disconnect

Cek log:

```bash
docker logs -f cloudflared
```

## Home Assistant Restart Loop

Cek log:

```bash
docker logs -f homeassistant
```
