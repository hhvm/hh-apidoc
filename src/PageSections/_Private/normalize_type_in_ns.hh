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

use namespace HH\Lib\Str;

function normalize_type_in_ns(
  string $type,
  string $ns,
): string {
  if ($ns === '') {
    return $type;
  }
  $ns .= "\\";
  if (Str\starts_with($type, $ns)) {
    return Str\strip_prefix($type, $ns);
  }
  return "\\".$type;
}
