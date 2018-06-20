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

/** Get the path for something being used as a type.
 *
 * This might be a class, interface, trait, or type alias.
 */
function get_path_for_type(
  IPathProvider<?string> $p,
  string $name,
): ?string {
  return $p->getPathForClass($name) ??
    $p->getPathForInterface($name) ??
    $p->getPathForTrait($name) ??
    $p->getPathForTransparentTypeAlias($name) ??
    $p->getPathForOpaqueTypeAlias($name);
}
