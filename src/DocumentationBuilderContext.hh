<?hh // strict
/*
 *  Copyright (c) 2018-present, Facebook, Inc.
 *  All rights reserved.
 *
 *  This source code is licensed under the MIT license found in the
 *  LICENSE file in the root directory of this source tree.
 *
 */

namespace Facebook\HHAPIDoc;

/** Contextual information required to build documentation. */
class DocumentationBuilderContext {
  /** Create an instance.
   *
   * @param $format the desired documentation format
   * @param $index an `Index` of all `Documentable`s. This may be used for
   *   autolinking.
   * @param $pathProvider a path provider that returns paths for documentables
   *   that exist, or null for ones that don't.
   */
  public function __construct(
    private OutputFormat $format,
    private Index $index,
    private IPathProvider<?string> $pathProvider,
    private bool $syntaxHighlightingOn,
    private bool $raiseErrorOnUndocumentedDefinitions,
  ) {
  }

  /** @selfdocumenting */
  public function getOutputFormat(): OutputFormat {
    return $this->format;
  }

  /** @selfdocumenting */
  public function getIndex(): Index {
    return $this->index;
  }

  /** @selfdocumenting */
  public function getPathProvider(): IPathProvider<?string> {
    return $this->pathProvider;
  }

  /** @selfdocumenting */
  public function IsSyntaxHighlightingOn(): bool {
    return $this->syntaxHighlightingOn;
  }

  /** @selfdocumenting */
  public function shouldRaiseErrorOnUndocumentedDefinitions(): bool {
    return $this->raiseErrorOnUndocumentedDefinitions;
  }

}
