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

function stringify_generics(
  string $ns,
  vec<ScannedGeneric> $generics,
): string {
  if (C\is_empty($generics)) {
    return '';
  }

  return $generics
    |> Vec\map($$, $g ==> stringify_generic($ns, $g))
    |> Str\join($$, ', ')
    |> '<'.$$.'>';
}
