# Recover GRUB & Initramfs

## Tags

linux, grub, initramfs, recovery, fsck

---

## Summary

Dokumentasi ini menjelaskan langkah-langkah untuk mendeteksi dan memperbaiki Linux yang gagal boot dan masuk ke initramfs (BusyBox).

Kasus umum:

- Boot masuk BusyBox
- GRUB hilang
- Muncul pesan:

```text
Insert boot media and press any key
```

---

# Environment

- Host repair: Ubuntu Server
- Target disk: `/dev/sdb`
- EFI partition: `/dev/sdb1`
- Root partition: `/dev/sdb2`

---

# Table of Contents

- Diagnosis
- Mount filesystem
- Repair filesystem using fsck
- Reinstall GRUB
- Verify BIOS/UEFI
- SMART health check
- Post-mortem

---

# Diagnosis

## Check devices

```bash
lsblk -f
blkid
```

Verifikasi:

- UUID
- filesystem
- root partition
- EFI partition

---

# Mount Filesystem

```bash
sudo mkdir -p /mnt/sdb
sudo mount /dev/sdb2 /mnt/sdb
sudo mount /dev/sdb1 /mnt/sdb/boot/efi
```

---

# Check fstab

```bash
cat /mnt/sdb/etc/fstab
```

Pastikan UUID pada `fstab` sesuai dengan output `blkid`.

---

# Repair Filesystem Using fsck

## Unmount partition

```bash
sudo umount /mnt/sdb || sudo umount -l /mnt/sdb
```

## Run fsck

```bash
sudo fsck -f /dev/sdb2
```

Jika muncul:

```text
Fix<y>?
```

Jawab:

```text
y
```

atau:

```text
a
```

untuk approve semua perbaikan.

---

## Verify filesystem

```bash
sudo mount /dev/sdb2 /mnt/sdb
ls /mnt/sdb
```

---

# Reinstall GRUB

## Mount root and EFI

```bash
sudo mount /dev/sdb2 /mnt
sudo mkdir -p /mnt/boot/efi
sudo mount /dev/sdb1 /mnt/boot/efi
```

## Bind system directories

```bash
sudo mount --bind /dev /mnt/dev
sudo mount --bind /proc /mnt/proc
sudo mount --bind /sys /mnt/sys
```

## Enter chroot

```bash
sudo chroot /mnt /bin/bash
```

## Reinstall GRUB

```bash
grub-install /dev/sdb
update-grub
```

## Exit chroot

```bash
exit
sudo umount -R /mnt
```

---

# Verify BIOS / UEFI

Pastikan:

- SSD terdeteksi
- Boot order benar
- Menggunakan UEFI boot entry
- Secure boot tidak mengganggu bootloader

---

# SMART Health Check

Install smartmontools:

```bash
sudo apt update
sudo apt install smartmontools
```

Check SSD health:

```bash
sudo smartctl -a /dev/sdb
```

Periksa:

- Reallocated sectors
- Pending sectors
- SMART health status

---

# Post-Mortem

Kemungkinan penyebab:

- Power loss
- Filesystem corruption
- SSD issue
- Bootloader corruption

---

# Prevention

- Backup rutin
- Monitoring SMART
- Hindari force shutdown
- Verifikasi boot order setelah perubahan hardware
