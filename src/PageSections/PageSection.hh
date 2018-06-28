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
  ScannedDefinition,
  ScannedClassish,
};

/** Base class for all page sections.
 *
 * A page is generated for each `Documentable`; each piece of content
 * (e.g. signature, description) is a section.
 *
 * Sections produce Markdown for a Documentable
 */
<<__ConsistentConstruct>>
abstract class PageSection {
  /** The definition currently being documented */
  protected ScannedDefinition $definition;
  /** The parent definition of the current definition.
   *
   * This will be `null` for top-level definitions such as classes and
   * functions, however for definitions such as methods, it will be set to the
   * containing class, interface, or trait.
   */
  protected ?ScannedClassish $parent;

  /** @selfdocumenting */
  public function __construct(
    protected DocumentationBuilderContext $context,
    protected Documentable $documentable,
    protected ?DocBlock $docBlock,
  ) {
    $this->definition = $documentable['definition'];
    $this->parent = $documentable['parent'];
  }

  /** Create markdown for this page section.
   *
   * @returns `null` if the section should not be rendered; for example:
   *   - it might not be appropriate for the current `OutputFormat`
   *   - it might not be relevant to the current type of `Documentable`
   *   - there might not be any content provided for the current `Documentable`
   */
  abstract public function getMarkdown(): ?string;
}
