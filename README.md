# hh-apidoc

An API documentation generator for Hack files. The generator works on files that start with `<?hh`.

## Installing hh-apidoc

1. [Install hhvm](https://docs.hhvm.com/hhvm/installation/introduction)
1. [Install composer](https://getcomposer.org/download/)
1. Move `composer.phar` to your desired location. Many people put this in their home directory or a global `bin` directory.
1. Clone this repo
1. `cd path/to/cloned/hh-apidoc`
1. `hhvm path/to/composer.phar install`
1. Verify installation via `hhvm bin/hh-apidoc --help`. You should see usage instructions.

## Testing hh-apidoc

The [Hack Standard Library](https://github.com/hhvm/hsl) is a good place to test the generator.

1. Clone the [HSL](https://github.com/hhvm/hsl) repo.
1. `cd path/to/cloned/hsl`
1. `hhvm bin/hh-apidoc -o /tmp/hsl-docs ./src` The `-o` is where to output the resulting files (it is important to note that the path given to `-o` must currently be an existing path). `.` means use the current directory as the source.
1. `cd /tmp/hsl-docs`
1. See generated `.html` files. You can open `index.html` in your favorite browser to see the generated documentation.

## License

hh-apidoc is MIT licensed, as found in the LICENSE file.
