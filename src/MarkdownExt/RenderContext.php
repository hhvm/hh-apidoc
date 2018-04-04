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

use type Facebook\HHAPIDoc\{
  Documentable,
  IPathProvider,
  OutputFormat,
};
use namespace HH\Lib\Keyset;

class RenderContext extends \Facebook\Markdown\RenderContext {
  private ?OutputFormat $format;
  private ?Documentable $documentable;
  private ?IPathProvider<?string> $pathProvider;

  public function getImplicitPrefixes(): keyset<string> {
    return keyset[
      "HH\\",
      "HH\\Lib\\",
    ];
  }

  /**
   * Set path provider used for internal references.
   *
   * This should usually be an instance of `IndexedPathProvider`.
   */
  public function setPathProvider(IPathProvider<?string> $provider): this {
    $this->pathProvider = $provider;
    return $this;
  }

  public function getPathProvider(): IPathProvider<?string> {
    $p = $this->pathProvider;
    invariant(
      $p !== null,
      "Call %s::setPathProvider() before rendering",
      static::class,
    );
    return $p;
  }

  public function setDocumentable(Documentable $documentable): this {
    invariant(
      $this->documentable === null,
      'Call %s::resetFileData between files',
      static::class,
    );
    $this->documentable = $documentable;
    return $this;
  }

  public function getDocumentable(): Documentable {
    $doc = $this->documentable;
    invariant(
      $doc !== null,
      'call %s::setDocumentable before attempting to render',
      static::class,
    );
    return $doc;
  }

  public function setOutputFormat(OutputFormat $f): this {
    $this->format = $f;
    return $this;
  }

  public function getOutputFormat(): OutputFormat {
    $f = $this->format;
    invariant(
      $f !== null,
      'call %s::setOutputFormat before attempting to render',
      static::class,
    );
    return $f;
  }

  <<__Override>>
  public function resetFileData(): this {
    parent::resetFileData();
    $this->documentable = null;
    return $this;
  }
}
