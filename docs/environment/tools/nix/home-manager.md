# Home-Manager

The [home-manager](https://github.com/nix-community/home-manager) project
provides a framework for managing user environments using [Nix](index.md). It
adopts the same declarative approach for defining how user environments should
be configured including what packages are available, how to configure dotfiles,
and other related settings.

## Resources

- [Repository](https://github.com/nix-community/home-manager)
- [Wiki](https://nixos.wiki/wiki/Home_Manager)
- [My dotfile](https://github.com/jmgilman/dotfiles/blob/master/dot_nixpkgs/darwin-configuration.nix)

## Install

The project is installed via integration with [nix-darwin](nix-darwin.md). This
greatly reduces the complexity of managing the environment as everything is
contained within a single file.

Example:

```nix
  # home-manager configuration
  imports = [ <home-manager/nix-darwin> ];
  users.users.josh = {
    name = "josh";
    home = "/Users/josh";
  };

  home-manager.users.josh = { pkgs, ... }: {
    # User-specific packages
    home.packages = [  ];

    # ...
```

## Usage

Configuration is done through the `nix-darwin`
[configuration file](nix-darwin.md#update-configuration). The options available
are very wide-ranging but the general format is best understood by looking at
the [source](https://github.com/nix-community/home-manager/tree/master/modules).
For example, it's possible to configure `zsh` which is located under the
`programs` module (`modules/programs/zsh.nix`). Looking at the associated
[file](https://github.com/nix-community/home-manager/blob/master/modules/programs/zsh.nix)
reveals the general configuration structure for the program. To enable `zsh` for
a user you would set:

```nix
programs.zsh.enable = true;
```

Most of the configuration for the development environment is done via
[zsh](https://www.zsh.org/) and [oh-my-zsh](https://ohmyz.sh/). The
`home-manager` configuration provides dedicated sections for both of the tools.
The remainder of this section contains pointers for how to achieve specific
goals within the configuration.

### Modify .zshrc

`home-manager` is responsible for maintaining the `zsh` associated dotfiles.
This is most apparent by inspecting the file itself:

```bash
$ ls -l ~/.zshrc
lrwxr-xr-x 1 josh 69 Feb 23 14:42 /Users/josh/.zshrc -> /nix/store/21xfmf3jzrlzlimsv4glyf59cpvibm7h-home-manager-files/.zshrc
```

Since the symlink resides in the Nix store it is therefore immutable and any
attempts to write to the dotfile will be prevented. The proper way to add
content to the dotfiles managed by `home-manager` is through the configuration.
For example, to add arbitrary content to the `.envrc` file, modify the
`programs.zsh.initExtra` property:

```nix
# ...
    programs.zsh = {
      initExtra = ''
        echo "Hello!"
      ''
    };
# ...
```

### Adding zsh plugins

`home-manager` manages all plugins for `zsh`, including the ones for
`oh-my-zsh`. Adding a plugin involves editing the `home-manager` configuration.
To add an official `oh-my-zsh` plugin:

```nix
# ...
    programs.zsh = {
      oh-my-zsh = {
        enable = true;
        plugins = [
            "my-plugin"
        ];
      };
    };
# ...
```

Alternatively, a plugin can be manually installed from source:

```nix
    programs.zsh = {
      plugins = [
        {
          name = "you-should-use";
          src = pkgs.fetchFromGitHub {
            owner = "MichaelAquilina";
            repo = "zsh-you-should-use";
            rev = "1.7.3";
            sha256 = "/uVFyplnlg9mETMi7myIndO6IG7Wr9M7xDFfY1pG5Lc=";
          };
        }
      ];
    };
```
