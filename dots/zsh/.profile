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
if [ -d "$HOME/.cargo" ] ; then
    if [ -d "$HOME/.cargo/bin" ] ; then
        PATH="$HOME/.cargo/bin:$PATH"
    fi

    if [ -f "$HOME/.cargo/env" ] ; then
        . "$HOME/.cargo/env"
    fi
fi

# set PATH so it includes user's zig bin if it exists
if [ -d "$HOME/.zig" ] ; then
    PATH="$HOME/.zig:$PATH"
fi

# Some systems don't have cmake in the repos, so we can install it locally to ~/.cmake
if [ -d "$HOME/.cmake/bin" ] ; then
    PATH="$HOME/.cmake/bin:$PATH"
fi

if [ -d "$HOME/.rvm/" ] ; then
    [[ -s "$HOME/.rvm/scripts/rvm" ]] && source "$HOME/.rvm/scripts/rvm" # Load RVM into a shell session *as a function*
    # Add RVM to PATH for scripting. Make sure this is the last PATH variable change.
    export PATH="$PATH:$HOME/.rvm/bin"
    export rvm_ignore_dotfiles=yes
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

export PIP_REQUIRE_VIRTUALENV=true

case `uname` in
    Darwin)

        if [ $(sysctl -n sysctl.proc_translated) = '0' ]; then
            # echo 'Running natively (arm64)'

            eval "$(/opt/homebrew/bin/brew shellenv)"

            export PATH="/opt/local/bin:$PATH"

            export PYENV_ROOT="$HOME/.pyenv_arm"

            # Python installed via `pyenv` searches the default library path `/usr/local/lib`
            # instead of the path used by homebrew (`/opt/homebrew/lib`). This can cause it
            # to find libraries installed with x86_64 homebrew instead of arm64 homebrew.
            #
            # This will inform any Python installation managed by `pyenv` to check against the
            # homebrew arm64 `lib` directory.
            #
            # Note: Apple's SIP considers this a security issue (with good reason), so the
            # `DYLD_LIBRARY_PATH` variable is cleared before executing signed applications within
            # the SIP umbrella. On the plus side, `pyenv` Python installations are not signed or SIP
            # protected like the homebrew installed variants.
            export DYLD_LIBRARY_PATH=/opt/homebrew/lib
        else
            # echo 'Running through Rosetta (x86_64)'

            eval "$(/usr/local/bin/brew shellenv)"

            export PYENV_ROOT="$HOME/.pyenv_intel"
        fi

        export PATH="$PYENV_ROOT/bin:$PATH"
        eval "$(pyenv init --path)"
        eval "$(pyenv init -)"

        export LANG='en_US.UTF-8'

        PATH="$HOME/.zsh/scripts/darwin:$PATH"

        ;;
    Linux)

        export _JAVA_AWT_WM_NONREPARENTING=1

        export LANG='en_US.UTF-8'

        ;;
esac
