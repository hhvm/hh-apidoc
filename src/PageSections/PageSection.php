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

use type Facebook\HHAPIDoc\{
  Documentable,
  DocBlock\DocBlock,
  DocumentationBuilderContext,
};
use type Facebook\DefinitionFinder\{
  ScannedBase,
  ScannedClass,
};

<<__ConsistentConstruct>>
abstract class PageSection {
  protected ScannedBase $definition;
  protected ?ScannedClass $parent;

  public function __construct(
    protected DocumentationBuilderContext $context,
    protected Documentable $documentable,
    protected ?DocBlock $docBlock,
  ) {
    $this->definition = $documentable['definition'];
    $this->parent = $documentable['parent'];
  }

  abstract public function getMarkdown(): ?string;
}
