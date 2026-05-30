# Security Notes

Repository ini bersifat public, jadi jangan commit file yang berisi secret atau data sensitif.

Jangan commit:

- `.env`
- token Cloudflare Tunnel
- private key SSH atau TLS
- password MQTT
- backup konfigurasi yang masih berisi credential
- file `client_secret*.json`

Gunakan file contoh seperti `.env.example` atau `*.conf.example` untuk dokumentasi konfigurasi.
