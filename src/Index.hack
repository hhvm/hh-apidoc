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
 * This can be used for auto-linking, generating index documents, or other
 * purposes */
type Index = shape(
  /** A list of all transparent type aliases */
  'types' => dict<string, Documentable>,
  /** A list of all opaque type aliases */
  'newtypes' => dict<string, Documentable>,
  /** A list of all functions */
  'functions' => dict<string, Documentable>,
  /** A list of all classes */
  'classes' => dict<string, Documentable>,
  /** A list of all interfaces */
  'interfaces' => dict<string, Documentable>,
  /** A list of all traits */
  'traits' => dict<string, Documentable>,
);
