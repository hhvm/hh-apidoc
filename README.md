# hh-apidoc

[![Continuous Integration](https://github.com/hhvm/hh-apidoc/actions/workflows/build-and-test.yml/badge.svg)](https://github.com/hhvm/hh-apidoc/actions/workflows/build-and-test.yml)

An API documentation generator for Hack files. The generator works on files that start with `<?hh`.

## Example

HHAPIDoc generates its own
[API reference documentation](https://hhvm.github.io/hh-apidoc/).

## Project status

This is derived from docs.hhvm.com's documentation generator, and has been in use there for several months.

As a standalone project, it is immature, and an early preview; work is needed on output format (prettiness), usability, and functionality.
See [the issues](https://github.com/hhvm/hh-apidoc/issues) to get started. We [welcome contributions](CONTRIBUTING.md).

## Installing hh-apidoc

1. [Install hhvm](https://docs.hhvm.com/hhvm/installation/introduction)
1. [Install composer](https://getcomposer.org/download/)
1. Move `composer.phar` to your desired location. Many people put this in their home directory or a global `bin` directory.
1. Clone this repo
1. `cd path/to/cloned/hh-apidoc`
1. `hhvm path/to/composer.phar install`
1. Verify installation via `hhvm bin/hh-apidoc --help`. You should see usage instructions.

## Testing hh-apidoc

Running `hh-apidoc` against itself is a good way to test the generator:

1. `hhvm bin/hh-apidoc -o /tmp/docs ./src` The `-o` is where to output the resulting files (it is important to note that the path given to `-o` must currently be an existing path). `.` means use the current directory as the source.
1. `cd /tmp/docs`
1. See generated `.html` files. You can open `index.html` in your favorite browser to see the generated documentation.

## License

hh-apidoc is MIT licensed, as found in the LICENSE file.
