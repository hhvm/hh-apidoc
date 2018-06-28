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
  ScannedClass,
  ScannedFunction,
  ScannedInterface,
  ScannedMethod,
  ScannedNewtype,
  ScannedTrait,
  ScannedType,
};

function get_path_for_documentable(
  IPathProvider<string> $provider,
  Documentable $what,
): string {
  $def = $what['definition'];
  if ($def instanceof ScannedClass) {
    return $provider->getPathForClass($def->getName());
  }
  if ($def instanceof ScannedInterface) {
    return $provider->getPathForInterface($def->getName());
  }
  if ($def instanceof ScannedTrait) {
    return $provider->getPathForTrait($def->getName());
  }
  if ($def instanceof ScannedFunction) {
    return $provider->getPathForFunction($def->getName());
  }
  if ($def instanceof ScannedType) {
    return $provider->getPathForTransparentTypeAlias($def->getName());
  }
  if ($def instanceof ScannedNewtype) {
    return $provider->getPathForOpaqueTypeAlias($def->getName());
  }
  if ($def instanceof ScannedMethod) {
    $p = $what['parent'];
    if ($p instanceof ScannedClass) {
      return $provider->getPathForClassMethod($p->getName(), $def->getName());
    }
    if ($p instanceof ScannedInterface) {
      return
        $provider->getPathForInterfaceMethod($p->getName(), $def->getName());
    }
    if ($p instanceof ScannedTrait) {
      return $provider->getPathForTraitMethod($p->getName(), $def->getName());
    }
  }
  invariant_violation("Failed to find path for %s", \get_class($def));
}
