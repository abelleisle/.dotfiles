#!/bin/sh
# Bootstraps my dotfiles from scratch

set -e

DOTFILES_DIR=$(CDPATH= cd -- "$(dirname -- "$0")" && pwd)
DOTFILES_USER=$(whoami)

# TERMTYPE=${TERM:-"xterm"}
TERMTYPE="xterm"

TEXT_BOLD=$(tput -T ${TERMTYPE} bold)
TEXT_NORM=$(tput -T ${TERMTYPE} sgr0)
TEXT_RED=$(tput -T ${TERMTYPE} setf 4)
TEXT_WARN=$(tput -T ${TERMTYPE} setf 6)
TEXT_INFO=$(tput -T ${TERMTYPE} setf 1)
TEXT_HEAD=$(tput -T ${TERMTYPE} setf 3)

exists()
{
    command -v "$1" >/dev/null 2>&1
}

header()
{
    echo "${TEXT_BOLD}${TEXT_HEAD}#############################${TEXT_NORM}"
    echo "${TEXT_HEAD}$@${TEXT_NORM}"
}

info()
{
    echo "${TEXT_INFO}$@${TEXT_NORM}"
}

warn()
{
    echo "${TEXT_WARN}$@${TEXT_NORM}"
}

error()
{
    echo "${TEXT_RED}$@${TEXT_NORM}" 1>&2
    exit 1
}

run()
{
    eval "$@" | sed 's/^/  /';
}

header "Bootstapping dotfiles!!"
info "User: ${DOTFILES_USER}"

#########################
#  AUTHENTICATE SCRIPT  #
#########################
if exists sudo; then
    info "Some commands in this script require root permissions."
    info "    Authenticating this script with sudo. You may have"
    info "    to enter your password here:"
    # sudo -v
else
    error "Sudo isn't found. Please install sudo for certain commands."
fi

################
#  SUBMODULES  #
################
header "Pulling git submodules"
cd ${DOTFILES_DIR}
run git submodule update --init

######################
#  INSTALL PACKAGES  #
######################

header "Installing base packages"
case `uname` in
    # MacOS
    Darwin)
        info "Using MacOS.. Installing the following programs with homebrew:";
        if exists brew; then
            # We check MacOS first because for some reason it defines 'apt'. Dumb. I know.
            run brew upgrade;
            # MacOS doesn't need zsh, bc, or unzip because they are installed by default
            run brew install stow neovim ripgrep fzf curl tmux make cmake gcc g++;
        else
            error "Homebrew not installed! Please install it."
        fi;;
    # Linux
    Linux)
        info "Using Linux! :)"
        # apt
        if exists apt; then
            info "Using apt.. Installing the following programs:"
            run sudo apt update;
            run sudo apt install -y stow zsh ripgrep fzf curl bc tmux make cmake gcc g++ unzip;
            header "Installing neovim"
            case `uname -m` in
                # ARM CPU
                aarch64)
                    warn "Using an ARM CPU. ARM CPUs requires the package manager version of neovim.";
                    warn "Neovim may be out of date";
                    run sudo apt install neovim -y;
                    warn "Neovim version:";
                    run nvim --version;;
                # x86
                x86_64)
                    warn "Apt usually has an outdated neovim. Installing directly from github.";
                    run sudo apt install fuse -y
                    mkdir -p ${HOME}/bin
                    run curl -Lo ${HOME}/bin/nvim https://github.com/neovim/neovim/releases/download/stable/nvim.appimage
                    chmod u+x ${HOME}/bin/nvim
                    PATH=${HOME}/bin:${PATH};;
                *) error "Unsupported arch: $(uname -m)"
            esac
        # Not apt
        else
            error "Unsupported Linux Distribution"
        fi;;
    *) error "Unknown OS: $(uname)" ;;
esac

###########################
#  CONFIGURE DIRECTORIES  #
###########################
header "Creating ~/.config/ directory"
if [ -n "${XDG_CONFIG_HOME+set}" ]; then
    mkdir -p $XDG_CONFIG_HOME;
elif [ -n "${HOME+set}" ]; then
    mkdir -p ${HOME}/.config/
else
    error "Neither XDG_CONFIG_HOME or HOME are defined.."
fi

STOW_CMD="stow -t ${HOME} -d ${DOTFILES_DIR}/dots"

######################
#  CONFIGURE NEOVIM  #
######################
header "Installing neovim configs"
run ${STOW_CMD} nvim
info "Syncing neovim plugins (this may take a while)"
NVIM_VERSION=$(nvim --version | head -n1 | sed -e 's|^[^0-9]*||' -e 's| .*||')
NVIM_REQUIRE="0.8.0"
if [ "$(printf '%s\n' "$NVIM_REQUIRE" "$NVIM_VERSION" | sort -V | head -n1)" = "$NVIM_REQUIRE" ]; then
    info "Installed Neovim version: v$NVIM_VERSION"
    run nvim --headless "+Lazy! install" +qa
else
    warn "Neovim is not at least v$NVIM_REQUIRE, plugins won't install"
fi

###################
#  CONFIGURE ZSH  #
###################
header "Installing zsh configs"
if [ -f ${HOME}/.profile ]; then
    warn "~/.profile already exists. Renaming to .profile.old"
    mv ${HOME}/.profile ${HOME}/.profile.old
fi
run ${STOW_CMD} zsh

header "Setting zsh as default shell"
run sudo chsh -s $(which zsh) ${DOTFILES_USER}

header "Sourcing .zshrc to install deps"
zsh -c "source ~/.zshrc"

####################
#  CONFIGURE TMUX  #
####################
header "Installing tmux configs"
run ${STOW_CMD} tmux
run ~/.tmux/plugins/tpm/bin/install_plugins
