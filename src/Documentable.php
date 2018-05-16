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
  ScannedBase,
  ScannedClass,
};

/** Something that can be documented.
 *
 * This includes things like classes, functions, methods, etc.
 */
type Documentable = shape(
  /** The item being documented */
  'definition' => ScannedBase,
  /** The definition that contains this definition, if any.
   *
   * This will be `null` for top-level definitions like classes and functions,
   * but for methods, this will be the containing class, interface, or trait.
   */
  'parent' => ?ScannedClass,
  /** The files that this definition was inferred from */
  'sources' => vec<string>,
);
