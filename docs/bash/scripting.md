# Bash Scripting

## Header

The following header should be included in all scripts.

```bash
#! /usr/bin/env bash
#
# Author: Joshua Gilman <joshuagilman@gmail.com>
#
#/ Usage: SCRIPTNAME [OPTIONS]... [ARGUMENTS]...
#/
#/
#/ OPTIONS
#/   -h, --help
#/                Print this help message
#/
#/ EXAMPLES
#/

set -o errexit   # abort on nonzero exitstatus
set -o nounset   # abort on unbound variable
set -o pipefail  # don't hide errors within pipes
```

Rationale:

- Use `env bash` for [portability][01].
- The shell options are [best practices][02]:
  - We always want to exit on undefined behavior (non-zero exit code)
  - We want to avoid the default beahvior of accepting unset variables
  - We want to avoid hiding non-zero exit codes within a complex pipe

## Conditionals

This has historically always been confusing to me when it comes to writing Bash
scripts. That is, until, I came across an article that explained the `[` symbol
is a builtin and in some cases, an actual program. Thus, the first the I wrote:

```bash
man [
```

My mind was blown and years of ambiguity was suddenly lifted as I could now
understand the various `-{x}` references can essentially be thought of as flags.
For example:

```bash
if [ -f filename ]
```

The man page describes what the `-f` flag does. Therefore, when in doubt, use
`man [` or `man test`.

## Logging

Debugging a bash script is hard enough, don't make it harder by not having
copious amounts of logging to track down bugs.

### Debug

The easiest way to debug a shell script is by making it print out all commands:

```bash
bash -x myscript.sh  # or add `set -x` to the top of the script
```

Use the following functions for logging:

```bash
readonly yellow='\e[0;33m'
readonly green='\e[0;32m'
readonly red='\e[0;31m'
readonly reset='\e[0m'

# Usage: log [ARG]...
#
# Prints all arguments on the standard output stream
log() {
  printf "${yellow}>> %s${reset}\n" "${*}"
}

# Usage: success [ARG]...
#
# Prints all arguments on the standard output stream
success() {
  printf "${green} %s${reset}}\n" "${*}"
}

# Usage: error [ARG]...
#
# Prints all arguments on the standard error stream
error() {
  printf "${red}!!! %s${reset}\n" "${*}" 1>&2
}
```

Use the `log` function for normal output. Always try to end the script with a
call to the `success` function as the human eye can quickly associate a green
response with "everything went well." Likewise, use the `error` function when
things go wrong to quickly draw attention to it.

Additionally, it's often useful to disable all startup scripts when running Bash
to isolate the environment:

```bash
env -i bash --noprofile --norc
```

## Exit Codes

Always exit on an error with a non-zero exit code. The following function should
be incorporated:

```bash
# Usage: die MESSAGE
# Prints the specified error message and exits with an error status
die() {
  error "${*}"
  exit 1
}
```

## Interactivity

The below functions are useful for asking the user basic questions:

```bash
# Usage: yesno MESSAGE
#
# Asks the user for an answer via y/n syntax.
yesno() {
 read -p "${*} [y/n] " -r
 printf "\n"
 if [[ ! $REPLY =~ ^[Yy]$ ]]; then
  return 1
 else
  return 0
 fi
}

# Usage: yesno_exit MESSAGE
#
# Asks the user to confirm via y/n syntax. Exits if answer is no.
yesno_exit() {
 read -p "${*} [y/n] " -r
 printf "\n"
 if [[ ! $REPLY =~ ^[Yy]$ ]]; then
  exit 1
 fi
}
```

The first function can be used in a simple if statement:

```bash
if yesno "Would you like to do this thing?"; then
  log "Doing the thing..."
fi
```

The second function is a shortcut for the common case where the script should
exit if the user gives a no answer:

```bash
yesno_exit "Confirm you want to do this thing?"
log "Doing the thing..."
```

## Always cleanup

If the script has side effects, like creating files in a temporary directory,
always provide a cleanup function in case of an unexpected error:

```bash
cleanup() {
  result=$?
  # Put cleanup code here
  exit ${result}
}

trap finish EXIT ERR
```

[01]: https://stackoverflow.com/a/10383546/1622821
[02]: https://gist.github.com/mohanpedala/1e2ff5661761d3abd0385e8223e16425
