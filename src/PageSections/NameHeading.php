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

class NameHeading extends PageSection {
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

    return $md;
  }
}
