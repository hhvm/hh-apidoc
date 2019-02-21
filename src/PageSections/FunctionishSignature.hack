/*
 *  Copyright (c) 2018-present, Facebook, Inc.
 *  All rights reserved.
 *
 *  This source code is licensed under the MIT license found in the
 *  LICENSE file in the root directory of this source tree.
 *
 */

namespace Facebook\HHAPIDoc\PageSections;

use type Facebook\DefinitionFinder\ScannedFunctionish;

/** Render the signature of a function or method */
final class FunctionishSignature extends PageSection {
  <<__Override>>
  public function getMarkdown(): ?string {
    $f = $this->definition;
    if (!$f instanceof ScannedFunctionish) {
      return null;
    }

    $str = _Private\stringify_functionish_signature(
      _Private\StringifyFormat::MULTI_LINE,
      $f,
      $this->docBlock,
    );

    return "```Hack\n".$str."\n```";
  }
}
