# Portainer

Dokumentasi deployment Portainer CE.

## Standar Homelab

- Menggunakan internal_net
- Data di /data/appdata/portainer
- Stack di /data/stacks/portainer

## Deploy

```bash
cd /data/stacks/portainer
docker compose up -d
```

## Akses

```text
https://IP-STB:9443
```

## Update

```bash
docker compose pull
docker compose up -d
```
