# Generation

The process of generating a new primary GPG key is a bit intensive, however, all
of it has been automated into a friendly Bash script to ease the process.

## Setup

The environment must already be setup and available before continuing. See the
[environment](environment.md) section for more details.

In addition to the environment being accessible, the folllowing is also needed:

1. A pen and paper to copy down the new secret data
1. A hardware encrypted USB drive for storing backups

## Creation

The environment already includes the automated script for creating a new key. To
begin the process, simply run:

```bash
export GNUPGHOME="$(key_workspace)"
key_build
```

When prompted, ensure that the passphrases for the primary key and the encrypted
partition are stored on paper. Once completed, you'll be prompted to reboot the
system to clear all temporary files and memory.
