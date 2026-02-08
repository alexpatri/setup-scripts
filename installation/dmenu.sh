#!/usr/bin/env bash
set -euo pipefail

# -------------------------------------------------------
# Script para baixar e compilar dmenu 5.2 com os patches:
# - dmenu-alpha
# - dmenu-xyw
# -------------------------------------------------------

# Versão alvo
DMENU_VERSION="5.2"
BASE_URL="https://tools.suckless.org/dmenu/patches"

# URLs dos patches
PATCH_ALPHA="$BASE_URL/alpha/dmenu-alpha-20230110-${DMENU_VERSION}.diff"
PATCH_XYW="$BASE_URL/xyw/dmenu-xyw-${DMENU_VERSION}.diff"

# Diretório de trabalho temporário
WORKDIR="$(mktemp -d)"
echo "Usando diretório temporário: $WORKDIR"
cd "$WORKDIR"

# 1) Instalar dependências caso não estejam
echo "Instalando dependências..."
sudo apt update
sudo apt install -y build-essential libx11-dev libxft-dev libxinerama-dev

# 2) Baixar o dmenu
echo "Baixando dmenu $DMENU_VERSION..."
wget "https://dl.suckless.org/tools/dmenu-${DMENU_VERSION}.tar.gz"
tar xf "dmenu-${DMENU_VERSION}.tar.gz"
cd "dmenu-${DMENU_VERSION}"

# 3) Baixar patches
echo "Baixando patches..."
wget "$PATCH_ALPHA"
wget "$PATCH_XYW"

# 4) Aplicar patches
patch -p1 < "dmenu-alpha-20230110-${DMENU_VERSION}.diff"
patch -p1 < "dmenu-xyw-${DMENU_VERSION}.diff"

# 5) Copiar config padrão para config.h
cp config.def.h config.h

# Alpha configurável
DMENU_ALPHA="0xbb"

echo "Configurando alpha = $DMENU_ALPHA"
sed -i "s/static const unsigned int alpha = 0x[0-9a-fA-F]\+/static const unsigned int alpha = $DMENU_ALPHA/" config.h

# 6) Compilar
echo "Compilando..."
make clean
make

# 7) Instalar
echo "Instalando (pode pedir sudo)..."
sudo make install

echo "Instalação concluída!"
echo "Excluindo diretório temporário..."
rm -rf "$WORKDIR"

