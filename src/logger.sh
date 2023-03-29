#!/bin/sh
## Wrap posix logger to redirect to log stream
#$ logger.sh -sp DEBUG "Hello" --
#< string >&3
set -eu
2>&- >&3 || exec 3>/dev/null

## env
argv=$@

## main
logger() { command logger -t "$0#$$" "$@" ;} 2>&3
