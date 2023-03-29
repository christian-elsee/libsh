# libsh

A collection of posix compliant, "stdlib" type, shell functions. See [utilsh](github.com/christian-elsee/utilsh) for a collection of executable scripts

- [Requirements](#requirements)
- [Usage](#usage)
  - [debug](#debug)
  - [enc](#enc)
  - [logger](#logger)
  - [teardown](#teardown)
- [Testing](#testing)
- [Development](#development)
- [License](#license)

## Requirements

A list of soft dependencies available during the development of any given script

- git, 2.24.3
```sh
$ git --version
git version 2.24.3 (Apple Git-128)
```
- Bash, 5.1.8
```sh
$ bash --version
GNU bash, version 5.1.8(1)-release (x86_64-apple-darwin20.3.0)
Copyright (C) 2020 Free Software Foundation, Inc.
License GPLv3+: GNU GPL version 3 or later <http://gnu.org/licenses/gpl.html>

This is free software; you are free to change and redistribute it.
There is NO WARRANTY, to the extent permitted by law.
```

- docker, 20.10.12
```sh
$ docker version | grep -A2 -E -- 'Client|Server'
Client:
 Version:           20.10.12
 API version:       1.41
--
Server:
 Engine:
  Version:          20.10.12
```

## Usage

A list of the function definitions commited to this repo, which details usage and provides examples

#### ## <a id="debug"></a>[src/debug.sh](src/debug.sh)

Writes a debug priority log entry to "stdlog" (~~fd#3~~)

```sh
$ ( . src/debug.sh; debug "foobar" 3>&2 ;)
Mar 29 20:07:17  christian[16791] <Debug>: foobar -- trace=-bash pid=8101 status=0
```

#### ## <a id="logger"></a>[src/logger.sh](src/logger.sh)

A system logger wrapper that adds additional attributes, deals with portability issues and writes log entries to "stdlog" (~~fd#3~~)

```sh
$ ( . src/logger.sh; logger -sp DEBUG -- "Test" 3>&2 ;)
Mar 29 20:23:52  -bash#8101[17198] <Debug>: Test
```

#### ## <a id="enc"></a>[src/enc.sh](src/enc.sh)

A portable base64 encoder against stdin or variadic argument set

```sh
$ ( . src/enc.sh; enc foo bar world ; )
Zm9vIGJhciB3b3JsZAo=
```
```sh
$ ( . src/enc.sh; echo foo bar world | enc - ; )
Zm9vIGJhciB3b3JsZAo=
```
#### ## <a id="teardown"></a>[src/teardown.sh](src/teardown.sh)

A minimal [signal handler](https://man7.org/linux/man-pages/man1/trap.1p.html) used to log caller, status and pid. By default, handles EXIT, INT and TERM signals.

```sh
$ ( $ ( . src/teardown.sh; echo foobar )
foobar
Mar 29 20:34:52  christian[17392] <Debug>: Teardown -- :: trace=-bash pid=8101 status=0
```
```sh
$ ( . src/teardown.sh; false )
Mar 29 20:35:31  christian[17406] <Debug>: Teardown -- :: trace=-bash pid=8101 status=1
```
```sh
$ ( . src/teardown.sh; exit 22 )
Mar 29 20:35:51  christian[17415] <Debug>: Teardown -- :: trace=-bash pid=8101 status=22
```
```sh
$ ( . src/teardown.sh; sleep inf ) &
$ kill %1
Terminated: 15
Mar 29 20:36:44  christian[17436] <Debug>: Teardown -- :: trace=-bash pid=8101 status=143
```

## Testing

A set of acceptance tests built on top of [bats](https://github.com/bats-core/bats-core) that output [tap](https://testanything.org/) compliant reports.

Tests are executed as part of the make workflow, but can be executed independently as well.

```sh
$ make check
...
1..5
ok 1 can write a debug log entry to stderr
ok 2 can encode an argument payload
ok 3 can encode a payload from stdin
ok 4 can log to stdlog
ok 5 can call teardown on exit
```

Tests cases are commited, as ~~bats~~ files, to the [test](test) directory.

## Development

A minimal overview of the development workflow.

1\. Add a shell file to `src` and commit.
```sh
$ cat <<eof | tee src/foobar.sh
#!/bin/sh
set -eu

foobar() { echo foobar ; }
eof
$ chmod +x src/foobar.sh
````
```sh
$ git add src/foobar.sh
$ git commit -m "Add Development Workflow Example Script"
[feature-github-actions db309ff] Add Development Workflow Example Script
 Date: Mon Mar 27 19:00:31 2023 +0200
 1 file changed, 4 insertions(+)
 create mode 100644 src/foobar.sh
 ```

2\. Add a [bats](https://github.com/bats-core/bats-core) test case to `test` and commit.
```sh
$ cat <<eof | tee test/foobar.bats
> #!/usr/bin/env bats

@test "can foobar" {
  foobar.sh | grep foobar
}

@test "can not barfoo" {
  ! ( foobar.sh | grep barfoo )
}
eof
```
```sh
$ git commit -m "Add Development Worfklow Example Test"
[feature-github-actions 72c862f] Add Development Worfklow Example Test
 1 files changed, 9 insertions(+), 0 deletions(-)
 create mode 100644 test/foobar.bats
```

3\. Evaluate test cases by running `make` workflow.
```sh
$ make | grep foo
ok 4 can foobar
ok 5 can not barfoo
```

4\. Push changes to repository on successful make workflow
```sh
$ make push
test "feature-github-actions"
# ensure working tree is clean for push
git status --porcelain \
  | xargs \
  | grep -qv .
ssh-agent bash -c \
  "<secrets/key.gpg gpg -d | ssh-add - \
    && git push origin feature-github-actions -f    \
  "
gpg: encrypted with rsa2048 key, ID BD4B2D8362388282, created 2019-05-30
      "local <local@me>"
Identity added: (stdin) (ssdd)
...
 * [new branch]      feature-github-actions -> feature-github-actions
```

5\. Check github actions build status.
```sh
$ ( gh workflow view main.yaml ) </dev/null
main - main.yaml
ID: 52494213

Total runs 3
Recent runs
✓  Update README                  main  feature-github-actions  push  4534871010
```

## License

[MIT](https://choosealicense.com/licenses/mit/)
