# Migrate Docker Root to SD Card

Panduan memindahkan Docker Root Directory dari eMMC ke SD Card.

## Kapan Perlu Migrasi?

Contoh gejala:

```bash
df -h /
```

Jika eMMC mulai penuh dan image Docker bertambah besar.

## Langkah Umum

1. Stop container
2. Stop Docker dan containerd
3. Buat direktori baru:

```bash
mkdir -p /data/docker-data
```

4. Salin data:

```bash
sudo rsync -aHAXx /var/lib/docker/ /data/docker-data/
```

5. Buat:

```bash
/etc/docker/daemon.json
```

Isi:

```json
{
  "data-root": "/data/docker-data"
}
```

6. Start kembali Docker

## Verifikasi

```bash
docker info | grep "Docker Root Dir"
```

Output yang diharapkan:

```text
Docker Root Dir: /data/docker-data
```

## Layout Akhir

```text
eMMC
├── Armbian
├── Docker Engine
└── System Files

SD Card
├── docker-data
├── appdata
├── backups
└── stacks
```
