#!/usr/bin/env bash

sudo apt update
sudo apt install bspwm sxhkd polybar dunst alacritty feh xorg

mkdir -p $HOME/.config/{bspwm,dunst,polybar,sxhkd}

cp ./config/bspwm/bspwmrc $HOME/.config/bspwm/
cp /usr/share/doc/bspwm/examples/sxhkdrc $HOME/.config/sxhkd/
cp /etc/polybar/config.ini $HOME/.config/polybar
cp /etc/xdg/dunst/dunstrc $HOME/.config/dunst/

mkdir $HOME/Images

cp ./wallpaper.png $HOME/Images/
