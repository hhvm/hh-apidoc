#!/usr/bin/env hhvm
/*
 *  Copyright (c) 2004-present, Facebook, Inc.
 *  All rights reserved.
 *
 *  This source code is licensed under the MIT license found in the
 *  LICENSE file in the root directory of this source tree.
 *
 */

namespace Facebook\HHAPIDoc;

<<__EntryPoint>>
async function cli_main(): Awaitable<noreturn> {
  $root = \realpath(__DIR__.'/..');
  $found_autoloader = false;
  while (true) {
    $autoloader = $root.'/vendor/autoload.hack';
    if (\file_exists($autoloader)) {
      $found_autoloader = true;
      require_once($autoloader);
      break;
    }
    if ($root === '') {
      break;
    }
    $parts = \explode('/', $root);
    \array_pop(inout $parts);
    $root = \implode('/', $parts);
  }

  if (!$found_autoloader) {
    \fprintf(\STDERR, "Failed to find autoloader.\n");
    exit(1);
  }

  \Facebook\AutoloadMap\initialize();

  $exit_code = await GeneratorCLI::runAsync();
  exit($exit_code);
}
