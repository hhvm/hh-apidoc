/*
 *  Copyright (c) 2018-present, Facebook, Inc.
 *  All rights reserved.
 *
 *  This source code is licensed under the MIT license found in the
 *  LICENSE file in the root directory of this source tree.
 *
 */

namespace Facebook\HHAPIDoc\PageSections;

use type Facebook\DefinitionFinder\{
  ScannedType,
  ScannedTypeish,
};
use namespace HH\Lib\Str;

/** Render the outline of a type alias */
final class TypeDeclaration extends PageSection {
  <<__Override>>
  public function getMarkdown(): ?string {
    $t = $this->definition;
    if (!$t is ScannedTypeish) {
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

    if ($t is ScannedType) {
      $code .= 'type ';
    } else {
      $code .= 'newtype ';
    }

    $code .= $t->getShortName();

    if ($t is ScannedType) {
      $code .= ' = ';
      // We want custom multi-line formatting for shapes here, so not calling
      // stringify_typehint() for those. Note that we still use the default
      // stringify_typehint() for shapes in other places, e.g. as function
      // arguments.
      $code .= $t->getAliasedType()->isShape()
        ? _Private\stringify_shape($ns, $t->getAliasedType()->getShapeFields())
        : _Private\stringify_typehint(
            $t->getNamespaceName(),
            $t->getAliasedType(),
          );
    }

    $code .= ';';

    return Str\format("```Hack\n%s\n```", $code);
  }
}
