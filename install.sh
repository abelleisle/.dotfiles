#!/bin/bash

#
# Makes symlinks for all configs
#

ln -s $PWD/polybar/config ~/.config/polybar/config

ln -s $PWD/rofi/config ~/.config/rofi/config

ln -s $PWD/openbox ~/.config/openbox

ln -s $PWD/dunst/dunstrc ~/.config/dunst/dunstrc

ln -s $PWD/zsh/oh-my-zsh ~/.oh-my-zsh
ln -s $PWD/zsh/zshrc ~/.zshrc
ln -s $PWD/zsh/zlogin ~/.zlogin

ln -s $PWD/nvim ~/.config/nvim

ln -s $PWD/xset/xprofile ~/.xprofile

ln -s $PWD/alsa/asoundrc ~/.asoundrc

ln -s $PWD/xset/Xresources ~/.Xresources

ln -s $PWD/xres ~/.xres

ln -s $PWD/themes ~/.themes

ln -s $PWD/scripts ~/.scripts

cp -vf wallpapers/* ~/Pictures/Wallpapers/

echo "Done."
