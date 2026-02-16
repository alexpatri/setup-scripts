#!/usr/bin/env bash
set -euo pipefail

FONT_NAME="Iosevka"
NERD_RELEASE_URL="https://github.com/ryanoasis/nerd-fonts/releases/latest/download/${FONT_NAME}.zip"
TMP_DIR="$(mktemp -d)"
USER_FONT_DIR="${HOME}/.local/share/fonts/nerd-fonts/${FONT_NAME}"

cleanup() {
  rm -rf "${TMP_DIR}"
}
trap cleanup EXIT

echo ">> Criando diretório de fontes: ${USER_FONT_DIR}"
mkdir -p "${USER_FONT_DIR}"

echo ">> Baixando ${FONT_NAME} Nerd Font..."
wget -q --show-progress -O "${TMP_DIR}/${FONT_NAME}.zip" "${NERD_RELEASE_URL}"

echo ">> Extraindo arquivos .ttf..."
unzip -oq "${TMP_DIR}/${FONT_NAME}.zip" "*.ttf" -d "${USER_FONT_DIR}"

echo ">> Atualizando cache de fontes..."
fc-cache -f "${HOME}/.local/share/fonts"

echo ">> Verificando instalação..."
if fc-list | grep -qi "IosevkaNerdFont"; then
    echo "Iosevka Nerd Font instalada com sucesso."
else
    echo "Fonte não encontrada no cache. Verifique manualmente com: fc-list | grep -i iosevka"
fi

echo ">> Concluído."
