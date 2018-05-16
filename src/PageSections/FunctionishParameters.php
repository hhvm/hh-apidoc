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
use type Facebook\DefinitionFinder\{
  ScannedFunctionAbstract,
  ScannedParameter,
};
use namespace HH\Lib\{C, Str, Vec};

class FunctionishParameters extends PageSection {
  <<__Override>>
  public function getMarkdown(): ?string {
    $f = $this->definition;
    if (!$f instanceof ScannedFunctionAbstract) {
      return null;
    }

    $params = $f->getParameters();
    if (C\is_empty($params)) {
      return null;
    }

    $docs = $this->docBlock?->getParameterInfo() ?? dict[];

    return $params
      |> Vec\map(
        $$,
        $p ==> static::getParameterListItem(
          $p,
          $docs['$'.$p->getName()] ?? null,
        ),
      )
      |> Str\join($$, "\n")
      |> "## Parameters\n\n".$$;
  }

  protected static function getParameterListItem(
    ScannedParameter $p,
    ?DocBlock\ParameterInfo $docs,
  ): string {
    $text = $docs['text'] ?? null;
    return \sprintf(
      '- `%s`%s',
      _Private\stringify_parameter($p, $docs),
      $text === null ? '' : ' '.$text,
    );
  }
}
