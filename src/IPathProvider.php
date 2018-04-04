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

interface IPathProvider<+T as ?string> {
  public function getPathForClass(string $class): T;
  public function getPathForInterface(string $interface): T;
  public function getPathForTrait(string $trait): T;

  public function getPathForClassMethod(string $class, string $method): T;
  public function getPathForInterfaceMethod(
    string $interface,
    string $method,
  ): T;
  public function getPathForTraitMethod(string $trait, string $method): T;

  public function getPathForFunction(string $function): T;
}
