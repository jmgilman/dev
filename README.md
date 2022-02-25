# Developer's Handbook

<p align="center">
    <a href="https://github.com/jmgilman/dev/actions/workflows/ci.yml">
        <img src="https://github.com/jmgilman/dev/actions/workflows/ci.yml/badge.svg"/>
    </a>
    <a href="https://app.netlify.com/sites/practical-blackwell-d2afc6/overview">
        <img src="https://img.shields.io/netlify/293d39e0-4467-4cd4-8787-3a49b2824e51"/>
    </a>
</p>

This repository contains the source for my personal development handbook. The
deployed version of it can be [seen here](https://dev.jmgilman.com/).

## Development

All dependencies are bundled in a [Nix](https://nixos.org/) flake. If you have
[direnv](https://direnv.net/) configured and installed, you can simply `cd` into
the repository and allow the `.envrc` file to drop you into an isolated
development enviroment. Otheriwse ensure you call `nix develop`.

If you don't want to use Nix, you'll need to ensure you have the following
available:

- [Poetry](https://python-poetry.org/)
- [Markdownlint](https://github.com/markdownlint/markdownlint)
- [Pre-Commit](https://pre-commit.com/)

Then install the Python dependencies:

```bash
poetry install
```

## Building

The handbook is built using [MkDocs](https://www.mkdocs.org/). To build the
handbook:

```bash
mkdocs build
```

The site contents will be availabe in the `site/` subdirectory.

## Publishing

The project uses [Netlify](https://www.netlify.com/) for deployment. Any pushes
to the master branch are automatically deployed to Netlify.

## Contributing

Check out the [issues][1] for items needing attention or submit your own and
then:

1. [Fork the repo][2]
1. Create your feature branch (git checkout -b feature/fooBar)
1. Commit your changes (git commit -am 'Add some fooBar')
1. Push to the branch (git push origin feature/fooBar)
1. Create a new Pull Request

[1]: https://github.com/jmgilman/dev/issues
[2]: https://github.com/jmgilman/dev/fork
