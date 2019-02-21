/*
 *  Copyright (c) 2018-present, Facebook, Inc.
 *  All rights reserved.
 *
 *  This source code is licensed under the MIT license found in the
 *  LICENSE file in the root directory of this source tree.
 *
 */

namespace Facebook\HHAPIDoc\PageSections\_Private;

use namespace HH\Lib\{C, Str};

/** Render `$type` as concisely and unambiguously as possible in the current
 * namespace */
function ns_normalize_type(
  string $ns,
  string $type,
): string {
  if ($ns === '') {
    return $type;
  }

  if (C\contains_key(AUTO_IMPORT_TYPES, $type)) {
    return $type;
  }

  $ns .= "\\";
  if (Str\starts_with($type, $ns)) {
    return Str\strip_prefix($type, $ns);
  }
  return "\\".$type;
}
