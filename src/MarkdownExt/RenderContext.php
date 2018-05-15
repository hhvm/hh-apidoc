<?hh // strict
/*
 *  Copyright (c) 2018-present, Facebook, Inc.
 *  All rights reserved.
 *
 *  This source code is licensed under the MIT license found in the
 *  LICENSE file in the root directory of this source tree.
 *
 */

namespace Facebook\HHAPIDoc\MarkdownExt;

use type Facebook\HHAPIDoc\{Documentable, IPathProvider, OutputFormat};
use namespace HH\Lib\Keyset;

/** Context for rendering markdown using FBMarkdown and
 * hh-apidoc's extensions.
 */
class RenderContext extends \Facebook\Markdown\RenderContext {
  private ?OutputFormat $format;
  private ?Documentable $documentable;
  private ?IPathProvider<?string> $pathProvider;

<<<<<<< HEAD
  /** If we something that looks like a symbole reference but we can't find it
   * in thecurrent namespace/class, this provides a list of other places to
=======
  /** Places to always look for symbols.
   *
   * If we have something that looks like a symbol reference, but we can't find
   * it in the current namespace/class, this provides a list of other places to
>>>>>>> suggested changes
   * look for commonly used symbols.
   */
  public function getImplicitPrefixes(): keyset<string> {
    return keyset[
      "HH\\",
      "HH\\Lib\\",
    ];
  }

  /**
   * Set path provider used for internal references.
   *
   * @param $provider An `IPathProvider` that returns null if the symbol does
   *   not exist. This should usually be an `IndexedPathProvider`.
   */
  public function setPathProvider(IPathProvider<?string> $provider): this {
    $this->pathProvider = $provider;
    return $this;
  }

  /** Return the path provider set with `setPathProvider()` */
  public function getPathProvider(): IPathProvider<?string> {
    $p = $this->pathProvider;
    invariant(
      $p !== null,
      "Call %s::setPathProvider() before rendering",
      static::class,
    );
    return $p;
  }

  /** Set the item currently being documented. */
  public function setDocumentable(Documentable $documentable): this {
    invariant(
      $this->documentable === null,
      'Call %s::resetFileData between files',
      static::class,
    );
    $this->documentable = $documentable;
    return $this;
  }

  /** Return the item we're currently generating documentation for. */
  public function getDocumentable(): Documentable {
    $doc = $this->documentable;
    invariant(
      $doc !== null,
      'call %s::setDocumentable before attempting to render',
      static::class,
    );
    return $doc;
  }

  /** Set the desired documentation format.
   *
   * This allows for different Markdown to be generated for different formats.
   */
  public function setOutputFormat(OutputFormat $f): this {
    $this->format = $f;
    return $this;
  }

  /** Get the format of documentation we are generated.
   *
   * This should be used minimally; users should generally expect identical
   * output in different formats.
   *
   * For example, syntax highlighting is applied to code blocks when we are
   * generating HTML.
   */
  public function getOutputFormat(): OutputFormat {
    $f = $this->format;
    invariant(
      $f !== null,
      'call %s::setOutputFormat before attempting to render',
      static::class,
    );
    return $f;
  }

  /** Clear all per-`Documentable` state */
  <<__Override>>
  public function resetFileData(): this {
    parent::resetFileData();
    $this->documentable = null;
    return $this;
  }
}
