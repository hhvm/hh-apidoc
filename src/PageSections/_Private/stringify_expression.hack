/*
 *  Copyright (c) 2018-present, Facebook, Inc.
 *  All rights reserved.
 *
 *  This source code is licensed under the MIT license found in the
 *  LICENSE file in the root directory of this source tree.
 *
 */

namespace Facebook\HHAPIDoc\PageSections\_Private;

use type Facebook\DefinitionFinder\ScannedExpression;
use function Facebook\DefinitionFinder\ast_without_trivia;

function stringify_expression(
  ScannedExpression $e
): string {
  if ($e->hasStaticValue()) {
    return \var_export($e->getStaticValue(), true);
  }
  return ast_without_trivia($e->getAST()->getCode());
}
