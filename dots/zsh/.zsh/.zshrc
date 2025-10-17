# zmodload zsh/zprof

# Load ZSH settings from zshrc.d
for file in ${ZDOTDIR}/zshrc.d/**/*(N); do
	[[ -r $file ]] && source $file
    echo $file
done
unset file

# Source our local settings
for file in ${ZDOTDIR}/"local.d"/**/*(N); do
	[[ -r $file ]] && source $file
    source $file
done
unset file

# Set VIM mode bindings
bindkey -v
bindkey jk vi-cmd-mode
bindkey zx vi-cmd-mode

# User configuration
# export MANPATH="/usr/local/man:$MANPATH"

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

# zprof
