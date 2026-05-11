# Remove Windows Boot Entry From GRUB

## Tags

linux, grub, uefi, dualboot, bootloader

---

# Summary

Dokumentasi ini menjelaskan cara:

- Menghapus menu boot Windows dari GRUB
- Menjadikan Ubuntu sebagai bootloader utama
- Membersihkan entri Windows Boot Manager dari UEFI

Cocok digunakan setelah migrasi penuh dari Windows ke Ubuntu.

---

# Table of Contents

- Check boot priority
- Remove Windows Boot Manager
- Disable os-prober
- Update GRUB
- Verification

---

# Check Boot Priority

Masuk ke BIOS/UEFI:

- DEL
- F2
- F12
- ESC

Pastikan:

- Ubuntu berada di urutan pertama
- GRUB digunakan sebagai bootloader utama

---

# Remove Windows Boot Manager

## Install efibootmgr

```bash
sudo apt install efibootmgr
```

## Check UEFI entries

```bash
sudo efibootmgr
```

Contoh:

```text
BootCurrent: 0001
BootOrder: 0001,0002,0003
Boot0001* ubuntu
Boot0002* Windows Boot Manager
Boot0003* UEFI: USB
```

## Delete Windows Boot Manager

```bash
sudo efibootmgr -b 0002 -B
```

Ganti `0002` sesuai nomor Windows Boot Manager.

---

# Set Ubuntu As Default Boot

```bash
sudo efibootmgr -o 0001
```

---

# Disable os-prober

Edit konfigurasi GRUB:

```bash
sudo nano /etc/default/grub
```

Tambahkan:

```bash
GRUB_DISABLE_OS_PROBER=true
GRUB_TIMEOUT_STYLE=hidden
GRUB_TIMEOUT=0
```

---

# Update GRUB

```bash
sudo update-grub
```

---

# Verification

Hasil akhir:

- Windows tidak muncul di GRUB
- Sistem langsung boot ke Ubuntu
- Entri Windows Boot Manager hilang
- Boot process lebih bersih
