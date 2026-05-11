# Enable Login Screen In LightDM

## Tags

linux, armbian, xfce, lightdm, login

---

# Summary

Dokumentasi ini menjelaskan cara mengaktifkan kembali login screen pada Armbian Desktop XFCE yang menggunakan LightDM.

Kasus umum:

- Sistem langsung masuk desktop
- Auto login aktif
- Tidak muncul login session

---

# Environment

- Armbian Desktop
- XFCE
- LightDM

---

# Table of Contents

- Edit LightDM config
- Disable auto login
- Restart LightDM
- Verification

---

# Edit LightDM Configuration

```bash
sudo nano /etc/lightdm/lightdm.conf
```

---

# Disable Auto Login

Cari baris:

```text
autologin-user=<username>
autologin-user-timeout=0
```

Ubah menjadi:

```text
#autologin-user=<username>
#autologin-user-timeout=0
```

---

# Restart LightDM

```bash
sudo systemctl restart lightdm
```

atau reboot:

```bash
sudo reboot
```

---

# Verification

Setelah restart:

- Login screen muncul
- Sistem tidak auto login
- User harus memasukkan password sebelum masuk desktop
