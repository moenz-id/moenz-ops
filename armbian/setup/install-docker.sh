#!/usr/bin/env bash
#
# Install Docker Engine on Debian / Armbian
# Uses Docker's official Debian APT repository:
# https://docs.docker.com/engine/install/debian/
#
# Supported architectures: amd64, arm64, armhf, ppc64el
# Supported Debian releases: bookworm, trixie
#
set -Eeuo pipefail

readonly DOCKER_REPO="https://download.docker.com/linux/debian"
readonly DOCKER_GPG_URL="${DOCKER_REPO}/gpg"
readonly KEYRING_DIR="/etc/apt/keyrings"
readonly KEYRING_FILE="${KEYRING_DIR}/docker.asc"
readonly SOURCE_FILE="/etc/apt/sources.list.d/docker.sources"

log() {
    printf '\n[INFO] %s\n' "$*"
}

die() {
    printf '\n[ERROR] %s\n' "$*" >&2
    exit 1
}

trap 'die "Command failed at line ${LINENO}."' ERR

if [[ "${EUID}" -ne 0 ]]; then
    die "Run this script with sudo: sudo $0"
fi

if [[ ! -r /etc/os-release ]]; then
    die "Cannot read /etc/os-release."
fi

# shellcheck disable=SC1091
source /etc/os-release

# Armbian identifies itself as ID=armbian and ID_LIKE=debian.
if [[ "${ID:-}" != "debian" && " ${ID_LIKE:-} " != *" debian "* ]]; then
    die "This installer supports Debian and Debian-based Armbian only."
fi

CODENAME="${VERSION_CODENAME:-}"
[[ -n "$CODENAME" ]] || die "Cannot determine distribution codename."

case "$CODENAME" in
    bookworm|trixie)
        log "Detected Debian release: $CODENAME"
        ;;
    *)
        die "Unsupported Debian release: $CODENAME. Supported: bookworm, trixie."
        ;;
esac

ARCH="$(dpkg --print-architecture)"
case "$ARCH" in
    amd64|arm64|armhf|ppc64el)
        log "Detected architecture: $ARCH"
        ;;
    *)
        die "Unsupported architecture: $ARCH"
        ;;
esac

export DEBIAN_FRONTEND=noninteractive

log "Installing prerequisites..."
apt-get update
apt-get install -y ca-certificates curl

log "Preparing Docker APT keyring..."
install -m 0755 -d "$KEYRING_DIR"
curl -fsSL "$DOCKER_GPG_URL" -o "$KEYRING_FILE"
chmod a+r "$KEYRING_FILE"

log "Configuring official Docker APT repository..."
cat > "$SOURCE_FILE" <<EOF
Types: deb
URIs: $DOCKER_REPO
Suites: $CODENAME
Components: stable
Architectures: $ARCH
Signed-By: $KEYRING_FILE
EOF

log "Refreshing APT package index..."
apt-get update

# Docker's documentation recommends removing conflicting packages first.
# Do not remove /var/lib/docker or /var/lib/containerd; these contain data.
CONFLICTS=(
    docker.io
    docker-compose
    docker-doc
    podman-docker
    containerd
    runc
)

INSTALLED_CONFLICTS=()
for package in "${CONFLICTS[@]}"; do
    if dpkg-query -W -f='${db:Status-Abbrev}' "$package" 2>/dev/null | grep -q '^ii'; then
        INSTALLED_CONFLICTS+=("$package")
    fi
done

if (("${#INSTALLED_CONFLICTS[@]}" > 0)); then
    log "Removing conflicting packages: ${INSTALLED_CONFLICTS[*]}"
    apt-get remove -y "${INSTALLED_CONFLICTS[@]}"
fi

log "Installing Docker Engine and official plugins..."
apt-get install -y \
    docker-ce \
    docker-ce-cli \
    containerd.io \
    docker-buildx-plugin \
    docker-compose-plugin

log "Enabling and starting Docker..."
systemctl enable --now docker

systemctl is-active --quiet docker || die "Docker service is not active."

log "Verifying installation..."
docker --version
containerd --version
docker compose version
docker buildx version

log "Docker service status:"
systemctl --no-pager --full status docker | sed -n '1,12p'

cat <<'EOF'

================================================
 Docker Engine installation completed
================================================

Test the installation:
  sudo docker run hello-world

Optional: allow your regular user to run Docker
commands without sudo (equivalent to root access):
  sudo usermod -aG docker "$USER"
Then log out and log in again.

EOF
