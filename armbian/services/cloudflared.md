# Cloudflared

Dokumentasi deployment Cloudflare Tunnel menggunakan Docker Compose.

## Standar Homelab

- Menggunakan internal_net
- Stack di /data/stacks/cloudflared
- Tunnel menggunakan TUNNEL_TOKEN

## Deploy

```bash
cd /data/stacks/cloudflared
docker compose up -d
```

## Verifikasi

```bash
docker ps
docker logs -f cloudflared
```

## Public Hostname

Contoh:

```text
ha.domain.com
n8n.domain.com
adguard.domain.com
```
