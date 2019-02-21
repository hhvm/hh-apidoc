/*
 *  Copyright (c) 2018-present, Facebook, Inc.
 *  All rights reserved.
 *
 *  This source code is licensed under the MIT license found in the
 *  LICENSE file in the root directory of this source tree.
 *
 */

namespace Facebook\HHAPIDoc;

use namespace HH\Lib\Str;

/** A path provider where all the documents should be in the same directory */
final class SingleDirectoryPathProvider implements IPathProvider<string> {
  /** Create an instance.
   *
   * @param $extension the filename extension to use - for example, `.md` or
   *   `.html`
   */
  public function __construct(
    private string $extension,
  ) {
  }

  private function escape(string $in): string {
    return Str\replace($in, '\\', '.');
  }

  public function getPathForClass(string $class): string {
    return 'class.'.$this->escape($class).$this->extension;
  }

  public function getPathForInterface(string $interface): string {
    return 'interface.'.$this->escape($interface).$this->extension;
  }

  public function getPathForTrait(string $trait): string {
    return 'trait.'.$this->escape($trait).$this->extension;
  }

  public function getPathForClassMethod(
    string $class,
    string $method,
  ): string {
    return $this->getPathForClass($class)
      |> Str\strip_suffix($$, $this->extension)
      |> $$.'.'.$this->escape($method).$this->extension;
  }

  public function getPathForInterfaceMethod(
    string $interface,
    string $method,
  ): string {
    return $this->getPathForInterface($interface)
      |> Str\strip_suffix($$, $this->extension)
      |> $$.'.'.$this->escape($method).$this->extension;
  }

  public function getPathForTraitMethod(
    string $trait,
    string $method,
  ): string {
    return $this->getPathForTrait($trait)
      |> Str\strip_suffix($$, $this->extension)
      |> $$.'.'.$this->escape($method).$this->extension;
  }

  public function getPathForFunction(string $function): string {
    return 'function.'.$this->escape($function).$this->extension;
  }

  public function getPathForTransparentTypeAlias(string $name): string {
    return 'type.'.$this->escape($name).$this->extension;
  }

  public function getPathForOpaqueTypeAlias(string $name): string {
    return 'newtype.'.$this->escape($name).$this->extension;
  }
}
