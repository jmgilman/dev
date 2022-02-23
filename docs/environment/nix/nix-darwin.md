# Nix-Darwin

[nix-darwin](https://github.com/LnL7/nix-darwin) is an opionated set of modules
for managing system-wide packages on macOS. It provides a centralized nix file
for declaring what packages are globally available in my development
environment.

## Resources

- [Repository](https://github.com/LnL7/nix-darwin)
- [Documentation](https://daiderd.com/nix-darwin/manual/index.html)
- [Wiki](https://github.com/LnL7/nix-darwin/wiki)

## Install

```bash
nix-build https://github.com/LnL7/nix-darwin/archive/master.tar.gz -A installer
./result/bin/darwin-installer
```

The installer will ask if you want to edit the default configuration. At the
time of this writing, it was necessary to add the following:

```nix
  nix.extraOptions = ''
    extra-platforms = aarch64-darwin x86_64-darwin
    experimental-features = nix-command flakes
  '';
```

After installing, the configuration will be located at
`~/.nixpkgs/darwin-configuration.nix`.

## Uninstall

```bash
nix-build https://github.com/LnL7/nix-darwin/archive/master.tar.gz -A uninstaller
./result/bin/darwin-uninstaller
```

## Update

### Update configuration

The configuration is managed by Chezmoi, to edit it:

```bash
chezmoi edit ~/.nixpkgs/darwin-configuration.nix && chezmoi apply
```

To make the changes take effect:

```bash
darwin-rebuild switch
```

### Update channel

To update the underlying channel:

```bash
nix-channel --update darwin
darwin-rebuild changelog
```

## Migrate

### Homebrew

To migrate from an existing installation that depends mainly on `brew`, the
following notes are helpful:

1. List the currently installed packages: `brew list`
1. Search for an equivalent package: `nix-env -qaP | grep -i <package>`
1. Add the package to `~/.nixpkgs/darwin-configuration.nix`.
1. Rebuild the environment: `darwin-rebuild switch`.
1. Uninstall the package from `homebrew`: `brew uninstall <package> --force`

Searching packages using `nix-env` can be slow, an alternative is to use the
[web interface](https://nixos.org/nixos/packages.html#).