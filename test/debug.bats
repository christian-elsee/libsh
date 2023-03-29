#!/usr/bin/env bats
. src/debug.sh

@test "can write a debug log entry to stderr" {
  debug "$token" 3>&1 1>/dev/null 2>&1 \
    | grep -- "$token"
}

setup_file() {
  export token=$( date +%s )
}
