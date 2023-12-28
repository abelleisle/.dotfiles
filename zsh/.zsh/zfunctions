#!/usr/bin/env zsh

################################################################################
#                   PLACE FOR DEFINING CUSTOM ZSH FUNCTIONS                    #
################################################################################
# NOTE: These functions will be synced in dotfiles.
# For local functions (e.g: work computer), please create a file ending in
# `.local` in the same directory

timezsh() {
  shell=${1-$SHELL}
  for i in $(seq 1 4); do /usr/bin/time $shell -i -c exit; done
}

mcd() {
    mkdir -p "$@" && cd "$@"
}
