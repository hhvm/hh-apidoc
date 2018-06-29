#!/bin/sh
set -ex
hhvm --version

hh_client

# Make sure it 'works'
hhvm bin/hh-apidoc -o docs src/
# Make sure it lints
hhvm vendor/bin/hhast-lint
