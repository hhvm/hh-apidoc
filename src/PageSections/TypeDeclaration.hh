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

use type Facebook\HHAPIDoc\DocBlock\DocBlock;
use type Facebook\DefinitionFinder\{
  ScannedNewtype,
  ScannedType,
  ScannedTypeish,
};
use namespace HH\Lib\{C, Str, Vec};

/** Render the outline of a type alias */
final class TypeDeclaration extends PageSection {
  <<__Override>>
  public function getMarkdown(): ?string {
    $t = $this->definition;
    if (!$t instanceof ScannedTypeish) {
      return null;
    }
    return $this->getTypeDeclaration($t);
  }

  public function getTypeDeclaration(ScannedTypeish $t): string {
    $code = '';

    $ns = $t->getNamespaceName();
    if ($ns !== '') {
      $code .= 'namespace '.$ns.";\n\n";
    }

    if ($t instanceof ScannedType) {
      $code .= 'type ';
    } else {
      $code .= 'newtype ';
    }

    $code .= _Private\ns_normalize_type($ns, $t->getName());

    if ($t instanceof ScannedType) {
      $code .= ' = '.
        _Private\stringify_typehint(
          $t->getNamespaceName(),
          $t->getAliasedType(),
        ).
        ';';
    } else {
      $code .= ';';
    }

    return Str\format("```Hack\n%s\n```", $code);
  }
}
