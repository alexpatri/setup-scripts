#!/usr/bin/env bash

TEMPLATE="$HOME/.config/dunst/dunstrc.template"
OUT="$HOME/.config/dunst/dunstrc"
WAL="$HOME/.cache/wal/colors.sh"

if [ ! -f "$TEMPLATE" ]; then
  echo "Template não encontrado: $TEMPLATE" >&2
  exit 1
fi

if [ ! -f "$WAL" ]; then
  echo "Arquivo do wal não encontrado: $WAL" >&2
  echo "Rode 'wal -i <imagem>' pelo menos uma vez." >&2
  exit 1
fi

# shellcheck disable=SC1090
. "$WAL"

# Paleta do wal (normalmente disponível em colors.sh)
# background / foreground já existem no seu setup
WAL_BG="${background}"
WAL_FG="${foreground}"

# Escolhas sensatas de acento/dim/crit a partir das cores do wal
WAL_ACCENT="${color4:-$color1}"
WAL_DIM="${color8:-$color0}"

WAL_BG_DARK="${color0:-$background}"
WAL_OK="${color2:-$foreground}"
WAL_CRIT="${color1:-$foreground}"
WAL_CRIT_FG="${foreground}"

# Gera o dunstrc substituindo placeholders
sed \
  -e "s/{WAL_BG}/$WAL_BG/g" \
  -e "s/{WAL_FG}/$WAL_FG/g" \
  -e "s/{WAL_ACCENT}/$WAL_ACCENT/g" \
  -e "s/{WAL_DIM}/$WAL_DIM/g" \
  -e "s/{WAL_BG_DARK}/$WAL_BG_DARK/g" \
  -e "s/{WAL_OK}/$WAL_OK/g" \
  -e "s/{WAL_CRIT}/$WAL_CRIT/g" \
  -e "s/{WAL_CRIT_FG}/$WAL_CRIT_FG/g" \
  "$TEMPLATE" > "$OUT"

# Recarrega o dunst
killall dunst 2>/dev/null || true
dunst &

# Teste opcional (comenta se não quiser)
notify-send "Tema aplicado via wal"
