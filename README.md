# drip

Gleam monorepo containing:

- [`core`](core/) — core library
- [`cli`](cli/) — command-line interface
- [`docs`](docs/) — documentation

## Setup

After cloning, point Git at the shared hooks directory so the commit-message check runs locally:

```sh
git config core.hooksPath .githooks
```

Commits must follow [Conventional Commits](https://www.conventionalcommits.org/).
