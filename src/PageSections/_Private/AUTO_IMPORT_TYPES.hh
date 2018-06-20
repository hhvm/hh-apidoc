<?hh // strict
/*
 *  Copyright (c) 2018-present, Facebook, Inc.
 *  All rights reserved.
 *
 *  This source code is licensed under the MIT license found in the
 *  LICENSE file in the root directory of this source tree.
 *
 */

namespace Facebook\HHAPIDoc\PageSections\_Private;

const keyset<string> AUTO_IMPORT_TYPES = keyset[
  'string',
  'int',
  'float',
  'num',
  'bool',
  'vec',
  'dict',
  'keyset',
  'Awaitable',
  'Vector',
  'Map',
  'Set',
  'ImmVector',
  'ImmMap',
  'ImmSet',
  'Traversable',
  'KeyedTraversable',
  'Container',
  'KeyedContainer',
  'Iterator',
  'KeyedIterator',
  'Iterable',
  'KeyedIterable',
  'Collection',
  'KeyedCollection',
  'IMemoizeParam',
  'AsyncIterator',
  'AsyncGenerator',
  'TypeStructure',
  'shape',
];
