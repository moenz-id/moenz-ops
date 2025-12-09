# 🟦 1. Mengaktifkan Kembali Login Session (Display Manager)

Di Armbian Desktop (XFCE), login session biasanya ditangani oleh LightDM. Jika sekarang boot langsung ke desktop tanpa login, berarti fitur auto-login aktif.

## ➤ Cara mematikan Auto Login (mengaktifkan login screen):

1. Edit file LightDM config:

    ```bash
    sudo nano /etc/lightdm/lightdm.conf
    ```


2. Cari baris seperti:

    `
    autologin-user=<username-pc>
    autologin-user-timeout=0
    `


3. Tambahkan tanda # untuk menonaktifkannya:

    ```bash
    #autologin-user=<username-pc>
    #autologin-user-timeout=0
    ```


4. Simpan (Ctrl+O, Enter) lalu keluar (Ctrl+X).

5. Restart:

    ```bash
    sudo systemctl restart lightdm
    ```


    atau reboot:

    ```bash
    sudo reboot
    ```

Setelah itu, Armbian akan menampilkan login screen dulu sebelum masuk desktop.
-

S
