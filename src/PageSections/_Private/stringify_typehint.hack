/*
 *  Copyright (c) 2018-present, Facebook, Inc.
 *  All rights reserved.
 *
 *  This source code is licensed under the MIT license found in the
 *  LICENSE file in the root directory of this source tree.
 *
 */

namespace Facebook\HHAPIDoc\PageSections\_Private;

use type Facebook\DefinitionFinder\{ScannedTypehint, TypeTextOptions};

/**
 * Render `$type` as concisely and unambiguously as possible in the current
 * namespace.
 */
function stringify_typehint(
  string $ns,
  ScannedTypehint $type,
): string {
  // This just delegates to the implementation in ScannedTypehint, but we keep
  // this function here to ensure that we always call getTypeText() consistently
  // with the same options.
  return $type->getTypeText($ns, TypeTextOptions::STRIP_AUTOIMPORTED_NAMESPACE);
}
