#!/usr/bin/env bats
. src/foobar.sh

@test "can foobar" {
  foobar | grep foobar
}

@test "can not barfoo" {
  ! echo foobar | grep -v foobar
}
