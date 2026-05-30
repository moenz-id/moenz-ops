# Docker Compose Files

Folder ini menyimpan file Docker Compose untuk layanan homelab.

## Compose Files

- [homeassistant.yaml](homeassistant.yaml) - Home Assistant dan Mosquitto
- [portainer.yaml](portainer.yaml) - Portainer CE
- [cloudflared.yaml](cloudflared.yaml) - Cloudflare Tunnel
- [searxng.yaml](searxng.yaml) - SearXNG

## Environment

Salin `.env.example` menjadi `.env` pada host deployment, lalu isi nilai yang dibutuhkan.

```bash
cp .env.example .env
```

Jangan commit file `.env` karena dapat berisi token atau secret.

## Network Standard

Semua container menggunakan network eksternal:

```text
internal_net
```

Kecuali Home Assistant yang menggunakan:

```yaml
network_mode: host
```

Mosquitto tetap menggunakan `internal_net`, tetapi port `1883` dipublish agar Home Assistant yang berjalan di host network dapat mengakses broker melalui IP host atau `localhost`.
