# Armbian Documentation

This folder contains operational notes, recovery procedures, and homelab documentation related to the Armbian STB environment.

---

# Terminology

| Name | Description |
|---|---|
| STB | STB running Armbian + Docker |
| openwrt | STB running OpenWrt as gateway/router |
| tplink | TP-Link router/AP |

---

# Documentation Index

## Docker

### Docker Backup & Restore

File:

```text
backup-restore-docker.md
```

Contains:
- Docker storage layout
- Bind mount strategy
- Backup workflow
- Restore workflow
- Docker recovery process
- DNS troubleshooting
- MAC address conflict troubleshooting
- Network recovery notes

---

# Current Architecture Summary

## openwrt
Role:
- Gateway
- DHCP server
- DNS server
- Internet routing

## STB (Armbian)
Role:
- Docker host
- Home Assistant
- Mosquitto
- n8n
- AdGuard Home
- Cloudflared

## tplink
Role:
- Access Point / switch

---

# Recommended Future Improvements

- Reverse proxy
- Internal DNS records
- VLAN segmentation
- Monitoring stack
- Docker Swarm / k3s
- Centralized backup automation
