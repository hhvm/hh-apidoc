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
  const type TConfig = shape(
    'format' => OutputFormat,
    'syntaxHighlighting' => bool,
    'hidePrivateMethods' => bool,
    'hideInheritedMethods' => bool,
    ?'frontMatter' => PageSections\FrontMatter::TConfig,
  );
  /** Create an instance.
   *
   * @param $format the desired documentation format
   * @param $index an `Index` of all `Documentable`s. This may be used for
   *   autolinking.
   * @param $pathProvider a path provider that returns paths for documentables
   *   that exist, or null for ones that don't.
   */
  public function __construct(
    private Index $index,
    private IPathProvider<?string> $pathProvider,
    private this::TConfig $config,
  ) {
  }

  /** @selfdocumenting */
  public function getOutputFormat(): OutputFormat {
    return $this->config['format'];
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
  public function isSyntaxHighlightingEnabled(): bool {
    return $this->config['syntaxHighlighting'];
  }

  /** @selfdocumenting */
  public function getConfiguration(): this::TConfig {
    return $this->config;
  }
}
