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

use type Facebook\DefinitionFinder\ScannedTypehint;
use namespace HH\Lib\{C, Str, Vec};

function stringify_typehint(
  string $ns,
  ScannedTypehint $type,
): string {
  $s = $type->isNullable() ? '?' : '';
  $s .= ns_normalize_type($ns, $type->getTypeName());

  $generics = $type->getGenericTypes();
  if (C\is_empty($generics)) {
    return $s;
  }

  $s .= $generics
    |> Vec\map($$, $sub ==> stringify_typehint($ns, $sub))
    |> Str\join($$, ', ')
    |> '<'.$$.'>';

  return $s;
}
