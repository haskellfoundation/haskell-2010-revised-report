# Haskell 2010 Revised Language Report

This repository contains the files required to build the revised version of the Haskell 2010 language report.
Both the HTML and the PDF version of the latest draft are available:

- For the HTML version: [haskell.foundation/haskell-2010-revised-report/](https://haskell.foundation/haskell-2010-revised-report/)
- For the PDF version: [haskell.foundation/haskell-2010-revised-report/haskell-2010-revised.pdf](https://haskell.foundation/haskell-2010-revised-report/haskell-2010-revised.pdf)

Note that the layout of both versions is not final, and that presentation of the HTML version in particular has not been optimized yet.

## How to Build the PDF report

In order to build the report you have to install Typst version `0.15` or later.
Typst is available at [typst.app/](https://typst.app/).

The `Makefile` contains a target to build the report, but the two following commands also work:

```console
> typst compile haskell-2010-revised.typ
```
builds the report in pdf form.

```console
> typst watch haskell-2010-revised.typ
```
continuously watches for file changes and rebuilds the pdf on every change.

## Building HTML

The `Makefile` contains a html target, but the layout has not yet been optimized for HTML, and there are various bugs that have to be fixed.

## Building the Standard Library Documentation

The standard library is now available as a Haskell package which exposes the API defined by the Haskell 2010 report in the [stdlib](./stdlib/) subdirectory.
This library exposes the specified API of the report, but does not provide any implementation of the exposed functions. You can build the API documentation as follows:

```console
> cd stdlib
> cabal haddock
```

## How to Contribute

The contribution process is documented in [CONTRIBUTING.md](CONTRIBUTING.md)

We have adopted the [Haskell Foundation Guidelines for Respectful Communication](https://haskell.foundation/guidelines-for-respectful-communication/) for this project.

## WG Members

The working group for editing the revised report consists of the following members:

| Name                        | GitHub Handle | Other    |
| --------------------------- | ------------- | -------- |
| David Binder                | @BinderDavid  | chair    |
| Mike Pilgrem                | @mpilgrem     |          |
| Freddy Cubas                | @superstar64  |          |
| Benjamin M                  | @L0neGamer    |          |
| Jaro Reinders               | @noughtmare   |          |
| Mario Blažević              | @blamario     |          |
| Mirek Kratochvil            | @exaexa       | co-chair |
| Adam Gundry                 | @adamgundry   |          |
| Jack Kelly                  | @endgame      |          |
| José Manuel Calderón Trilla | @jmct         |          |
| Brendan Lane                | @gilgamec     |          |

## References and Prior Work

- The verb/latex sources for the Haskell 2010 language report are available at [github.com/haskell/haskell-report](https://github.com/haskell/haskell-report)
- The discussions of the Haskell Prime committee are archived at [github.com/haskell/rfcs](https://github.com/haskell/rfcs)
- The Haskell Prime mailing list archive is available [here](https://mailman.haskell.org/mailman3/lists/haskell-prime.haskell.org/)
- The Monad of no return proposal is available [here](https://gitlab.haskell.org/ghc/ghc/-/wikis/proposal/monad-of-no-return)
- The MonadFail proposal is available [here](https://gitlab.haskell.org/haskell/prime/-/wikis/libraries/proposals/monad-fail)
- The Functor-Applicative-Monad proposal is available [here](https://wiki.haskell.org/Functor-Applicative-Monad_Proposal)
- The Foldable-Traversable ("Burning Bridges") proposal is available [here](https://wiki.haskell.org/Foldable_Traversable_In_Prelude)