#!/usr/bin/env bats
. src/logger.sh

@test "can log to stdlog" {
  logger -sp DEBUG -- "$token" 3>&1 >/dev/null 2>&1 \
    | grep -- "$token"
}

setup_file() {
  export token=$( date +%s )
}
