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

/** An index of all the `Documentable`s that we should act on.
 *
 * This can be used for auto-linking, generating index documented, or other
 * purposes */
type Index = shape(
  /** A list of all transparent type aliases */
  'types' => keyset<string>,
  /** A list of all opaque type aliases */
  'newtypes' => keyset<string>,
  /** A list of all function names */
  'functions' => keyset<string>,
  /** A map from class names to a list of method names */
  'classes' => dict<string, keyset<string>>,
  /** A map from interfaces names to a list of method names */
  'interfaces' => dict<string, keyset<string>>,
  /** A map from trait names to a list of method names */
  'traits' => dict<string, keyset<string>>,
);
