# bk - Reverse 'cd'
# Copyright (C), Ilya Zelvyansky, 2016
#
# GPLv2

# Source this file from .bashrc

print_bk_usage()
{
    echo "USAGE: bk [-h | dir]"
    echo "The -h option prints this message. Otherwise:"
    echo "* If [dir] is omitted, 'bk' goes to the previous directory (i.e., it is equivalent to 'cd -')."
    echo "* If [dir] matches only one directory in the current path, 'bk' goes there."
    echo "* If [dir] matches more than one directory in the current path, 'bk' goes to the rightmost match, EXCLUDING the current directory."
    echo "For example, if the current path is /a/b/c/a/c, then:"
    echo "* 'bk a' is equivalent to 'cd /a/b/c/a/'."
    echo "* 'bk b' is equivalent to 'cd /a/b/'."
    echo "* 'bk c' is equivalent to 'cd /a/b/c/' (not to 'cd .' !!!)."
}


bk()
{
    if [ $# -gt 1 ]; then
	print_bk_usage 1>&2
        return 1
    elif [ $# -eq 0 ]; then
        if [ "$OLDPWD" = "" ]; then
	    cd > /dev/null
	else
            cd - > /dev/null
	fi
        return 0
    elif [ "$1" == '-h' ]; then
	print_bk_usage
	return 0
    elif [[ ! "$1" =~ [^./]|"..." ]]; then
        cd "$1"
        return 0
    fi
    
    local path="$(sed -r 's/\/+/\//g' <<< "/$1/")"

    if [[ "$(dirname "$PWD")/" =~ [[:print:]]*"$path" || "$PWD/" =~ [[:print:]]*"$path" ]]; then
        cd "${BASH_REMATCH[0]}"
        return 0
    else
        echo "Error: \"$1\" was not found in the current path." 1>&2
        return 1
    fi
}


_bk()
{
    [[ $COMP_CWORD -gt 1 ]] && return

    local compword=$(sed 's/\\//g' <<< "${COMP_WORDS[1]}")
    local path="$(dirname "$PWD")/"
    local match

    while [[ "$path" =~ [[:print:]]*/("$compword"[^/]*)/ ]]; do
	match="${BASH_REMATCH[1]}"
        path=${path%"$match"*}
	[ $COMP_TYPE != 63 ] && match=$(sed 's/\([^[:alnum:]\/~@#%_.+-]\)/\\\1/g' <<< "$match")
        COMPREPLY+=( "$match" )
    done
}


complete -F _bk bk
