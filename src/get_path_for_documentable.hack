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

function get_path_for_documentable(
  IPathProvider<?string> $provider,
  Documentable $what,
): ?string {
  $def = $what['definition'];
  if ($def is ScannedClass) {
    return $provider->getPathForClass($def->getName());
  }
  if ($def is ScannedInterface) {
    return $provider->getPathForInterface($def->getName());
  }
  if ($def is ScannedTrait) {
    return $provider->getPathForTrait($def->getName());
  }
  if ($def is ScannedFunction) {
    return $provider->getPathForFunction($def->getName());
  }
  if ($def is ScannedType) {
    return $provider->getPathForTransparentTypeAlias($def->getName());
  }
  if ($def is ScannedNewtype) {
    return $provider->getPathForOpaqueTypeAlias($def->getName());
  }
  if ($def is ScannedMethod) {
    $p = $what['parent'];
    if ($p is ScannedClass) {
      return $provider->getPathForClassMethod($p->getName(), $def->getName());
    }
    if ($p is ScannedInterface) {
      return
        $provider->getPathForInterfaceMethod($p->getName(), $def->getName());
    }
    if ($p is ScannedTrait) {
      return $provider->getPathForTraitMethod($p->getName(), $def->getName());
    }
  }
  invariant_violation('Failed to find path for %s', \get_class($def));
}
