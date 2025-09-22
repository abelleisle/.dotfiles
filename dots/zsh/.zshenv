# We want to put zsh files under ~/.zsh
export ZDOTDIR=${HOME:-~}/.zsh

# ZSH cache should go to ~/.cache/zsh
export ZSH_CACHE_DIR="${XDG_CACHE_HOME:-$HOME/.cache}/zsh"

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

# Don't let Darwin and some Linux (Ubuntu) distros run compinit globally
export skip_global_compinit=1
