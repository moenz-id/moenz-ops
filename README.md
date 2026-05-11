# Personal Knowledge Base

Repository ini berisi kumpulan dokumentasi pribadi, troubleshooting Linux, konfigurasi system, dan catatan teknis yang digunakan untuk kebutuhan sehari-hari.

Fokus utama repository:

- Linux troubleshooting
- Bootloader recovery
- System configuration
- Desktop environment configuration
- Personal sysadmin notes
- Recovery documentation

---

# Repository Structure

```text
github/
├── README.md
└── linux/
    ├── guides/
    ├── scripts/
    ├── notes/
    └── cheatsheets/
```

---

# Linux Guides

## Recover GRUB & Initramfs

Dokumentasi recovery Linux ketika sistem gagal boot dan masuk ke BusyBox/initramfs.

Topics:

- fsck recovery
- chroot repair
- reinstall GRUB
- EFI troubleshooting
- SMART health check

Link:

- [recover-initramfs-grub.md](linux/guides/recover-initramfs-grub.md)

---

## Remove Windows Boot Entry

Membersihkan entri Windows Boot Manager setelah migrasi penuh ke Ubuntu.

Topics:

- efibootmgr
- UEFI boot cleanup
- disable os-prober
- GRUB cleanup

Link:

- [remove-windows-boot-entry.md](linux/guides/remove-windows-boot-entry.md)

---

## Enable Login Screen In LightDM

Mengaktifkan kembali login screen pada Armbian XFCE yang menggunakan LightDM.

Topics:

- disable auto login
- LightDM configuration
- XFCE session login

Link:

- [enable-login-screen-lightdm.md](linux/guides/enable-login-screen-lightdm.md)

---

# Documentation Standard

Setiap dokumentasi di repository ini sebisa mungkin memiliki:

- Summary
- Environment
- Step-by-step guide
- Verification
- Post-mortem
- Prevention / mitigation

---

# Naming Convention

## Markdown Files

```text
verb-topic.md
```

Example:

```text
recover-initramfs-grub.md
remove-windows-boot-entry.md
enable-login-screen-lightdm.md
```

---

## Scripts

```text
verb-purpose.sh
```

Example:

```text
backup-home.sh
mount-nas.sh
repair-network.sh
```

---

# Notes

Semua dokumentasi ditulis berdasarkan pengalaman penggunaan nyata dan dapat berubah sesuai kebutuhan environment.
