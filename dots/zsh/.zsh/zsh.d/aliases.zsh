# General aliases
alias ls="ls --color=auto -G"

# OS specific aliases
case "$(uname -s)" in
    Darwin)
        alias lsusb="cyme"
        ;;
    Linux)
        ;;
esac

# Helix is packaged inconsistently, let's always use hx
if [ command -v helix &> /dev/null ]; then
    alias hx="helix"
fi
