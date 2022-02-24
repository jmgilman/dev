# Direnv

The [direnv][@1] extension provides a method of automatically executing shell
code from a `.envrc` file when you `cd` into a directory. It allows
accomplishing numerous things, most notably setting up a shell environment in
the context of a specific project.

## Install

The `direnv` extension is managed by [home-manager][@2]:

```nix linenums="1"
# ...
    programs.direnv = {
      enable = true;
      nix-direnv = {
        enable = true;
      };
    };
# ...
```

The [nix-direnv][@3] package is also installed to provide Nix integration.

## Usage

The main premise of `direnv` is to load `.envrc` files it finds when changing
into a directory. The contents of the `.envrc` file is shell code. The most
common use case is loading environment variables that make sense in the context
of the directory.

My development environment primarily utilizes this functionality to enter
contextualized [nix shells][@4]. A [flake.nix][@5] file located at the root of
the project is responsible for defining the dependencies needed to develop the
project and the `nix-direnv` integration will automatically create a new shell
environment loaded with these dependencies upon entering the directory.

The result of this is isolated environments for each project which include all
the dependnecies necessary to develop against the specific project.

### Example

The easiest way to understand usage is through an example. Let's say we have a
Python project that targets Python 3.10 and uses the [poetry][@6] package
manager for managing dependencies. Ideally, when we develop in this environment
we want to ensure that an isolated copy of Python 3.10 is available and in which
`poetry` has been installed. This would be the `flake.nix`:

```nix linenums="1"
{
  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs";
    flake-utils.url = "github:numtide/flake-utils";
  };

  outputs = { self, nixpkgs, flake-utils }:
    flake-utils.lib.eachDefaultSystem (system:
      let pkgs = nixpkgs.legacyPackages.${system};
      in {
        devShell = pkgs.mkShell {
          buildInputs = [
            pkgs.python310 (
              pkgs.poetry.override { python = pkgs.python310; }
            )
          ];
        };
      });
}
```

On line 11 we define a new development shell and then specify `pkgs.Python310`
as an input. This will ensure that the latest patch version of Python 3.10 is
available in the environment. Additionally, we include the `pkgs.poetry` package
which is responsible for ensuring `poetry` is available. The bit on line 14
overrides the Python being used by the `pkgs.poetry` package to be the same as
the one the rest of the environment depends on. This ensures that we don't
accidently install `poetry` against a different version of Python which can
cause some strange configuration errors.

With the above flake, we can now create our `.envrc` file:

```bash linenums="1"
use flake
source $(poetry env info --path)/bin/activate
```

The `use flake` magic comes from the `nix-direnv` integration and basically
instructs `direnv` to load our `flake.nix`. In addition to this, we also
automatically activate our `poetry` context. The result is that when we `cd`
into this directory we'll be dropped into an isolated shell with our `poetry`
dependencies already available to us.

<!-- reference links -->

[@1]: https://direnv.net/
[@2]: nix/home-manager.md
[@3]: https://github.com/nix-community/nix-direnv
[@4]: https://nixos.org/manual/nix/stable/command-ref/new-cli/nix3-develop.html
[@5]: https://nixos.wiki/wiki/Flakes
[@6]: https://python-poetry.org/
