#!/usr/bin/env bash

sudo apt update
sudo apt install zsh bspwm sxhkd polybar dunst alacritty feh xorg picom pipx

sudo apt install --reinstall polkitd

pipx install pywal

mkdir $HOME/.config

cp -r ./config/bspwm/ $HOME/.config/
cp -r ./config/alacritty/ $HOME/.config/
cp -r ./config/picom/ $HOME/.config/
# cp /usr/share/doc/bspwm/examples/sxhkdrc $HOME/.config/sxhkd/
# cp /etc/polybar/config.ini $HOME/.config/polybar
# cp /etc/xdg/dunst/dunstrc $HOME/.config/dunst/

mkdir $HOME/Images

cp ./wallpaper.png $HOME/Images/

wal -i $HOME/Images/wallpaper.png
