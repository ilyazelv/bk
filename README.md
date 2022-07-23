This script introduces the 'bk' function, which basically works as reverse 'cd'.

To use it, just put 'bk.sh' in your home directory and source it from '.bashrc'.

USAGE: bk [-h | dir]

The -h option prints this message. Otherwise:
* If [dir] is omitted, 'bk' goes to the previous directory (i.e., it is equivalent to 'cd -').
* If [dir] matches only one directory in the current path, 'bk' goes there.
* If [dir] matches more than one directory in the current path, 'bk' goes to the rightmost match, EXCLUDING the current directory.

For example, if the current path is /a/b/c/a/c, then:
* 'bk a' is equivalent to 'cd /a/b/c/a/'.
* 'bk b' is equivalent to 'cd /a/b/'.
* 'bk c' is equivalent to 'cd /a/b/c/' (not to 'cd .' !!!).
