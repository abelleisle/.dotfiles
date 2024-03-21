#! /usr/bin/env zsh

yes_or_NO() {
    string="${@:-Continue?}"
    [[ "$(echo -n "${string} [y/N]> " >&2; read; echo $REPLY)" == [Yy]* ]] \
        && return 0 \
        || return 1
}

YES_or_no() {
    string="${@:-Continue?}"
    [[ "$(echo -n "${string} [Y/n]> " >&2; read; echo $REPLY)" == [Nn]* ]] \
        && return 1 \
        || return 0
}
