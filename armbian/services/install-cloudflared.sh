#!/usr/bin/env bash
#
# Install Cloudflare Tunnel (cloudflared) from the official Cloudflare APT repository.
# Supports Debian-based distributions, including Armbian.
#
# Usage:
#   sudo bash install-cloudflared.sh
#
set -Eeuo pipefail

readonly GPG_URL="https://pkg.cloudflare.com/cloudflare-main.gpg"
readonly REPO_URL="https://pkg.cloudflare.com/cloudflared"
readonly KEYRING_DIR="/usr/share/keyrings"
readonly KEYRING_FILE="${KEYRING_DIR}/cloudflare-main.gpg"
readonly REPO_FILE="/etc/apt/sources.list.d/cloudflared.list"

log() {
    printf '\n[INFO] %s\n' "$*"
}

die() {
    printf '\n[ERROR] %s\n' "$*" >&2
    exit 1
}

trap 'die "Installation failed at line ${LINENO}."' ERR

if [[ "$EUID" -ne 0 ]]; then
    die "Run this script using sudo: sudo bash $0"
fi

if [[ ! -r /etc/os-release ]]; then
    die "Cannot detect operating system: /etc/os-release is missing."
fi

# shellcheck disable=SC1091
source /etc/os-release

case " ${ID:-} ${ID_LIKE:-} " in
    *"debian"*|*"ubuntu"*) ;;
    *) die "This script requires Debian, Ubuntu, or a Debian-based distribution." ;;
esac

log "Detected OS: ${PRETTY_NAME:-Unknown}"
log "Architecture: $(dpkg --print-architecture)"

log "Installing required dependencies..."
apt-get update
apt-get install -y ca-certificates curl

log "Adding Cloudflare APT signing key..."
install -d -m 0755 "$KEYRING_DIR"
curl -fsSL "$GPG_URL" -o "$KEYRING_FILE"
chmod 0644 "$KEYRING_FILE"

log "Adding official Cloudflare APT repository..."
cat > "$REPO_FILE" <<EOF
deb [signed-by=${KEYRING_FILE}] ${REPO_URL} any main
EOF

log "Updating package index..."
apt-get update

log "Installing cloudflared..."
apt-get install -y cloudflared

if ! command -v cloudflared >/dev/null 2>&1; then
    die "cloudflared binary was not found after installation."
fi

log "Verifying installation..."
cloudflared --version

cat <<'EOF'

================================================
 cloudflared installation completed
================================================

Next steps:

1. Create or select a Tunnel in the Cloudflare Zero Trust dashboard.
2. Install the tunnel service using the token shown by Cloudflare:

   sudo cloudflared service install '<TUNNEL_TOKEN>'

3. Check service status:

   sudo systemctl status cloudflared

4. Follow service logs:

   sudo journalctl -u cloudflared -f

Keep your tunnel token secret. Do not commit it to a repository.
EOF
