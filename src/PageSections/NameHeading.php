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

use type Facebook\DefinitionFinder\ScannedFunctionAbstract;
use namespace HH\Lib\Str;

/** Render a heading with the name of the current item */
final class NameHeading extends PageSection {
  <<__Override>>
  public function getMarkdown(): string {
    $md = '# ';
    if ($this->parent) {
      $md .= $this->parent->getName().'::';
    }
    $def = $this->definition;
    $md .= $def->getName();

    if ($def instanceof ScannedFunctionAbstract) {
      $md .= '()';
    }

    return Str\replace($md, "\\", "\\\\");
  }
}
