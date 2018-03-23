#!/bin/bash

#
# Makes symlinks for all configs
#

ln -b -s $PWD/polybar/config ~/.config/polybar/config
ln -b -s $PWD/zsh/oh-my-zsh ~/.oh-my-zsh
ln -b -s $PWD/zsh/zshrc ~/.zshrc

cp -vf wallpapers/* ~/Pictures/Wallpapers/

echo "Done."
