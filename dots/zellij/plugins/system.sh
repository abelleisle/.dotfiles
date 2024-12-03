#!/usr/bin/env bash


if [[ $# -eq 0 ]] ; then
    echo "Need to provide arg"
    exit 1;
fi

cpu_usage() {
    case `uname` in
        Darwin)
            cpu=$(LC_ALL=C top -l1 -s0 2>/dev/null | awk '/^CPU/ {print 100 - $7}')
            echo "${cpu}%"
            ;;
        Linux)
            echo "System usage not ported to Linux yet"
            ;;
        *)
            echo "Unsupported system"
            ;;
    esac
}

mem_usage() {
    case `uname` in
        Darwin)
            mem=$(ps -A -o %mem | awk '{ mem += $1 } END {print mem}')
            echo "${mem}%"
            ;;
        Linux)
            echo "System usage not ported to Linux yet"
            ;;
        *)
            echo "Unsupported system"
            ;;
    esac
}

case $1 in
    cpu)
        cpu_usage
        ;;
    mem)
        mem_usage
        ;;
    *)
        echo "arg invalid: $1"
        exit 1
        ;;
esac

