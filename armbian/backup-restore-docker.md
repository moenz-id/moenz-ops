# Docker Backup & Restore Notes

This document contains operational notes and troubleshooting history related to Docker backup, restore, SD card migration, and network recovery on the Armbian STB.

---

# Docker Storage Layout

## Docker Root

Docker data stored on SD card:

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

Meaning:

- Persistent application data is stored in:

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

# Backup Strategy

## Backup to PC using rsync

Example:

```bash
sudo rsync -avz /home/moenz/docker/ moenz@192.168.1.154:/home/moenz/backup/config/
```

Docker metadata backup:

```bash
sudo rsync -avz /var/lib/docker/ moenz@192.168.1.154:/home/moenz/backup/docker/
```

---

# Wrong Restore Structure Issue

Incorrect backup structure:

```bash
backup/docker/docker/
```

This created nested Docker directories:

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

# RWLayer Error

Error:

```text
RWLayer of container ... is unexpectedly nil
```

Meaning:
- Docker container layer metadata damaged
- Persistent application data still safe

Solution:

```bash
docker compose up -d
```

---

# DNS Troubleshooting

Recommended DNS configuration:

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
