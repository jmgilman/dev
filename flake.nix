{
  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs";
    flake-utils.url = "github:numtide/flake-utils";
    poetry2nix-src.url = github:nix-community/poetry2nix;
  };

  outputs = { self, nixpkgs, flake-utils, poetry2nix-src }:
    flake-utils.lib.eachDefaultSystem (system:
      let

        pkgs = import nixpkgs {
          inherit system;
          # Overrides poetry to use the specified python version
          # see: https://github.com/nix-community/poetry2nix/blob/master/overlay.nix
          overlays = [ poetry2nix-src.overlay ];
        };

        app = pkgs.poetry2nix.mkPoetryApplication {
          projectDir = ./.;
          python = pkgs.python310;
          preferWheels = true;
          # Common overrides to make python package builds more reliable
          # see: https://github.com/nix-community/poetry2nix/blob/master/overrides/default.nix
          overrides = [
            pkgs.poetry2nix.defaultPoetryOverrides
          ];
        };
      in {
        devShell = pkgs.mkShell {
          buildInputs = [
            pkgs.mdl
          ];
          inputsFrom = [app];
        };
      });
}
