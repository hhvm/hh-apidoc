/*
 *  Copyright (c) 2018-present, Facebook, Inc.
 *  All rights reserved.
 *
 *  This source code is licensed under the MIT license found in the
 *  LICENSE file in the root directory of this source tree.
 *
 */

namespace Facebook\HHAPIDoc\PageSections\_Private;

use namespace Facebook\TypeAssert;
use namespace Facebook\HHAPIDoc\DocBlock;
use type Facebook\DefinitionFinder\ScannedParameter;
use namespace HH\Lib\Str;

function stringify_parameter(
  string $ns,
  ScannedParameter $parameter,
  ?DocBlock\ParameterInfo $docs,
): string {
  $s = '';

  if ($parameter->isInOut()) {
    $s .= 'inout ';
  }

  $types = $docs['types'] ?? vec[];
  $typehint = $parameter->getTypehint();
  if ($types) {
    $s .= Str\join($types, '|').' ';
  } else if ($typehint) {
    $s .= stringify_typehint($ns, $typehint).' ';
  }

  if ($parameter->isVariadic()) {
    $s .= '...';
  }
  $s .= '$'.$parameter->getName();

  if ($parameter->isOptional()) {
    $default = TypeAssert\not_null($parameter->getDefault());
    if ($default->hasStaticValue()) {
      $s .= ' = '.\var_export($default->getStaticValue(), true);
    } else {
      $s .= ' = '.Str\trim($default->getAST()->getCode());
    }
  }

  return $s;
}
