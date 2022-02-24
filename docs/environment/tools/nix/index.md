# Nix

[Nix](https://nixos.org/) is the primary package management tool used for
managing packages in my development environment. See the related
[architecture](../../architecture.md#nix) section for more details on how it
fits into the overall environment.

## Resources

- [Website](https://nixos.org/)
- [Documentation](https://nixos.org/manual/nix/stable/)
- [Wiki](https://nixos.wiki/)
- [Nix Pills](https://nixos.org/guides/nix-pills/)
- [Nix DevOps](https://nix.dev/)

## Install

The
[official installation script](https://nixos.org/download.html#nix-install-macos)
will do most of the work:

```bash
sh <(curl -L https://nixos.org/nix/install)
```

Some notes about the installation process:

1. A new volume is created and mounted at `/nix`
1. The `fstab` is modified to auto-mount the volume at startup
1. The volume is owned by `root` and the generated `nixbld` accounts
1. The nix store is created at `/nix/store`
1. Various daemons are created for managing the Nix installation

Test the installation with the following command:

```bash
nix-shell -p nix-info --run "nix-info -m"
```

## Uninstall

There doesn't seem to be good official instructions for uninstalling Nix. I've
tested and had success using the instructions in this
[Github Issue](https://github.com/NixOS/nix/issues/3900#issuecomment-716916990).

Note that it's possible to run the installer again even with a dirty system and
it *should* do the right thing.
