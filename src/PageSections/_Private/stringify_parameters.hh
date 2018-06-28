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
use type Facebook\DefinitionFinder\ScannedFunctionish;
use namespace HH\Lib\{Str, Vec};

function stringify_parameters(
  string $ns,
  StringifyFormat $format,
  ScannedFunctionish $function,
  ?DocBlock $docs,
): string {
  $params = Vec\map(
    $function->getParameters(),
    $p ==> stringify_parameter(
      $ns,
      $p,
      $docs?->getParameterInfo()['$'.$p->getName()] ?? null,
    ),
  );

  if (!$params) {
    return '()';
  }

  switch($format) {
    case StringifyFormat::MULTI_LINE:
      return $params
        |> Vec\map($$, $p ==> '  '.$p.',')
        |> Str\join($$, "\n")
        |> "(\n".$$."\n)";
    case StringifyFormat::ONE_LINE:
      return $params
        |> Str\join($$, ', ')
        |> '('.$$.')';
  }
}
