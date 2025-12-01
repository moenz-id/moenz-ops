# Memperbaiki masalah **tiba-tiba masuk initramfs (BusyBox)** dan membuat dokumentasi

Dokumentasi ini menjelaskan langkah-langkah yang saya lakukan untuk mendeteksi, memperbaiki, dan memulihkan sistem Linux yang tiba-tiba masuk ke **initramfs**. Ditulis dalam Bahasa Indonesia agar mudah diunggah ke GitHub sebagai `README.md`.

---

## Ringkasan masalah

- Gejala: PC tiba-tiba boot ke `initramfs` (BusyBox) atau menampilkan pesan `Insert boot media and press any key` setelah percobaan perbaikan.
- Disk yang bermasalah: SSD yang berisi instalasi Linux (contoh di dokumentasi ini: `/dev/sdb` dengan `sdb1` = EFI (FAT32) dan `sdb2` = root (ext4)).
- Penyebab umum: corrupt filesystem, inode/orphan list corrupt, block bitmap mismatch, atau bootloader (GRUB/UEFI) tidak terdeteksi.

---

## Lingkungan (contoh pada kasus ini)

- Host perbaikan: Ubuntu Server (digunakan untuk memperbaiki SSD)
- SSD bermasalah terpasang ke host perbaikan sebagai `/dev/sdb`
- Partisi pada SSD:
  - `/dev/sdb1` - EFI (vfat) — biasanya `/boot/efi`
  - `/dev/sdb2` - ext4 — root (`/`)

> Catatan: pada PC yang sedang dipakai sebelumnya, disk sistem utama adalah `/dev/sda` (contoh lain). Pastikan Anda menyesuaikan device names.

---

## Langkah-langkah diagnosis

1. **Cek device dan filesystem**

```bash
lsblk -f
blkid
```

Perhatikan partisi mana yang berisi root (`/`) dan apakah UUID sesuai dengan `/etc/fstab` pada sistem di dalam SSD.

2. **Mount sistem dari SSD (di host perbaikan)**

```bash
sudo mkdir -p /mnt/sdb
sudo mount /dev/sdb2 /mnt/sdb        # mount root
sudo mount /dev/sdb1 /mnt/sdb/boot/efi  # mount efi jika ada
```

3. **Periksa fstab di dalam SSD**

```bash
cat /mnt/sdb/etc/fstab
```

Bandingkan UUID pada `blkid` dengan yang tercantum di `fstab`. Kalau cocok, masalah kemungkinan besar filesystem corrupt, bukan fstab/UUID.

---

## Memperbaiki filesystem (fsck)

> **Peringatan:** Pastikan partisi tidak sedang ter-mount sebelum menjalankan `fsck` (kecuali Anda menjalankan mode read-only yang khusus). Melakukan `fsck` pada partisi yang masih di-mount dapat merusak data.

1. Unmount (jika masih ter-mount):

```bash
sudo umount /mnt/sdb || sudo umount -l /mnt/sdb
```

2. Jalankan fsck (paksa):

```bash
sudo fsck -f /dev/sdb2
```

3. Saat muncul prompt `Fix<y>?`, jawab `y` (atau `a` untuk yes to all). Contoh pesan yang mungkin muncul:

```
Inodes that were part of a corrupted orphan linked list found. Fix<y>? yes
Free blocks count wrong ... Fix<y>? yes
***** FILE SYSTEM WAS MODIFIED *****
```

4. Jika `sdb1` juga mengalami masalah, jalankan juga (meskipun jarang diperlukan):

```bash
sudo fsck -f /dev/sdb1
```

5. Setelah `fsck` selesai dan melaporkan `FILE SYSTEM WAS MODIFIED`, mount kembali untuk verifikasi:

```bash
sudo mount /dev/sdb2 /mnt/sdb
ls /mnt/sdb
```

---

## Memulihkan bootloader (GRUB/UEFI) — langkah chroot

Jika setelah perbaikan filesystem PC menampilkan pesan **"Insert boot media and press any key"**, kemungkinan GRUB/UEFI entry hilang atau tidak terdaftar di firmware. Lakukan langkah berikut di host perbaikan:

1. Mount root & EFI (jika belum):

```bash
sudo mount /dev/sdb2 /mnt
sudo mkdir -p /mnt/boot/efi
sudo mount /dev/sdb1 /mnt/boot/efi
```

2. Bind mount system dirs:

```bash
sudo mount --bind /dev  /mnt/dev
sudo mount --bind /proc /mnt/proc
sudo mount --bind /sys  /mnt/sys
```

3. Masuk chroot:

```bash
sudo chroot /mnt /bin/bash
```

4. Reinstall GRUB ke disk physical (bukan partisi):

```bash
# contoh untuk disk /dev/sdb
grub-install /dev/sdb
update-grub
```

> Jika sistem menggunakan UEFI, `grub-install` otomatis akan menulis ke `/boot/efi` dan menambahkan entry UEFI. Pastikan `efibootmgr` tersedia jika Anda perlu memeriksa entry UEFI.

5. Keluar chroot dan unmount:

```bash
exit
sudo umount -R /mnt
```

6. Pasang kembali SSD ke PC target dan boot. Jika BIOS/UEFI boot-order benar (pastikan memilih `UEFI: <nama SSD>`), sistem harus boot ke GRUB → Linux.

---

## Periksa BIOS/UEFI

- Masuk BIOS saat boot (tombol tergantung vendor: DEL/F2/F12/ESC).
- Periksa apakah SSD muncul di daftar storage.
- Pastikan boot order menunjuk ke **UEFI: <nama SSD / Ubuntu>** atau `Ubuntu Boot Manager` sebagai prioritas pertama.
- Jika secure boot aktif dan Anda memakai kernel/GRUB non-signed custom, coba matikan secure boot sementara.

Catatan: Pilihan "Boot to SATA device" sering memicu pesan `Insert boot media` bila firmware menganggap mode legacy tidak ada bootloader.

---

## Verifikasi akhir & pemeriksaan kesehatan SSD (opsional)

Install `smartmontools` di host perbaikan jika belum ada:

```bash
sudo apt update
sudo apt install smartmontools
sudo smartctl -a /dev/sdb
```

Perhatikan atribut seperti `Reallocated_Sector_Ct`, `Current_Pending_Sector`, dan `SMART overall-health self-assessment test result`.

---

## Post-mortem dan mitigasi

- Kemungkinan penyebab awal: kehilangan daya saat menulis, kabel SATA/Power longgar, atau masalah SMART.
- Tindakan pencegahan:
  - Backup rutin (rsync, snapshot, atau imaging) terutama sebelum perubahan hardware.
  - Jalankan `smartctl` berkala untuk mendeteksi tanda-tanda kegagalan.
  - Jangan cabut/memasang SSD saat sistem menulis data sensitif.
  - Pastikan BIOS boot order dikembalikan ke `UEFI` setelah mengganti hardware.

---
