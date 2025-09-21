# We want to put zsh files under ~/.zsh
ZDOTDIR=${HOME:-~}/.zsh

# ZSH cache should go to ~/.cache/zsh
ZSH_CACHE_DIR="${XDG_CACHE_HOME:-$HOME/.cache}/zsh"

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

# Don't let Darwin and some other Linux distros run compinit globally
skip_global_compinit=1
