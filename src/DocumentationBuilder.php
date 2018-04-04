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

class DocumentationBuilder {
  public function __construct(
    private DocumentationBuilderContext $context,
  ) {
  }

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

  public function getDocumentation(
    Documentable $documentable,
  ): string {
    $body = $this->getDocumentationBody($documentable);
    switch ($this->context->getOutputFormat()) {
      case OutputFormat::MARKDOWN:
        return $body;
      case OutputFormat::HTML:
        return $this->wrapHTMLBody($documentable, $body);
    }
  }

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

  protected function getDocumentationBody(
    Documentable $documentable,
  ): string {
    $docs = DocBlock\DocBlock::nullable(
      $documentable['definition']->getDocComment(),
    );
    $ctx = $this->context;
    $md = $this->getPageSections()
      |> Vec\map($$, $s ==> (new $s($ctx, $documentable, $docs))->getMarkdown())
      |> Vec\filter_nulls($$)
      |> Str\join($$, "\n\n");

    $parser_ctx = new Markdown\ParserContext();
    $ast = Markdown\parse($parser_ctx, $md);

    $render_ctx = (new MarkdownExt\RenderContext())
      ->setOutputFormat($this->context->getOutputFormat())
      ->setDocumentable($documentable)
      ->setPathProvider(
        new IndexedPathProvider(
          $this->context->getIndex(),
          $this->context->getPathProvider(),
        ),
      )
      ->appendFilters(
        new MarkdownExt\AutoLinkifyFilter(),
        new MarkdownExt\SyntaxHighlightingFilter(),
      );
    switch ($this->context->getOutputFormat()) {
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
