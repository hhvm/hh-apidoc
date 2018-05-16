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
  /** @selfdocumenting */
  'functions' => keyset<string>,
  /** @selfdocumenting */
  'classes' => dict<string, keyset<string>>,
  /** @selfdocumenting */
  'interfaces' => dict<string, keyset<string>>,
  /** @selfdocumenting */
  'traits' => dict<string, keyset<string>>,
);
