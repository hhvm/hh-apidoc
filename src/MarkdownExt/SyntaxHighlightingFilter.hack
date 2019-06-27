/*
 *  Copyright (c) 2018-present, Facebook, Inc.
 *  All rights reserved.
 *
 *  This source code is licensed under the MIT license found in the
 *  LICENSE file in the root directory of this source tree.
 *
 */

namespace Facebook\HHAPIDoc\MarkdownExt;

use type Facebook\Markdown\Blocks\CodeBlock;
use type Facebook\HHAPIDoc\OutputFormat;
use namespace Facebook\{HHAST, Markdown};
use namespace HH\Lib\{C, Str, Vec};

/**
 * Apply syntax highlighting to Hack code blocks.
 *
 * This is whitelisted for specific `OutputFormat`s - when generating generic
 * Markdown, we leave syntax highlighting for the final renderer.
 */
final class SyntaxHighlightingFilter extends Markdown\RenderFilter {
  const keyset<string> KEYWORDS = keyset[
    'hh',
    'HH',
    'Hack',
    'hack',
  ];

  <<__Override>>
  public function filter(
    Markdown\RenderContext $context,
    Markdown\ASTNode $node,
  ): vec<Markdown\ASTNode> {
    if (!$node instanceof CodeBlock) {
      return vec[$node];
    }
    if ($context instanceof namespace\RenderContext) {
      if ($context->getOutputFormat() !== OutputFormat::HTML) {
        return vec[$node];
      }
    }

    $info = $node->getInfoString();
    if ($info is null || (!C\contains_key(self::KEYWORDS, $info))) {
      return vec[$node];
    }

    $ast = \HH\Asio\join(HHAST\from_file_async(
      HHAST\File::fromPathAndContents('__DATA__', $node->getCode()),
    ));
    return vec[new Markdown\Blocks\HTMLBlock(
      '<pre><code class="language-'.
      $info.
      '">'.
      self::getHTML($ast).
      "</code></pre>\n",
    )];
  }

  /** Convert an HHAST FFP AST node into an HTML string. */
  protected static function getHTML(HHAST\Node $node): string {
    if ($node instanceof HHAST\Missing) {
      return '';
    }

    if ($node->isTrivia() || $node->isToken()) {
      $inner = \htmlspecialchars($node->getCode());
    } else {
      $inner = $node->getChildren()
        |> Vec\map($$, $child ==> self::getHTML($child))
        |> Str\join($$, '');
    }

    if ($node instanceof HHAST\NodeList ) {
      return $inner;
    }

    return Str\format(
      '<span class="hs-%s">%s</span>',
      \get_class($node)
        |> Str\split($$, "\\")
        |> C\lastx($$)
        |> Str\strip_prefix($$, 'Editable'),
      $inner,
    );
  }
}
