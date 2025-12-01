# Menghilangkan Menu Boot Windows Setelah Migrasi ke Ubuntu


Setelah berpindah penuh ke Ubuntu, terkadang sistem masih menampilkan pilihan boot menuju ***Windows***, meskipun Windows sebenarnya sudah tidak digunakan lagi. Hal ini disebabkan karena entri Windows Boot Manager masih tersimpan di firmware UEFI, sehingga GRUB menampilkan opsi tersebut saat boot.

Dokumentasi ini menjelaskan langkah-langkah untuk membuat PC langsung boot ke Ubuntu tanpa menampilkan pilihan boot Windows.

## 1. Mengatur Prioritas Boot di BIOS/UEFI

Langkah pertama adalah memastikan bahwa firmware PC benar-benar memilih Ubuntu sebagai bootloader utama:

* Masuk ke BIOS/UEFI saat komputer dinyalakan (`Del, F2, F12`, atau sesuai motherboard).

* Buka menu ***Boot***, ***Boot Options***, atau ***Boot Priority***.

* Pastikan **Ubuntu** atau **GRUB** berada pada urutan pertama.

* Simpan dan keluar.

Langkah ini memastikan bahwa sistem menggunakan GRUB milik Ubuntu saat boot.

## 2. Menghapus Entri Windows Boot Manager (Opsional)

Jika Windows memang sudah tidak digunakan dan ingin menghapus jejaknya dari firmware UEFI, gunakan `efibootmgr`.

### Instal dan cek entri UEFI:

```bash
sudo apt install efibootmgr
sudo efibootmgr
```


Contoh output:

```bash
BootCurrent: 0001
BootOrder: 0001,0002,0003
Boot0001* ubuntu
Boot0002* Windows Boot Manager
Boot0003* UEFI: USB

```
### Menghapus entri Windows:

```bash
sudo efibootmgr -b 0002 -B
```


(Ubah `0002` sesuai nomor Windows Boot Manager yang muncul di sistem Anda.)

Menjadikan Ubuntu sebagai default (jika diperlukan):
```bash
sudo efibootmgr -o 0001
```

## 3. Menonaktifkan Deteksi Sistem Lain di GRUB

GRUB secara otomatis mendeteksi OS lain menggunakan `os-prober`. Jika Windows sudah dihapus, kita bisa menonaktifkan deteksi ini agar GRUB tidak menampilkan entri Windows lagi.

### Edit konfigurasi GRUB:

```bash
sudo nano /etc/default/grub
```


Tambahkan atau pastikan baris berikut ada:


```bash
GRUB_DISABLE_OS_PROBER=true
GRUB_TIMEOUT_STYLE=hidden
GRUB_TIMEOUT=0
```

### Update GRUB:


```bash
sudo update-grub
```


Setelah ini, GRUB tidak akan menampilkan menu OS lain dan akan langsung boot ke Ubuntu.
-

### Hasil Akhir

Dengan mengikuti langkah-langkah di atas:

* Windows tidak lagi muncul di menu boot.

* GRUB tidak menampilkan pilihan OS.

* Sistem langsung boot ke Ubuntu.

* Entri Windows Boot Manager di UEFI (opsional) akan hilang sepenuhnya.

Dokumentasi ini dapat digunakan sebagai referensi jika di masa mendatang diperlukan pengaturan ulang bootloader atau ketika membersihkan sisa-sisa sistem lama.