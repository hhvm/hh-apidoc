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

use namespace HH\Lib\C;

/** A path provider that wraps another path provider, and returns `null` if
 * items aren't present in the index */
final class IndexedPathProvider implements IPathProvider<?string> {
  /** Create an instance
   *
   * @param $index an index of all valid documentable names
   * @param $paths a path provider to wrap
   */
  public function __construct(
    private Index $index,
    private IPathProvider<?string> $paths,
  ) {
  }

  public function getPathForClass(string $class): ?string {
    if (!C\contains_key($this->index['classes'], $class)) {
      return null;
    }
    return $this->paths->getPathForClass($class);
  }

  public function getPathForInterface(string $interface): ?string {
    if (!C\contains_key($this->index['interfaces'], $interface)) {
      return null;
    }
    return $this->paths->getPathForInterface($interface);
  }

  public function getPathForTrait(string $trait): ?string {
    if (!C\contains_key($this->index['traits'], $trait)) {
      return null;
    }
    return $this->paths->getPathForTrait($trait);
  }

  public function getPathForClassMethod(
    string $class,
    string $method,
  ): ?string {
    if (!C\contains_key($this->index['classes'][$class] ?? keyset[], $method)) {
      return null;
    }
    return $this->paths->getPathForClassMethod($class, $method);
  }

  public function getPathForInterfaceMethod(
    string $interface,
    string $method,
  ): ?string {
    if (
      !C\contains_key(
        $this->index['interfaces'][$interface] ?? keyset[],
        $method,
      )
    ) {
      return null;
    }
    return $this->paths->getPathForInterfaceMethod($interface, $method);
  }

  public function getPathForTraitMethod(
    string $trait,
    string $method,
  ): ?string {
    if (!C\contains_key($this->index['traits'][$trait] ?? keyset[], $method)) {
      return null;
    }
    return $this->paths->getPathForTraitMethod($trait, $method);
  }

  public function getPathForFunction(string $function): ?string {
    if (!C\contains_key($this->index['functions'], $function)) {
      return null;
    }
    return $this->paths->getPathForFunction($function);
  }

  public function getPathForOpaqueTypeAlias(string $name): ?string {
    if (!C\contains_key($this->index['newtypes'], $name)) {
      return null;
    }
    return $this->paths->getPathForOpaqueTypeAlias($name);
  }

  public function getPathForTransparentTypeAlias(string $name): ?string {
    if (!C\contains_key($this->index['types'], $name)) {
      return null;
    }
    return $this->paths->getPathForTransparentTypeAlias($name);
  }
}
