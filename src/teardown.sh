#!/bin/sh
## Produces TAP output from a given set of executable files
#$ test.sh ./test ./another/path *.test
set -eu
trap 'teardown $0 $$ $?' EXIT INT TERM

## func
teardown() { local status=$?
	logger -sp DEBUG "Teardown" -- "trace=$1" "pid=$2" "status=$status"
	exit $status
}
