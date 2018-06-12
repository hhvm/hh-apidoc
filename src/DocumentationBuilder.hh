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
use namespace HH\Lib\{Str, Vec};

/** Main entrypoint to generate a document for a specific `Documentable` */
class DocumentationBuilder {
  /**
   * Create a new instance.
   *
   * @param $context Context such as desired output format
   */
  public function __construct(
    private DocumentationBuilderContext $context,
  ) {
  }

  /** @selfdocumenting */
  protected function getContext(): DocumentationBuilderContext {
    return $this->context;
  }

  /**
   * List of instantiable `PageSection` subclasses to include in the document.
   */
  protected function getPageSections(
  ): keyset<classname<PageSections\PageSection>> {
    return keyset[
      PageSections\NameHeading::class,
      PageSections\DeprecationMessage::class,
      PageSections\Summary::class,
      PageSections\FunctionishSignature::class,
      PageSections\Description::class,
      PageSections\InterfaceSynopsis::class,
      PageSections\FunctionishParameters::class,
      PageSections\FunctionishReturnValues::class,
    ];
  }

  /** Produce the actual documentation as a string.
   *
   * This will be in the format specified by the context that was passed to
   * `__construct()`
   */
  public function getDocumentation(
    Documentable $documentable,
  ): string {
    $body = $this->getDocumentationBody($documentable);
    switch ($this->getContext()->getOutputFormat()) {
      case OutputFormat::MARKDOWN:
        return $body;
      case OutputFormat::HTML:
        return $this->wrapHTMLBody($documentable, $body);
    }
  }

  /**
   * Generate a full HTML document from a body.
   *
   * @param $body the main content of the document in HTML format,
   *   suitable for insertion into`<body>` tags. It does not include the
   *   `<body>` tags.
   * @return a full HTML document, including the outermost `<html>` tag.
   */
  protected function wrapHTMLBody(Documentable $what, string $body): string {
    $def = $what['definition'];
    $parent = $what['parent'];
    if ($parent !== null) {
      $name = $parent->getName().'::'.$def->getName();
    } else {
      $name = $def->getName();
    }

    return Str\format(
      "<html>\n<head>\n<title>%s</title>\n<style>\n%s\n</style>\n</head>\n".
      "<body>\n%s\n</body>\n</html>",
      \htmlspecialchars($name),
      \file_get_contents(__DIR__.'/syntax.css')
        |> Str\trim($$)
        |> \htmlspecialchars($$),
      $body,
    );
  }

  /** Get the main body of the documentation in the context-appropriate
   * output format.
   *
   * In the case of HTML, this should be suitable for insertion into `<body>`
   * tags, but should not include the `<body>` tag.
   *
   * @see wrapHTMLBody
   */
  protected function getDocumentationBody(
    Documentable $documentable,
  ): string {
    $docs = DocBlock\DocBlock::nullable(
      $documentable['definition']->getDocComment(),
    );
    $ctx = $this->getContext();
    $md = $this->getPageSections()
      |> Vec\map($$, $s ==> (new $s($ctx, $documentable, $docs))->getMarkdown())
      |> Vec\filter_nulls($$)
      |> Str\join($$, "\n\n");

    $parser_ctx = new Markdown\ParserContext();
    $ast = Markdown\parse($parser_ctx, $md);

    $render_ctx = (new MarkdownExt\RenderContext())
      ->setOutputFormat($this->getContext()->getOutputFormat())
      ->setDocumentable($documentable)
      ->setPathProvider(
        new IndexedPathProvider(
          $this->getContext()->getIndex(),
          $this->getContext()->getPathProvider(),
        ),
      )
      ->appendFilters(
        new MarkdownExt\AutoLinkifyFilter(),
        new MarkdownExt\SyntaxHighlightingFilter(),
      );
    switch ($this->getContext()->getOutputFormat()) {
      case OutputFormat::MARKDOWN:
        $renderer = new Markdown\MarkdownRenderer($render_ctx);
        break;
      case OutputFormat::HTML:
        $renderer = new Markdown\HTMLRenderer($render_ctx);
        break;
    }
    return $renderer->render($ast);
  }
}
