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

use namespace Facebook\Markdown;
use namespace HH\Lib\{C, Keyset, Str, Vec};

class IndexDocumentBuilder {
  public function __construct(
    protected DocumentationBuilderContext $context,
  ) {
  }

  public function getIndexDocument(): string {
    $md = $this->getIndexDocumentMarkdown();
    switch ($this->context->getOutputFormat()) {
      case OutputFormat::MARKDOWN:
        return $md;
      case OutputFormat::HTML:
        return $this->renderToHTML($md);
    }
  }

  protected function renderToHTML(
    string $markdown,
  ): string {
    $body = $markdown
      |> Markdown\parse(new Markdown\ParserContext(), $$)
      |> (new Markdown\HTMLRenderer(new Markdown\RenderContext()))
        ->render($$);

    return '<html><head><title>API Index</title></head><body>'.
      $body."</body></html>\n";
  }

  protected function getIndexDocumentMarkdown(): string {
    $index = $this->context->getIndex();
    $paths = new IndexedPathProvider($index, $this->context->getPathProvider());

    return vec[
      $this->renderPart(
        'Functions',
        $index['functions'],
        $name ==> $paths->getPathForFunction($name),
      ),
      $this->renderPart(
        'Classes',
        Keyset\keys($index['classes']),
        $name ==> $paths->getPathForClass($name),
      ),
      $this->renderPart(
        'Interfaces',
        Keyset\keys($index['interfaces']),
        $name ==> $paths->getPathForInterface($name),
      ),
      $this->renderPart(
        'Traits',
        Keyset\keys($index['traits']),
        $name ==> $paths->getPathForTrait($name),
      ),
    ]
      |> Vec\filter_nulls($$)
      |> Str\join($$, "\n\n")
      |> "# API Index\n\n".$$;
  }

  protected function renderPart(
    string $title,
    keyset<string> $names,
    (function(string): ?string) $get_path,
  ): ?string {
    if (C\is_empty($names)) {
      return null;
    }
    $names = Keyset\sort($names);

    return $names
      |> Vec\sort($$)
      |> Vec\map(
        $$,
        $name ==> '- ['.Str\replace($name, "\\", "\\\\").']('.$get_path($name).')',
      )
      |> Str\join($$, "\n")
      |> "## ".$title."\n\n".$$;
  }
}
