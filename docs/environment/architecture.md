# Architecture

This sections serves as a reference for the general architecture used to create
my daily development environment. It contains a high-level overview of the core
components; for more detailed descriptions please see the associated entry in
the index.

## Overview

The primary architecture consists of three tools:

1. [Nix](#nix)
1. [Homebrew](#homebrew)
1. [Chezmoi](#chezmoi)

Combined together, they allow (mostly) restoring my development environment to a
consistent state. Additionally, they are self-documenting through their various
configuration files and allow me to easily document the tools I use in my
day-to-day work.

## Nix

[Nix][@1] is a package management system which claims to make reproducible and
declarative systems through it's unique functional approach to package
management. It is, to say the least, a very polarizing tool with evangelists
seemingly on both sides of it. Below is a very opionated summary of the debate:

- Pros
  - Allows creating (mostly) reproducible environments
  - Can make system-wide user environments or individual shell environments
  - Has rich support for dependency management
  - Is (mostly) well-documented
- Cons
  - Not even remotely beginner friendly
  - The Nix language is functional and can be very off-putting
  - Tends to be very fragile
  - Inner-workings can be magical and not documented very well

### Nix History

I successfully avoided Nix for many years and, like most Mac users, relied on
the trusty `brew` package manager for all of my needs. However, throughout those
years, there were many times where I came up against certain situations in which
I recognized the superiority Nix would have had in managing it. The `brew`
package manager in particular can suffer from dependency-hell since by default
everything is installed globally (i.e. I hope Python 3.10 works for all of my
installed packages).

Taking the above into account, Nix ended up falling nearly 50-50 when I applied
my [guidelines][@2] to it, which is a major reason it sat on the backburner for
so long. However, due to its continued maturity and my desire to have a
well-maintained, reproducible environment, it eventually won me over and I
(mostly) moved away from `brew`.

### Nix Utility

Nix serves as the primary package management tool on my MacBook. It utilizes
[nix-darwin][@3] to create an isolated environment for handling global packages.
The result is that most of the tooling is documented in the
`~/.nixpkgs/darwin-configuration.nix` file.

The above is what enables reproducibility for my environment. Since the
aforementioned file is revision controlled, restoring my tools to a predictable
state is as simple as fetching the configuration file from git and running
`darwin-rebuild switch`.

In addition to system-wide configuration, per-environment configuration is
provided through the use of `nix shell`. In particular, most of my repositories
include a `flake.nix` file which defines the dependencies required to hack on
each individual project. This primarily replaces the need for tools like `nvm`
or `pyenv` since Nix will automatically handle pulling down the right binaries
dependening on what the project requires. This is by far the shining feature of
Nix to me and is what primarily won me over in switching to it.

For reference material and guides, see [Nix][@4].

## Homebrew

The [Homebrew][@5] package manager hardly needs an introduction as it's almost
ubiquitous with Mac package management. It's a mature and widely used package
manager written in Ruby which has a vast ecosystem of "formulas" for installing
common software. In particular, `brew` can handle both traditional CLI tools as
well as graphical applications (known as *casks*).

### Homebrew Utility

The `brew` package manager compliments Nix by handling the manageemnt of
graphical applications in my environment. This is a task that Nix isn't capable
of handling and is why I still find the need for `brew` on my system.

Reproducibility is acheived by using the [bundle][@6] feature of `brew`. A
`~/.brew` file contains all of the graphical user applications expected to be on
a system and they can be easily installed via `brew bundle install`. This
configuration file, like the `nix-darwin` counterpart, is revision controlled
and can be pulled down and executed to bring things to a predictable state.

## Chezmoi

[Chezmoi][@7] is a tool for handling version controlling of the various
"dotfiles" that often sit at the root of a user's home directory. Since these
dotfiles are often responsible for customizing the user experience across
various software and can end up being highly customized, Chezmoi finds its use
in revision controlling them and allowing easily importing of them to almost any
system.

### Chezmoi Utility

Chezmoi serves as the gatekeeper of my personal dotfiles. Edits to dotfiles are
made using `chezmoi edit` and any changes are committed and pushed up to a
public Github repository.

In particular, Chezmoi is responsible for making the boostrapping process of
bringing a new system into a predictable state much easier. Essentially, once
Nix is installed a new shell can be executed with the `chezmoi` binary available
and then all of my dotfiles can be pulled down onto the system from the remote
Github repository. Once the dotfiles are present, `nix-darwin` and `brew` can
both apply their respective configurations to install all of my tooling on the
system.

As mentioned above, Chezmoi also ensures the hard work I've put into customizing
my dotfiles is not lost and can be predictably applied to other systems I may
find myself using (or recovering my MacBook in case of emergencies).

[@1]: https://nixos.org/
[@2]: index.md#guidelines
[@3]: https://github.com/LnL7/nix-darwin
[@4]: tools/nix/index.md
[@5]: https://brew.sh/
[@6]: https://github.com/Homebrew/homebrew-bundle
[@7]: https://www.chezmoi.io/
