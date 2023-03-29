#!/usr/bin/env bats

@test "can call teardown on exit" {
  ( . src/teardown.sh
  ) 2>&1 \
    1>/dev/null \
  | grep -- Teardown
}
