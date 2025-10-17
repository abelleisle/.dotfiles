#!/usr/bin/env zsh

reduce_path() {
    local path="$1"

    # Replace $HOME with ~
    if [[ "$path" == "$HOME"* ]]; then
        path="~${path#$HOME}"
    fi

    # Convert path to array by splitting on /
    local parts=(${(s:/:)path})
    local result_parts=()

    # Filter out empty parts
    for part in "${parts[@]}"; do
        if [[ -n "$part" ]]; then
            result_parts+=("$part")
        fi
    done

    local num_parts=${#result_parts[@]}

    # If 2 or fewer parts, return original
    if [[ $num_parts -le 2 ]]; then
        echo "$path"
        return
    fi

    # Build result: truncate all but last 2 parts
    local result=""
    for ((i=1; i<=num_parts; i++)); do
        if [[ $i -eq 1 ]]; then
            result="${result_parts[$i]}"
        elif [[ $i -le $((num_parts - 2)) ]]; then
            # Truncate to first character
            result="$result/${result_parts[$i]:0:1}"
        else
            # Keep last 2 parts full
            result="$result/${result_parts[$i]}"
        fi
    done

    echo "$result"
}
