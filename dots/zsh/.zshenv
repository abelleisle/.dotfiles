# We want to put zsh files under ~/.zsh
ZDOTDIR=${HOME:-~}/.zsh

# ZSH cache should go to ~/.cache/zsh
ZSH_CACHE_DIR="${XDG_CACHE_HOME:-$HOME/.cache}/zsh"

# Don't let Darwin and some Linux (Ubuntu) distros run compinit globally
skip_global_compinit=1

# Change sort order to be more predictable
# numbers > uppercase > lowercase
LC_COLLATE=C

# Debug function for zsh scripts
# Usage: zdebug "message" or zdebug "context: message"
# Enable by setting: export DOTFILES_ZSH_DEBUG=1
zdebug() {
  [[ "${DOTFILES_ZSH_DEBUG}" == "1" ]] || return
  echo "[ZDEBUG] $@" >&2
}
