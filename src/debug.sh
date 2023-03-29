#!/usr/bin/env false
set -eu

## fd
2>&- >&3 || exec 3>/dev/null

## func
debug () { local status=$? msg=$1 ;shift
	logger -sp DEBUG "$msg" -- \
  	"trace=$0" \
  	"pid=$$" \
  	"status=$status"
} 2>&3
