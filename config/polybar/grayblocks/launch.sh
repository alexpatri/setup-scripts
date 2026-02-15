#!/usr/bin/env bash

# Add this script to your wm startup file.

DIR="$HOME/.config/polybar/grayblocks"

DOCK_WIDTH=360

# monitor primário (pega a largura)
SCREEN_W=$(xrandr | awk '/ primary/{print $4}' | cut -d'x' -f1 | cut -d'+' -f1)

# fallback se não achar "primary"
if [ -z "$SCREEN_W" ]; then
  SCREEN_W=$(xrandr | awk '/\*/{print $1; exit}' | cut -d'x' -f1)
fi

DOCK_X=$(( (SCREEN_W - DOCK_WIDTH) / 2 ))
export DOCK_X
export DOCK_WIDTH

# Terminate already running bar instances
killall -q polybar

# Wait until the processes have been shut down
while pgrep -u $UID -x polybar >/dev/null; do sleep 1; done

# Launch the bar
polybar -q main -c "$DIR"/config.ini &
polybar -q dock -c "$DIR"/dock.ini &
echo $! > /tmp/polybar_dock.pid
