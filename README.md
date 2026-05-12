# moenz-ops

Personal Linux operations knowledge base berisi dokumentasi troubleshooting, recovery guide, konfigurasi system, dan catatan sysadmin yang digunakan untuk kebutuhan sehari-hari.

Repository ini dibuat sebagai:

- Personal sysadmin notebook
- Linux troubleshooting archive
- Recovery documentation
- System configuration reference
- Operational notes repository

---

# Focus Areas

- Linux troubleshooting
- Bootloader recovery
- UEFI & GRUB repair
- Desktop environment configuration
- System maintenance
- Recovery & disaster mitigation
- Personal operations notes
- Docker & homelab operations
- Armbian STB infrastructure

---

# Repository Structure

```text
moenz-ops/
├── README.md
├── armbian/
│   ├── README.md
│   └── backup-restore-docker.md
└── linux/
    ├── guides/
    ├── scripts/
    ├── notes/
    └── cheatsheets/
```

---

# Armbian Documentation

Dokumentasi terkait:

- Docker backup & restore
- STB homelab setup
- Network troubleshooting
- DNS & gateway recovery
- MAC conflict troubleshooting
- Docker recovery workflow

Documentation:

- [Armbian Overview](armbian/README.md)
- [Docker Backup & Restore](armbian/backup-restore-docker.md)

---

# Linux Guides

## Recover GRUB & Initramfs

Recovery guide ketika Linux gagal boot dan masuk ke BusyBox/initramfs.

Topics:

- fsck recovery
- chroot repair
- reinstall GRUB
- EFI troubleshooting
- SMART health check

Documentation:

- [recover-initramfs-grub.md](linux/guides/recover-initramfs-grub.md)

---

## Remove Windows Boot Entry

Membersihkan Windows Boot Manager setelah migrasi penuh ke Ubuntu.

Topics:

- efibootmgr
- UEFI cleanup
- GRUB cleanup
- disable os-prober

Documentation:

- [remove-windows-boot-entry.md](linux/guides/remove-windows-boot-entry.md)

---

## Enable Login Screen In LightDM

Mengaktifkan kembali login screen pada Armbian XFCE menggunakan LightDM.

Topics:

- auto login
- LightDM configuration
- XFCE login session

Documentation:

- [enable-login-screen-lightdm.md](linux/guides/enable-login-screen-lightdm.md)

---

# Documentation Standard

Setiap dokumentasi di repository ini diusahakan memiliki:

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

# Future Plans

Planned repository expansion:

- automation scripts
- docker notes
- networking guides
- server management
- homelab documentation
- shell utilities
- recovery scripts
- infrastructure diagrams
- backup automation

---

# Notes

Semua dokumentasi ditulis berdasarkan pengalaman penggunaan nyata dan dapat berubah sesuai kebutuhan environment.
