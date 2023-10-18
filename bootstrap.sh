#!/bin/sh
# Bootstraps my dotfiles from scratch

set -u

DOTFILES_DIR=$(CDPATH= cd -- "$(dirname -- "$0")" && pwd)
DOTFILES_USER=$(whoami)

echo "Bootstapping dotfiles!!"

#########################
#  AUTHENTICATE SCRIPT  #
#########################
if command -v sudo ; then
    echo "Some commands in this script require root permissions."
    echo "    Authenticating this script with sudo. You may have"
    echo "    to enter your password here:"
    sudo -v
else
    echo "Sudo isn't found. Please install sudo for certain commands."
fi

######################
#  INSTALL PACKAGES  #
######################

echo "Installing base packages"
if command -v brew &> /dev/null ; then
    # We check MacOS first because for some reason it defines 'apt'. Dumb. I know.
    echo "Using MacOS.. Installing the following programs with homebrew:"
    brew upgrade;
    brew install stow neovim zsh ripgrep fzf bc;
elif command -v apt &> /dev/null ; then
    echo "Using apt.. Installing the following programs:"
    sudo apt update;
    sudo apt install -y stow neovim zsh ripgrep fzf bc;
fi

###########################
#  CONFIGURE DIRECTORIES  #
###########################
echo "Creating ~/.config/ directory"
if [ -n "${XDG_CONFIG_HOME}" ]; then
    mkdir -p $XDG_CONFIG_HOME;
elif [ -n "${HOME}" ]; then
    mkdir -p ${HOME}/.config/
else
    echo "Neither XDG_CONFIG_HOME or HOME are defined.."
    exit 1
fi

STOW_CMD="stow -t ${HOME} -d ${DOTFILES_DIR}"

######################
#  CONFIGURE NEOVIM  #
######################
echo "Installing neovim configs"
eval ${STOW_CMD} nvim

###################
#  CONFIGURE ZSH  #
###################
echo "Installing zsh configs"
eval ${STOW_CMD} zsh
echo "Setting zsh as default shell"
sudo chsh -s $(which zsh) ${DOTFILES_USER}
