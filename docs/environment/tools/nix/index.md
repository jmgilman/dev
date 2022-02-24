# Nix

[Nix][@1] is the primary package management tool used for managing packages in
my development environment. See the related [architecture][@2] section for more
details on how it fits into the overall environment.

## Resources

- [Website][@3]
- [Documentation][@4]
- [Wiki][@5]
- [Nix Pills][@6]
- [Nix DevOps][@7]

## Install

The [official installation script][@8] will do most of the work:

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
tested and had success using the instructions in this [Github Issue][@9].

Note that it's possible to run the installer again even with a dirty system and
it *should* do the right thing.

<!-- reference links -->

[@1]: https://nixos.org/
[@2]: ../../architecture.md#nix
[@3]: https://nixos.org/
[@4]: https://nixos.org/manual/nix/stable/
[@5]: https://nixos.wiki/
[@6]: https://nixos.org/guides/nix-pills/
[@7]: https://nix.dev/
[@8]: https://nixos.org/download.html#nix-install-macos
[@9]: https://github.com/NixOS/nix/issues/3900#issuecomment-716916990
