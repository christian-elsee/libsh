#!/bin/sh
## Portable base64 encode
#$ enc.sh $@, echo xyv | enc.sh -
#< string
set -eu

## env
argv=$@

## main
enc() { local payload=$@
	{ test "$payload" = "-" ] \
			&& cat \
			|| echo "$@"
	} | base64 \
		| tr -d \\n
}

if [ "$(basename -- "$0")" = "enc.sh" ]; then
	enc "$@"
fi
