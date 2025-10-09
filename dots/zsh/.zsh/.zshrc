# zmodload zsh/zprof

# Make sure zsh cache dir exists
[[ ! -d $ZSH_CACHE_DIR ]] && command mkdir -p "$ZSH_CACHE_DIR"

# Zinit installation and setup
ZINIT_HOME="${XDG_DATA_HOME:-${HOME}/.local/share}/zinit/zinit.git"
[ ! -d $ZINIT_HOME ] && mkdir -p "$(dirname $ZINIT_HOME)"
[ ! -d $ZINIT_HOME/.git ] && git clone https://github.com/zdharma-continuum/zinit.git "$ZINIT_HOME"
source "${ZINIT_HOME}/zinit.zsh"

# Source our custom functions
if [ -d ${ZDOTDIR}/extra/ ]; then
    for file in ${ZDOTDIR}/extra/**; do
        source $file;
    done
fi

# ESW script settings
ESW_HELPERS_SQUID_EN=1

# ESW script source
ESW_DOTS_DIR=~/.dots-esw # Change this to point to where you've cloned this repo
if [ -d $ESW_DOTS_DIR ]; then
    source $ESW_DOTS_DIR/shell/shellenv
fi

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

# History settings
HIST_STAMPS="mm/dd/yyyy"
HISTFILE=${HOME:-~}/.zsh_history
HISTSIZE=100000
SAVEHIST=1000000

setopt EXTENDED_HISTORY          # Write the history file in the ':start:elapsed;command' format.
setopt HIST_EXPIRE_DUPS_FIRST    # Expire a duplicate event first when trimming history.
setopt HIST_FIND_NO_DUPS         # Do not display a previously found event.
setopt HIST_IGNORE_ALL_DUPS      # Delete an old recorded event if a new event is a duplicate.
setopt HIST_IGNORE_DUPS          # Do not record an event that was just recorded again.
setopt HIST_IGNORE_SPACE         # Do not record an event starting with a space.
setopt HIST_SAVE_NO_DUPS         # Do not write a duplicate event to the history file.
setopt SHARE_HISTORY             # Share history between all sessions.

# Plugin Settings
VI_MODE_SET_CURSOR=true
VI_MODE_RESET_PROMPT_ON_MODE_CHANGE=true
MODE_INDICATOR="%F{white}[N]%f"
INSERT_MODE_INDICATOR="%F{yellow}[I]%f"
FZF_DEFAULT_OPTS='--height 75% --layout=reverse'

# Load OMZ libs that we need
zinit snippet OMZL::async_prompt.zsh
zinit snippet OMZL::git.zsh
zinit snippet OMZL::key-bindings.zsh
zinit snippet OMZL::theme-and-appearance.zsh

# Load zinit plugins
zinit snippet OMZP::sudo
zinit snippet OMZP::vi-mode
zinit lucid wait for hlissner/zsh-autopair

# If we aren't running MacOS add nix-shell plugin.
# We can't use this on MacOS because Apple refuses to use
# a bash version >4 due to GPLv3 licensing.
if [[ $(uname) != "Darwin" ]]; then
    zinit light chisui/zsh-nix-shell
fi

# Load completions and syntax highlighting
ZINIT[ZCOMPDUMP_PATH]=${ZSH_CACHE_DIR}/compdump
zinit wait lucid for \
  atinit"ZINIT[COMPINIT_OPTS]=-C; zicompinit; zicdreplay" \
     zdharma/fast-syntax-highlighting \
  blockf \
     zsh-users/zsh-completions \
  blockf \
     nix-community/nix-zsh-completions \
  atload"!_zsh_autosuggest_start" \
     zsh-users/zsh-autosuggestions

# Set VIM mode bindings
bindkey -v
bindkey jk vi-cmd-mode
bindkey zx vi-cmd-mode

# User configuration
# export MANPATH="/usr/local/man:$MANPATH"
# export LANG=en_US.UTF-8

# If there is no SSH connection, set colors
if [ -z "$SSH_CONNECTION" ]; then

    # If wal is used, source the wal colors
    if [ -d ~/.cache/wal ]; then
        [[ -s ~/.cache/wal/sequences ]] && cat ~/.cache/wal/sequences
        [[ -s ~/.cache/wal/colors-tty.sh ]] && source ~/.cache/wal/colors-tty.sh
    fi

    # If home-manager is used, source our colorscheme
    if [ -d ~/.shelf ]; then
        # [[ -s ~/.shelf/sequences ]] && cat ~/.shelf/sequences
        # [[ -s ~/.shelf/colors-tty.sh ]] && source ~/.shelf/colors-tty.sh
    fi

fi

# ZSH Completions
zstyle ':completion:*' menu select # Enable menu selection for completions (easier to see)
zstyle ':completion:*' matcher-list 'm:{[:lower:]}={[:upper:]} r:|?=**'
zstyle ':completion:*:*:nvim:*' file-patterns '^*.(aux|pdf|dvi|o|elf|bin):source-files' '*:all-files'
fpath+=(${HOME:-~}/.zfunc)
fpath+=(${ZDOTDIR}/completions.d)

# Ghostty resources loading
if [[ -n $GHOSTTY_RESOURCES_DIR ]]; then
  autoload -Uz -- "$GHOSTTY_RESOURCES_DIR"/shell-integration/zsh/ghostty-integration
  ghostty-integration
  unfunction ghostty-integration
fi

# Autostart zellij
# if command -v zellij >/dev/null 2>&1; then
#     eval "$(zellij setup --generate-auto-start zsh)"
# fi

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

# Sets the EDITOR env variable. Used for git commits and the like
if [[ -n $(command -v nvim) ]]; then
    export EDITOR=nvim
    export MANPAGER='nvim +Man!'
elif [[ -n $(command -v vim) ]]; then
    export EDITOR=vim
    export MANPAGER='vim -M +MANPAGER --not-a-term -'
elif [[ -n $(command -v vi) ]]; then
    export EDITOR=vi
fi
export VISUAL="$EDITOR"

# If bat is available, use that as our manpager (faster than vim for large pages)
if [[ -n $(command -v bat) ]]; then
    export MANPAGER="sh -c 'awk '\''{ gsub(/\x1B\[[0-9;]*m/, \"\", \$0); gsub(/.\x08/, \"\", \$0); print }'\'' | bat -p -lman'"
fi

if (( $+commands[direnv] )); then
    eval "$(direnv hook zsh)"
fi

if (( $+commands[fzf] )); then
    source <(fzf --zsh)
fi

# Load shell theme
if (( $+commands[starship] )); then
    eval "$(starship init zsh)"
else
    source ${ZDOTDIR}/custom/themes/passion.zsh-theme
fi

# zprof
