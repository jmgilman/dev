# Homebrew

[Homebrew](https://brew.sh/) provides package management for graphical
applications in the environment. It does this through a versioned Bundle file
that is tracked by Chezmoi.

## Resources

- [Website](https://brew.sh/)
- [Personal tap](https://github.com/jmgilman/homebrew-apps)

## Install

Run the installer script:

```bash
/bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
```

To download and install the `bundle` subcommand, invoke it at least once:

```bash
brew bundle
```

## Uninstall

Run the uninstaller script:

```bash
/bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/uninstall.sh)"
```

## Usage

### Adding applications

The configuration file is managed by Chezmoi and can be edited with:

```bash
chezmoi edit .brew
```

The format is straight-forward:

```text
cask "<app name>"
```

Some casks might require an additional tap:

```text
tap "owner/repo"
```

Once added:

```bash
chezmoi apply && brew bundle install
```

Don't forget to commit any changes!

### Upgrading applications

The `install` subcommand will also update applications:

```bash
brew bundle install
```
