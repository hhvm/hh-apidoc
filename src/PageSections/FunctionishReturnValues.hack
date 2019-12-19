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
use type Facebook\DefinitionFinder\ScannedFunctionish;

use namespace HH\Lib\{C, Str, Vec};

/** Return information on possible return values for a function or method. */
final class FunctionishReturnValues extends PageSection {
  <<__Override>>
  public function getMarkdown(): ?string {
    $f = $this->definition;
    if (!$f is ScannedFunctionish) {
      return null;
    }

    $values = $this->docBlock?->getReturnInfo() ?? vec[];
    if (C\is_empty($values)) {
      $ret_info = $f->getReturnType();
      if ($ret_info === null) {
        return null;
      }
      $values = vec[shape('types' => vec[], 'text' => null)];
    }

    return $values
      |> Vec\map($$, $v ==> self::getReturnValueInformation($f, $v))
      |> Str\join($$, "\n")
      |> "## Returns\n\n".$$;
  }

  private static function getReturnValueInformation(
    ScannedFunctionish $f,
    DocBlock\ReturnInfo $docs,
  ): string {
    $ret = '- ';

    $types =
      Vec\filter($docs['types'], $type ==> $type !== '\-' && $type !== '-');
    $typehint = $f->getReturnType();
    if ($types) {
      $ret .= '`'.Str\join($types, '|').'`';
    } else if ($typehint) {
      $ret .=
        '`'._Private\stringify_typehint($f->getNamespaceName(), $typehint).'`';
    }
    $text = $docs['text'];
    if ($text !== null) {
      $ret .= ' - '.$text;
    }
    return $ret;
  }
}
