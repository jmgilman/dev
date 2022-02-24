# Guide

This page is the master guide for my development environment. It contains short
entries on all notable tools, commands, and other miscellaneous things that are
worth documenting. As such, it's sort of a hodge podge, but I have attempted to
keep it somewhat organized so that it remains useful.

## Alias Cheat Sheet

| Alias | Definition                                                                       | Description                                                             |
| ----- | -------------------------------------------------------------------------------- | ----------------------------------------------------------------------- |
| ..    | `cd ..`                                                                          | Changes to the parent directory                                         |
| ...   | `cd ../..`                                                                       | Changes to the grandparent directory                                    |
| -     | `ls -`                                                                           | Changes to the previous directory                                       |
| brg   | `batgrep`                                                                        | Short for `batgrep`                                                     |
| cat   | `bat --paging=never`                                                             | Replaces `cat` with `bat`                                               |
| count | `find . -type f \| wc -l`                                                        | Counts all files in the directory and any subdirectories                |
| ct    | `column -t`                                                                      | Formats input data into columns                                         |
| cz    | `chezmoi`                                                                        | Short for `chezmoi`                                                     |
| cza   | `chezmoi apply`                                                                  | Applies pending `chezmoi` changes                                       |
| czd   | `cd ~/.local/share/chezmoi`                                                      | Changes into the `chezmoi` source directory                             |
| cze   | `chezmoi edit`                                                                   | Edits a file tracked by `chezmoi`                                       |
| czr   | `chezmoi apply ~/.nixpkgs/darwin-configuration.nix darwin-update && exec $SHELL` | Applies the `nix-darwin` configuration and resets the shell environment |
| g     | `git`                                                                            | Short for `git`                                                         |
| gcmsg | `git commit -m`                                                                  | Commits changes with a short message                                    |
| gd    | `git diff`                                                                       | Shows current diff of working tree                                      |
| gst   | `git status`                                                                     | Shows status of working tree                                            |
| left  | `ls -t -1`                                                                       | Sorts files by most recently modified                                   |
| ll    | `ls -la`                                                                         | Shows all files and their properties                                    |
| lt    | `du -sh * \| sort -h`                                                            | Sorts files by their size                                               |
| mount | `mount \| grep -E ^/dev \| column -t`                                            | Makes the `mount` output easier to read                                 |
| now   | `date +"%T"`                                                                     | Returns the current time                                                |
| ports | `sudo lsof -iTCP -sTCP:LISTEN -n -P`                                             | Shows all open ports                                                    |
| today | `date +"%d-%m-%Y"`                                                               | Returns the current date                                                |
| vi    | `vim`                                                                            | Short for `vim`                                                         |

## CLI Tools

### asciinema

- [Website][@01]
- [Package][@02]
- `tldr asciinema`

A CLI tool for recording terminal sessions. To start a recording:

```bash
asciinema rec
```

Press `ctrl+d` to stop the recording. You can save the cast locally or upload it
to the SaaS version. Unfortunately it doesn't provide a way to embed the output
in something like a Github README. I've found the best method for making it
portable is to convert the cast file to an SVG using [svg-term-cli][@03]. This
can be checked in and then referenced directly in the README.c

### ansible

- [Website][@04]
- [Package][@05]
- `tldr ansible`

A general-purpose automation tool for managing system lifecycles in a
declarative and idempotent way.

### autojump

- [Website][@06]
- [Package][@07]

A self-learning CLI tool for quickly navigating filesystems. Example:

```bash
j co/de  # cd's into code/dev
```

The above works because I spend a large amount of time navigating to my `~/code`
folder and `dev` is the only child that partially matches. This will improve
overtime as the learning algorithm progresses.

### awscli2

- [Website][@08]
- [Package][@09]
- `tldr aws`

The official CLI tool for Amazon AWS.

### bat

- [Website][@10]
- [Package][@11]
- `tldr bat`

A fancy version of `cat`. Performs syntax highlighting, pretty printing, line
numbering, etc. In my environment I have aliased `cat` to `bat` since by default
`bat` will remove formatting when it detects a pipe so it should be a suitable
replacement.

```bash
cat myfile.json  # or bat myfile.json
```

These additional tools are also available:

- `batman`: Displays man pages using `bat`
- `batgrep`: Like `ripgrep` but passes output to `bat` (aliased to `brg`)
- `batdiff`: Like `diff` but uses `bat`
- `batchwatch`: Watches a file using `bat` for output
- `prettybat`: Pretty prints a file using `bat`

### bitwarden-cli

- [Website][@12]
- [Package][@13]
- `tldr bw`

The official CLI tool for [Bitwarden][@14]. Provides programmatic access to a
Bitwarden vault.

```bash
bw login  # Is persisted
bw unlock
bbw get folder lab
```

### chezmoi

- [Website][@15]
- [Package][@16]
- `tldr chezmoi`

A dotfile manager. See the [dedicated page][@17] for more information.

### consul

- [Website][@18]
- [Package][@19]
- `tldr consul`

An advanced network mesh geared at connecting microservices in a distributed
environment.

### fd

- [Website][@20]
- [Package][@21]
- `tldr fd`

A sensible replacement for the `find` CLI tool. It supports regular expressions,
glob patterns, and strict-text searching.

```bash
$ fd netfl
Software/python/imdb-ratings/netflix-details.py

$ fd passwd /etc
/etc/default/passwd

$ fd '^x.*rc$'
X11/xinit/xinitrc
```

### fzf

- [Website][@22]
- [Package][@23]
- `tldr fzf`

A fuzzy-finder tool. Provides an interactive interface for performing a fuzzy
search across arbitrary data piped into the program. Incredibly useful when
combined with other tools like `fd` and `tldr`.

```bash
d=$(fd *.json code | fzf) && bat $d
```

### gh

- [Website][@24]
- [Package][@25]
- `tldr gh`

The official Github CLI tool. Provides programmatic access to most features
available on Github including the issues/PR lifecycles. Before it can be used it
must be authenticated to a Github account:

```bash
gh auth login
```

Once authenticated, it's possible to begin interacting with repositories. Note
that `gh` is context-aware based on the current repository.

```bash
gh pr create --title "The bug is fixed" --body "Everything works again"
```

### google-cloud-sdk

- [Website][@26]
- [Package][@27]
- `tldr gcloud`

The official Google Cloud CLI tool. Provides programmatic access to various
Google Cloud services and a centralized interface for managing projects.

### lastpass-cli

- [Website][@28]
- [Package][@29]
- `tldr lpass`

The official LastPass CLI tool. Provides programmatic access to a Vault for
fetching secrets. Before using, requires authentication:

```bash
lpass login <username>
```

Once authenticated, you can begin querying the vault:

```bash
$ lpass ls
...

$ lpass show "Lab/AWS"
...
```

### jq

- [Website][@30]
- [Package][@31]
- `tldr jq`

A tool for manipulating and generating JSON on the command-line. Examples:

```bash
$ echo '{"id": 1, "name": "Cam"}' | jq '.id'
1

$ echo '{"nested": {"a": {"b": 42}}}' | jq '.nested.a.b'
42

$ echo '[0, 1, 1, 2, 3, 5, 8]' | jq '.[3]'
3

$ echo '[{"id": 1, "name": "Mario"}, {"id": 2, "name": "Luigi"}]' | jq '.[1].name'
"Luigi"

$ echo '{ "a": 1, "b": 2 }' | jq '{ a: .b, b: .a }'
{ "a": 2, "b": 1 }

$ echo '{ "a": 1, "b": 2 }' | jq 'keys'
[a, b]

$ echo '[1, 2, [3, 4]]' | jq 'flatten'
[1, 2, 3, 4]
```

### navi

- [Website][@32]
- [Package][@33]
- `tldr navi`

Provides access to cheat sheets from the command-line. This tool is a staple in
my environment as it provides a singular interface for storing rarely used CLI
invocations that are useful but hard to remember. Cheats are stored in
`~/.cheats` directory in files that end with the `.cheat` extension. They are
controlled by `chezmoi`.

Creating a new cheat:

```text
% git, code

# Revert last commit
git reset HEAD~
```

The above creates a cheat tagged wit `git` and `code` with a description of
"Revert last commit." When selected, the command it will return is
`git reset HEAD~`.

Accessing cheats is done by either pressing `ctrl + g` or executing `navi`.

### packer

- [Website][@34]
- [Package][@35]
- `tldr packer`

A tool for generating immutable images. Packer provides a syntax for defining
immutable operating system images which can then be readily deployed through
various services like AWS/GCP/Azure. These are often referred to as "golden
images."

### ripgrep

- [Website][@36]
- [Package][@37]
- `tldr rg`

A sensible replacement for `grep`. It's faster, provides support for regular
expressions, and provides more useful context then it's counterpart.

```bash
cat foo.txt | rg "^Option: .*partial value"
```

For source code files, it's recommended to use `batgrep`:

```bash
cat foo.py | brg "def myfunc_.*_name"
```

It provides more context around matche as well as syntax highlighting.

### terraform

- [Website][@38]
- [Package][@39]
- `tldr terraform`

A tool for automating complex deployments. Provides a syntax for defining the
state of a complex system and then supports interacting with that state by
creating it, modifying it, and destroying it. Supports the IaC model.

### tldr

- [Website][@40]
- [Package][@41]

A tool for generating short summaries of various popular CLI tools. A great
alternative to `--help` or `man` as it often succinctly demonstrates what a tool
is and how to quickly get started with it.

```bash
tldr git
```

### vault

- [Website][@42]
- [Package][@43]
- `tldr vault`

A secrets backend for managing various secrets. Provides a secret store for
arbitrary secrets, encryption on demand, dynamic credentials, certificate
generation, etc.

<!-- reference links -->

[@01]: https://asciinema.org/
[@02]: https://github.com/NixOS/nixpkgs/blob/nixos-unstable/pkgs/tools/misc/asciinema/default.nix
[@03]: https://github.com/marionebl/svg-term-cli
[@04]: https://www.ansible.com/
[@05]: https://github.com/NixOS/nixpkgs/blob/nixos-unstable/pkgs/development/python-modules/ansible/core.nix
[@06]: https://github.com/wting/autojump
[@07]: https://github.com/NixOS/nixpkgs/blob/nixos-unstable/pkgs/tools/misc/autojump/default.nix
[@08]: https://docs.aws.amazon.com/cli/latest/userguide/cli-chap-getting-started.html
[@09]: https://github.com/NixOS/nixpkgs/blob/nixos-unstable/pkgs/tools/admin/awscli2/default.nix
[@10]: https://github.com/sharkdp/bat
[@11]: https://github.com/NixOS/nixpkgs/blob/nixos-unstable/pkgs/tools/misc/bat/default.nix
[@12]: https://bitwarden.com/help/cli/
[@13]: https://github.com/NixOS/nixpkgs/blob/nixos-unstable/pkgs/development/node-packages/node-packages.nix
[@14]: https://bitwarden.com/
[@15]: https://www.chezmoi.io/
[@16]: https://github.com/NixOS/nixpkgs/blob/nixos-unstable/pkgs/tools/misc/chezmoi/default.nix
[@17]: tools/chezmoi.md
[@18]: https://www.consul.io/
[@19]: https://github.com/NixOS/nixpkgs/blob/nixos-unstable/pkgs/servers/consul/default.nix
[@20]: https://github.com/sharkdp/fd
[@21]: https://github.com/NixOS/nixpkgs/blob/nixos-unstable/pkgs/tools/misc/fd/default.nix
[@22]: https://github.com/junegunn/fzf
[@23]: https://github.com/NixOS/nixpkgs/blob/nixos-unstable/pkgs/tools/misc/fzf/default.nix
[@24]: https://github.com/cli/cli
[@25]: https://github.com/NixOS/nixpkgs/blob/nixos-unstable/pkgs/applications/version-management/git-and-tools/gh/default.nix
[@26]: https://cloud.google.com/sdk
[@27]: https://github.com/NixOS/nixpkgs/blob/nixos-unstable/pkgs/tools/admin/google-cloud-sdk/default.nix
[@28]: https://github.com/lastpass/lastpass-cli
[@29]: https://github.com/NixOS/nixpkgs/blob/nixos-unstable/pkgs/tools/security/lastpass-cli/default.nix
[@30]: https://stedolan.github.io/jq/
[@31]: https://github.com/NixOS/nixpkgs/blob/nixos-unstable/pkgs/development/tools/jq/default.nix
[@32]: https://github.com/denisidoro/navi
[@33]: https://github.com/NixOS/nixpkgs/blob/nixos-unstable/pkgs/applications/misc/navi/default.nix
[@34]: https://www.packer.io/
[@35]: https://github.com/NixOS/nixpkgs/blob/nixos-unstable/pkgs/development/tools/packer/default.nix
[@36]: https://github.com/BurntSushi/ripgrep
[@37]: https://github.com/NixOS/nixpkgs/blob/nixos-unstable/pkgs/tools/text/ripgrep/default.nix
[@38]: https://www.terraform.io/
[@39]: https://github.com/NixOS/nixpkgs/blob/nixos-unstable/pkgs/applications/networking/cluster/terraform/default.nix
[@40]: https://tldr.sh/
[@41]: https://github.com/NixOS/nixpkgs/blob/nixos-unstable/pkgs/tools/misc/tldr/default.nix
[@42]: https://www.vaultproject.io/
[@43]: https://github.com/NixOS/nixpkgs/blob/nixos-unstable/pkgs/tools/security/vault/default.nix
