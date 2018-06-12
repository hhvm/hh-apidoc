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

use type Facebook\HHAPIDoc\DocBlock\DocBlock;
use type Facebook\DefinitionFinder\{
  ScannedFunctionAbstract,
  ScannedMethod,
};
use namespace HH\Lib\{Str, Vec};

function stringify_functionish_signature(
  StringifyFormat $format,
  ScannedFunctionAbstract $function,
  ?DocBlock $docs,
): string {
  $ret = '';
  $ns = $function->getNamespaceName();
  if ($format === StringifyFormat::MULTI_LINE && $ns !== '') {
    $ret .= 'namespace '.$ns.";\n\n";
    $name = $function->getShortName();
  } else {
    $name = $function->getName();
  }

  if ($function instanceof ScannedMethod) {
    if ($function->isAbstract()) {
      $ret .= 'abstract ';
    }

    if ($function->isFinal()) {
      $ret .= 'final ';
    }

    if ($function->isPublic()) {
      $ret .= 'public ';
    } else if ($function->isPrivate()) {
      $ret .= 'private ';
    } else if ($function->isProtected()) {
      $ret .= 'protected ';
    }

    if ($function->isStatic()) {
      $ret .= 'static ';
    }
  }

  $ret .= 'function '.$name;
  $ret .= stringify_generics($function->getGenericTypes());
  $ret .= stringify_parameters($format, $function, $docs);

  if ($type = $function->getReturnType()) {
    $ret .= ': '.stringify_typehint($type);
  }

  $ret .= ';';
  return $ret;
}
