# Chezmoi

[Chezmoi][@1] is the gate-keeper for managing my personal dotfiles. It enables
seamless version controlling of dotfiles to enable easier recovery and sharing
of dotfiles.

## Install

Chezmoi is automatically installed by Nix during the bootstrap process.

## Usage

### Editing

To edit a dotfile:

```bash
chezmoi edit ~/.bashrc
```

By default, Chezmoi is configured to open files with VSCode. Editing the
dotfiles directly in the home directory is not recommended as it bypasses the
syncing that Chezmoi performs.

Once edits have been made, they must be applied before they will take effect in
the home directory:

```bash
chezmoi apply
```

If the dotfiles were edited directly before calling this, a chance is given to
not have the changes clobbered by performing a merge. Otherwise, the local
dotfiles will be updated with the previous changes.

Note that some dotfiles have triggers that occur on edits. For example, the
`.nixpkgs/darwin-configuration.nix` automatically invokes
`darwin-rebuild switch` in order to apply the edits immediately.

### Committing

Once changes have been tested they should be committed and pushed up to the
remote repository. You can either change into the source directory directly and
invoke git:

```bash
cd ~/.local/share/chezmoi
git status
```

Or, you can invoke git through Chezmoi:

```bash
chezmoi git status
```

## Templates

Some dotfiles appear as templates in the source directory (denoted with the
`.tmpl` file extension). When applied, these files create their respective files
in the home directory (i.e. `dot_foo.tmpl` becomes `.foo`).

Most templates make use of a secret integration for pulling down sensitive
information during an `apply`. See the [docs][@2] for more details on how this
works.

Note that because of this secret integration, you may be prompted to
authenticate when performing an `apply` operation. This can be avoided by
specifying the exact file to apply and thus avoid having to apply templates
which rely on secrets:

```bash
chezmoi apply ~/.exports
```

<!-- reference links -->

[@1]: https://www.chezmoi.io/
[@2]: https://www.chezmoi.io/user-guide/password-managers/
