#!/bin/sh
set -ex
apt update -y
DEBIAN_FRONTEND=noninteractive apt install -y php-cli zip unzip
hhvm --version
php --version

(
  cd $(mktemp -d)
  curl https://getcomposer.org/installer | php -- --install-dir=/usr/local/bin --filename=composer --version="1.9.3"
)
hhvm --php -d hhvm.jit=0 -r "echo HHVM_VERSION;"
composer install

hh_client
# Look ma, no tests!
# vendor/bin/hacktest tests/
vendor/bin/hhast-lint

bin/hh-apidoc -o docs src
git add docs/
if ! git diff --quiet --cached; then
  echo "Documentation needs regenerating."
  exit
fi
