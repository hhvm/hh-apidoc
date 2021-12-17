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
  ScannedClass,
  ScannedFunction,
  ScannedInterface,
  ScannedMethod,
  ScannedNewtype,
  ScannedTrait,
  ScannedType,
};

use namespace HH\Lib\{Str, Vec};

/** @selfdocumenting */
function create_index(
  Traversable<Documentable> $in,
  shape('hidePrivateNamespaces' => bool) $options,
): Index {
  $index = shape(
    'types' => dict[],
    'newtypes' => dict[],
    'functions' => dict[],
    'classes' => dict[],
    'interfaces' => dict[],
    'traits' => dict[],
  );

  if ($options['hidePrivateNamespaces']) {
    $in = Vec\filter($in, $def ==> {
      $namespace = $def['definition']->getNamespaceName();
      // Supports _Private and __Private
      return !Str\contains($namespace, '_Private');
    });
  }

  foreach ($in as $what) {
    $def = $what['definition'];
    $name = $def->getName();

    if ($def is ScannedFunction) {
      $index['functions'][$name] = $what;
      continue;
    }
    if ($def is ScannedType) {
      $index['types'][$name] = $what;
      continue;
    }
    if ($def is ScannedNewtype) {
      $index['newtypes'][$name] = $what;
      continue;
    }
    if ($def is ScannedClass) {
      $index['classes'][$name] = $what;
      continue;
    }

    if ($def is ScannedInterface) {
      $index['interfaces'][$name] = $what;
      continue;
    }

    if ($def is ScannedTrait) {
      $index['traits'][$name] = $what;
      continue;
    }

    invariant(
      $def is ScannedMethod,
      "Can't handle class %s",
      \get_class($def),
    );
  }
  return $index;
}
