# zmodload zsh/zprof

# Path to your oh-my-zsh installation.
export ZSH=$HOME/.zsh/oh-my-zsh

# ~/.zprofile will source ~/.profile, so we don't need to here
# if [ -f ~/.profile ]; then
#     source ~/.profile
# fi

# Source our custom functions
if [ -d ~/.zsh/extra/ ]; then
    for file in ~/.zsh/extra/**; do
        source $file;
    done
fi

# Set name of the ZSH theme to load
ZSH_THEME="passion"

# Disable OMZ update reminders
zstyle ':omz:update' mode disabled  # disable automatic updates

# Uncomment the following line to use case-sensitive completion.
# CASE_SENSITIVE="true"

# Uncomment the following line to use hyphen-insensitive completion.
# Case-sensitive completion must be off. _ and - will be interchangeable.
# HYPHEN_INSENSITIVE="true"

# Uncomment the following line if pasting URLs and other text is messed up.
# DISABLE_MAGIC_FUNCTIONS="true"

# Uncomment the following line to disable colors in ls.
# DISABLE_LS_COLORS="true"

# Uncomment the following line to disable auto-setting terminal title.
# DISABLE_AUTO_TITLE="true"

# Uncomment the following line to enable command auto-correction.
# ENABLE_CORRECTION="true"

# Uncomment the following line to display red dots whilst waiting for completion.
# You can also set it to another string to have that shown instead of the default red dots.
# e.g. COMPLETION_WAITING_DOTS="%F{yellow}waiting...%f"
# Caution: this setting can cause issues with multiline prompts in zsh < 5.7.1 (see #5765)
# COMPLETION_WAITING_DOTS="true"

# Uncomment the following line if you want to disable marking untracked files
# under VCS as dirty. This makes repository status check for large repositories
# much, much faster.
# DISABLE_UNTRACKED_FILES_DIRTY="true"

# ZSH History Settings
HIST_STAMPS="mm/dd/yyyy"
#HISTFILE=~/.cache/zsh/zsh_histfile
HISTSIZE=10000
SAVEHIST=10000

# Start completions
# autoload -Uz compinit
# compinit #-d ~/.cache/zsh/zcompdump-$ZSH_VERSION

# Start completions and only refresh the comp dump once every 24 hours
autoload -Uz compinit
for dump in ~/.zcompdump(N.mh+24); do
  compinit
done
compinit -C

# Extra plugins and themes
export ZSH_CUSTOM=$HOME/.zsh/custom

# Plugin Settings
VI_MODE_SET_CURSOR=true
VI_MODE_RESET_PROMPT_ON_MODE_CHANGE=true
MODE_INDICATOR="%F{white}[N]%f"
INSERT_MODE_INDICATOR="%F{yellow}[I]%f"

# Load the plugins
plugins=(
    zsh-autosuggestions
    # gitfast
    sudo
    zsh-autopair
    vi-mode
    fzf-zsh-plugin
    direnv
)

# If we aren't running MacOS add nix-shell plugin.
# We can't use this on MacOS because Apple refuses to use
# a bash version >4 due to GPLv3 licensing.
if [[ $(uname) != "Darwin" ]]; then
    plugins+=(nix-shell)
fi

# This plugin needs to be loaded last
plugins+=(zsh-syntax-highlighting)

# Load OMZ
source $ZSH/oh-my-zsh.sh

# Set VIM mode bindings
bindkey -v
bindkey jk vi-cmd-mode
bindkey zx vi-cmd-mode

# User configuration
# export MANPATH="/usr/local/man:$MANPATH"
# export LANG=en_US.UTF-8

# Sets the EDITOR env variable. Used for git commits and the like
if [[ -n $(command -v nvim) ]]; then
    export EDITOR=nvim
elif [[ -n $(command -v vim) ]]; then
    export EDITOR=vim
elif [[ -n $(command -v vi) ]]; then
    export EDITOR=vi
fi
export VISUAL="$EDITOR"

# Sets the SHELL env variable so tmux opens the correct shell
export SHELL="$(which zsh)"

# If wal is used, source the wal colors
if [ -d ~/.cache/wal ]; then
    cat ~/.cache/wal/sequences
    source ~/.cache/wal/colors-tty.sh
fi

# ZSH Completions
#zstyle ':completion:*' menu select
zstyle ':completion:*:*:nvim:*' file-patterns '^*.(aux|pdf|dvi|o|elf|bin):source-files' '*:all-files'
fpath+=~/.zfunc

# Load all of the plugins that were defined in ~/.zshrc
# for plugin ($plugins); do
#     timer=$(python -c 'from time import time; print(int(round(time() * 1000)))')
#     if [ -f $ZSH_CUSTOM/plugins/$plugin/$plugin.plugin.zsh ]; then
#         source $ZSH_CUSTOM/plugins/$plugin/$plugin.plugin.zsh
#     elif [ -f $ZSH/plugins/$plugin/$plugin.plugin.zsh ]; then
#         source $ZSH/plugins/$plugin/$plugin.plugin.zsh
#     fi
#     now=$(python -c 'from time import time; print(int(round(time() * 1000)))')
#     elapsed=$(($now-$timer))
#     echo $elapsed":" $plugin
# done

# zprof
