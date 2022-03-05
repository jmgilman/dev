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
deployed version of it can be [seen here][01].

## Development

All dependencies are bundled in a [Nix][02] flake:

```bash
nix develop
```

If you have [direnv][03] installed:

```bash
direnv allow
```

If you don't want to use Nix, you'll need to ensure you have the following
dependencies available:

- [Poetry][04]
- [Markdownlint][05]

Then install the Python dependencies:

```bash
poetry install
```

## Building

The handbook is built using [MkDocs][06]. To build the handbook:

```bash
mkdocs build
```

The site contents will be availabe in the `site/` subdirectory.

## Publishing

The project uses [Netlify][07] for deployment. Any pushes to the master branch
are automatically deployed to Netlify.

## Contributing

Check out the [issues][08] for items needing attention or submit your own and
then:

1. [Fork the repo][09]
1. Create your feature branch (git checkout -b feature/fooBar)
1. Commit your changes (git commit -am 'Add some fooBar')
1. Push to the branch (git push origin feature/fooBar)
1. Create a new Pull Request

[01]: https://dev.jmgilman.com/
[02]: https://nixos.org/
[03]: https://direnv.net/
[04]: https://python-poetry.org/
[05]: https://github.com/igorshubovych/markdownlint-cli
[06]: https://www.mkdocs.org/
[07]: https://www.netlify.com/
[08]: https://github.com/jmgilman/dev/issues
[09]: https://github.com/jmgilman/dev/fork
