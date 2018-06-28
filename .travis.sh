#!/bin/sh
set -ex
hhvm --version

hh_client

hhvm bin/hh-apidoc -o $(mktemp -d) src/
hhvm vendor/bin/hhast-lint
