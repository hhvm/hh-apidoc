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
use type Facebook\DefinitionFinder\ScannedType;
use namespace HH\Lib\{Str, Vec};

/** Detailed information for shape fields, including per-field docbocks */
final class ShapeFields extends PageSection {
  <<__Override>>
  public function getMarkdown(): ?string {
    $t = $this->definition;
    // Intentionally not documenting opaque type aliases
    if (!$t is ScannedType) {
      return null;
    }
    $t = $t->getAliasedType();
    if (!$t->isShape()) {
      return null;
    }

    return Vec\map(
      $t->getShapeFields(),
      $field ==> {
        $docs = $field->getDocComment();
        if ($docs === null) {
          $docs = '';
        } else {
          $docs = ' - '.(new DocBlock($docs))->getSummary() ?? '';
        }
        return Str\format(
          '- `%s%s: %s`%s',
          $field->isOptional() ? '?' : '',
          _Private\stringify_expression($field->getName()),
          _Private\stringify_typehint(
            $this->definition->getNamespaceName(),
            $field->getValueType(),
          ),
          $docs,
        );
      },
    )
      |> Str\join($$, "\n")
      |> "## Fields\n\n".$$;
  }
}
