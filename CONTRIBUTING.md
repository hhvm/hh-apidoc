# Contributing to hh-apidoc
We want to make contributing to this project as easy and transparent as
possible.

## Our Development Process

This project is developed in the 'master' branch on GitHub. Changes should be
submitted as pull requests.

Usually, versions will be tagged directly from master; if changes are needed to
an old release, a branch will be cut from the previous release in that series - e.g.
v1.2.3 might be tagged from a `1.2.x` branch.

## Pull Requests
We actively welcome your pull requests.
1. Fork the repo and create your branch from `master`.
2. If you've added code that should be tested, add tests
3. Ensure the test suite passes and the example still work
4. If you haven't already, complete the Contributor License Agreement ("CLA").

## Contributor License Agreement ("CLA")
In order to accept your pull request, we need you to submit a CLA. You only need
to do this once to work on any of Facebook's open source projects.

Complete your CLA here: <https://code.facebook.com/cla>

## Issues
We use GitHub issues to track public bugs. Please ensure your description is
clear and has sufficient instructions to be able to reproduce the issue.

Facebook has a [bounty program](https://www.facebook.com/whitehat/) for the safe
disclosure of security bugs. In those cases, please go through the process
outlined on that page and do not file a public issue.

## Core Components

- `Facebook\HHAPIDoc\DocBlock`: A Docblock parser, exposing summary,
  description, tags and so on.
- `Facebook\HHAPIDoc\PageSections`: Parts of documentation pages. These take a
  `Documentable`, and produce Markdown (or nothing, if the section doesn't
  handle that type. For example, the `ShapeFields` section produces nothing
  for most pages, but produces detailed information for type aliases that
  resolve to shape.
- `Facebook\HHAPIDoc/MarkdownExt`: Extensions to
  [fbmarkdown](https://github.com/hhvm/fbmarkdown); for example, `myfunc()` or
  `MyType` in backticks gets automatically linked to the relevant page, and
  syntax highlighting.
- `Facebook\HHAPIDoc\Documentable`: a thing that we might want to generate
  a page for. This includes a `ScannedDefinition` from
  [definition-finder](https://github.com/hhvm/definition-finder), a list of the
  files used to generate the definition, and an optional parent definition; for
  example, methods have parents (the containing class), functions don't.

## API Reference

https://hhvm.github.io/hh-apidoc/

## Coding Style
* 2 spaces for indentation rather than tabs
* 80 character line length
* Please be consistent with the existing code style

`hackfmt` or in-IDE code formatting (in 3.27+) and `hhast-lint` will
enforce most of the rules.

## License
By contributing HH-APIDoc, you agree that your contributions will be licensed
under its MIT license.
