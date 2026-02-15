#!/bin/sh

PID_FILE=/tmp/polybar_dock.pid
LOCK=/tmp/polybar_dock_peek.lock
TIME=3

[ -r "$PID_FILE" ] || exit 0
PID=$(cat "$PID_FILE")

# se já existe lock, não faz nada
[ -f "$LOCK" ] && exit 0

# cria lock (marca que é um show temporário)
touch "$LOCK"

# mostra a dock
polybar-msg -p "$PID" cmd show >/dev/null 2>&1

# espera e esconde novamente
(
  sleep "$TIME"
  polybar-msg -p "$PID" cmd hide >/dev/null 2>&1
  rm -f "$LOCK"
) &

