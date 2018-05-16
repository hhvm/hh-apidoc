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

/** Get paths for documentable definitions.
 *
 * These are used to:
 * - generate links
 * - decide where to create files containing documentation
 *
 * If `T` is nullable, it should return null if the definition does not exist.
 *
 * @see IndexedPathProvider
 */
interface IPathProvider<+T as ?string> {
  /** @selfdocumenting */
  public function getPathForClass(string $class): T;
  /** @selfdocumenting */
  public function getPathForInterface(string $interface): T;
  /** @selfdocumenting */
  public function getPathForTrait(string $trait): T;

  /** @selfdocumenting */
  public function getPathForClassMethod(string $class, string $method): T;
  /** @selfdocumenting */
  public function getPathForInterfaceMethod(
    string $interface,
    string $method,
  ): T;
  /** @selfdocumenting */
  public function getPathForTraitMethod(string $trait, string $method): T;

  /** @selfdocumenting */
  public function getPathForFunction(string $function): T;
}
