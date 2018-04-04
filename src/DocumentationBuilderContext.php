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

class DocumentationBuilderContext {
  public function __construct(
    private OutputFormat $format,
    private Index $index,
    private IPathProvider<?string> $pathProvider,
  ) {
  }

  public function getOutputFormat(): OutputFormat {
    return $this->format;
  }

  public function getIndex(): Index {
    return $this->index;
  }

  public function getPathProvider(): IPathProvider<?string> {
    return $this->pathProvider;
  }
}
