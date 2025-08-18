#!/usr/bin/env bash
set -euo pipefail

# Detect arch for the right AppImage name
arch="$(uname -m)"
case "$arch" in
  x86_64)   APPIMG="nvim-linux-x86_64.appimage" ;;
  aarch64)  APPIMG="nvim-linux-arm64.appimage" ;;
  arm64)    APPIMG="nvim-linux-arm64.appimage" ;;
  *) echo "Unsupported arch: $arch"; exit 1 ;;
esac

# Source of truth (Neovim releases)
BASE="https://github.com/neovim/neovim/releases/latest/download"
NVIM_URL="$BASE/$APPIMG"

# Install targets (works whether the setup runs as root or not)
if [ "$(id -u)" -eq 0 ]; then
  INSTALL_DIR="/opt/nvim"
  BIN_DIR="/usr/local/bin"
else
  INSTALL_DIR="$HOME/.local/opt/nvim"
  BIN_DIR="$HOME/.local/bin"
fi

# Minimal deps (Ubuntu image)
if command -v apt-get >/dev/null 2>&1; then
  apt-get update -y
  apt-get install -y curl ca-certificates
fi

tmpdir="$(mktemp -d)"
trap 'rm -rf "$tmpdir"' EXIT
cd "$tmpdir"

# Download (fail on 4xx/5xx; follow redirects)
curl -fL --retry 3 -o nvim.appimage "$NVIM_URL"
chmod +x nvim.appimage

# Extract to avoid FUSE requirement
./nvim.appimage --appimage-extract >/dev/null

# Install atomically
mkdir -p "$INSTALL_DIR" "$BIN_DIR"
rm -rf "${INSTALL_DIR}.new"
cp -a squashfs-root "${INSTALL_DIR}.new"
rm -rf "$INSTALL_DIR"
mv "${INSTALL_DIR}.new" "$INSTALL_DIR"

# Link entry point
ln -sfn "$INSTALL_DIR/usr/bin/nvim" "$BIN_DIR/nvim"

# Ensure PATH for user installs
if [ "$(id -u)" -ne 0 ]; then
  case ":$PATH:" in *":$BIN_DIR:"*) : ;; *)
    mkdir -p "$HOME/.profile.d"
    echo "export PATH=\"$BIN_DIR:\$PATH\"" > "$HOME/.profile.d/nvim-path.sh"
    export PATH="$BIN_DIR:$PATH"
  esac
fi

# Smoke test
"$BIN_DIR/nvim" --version | head -n1
