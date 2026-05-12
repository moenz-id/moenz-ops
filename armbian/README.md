# Armbian STB Homelab Documentation

## Terminology

| Name | Description |
|---|---|
| STB | STB running Armbian + Docker |
| openwrt | STB running OpenWrt as gateway/router |
| tplink | TP-Link router/AP |

---

# Architecture Overview

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

# Docker Storage Layout

## Docker Root

Docker data originally stored on SD card:

```bash
/data/docker
```

Mounted to:

```bash
/var/lib/docker
```

Example `/etc/fstab`:

```fstab
UUID=<sdcard-uuid>  /data  ext4  defaults,noatime,commit=600  0  2

/data/docker      /var/lib/docker       none  bind  0  0
/data/containerd  /var/lib/containerd   none  bind  0  0
```

---

# Important Discovery

The setup uses **bind mounts**, not Docker named volumes.

Example:

```yaml
services:
  homeassistant:
    volumes:
      - /home/moenz/docker/homeautomation/homeassistant/config:/config
```

This means:

- Application data is stored inside:

```bash
/home/moenz/docker/
```

- Docker containers themselves are disposable.
- Recreating containers does not remove application data.

---

# Most Important Backup Location

## Recommended backup target

```bash
/home/moenz/docker/
```

Contains:
- Home Assistant configuration
- Mosquitto data
- Docker Compose files
- Application configs
- Persistent application state

---

# Docker Backup Lessons Learned

## Wrong restore structure

Incorrect backup structure:

```bash
backup/docker/docker/
```

This caused nested Docker directories:

```bash
/var/lib/docker/docker/
```

Docker could not detect containers correctly.

---

# Correct Restore Method

Restore from PC to STB:

```bash
sudo rsync -avz moenz@192.168.1.154:/home/moenz/backup/docker/docker/ /var/lib/docker/
```

Important:
- Use trailing `/`
- Copy contents, not parent directory

---

# Docker Recovery Workflow

## Restart metadata services

```bash
sudo systemctl restart containerd
sudo systemctl restart docker
```

## Recreate containers

```bash
docker compose up -d
```

This recreates containers using existing bind-mounted application data.

---

# DNS Configuration

Recommended DNS for STB:

```bash
nameserver 192.168.1.1
```

Reason:
- openwrt acts as central DNS server
- Easier local networking
- Centralized management

Avoid relying only on:

```bash
8.8.8.8
```

except as fallback.

---

# MAC Address Conflict Issue

## Symptoms

- SSH randomly unreachable
- Cannot ping gateway
- Network instability
- ARP problems
- Intermittent connectivity

Most likely caused by MAC address conflicts between:
- openwrt STB
- Armbian STB

---

# Temporary MAC Fix

```bash
sudo ip link set eth0 down
sudo ip link set eth0 address 02:11:22:33:44:55
sudo ip link set eth0 up
```

---

# Permanent MAC Configuration

Edit:

```bash
/etc/network/interfaces
```

Example:

```ini
auto lo
iface lo inet loopback

auto eth0
iface eth0 inet dhcp
    hwaddress ether 02:11:22:33:44:55
```

---

# Useful Network Commands

## Check IP

```bash
ip a
```

## Check route

```bash
ip route
```

## Flush ARP cache

```bash
sudo ip neigh flush all
```

## Restart interface

```bash
sudo ip link set eth0 down
sudo ip link set eth0 up
```

---

# Realtek WiFi Driver Spam Fix

Issue:

```text
RTL871X spam messages flooding terminal
```

Temporary fix:

```bash
dmesg -n 1
```

Optional WiFi disable:

```bash
sudo ip link set wlan0 down
```

---

# Recommended Homelab Direction

## openwrt
- Gateway
- DNS
- Reverse proxy (future)
- Internet edge node

## STB
- Service node
- Docker workloads
- Home Assistant
- Internal apps

## Future Improvements
- Reverse proxy
- Internal DNS records
- VLAN segmentation
- Docker Swarm or k3s
- Monitoring stack

---

# Final Lessons Learned

## Most important data is NOT Docker container data.

The important data is:

```bash
/home/moenz/docker/
```

Containers can always be recreated using:

```bash
docker compose up -d
```

Persistent application state remains safe as long as bind-mounted directories are backed up.
