<?hh // strict
/*
 *  Copyright (c) 2018-present, Facebook, Inc.
 *  All rights reserved.
 *
 *  This source code is licensed under the MIT license found in the
 *  LICENSE file in the root directory of this source tree.
 *
 */

namespace Facebook\HHAPIDoc\PageSections;

use namespace Facebook\HHAPIDoc\DocBlock;
use type Facebook\DefinitionFinder\ScannedFunctionAbstract;

use namespace HH\Lib\{C, Vec, Str};

/** Return information on possible return values for a function or method. */
final class FunctionishReturnValues extends PageSection {
  <<__Override>>
  public function getMarkdown(): ?string {
    $f = $this->definition;
    if (!$f instanceof ScannedFunctionAbstract) {
      return null;
    }

    $values = $this->docBlock?->getReturnInfo() ?? vec[];
    if (C\is_empty($values)) {
      return null;
    }

    return $values
      |> Vec\map($$, $v ==> self::getReturnValueInformation($f, $v))
      |> Str\join($$, "\n")
      |> "## Return Values\n\n".$$;
  }

  private static function getReturnValueInformation(
    ScannedFunctionAbstract $f,
    DocBlock\ReturnInfo $docs,
  ): string {
    $ret = '- ';

    $types = Vec\filter(
      $docs['types'],
      $type ==> $type !== '\-' && $type !== '-',
    );
    if ($types) {
      $ret .= '`'.Str\join($types, '|').'` - ';
    } else if ($type = $f->getReturnType()) {
      $ret .= '`'._Private\stringify_typehint($type).'` - ';
    }
    $ret .= $docs['text'];
    return $ret;
  }
}
