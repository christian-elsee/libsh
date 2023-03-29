#!/usr/bin/env bats
. src/enc.sh

@test "can encode an argument payload" {
  enc "$token" | base64 -d | grep -- "$token"
}

@test "can encode a payload from stdin" {
  printf "$token" | enc - | base64 -d | grep -- "$token"
}

setup_file() {
  export token=$( date +%s )
}

