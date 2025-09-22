# We want to put zsh files under ~/.zsh
export ZDOTDIR=${HOME:-~}/.zsh

# ZSH cache should go to ~/.cache/zsh
export ZSH_CACHE_DIR="${XDG_CACHE_HOME:-$HOME/.cache}/zsh"

# Don't let Darwin and some Linux (Ubuntu) distros run compinit globally
export skip_global_compinit=1
