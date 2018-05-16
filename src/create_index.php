<?hh // strict
/*
 *  Copyright (c) 2018-present, Facebook, Inc.
 *  All rights reserved.
 *
 *  This source code is licensed under the MIT license found in the
 *  LICENSE file in the root directory of this source tree.
 *
 */

namespace Facebook\HHAPIDoc;

use type Facebook\DefinitionFinder\{
  ScannedBasicClass,
  ScannedFunction,
  ScannedInterface,
  ScannedMethod,
  ScannedTrait,
};

use namespace HH\Lib\C;

/** @selfdocumenting */
function create_index(
  Traversable<Documentable> $in,
): Index {
  $index = shape(
    'functions' => keyset[],
    'classes' => dict[],
    'interfaces' => dict[],
    'traits' => dict[],
  );

  foreach ($in as $what) {
    $def = $what['definition'];
    $name = $def->getName();

    if ($def instanceof ScannedFunction) {
      $index['functions'][] = $name;
      continue;
    }
    if ($def instanceof ScannedBasicClass) {
      if (!C\contains_key($index['classes'], $name)) {
        $index['classes'][$def->getName()] = keyset[];
      }
      continue;
    }
    if ($def instanceof ScannedInterface) {
      if (!C\contains_key($index['interfaces'], $name)) {
        $index['interfaces'][$def->getName()] = keyset[];
      }
      continue;
    }
    if ($def instanceof ScannedTrait) {
      if (!C\contains_key($index['traits'], $name)) {
        $index['traits'][$def->getName()] = keyset[];
      }
      continue;
    }

    invariant(
      $def instanceof ScannedMethod,
      "Can't handle class %s",
      \get_class($def),
    );

    $p = $what['parent'];
    invariant($p !== null, 'got a method with null parent');
    $pn = $p->getName();
    if ($p instanceof ScannedBasicClass) {
      if (!C\contains_key($index['classes'], $pn)) {
        $index['classes'][$pn] = keyset[];
      }
      $index['classes'][$pn][] = $name;
      continue;
    }
    if ($p instanceof ScannedInterface) {
      if (!C\contains_key($index['interfaces'], $pn)) {
        $index['interfaces'][$pn] = keyset[];
      }
      $index['interfaces'][$pn][] = $name;
      continue;
    }
    if ($p instanceof ScannedTrait) {
      if (!C\contains_key($index['traits'], $pn)) {
        $index['traits'][$pn] = keyset[];
      }
      $index['traits'][$pn][] = $name;
      continue;
    }
    invariant_violation(
      "Can't handle parent type %s",
      \get_class($p),
    );
  }
  return $index;
}
