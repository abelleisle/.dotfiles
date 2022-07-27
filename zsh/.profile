# ~/.profile: executed by the command interpreter for login shells.
# This file is not read by bash(1), if ~/.bash_profile or ~/.bash_login
# exists.
# see /usr/share/doc/bash/examples/startup-files for examples.
# the files are located in the bash-doc package.

# the default umask is set in /etc/profile; for setting the umask
# for ssh logins, install and configure the libpam-umask package.
#umask 022

# if running bash
if [ -n "$BASH_VERSION" ]; then
    # include .bashrc if it exists
    if [ -f "$HOME/.bashrc" ]; then
	. "$HOME/.bashrc"
    fi
fi

# set PATH so it includes user's private bin if it exists
if [ -d "$HOME/bin" ] ; then
    PATH="$HOME/bin:$PATH"
fi

if [ -d "$HOME/bin/wm" ] ; then
    PATH="$HOME/bin/wm:$PATH"
fi

# set PATH so it includes user's private bin if it exists
if [ -d "$HOME/.local/bin" ] ; then
    PATH="$HOME/.local/bin:$PATH"
fi

# set PATH so it includes user's cargo bin if it exists
if [ -d "$HOME/.cargo/bin" ] ; then
    PATH="$HOME/.cargo/bin:$PATH"
fi

# set PATH so it includes user's zig bin if it exists
if [ -d "$HOME/.zig" ] ; then
    PATH="$HOME/.zig:$PATH"
fi

# If the ESP toolchain is installed, create a function to access it
idf() {
    if [ -d "$HOME/bin/esp/esp-idf" ] && [ -d "$HOME/bin/esp/toolchain" ] ; then
        export IDF_TOOLS_PATH=$HOME/bin/esp/toolchain
        if ! command -v idf.py &> /dev/null
        then
            . "$HOME/bin/esp/esp-idf/export.sh"
        fi

        idf.py "${@:1}"
    else
        echo "ESP-IDF is not installed.\n"
        echo "Please install the IDF to: $HOME/bin/esp/esp-idf\n"
        echo "Next, set IDF_TOOLS_PATH to: $HOME/bin/esp/toolchain"
        echo " and run $HOME/bin/esp/esp-idf/install.sh"
    fi
}

export _JAVA_AWT_WM_NONREPARENTING=1

case `uname` in
    Darwin)

        if [ $(sysctl -n sysctl.proc_translated) = '0' ]; then
            #echo 'Running natively (arm64)'

            eval "$(/opt/homebrew/bin/brew shellenv)"

            export PYENV_ROOT="$HOME/.pyenv_arm"
            PATH="$HOME/.pyenv_arm/shims:$PATH"

            export DYLD_FALLBACK_LIBRARY_PATH=/opt/homebrew/lib

            if [ -d "$HOME/Library/Python/3.9/bin" ] ; then
                PATH="$HOME/Library/Python/3.9/bin:$PATH"
            fi

        else
            #echo 'Running through Rosetta (x86_64)'

            eval "$(/usr/local/bin/brew shellenv)"

            export PYENV_ROOT="$HOME/.pyenv_intel"
            PATH="$HOME/.pyenv_intel/shims:$PATH"

            if [ -d "$HOME/Library/Python/3.9/bin" ] ; then
                PATH="$HOME/Library/Python/3.9/bin:$PATH"
            fi
        fi

        eval "$(pyenv init -)"

        export LANG='en_US.UTF-8'

        ;;
    Linux)
        ;;
esac
