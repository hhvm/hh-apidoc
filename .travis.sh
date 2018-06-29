#!/bin/sh
set -ex
hhvm --version

composer install --ignore-platform-reqs

hh_client

# Make sure it 'works'
hhvm bin/hh-apidoc -o docs src/
# Make sure it lints
hhvm vendor/bin/hhast-lint

git add docs/
if ! git diff --quiet --cached; then
  echo "Documentation needs regenerating."
  exit 1
fi
