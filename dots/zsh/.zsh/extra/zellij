#!/usr/bin/env zsh

# Zellij session management function
z() {
    local session_name="$1"

    # Get list of existing sessions
    local existing_sessions
    existing_sessions=$(zellij ls -s 2>/dev/null)

    # Check if session name is provided
    if [[ -z "$session_name" ]]; then
        echo "Usage: z <session_name>"
        echo "Example: z dps"
        echo ""
        echo "Active sessions:"
        echo $existing_sessions
        return 1
    fi

    # Check if zellij is installed
    if ! command -v zellij &> /dev/null; then
        echo "Error: zellij is not installed or not in PATH"
        return 1
    fi

    # Check if the session already exists
    if echo "$existing_sessions" | grep -q "^${session_name}$"; then
        echo "Attaching to existing zellij session: $session_name"
        zellij attach "$session_name"
    else
        echo "Creating new zellij session: $session_name"
        case "$session_name" in
            "dps")
                zellij -n "dps" -s "$session_name"
                ;;
            *)
                zellij -s "$session_name"
                ;;
        esac
    fi
}

# Zellij sessionizer
zs() {
    local session_path=${1:A}
    local current_path=0

    # If no session path was provided as an argument
    if [[ -z $session_path ]]; then
        # Get the current working directory
        session_path=$(pwd)
        current_path=1
    fi

    if [[ ! -e $session_path ]]; then
        echo "Provided session path $session_path doesn't exist :("
        return 1
    fi

    if [[ -f $session_path ]]; then
        echo "Provided session path $session_path is not a directory :("
        return 1
    fi

    # Reduce the path to get our session name:
    #   Use `reduce_path` to get a shortened path (that's also human readable)
    #   Remove all '/' except for the last two (and replace those with '.')
    #     1. Reverse the string
    #     2. Replacing '/' with a random char (§) twice.
    #     3. Replace the rest of '/' with nothing.
    #     4. Replace all '.' in path with '_'
    #     5. Replace '§' with '.' (Zellij can't have '/' in session name)
    #     6. Reverse the string again (correct way around now)
    #     7. Replace ~. at beginning with ~ (looks better than '~.' if it's a short path)
    local session_name=$(reduce_path $session_path | rev | sed 's|/|§|1; s|/|§|1; s|/||g; s|\.|_|g; s|§|.|g' | rev | sed 's|~\.|~|1')

    echo "Session name: $session_name"

    # We're outside of zellij, so lets create a new session or attach to a new one.
    if [[ -z $ZELLIJ ]]; then
        if [[ $current_path -eq 0 ]]; then
            echo "cd'ing into $session_path"
            cd $session_path
        fi

        # -c will make zellij to either create a new session or to attach into an existing one
        zellij attach $session_name -c
        return 0
    fi

    echo "Please exit zellij to use zs"

    return 1
}

# Zellij sessionizer (WIP)
zs_wip()  {
    paths=$@

    if [[ -z $paths ]]; then
        echo "No paths were specified, usage: ./zellij-sessionizer path1 path2 etc.."
        return 1
    fi

    # Check whether the machine has fd available
    if [ -x "$(command -v fd)" ]; then
        selected_path=$(fd . $paths --min-depth 1 --max-depth 3 --type d | fzf)
    else
        # defer to find if not
        selected_path=$(find $paths -mindepth 1 -maxdepth 3 -type d | fzf)
    fi

    # If nothing was picked, silently exit
    if [[ -z $selected_path ]]; then
        return 1
    fi

    # If no directory was selected, exit the script
    if [[ -z $selected_path ]]; then
        return 1
    fi

    # Get the name of the selected directory, replacing "." with "_"
    session_name=$(basename "$selected_path" | tr . _)

    # We're outside of zellij, so lets create a new session or attach to a new one.
    if [[ -z $ZELLIJ ]]; then
        cd $selected_path

    # -c will make zellij to either create a new session or to attach into an existing one
        zellij attach $session_name -c
        return 0
    fi

    # We're inside zellij so we'll open a new pane and move into the selected directory
    zellij action new-pane

    # Hopefully they'll someday support specifying a directory and this won't be as laggy
    # thanks to @msirringhaus for getting this from the community some time ago!
    zellij action write-chars "cd $selected_path" && zellij action write 10
}
