#!/bin/sh

BAR_W=520
BAR_H=60
OFF_Y=16

ts() { date '+%F %T'; }

dock_msg() {
  [ -r /tmp/polybar_dock.pid ] || return 1
  polybar-msg -p "$(cat /tmp/polybar_dock.pid)" "$@" >/dev/null 2>&1
}


# resolução
SCREEN_W=$(xrandr | awk '/ primary/{print $4}' | cut -d'x' -f1 | cut -d'+' -f1)
SCREEN_H=$(xrandr | awk '/ primary/{print $4}' | cut -d'x' -f2 | cut -d'+' -f1)
if [ -z "$SCREEN_W" ] || [ -z "$SCREEN_H" ]; then
  geom=$(xrandr | awk '/\*/{print $1; exit}')
  SCREEN_W=$(echo "$geom" | cut -d'x' -f1)
  SCREEN_H=$(echo "$geom" | cut -d'x' -f2)
fi

DOCK_X=$(( (SCREEN_W - BAR_W) / 2 ))
DOCK_Y=$(( SCREEN_H - OFF_Y - BAR_H ))
DOCK_R=$(( DOCK_X + BAR_W ))
DOCK_B=$(( DOCK_Y + BAR_H ))


intersects() {
  wx=$1 wy=$2 ww=$3 wh=$4
  wr=$((wx + ww))
  wb=$((wy + wh))

  [ "$wr" -le "$DOCK_X" ] && return 1
  [ "$wx" -ge "$DOCK_R" ] && return 1
  [ "$wb" -le "$DOCK_Y" ] && return 1
  [ "$wy" -ge "$DOCK_B" ] && return 1
  return 0
}

focused_geom_x11() {
  wid=$(bspc query -N -n focused 2>/dev/null)
  [ -n "$wid" ] || return 1
  xwininfo -id "$wid" 2>/dev/null | awk '
    /Absolute upper-left X:/ {x=$4}
    /Absolute upper-left Y:/ {y=$4}
    /Width:/ {w=$2}
    /Height:/ {h=$2}
    END { if (x==""||y==""||w==""||h=="") exit 1; print x, y, w, h }
  ' || return 1
}

# evita repetir show/hide o tempo todo
LAST=""
set_state() {
  state="$1" # show|hide
  [ "$state" = "$LAST" ]
  LAST="$state"
  if [ "$state" = "hide" ]; then
    dock_msg cmd hide
  else
    dock_msg cmd show
  fi
}

check_once() {
  # janela focada existe?
  wid=$(bspc query -N -n focused 2>/dev/null)
  if [ -z "$wid" ]; then
    set_state show
    return
  fi

  # fullscreen?
  if bspc query -T -n focused 2>/dev/null | grep -q '"fullscreen":true'; then
    set_state hide
    return
  fi

  geom=$(focused_geom_x11)
  if [ -z "$geom" ]; then
    set_state show
    return
  fi

  set -- $geom
  wx=$1 wy=$2 ww=$3 wh=$4

  if intersects "$wx" "$wy" "$ww" "$wh"; then
    set_state hide
  else
    set_state show
  fi
}

check_once

bspc subscribe node_focus node_geometry node_state node_add node_remove desktop_focus monitor_focus | \
while read -r ev; do
  check_once
done

