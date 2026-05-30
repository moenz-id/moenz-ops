# Home Assistant Container

Dokumentasi deployment Home Assistant menggunakan Docker Compose.

## Standar Homelab

- network_mode: host
- Data di /data/appdata/homeassistant
- Stack di /data/stacks/homeassistant
- MQTT terpisah menggunakan Mosquitto

## Struktur Direktori

```text
/data/appdata/homeassistant
/data/stacks/homeassistant
```

## Deploy

```bash
cd /data/stacks/homeassistant
docker compose up -d
```

## Verifikasi

```bash
docker ps
docker logs -f homeassistant
```

## Akses

```text
http://IP-STB:8123
```
