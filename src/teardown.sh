#!/bin/sh
set -eu
trap 'teardown $0 $$ $?' EXIT INT TERM

## func
teardown() { local status=$?
	logger -sp DEBUG "Teardown" -- \
    ::  "trace=$1" \
        "pid=$2" \
        "status=$status"
  trap - EXIT INT TERM
	exit $status
}
