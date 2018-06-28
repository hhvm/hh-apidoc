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

use namespace Facebook\TypeAssert;
use namespace Facebook\HHAPIDoc\DocBlock;
use type Facebook\DefinitionFinder\ScannedParameter;
use namespace HH\Lib\{C, Str, Vec};

function stringify_parameter(
  string $ns,
  ScannedParameter $parameter,
  ?DocBlock\ParameterInfo $docs,
): string {
  $s = '';

  $types = $docs['types'] ?? null;
  if ($types) {
    $s .= Str\join($types, '|').' ';
  } else if ($th = $parameter->getTypehint()) {
    $s .= stringify_typehint($ns, $th).' ';
  }

  if ($parameter->isVariadic()) {
    $s .= '...';
  }
  if ($parameter->isPassedByReference()) {
    $s .= '&';
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
