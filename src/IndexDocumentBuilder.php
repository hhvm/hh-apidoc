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

/** Generate a document that contains links to all documented definitions. */
class IndexDocumentBuilder {
  /** @selfdocumenting */
  public function __construct(
    private DocumentationBuilderContext $context,
  ) {
  }

  /** @selfdocumenting */
  protected function getContext(): DocumentationBuilderContext {
    return $this->context;
  }

  /**
   * Produce the index document in the format specified by the current
   * context
   */
  public function getIndexDocument(): string {
    $md = $this->getIndexDocumentMarkdown();
    switch ($this->context->getOutputFormat()) {
      case OutputFormat::MARKDOWN:
        return $md;
      case OutputFormat::HTML:
        return $this->renderToHTML($md);
    }
  }

  /** @selfdocumenting */
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

  /** @selfdocumenting */
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

  /**
   * Render an index section to Markdown.
   *
   * @param $title the title of the section - e.g. 'Classes'
   * @param $names the names of all the definitions that belong in this section
   * @param $get_path a callable that takes a name from `$names` and returns
   *   `null` if a path can't be found, otherwise returns a path suitable for
   *   linking to for the specified name.
   * @return string Markdown
   */
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
