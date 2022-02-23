# Bootstrap

This page provides instructions on bootstrapping my development environment on
my current hardware. The purpose is for recovery should my hardware need to be
reinstalled for any reason.

## Steps

1. Install xcode: `xcode-select --install`
1. Install Rosetta: `softwareupdate --install-rosetta`
1. Install [Nix](nix/index.md#install) and
   [nix-darwin](nix/nix-darwin.md#install)
1. Install [Homebrew](homebrew.md#install)
1. Open a shell with `chezmoi`: `nix shell nixpkgs#chezmoi`
1. Initialize dot-files: `chezmoi init https://github.com/jmgilman/dotfiles`
1. Apply dotfiles: `chezmoi apply`
1. Reload shell
1. Install system packages and configuration: `darwin-rebuild switch`
1. Install casks: `brew bundle install`
