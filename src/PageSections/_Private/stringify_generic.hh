<?hh // strict
/*
 *  Copyright (c) 2018-present, Facebook, Inc.
 *  All rights reserved.
 *
 *  This source code is licensed under the MIT license found in the
 *  LICENSE file in the root directory of this source tree.
 *
 */

namespace Facebook\HHAPIDoc\PageSections\_Private;

use type Facebook\DefinitionFinder\ScannedGeneric;
use namespace HH\Lib\{C, Str, Vec};

function stringify_generic(
  string $ns,
  ScannedGeneric $generic,
): string {
  if ($generic->isCovariant()) {
    $base = '+';
  } else if ($generic->isContravariant()) {
    $base = '-';
  } else {
    $base = '';
  }
  $base .= ns_normalize_type($ns, $generic->getName());

  $constraints = $generic->getConstraints();
  if (C\is_empty($constraints)) {
    return $base;
  }

  return $constraints
    |> Vec\map($$, $c ==> $c['relationship'].' '.$c['type']->getTypeText())
    |> Str\join($$, ' ')
    |> $base.' '.$$;
}
