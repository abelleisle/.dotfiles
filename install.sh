#!/bin/bash

#
# Makes symlinks for all configs
#

ln -s $PWD/polybar/config ~/.config/polybar/config

ln -s $PWD/rofi/config ~/.config/rofi/config

ln -s $PWD/openbox ~/.config/openbox

ln -s $PWD/zsh/oh-my-zsh ~/.oh-my-zsh
ln -s $PWD/zsh/zshrc ~/.zshrc

ln -s $PWD/xset/xprofile ~/.xprofile

ln -s $PWD/xres ~/.xres
ln -s $PWD/xres/Xresources ~/.Xresources

cp -vf wallpapers/* ~/Pictures/Wallpapers/

echo "Done."
