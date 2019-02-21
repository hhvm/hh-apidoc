/*
 *  Copyright (c) 2018-present, Facebook, Inc.
 *  All rights reserved.
 *
 *  This source code is licensed under the MIT license found in the
 *  LICENSE file in the root directory of this source tree.
 *
 */

namespace Facebook\HHAPIDoc\PageSections\_Private;

use type Facebook\DefinitionFinder\ScannedShapeField;
use namespace HH\Lib\{C, Str, Vec};

function stringify_shape(
  string $ns,
  vec<ScannedShapeField> $fields,
): string {
  $ret = "shape(\n";
  foreach ($fields as $field) {
    $ret .= '  '.stringify_expression($field->getName());
    $ret .= ' => ';

    $value = stringify_typehint($ns, $field->getValueType());
    $lines = Str\split($value, "\n");
    if (C\count($lines) === 1) {
      $ret .= $lines[0];
    } else {
      $ret .= $lines
        |> Vec\map($$, $l ==> '  '.$l)
        |> Str\join($$, "\n")
        |> "\n".$$;
    }
    $ret .= ",\n";
  }

  return $ret.')';
}
