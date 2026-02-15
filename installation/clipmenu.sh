#!/usr/bin/env bash
set -euo pipefail

REPO_URL="https://github.com/cdown/clipmenu.git"
BUILD_DIR="/tmp/clipmenu-build"
INSTALL_PREFIX="/usr/local"

echo "==> Atualizando lista de pacotes..."
sudo apt update

echo "==> Instalando dependências..."
sudo apt install -y \
    build-essential \
    libx11-dev \
    libxfixes-dev \
    xclip \
    libnotify-bin

echo "==> Clonando repositório..."
rm -rf "$BUILD_DIR"
git clone "$REPO_URL" "$BUILD_DIR"

cd "$BUILD_DIR"

echo "==> Compilando..."
make

echo "==> Instalando em $INSTALL_PREFIX ..."
sudo make PREFIX="$INSTALL_PREFIX" install

echo "==> Limpeza..."
cd /
rm -rf "$BUILD_DIR"

echo "==> Instalação concluída."

