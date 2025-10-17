if [ command -v helix &> /dev/null ]; then
    alias hx="helix"
fi

case "$(uname -s)" in
    Darwin)
        alias lsusb="cyme"
        ;;
    Linux)
        ;;
esac
