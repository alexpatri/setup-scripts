#!/usr/bin/env bash

sudo apt update
sudo apt install unzip zsh bspwm sxhkd lightdm polybar dunst alacritty feh xorg picom pipx xclip

sudo apt install --reinstall polkitd

pipx install pywal

mkdir $HOME/.config

cp -r ./config/bspwm/ $HOME/.config/
cp -r ./config/alacritty/ $HOME/.config/
cp -r ./config/picom/ $HOME/.config/
cp -r ./config/dunst/ $HOME/.config/
cp -r ./config/sxhkdrc/ $HOME/.config/
cp -r ./config/polybar/ $HOME/.config/

mkdir $HOME/Images

cp ./wallpaper.png $HOME/Images/

wal -i $HOME/Images/wallpaper.png
