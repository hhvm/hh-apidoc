/*
 *  Copyright (c) 2018-present, Facebook, Inc.
 *  All rights reserved.
 *
 *  This source code is licensed under the MIT license found in the
 *  LICENSE file in the root directory of this source tree.
 *
 */

namespace Facebook\HHAPIDoc\MarkdownExt;

use type Facebook\DefinitionFinder\ScannedClassish;
use type Facebook\Markdown\Inlines\{
  CodeSpan,
  Link,
};
use function Facebook\HHAPIDoc\get_path_for_type;
use namespace Facebook\Markdown;
use namespace HH\Lib\{C, Str, Vec};

/**
 * Given something like `Vec\map()`, automatically make it a link
 */
final class AutoLinkifyFilter extends Markdown\RenderFilter {
  private vec<CodeSpan> $seen = vec[];

  <<__Override>>
  public function resetFileData(): this {
    $this->seen = vec[];
    return $this;
  }

  <<__Override>>
  public function filter(
    Markdown\RenderContext $context,
    Markdown\ASTNode $node,
  ): vec<Markdown\ASTNode> {
    if (!$node is CodeSpan) {
      return vec[$node];
    }

    if (C\contains($this->seen, $node)) {
      return vec[$node];
    }
    $this->seen[] = $node;

    $content = $node->getCode();

    if ($content === '') {
      return vec[$node];
    }

    if (Str\starts_with($content, '$')) {
      return vec[$node];
    }

    invariant(
      $context is RenderContext,
      'Expected render context to be a %s',
      RenderContext::class,
    );
    $name = $context->getDocumentable()['definition']->getName();

    $words = Str\split($content, ' ');
    $definition = C\firstx($words);

    $leading = '';
    $trailing = Vec\drop($words, 1) |> Str\join($$, ' ');
    if ($trailing !== '') {
      $trailing = ' '.$trailing;
    }

    if (Str\starts_with($definition, '?')) {
      $leading = '?';
      $definition = Str\slice($definition, 1);
    }

    if (!\preg_match('/^[a-zA-Z\\\\]/', $definition)) {
      return vec[$node];
    }

    if (Str\ends_with($name, $definition)) {
      return vec[$node];
    }

    $path = self::getPath(
      $context,
      $definition,
    );

    if ($path === null) {
      return vec[$node];
    }

    $inner = new CodeSpan($definition);
    $this->seen[] = $inner;

    $ret = vec[];
    if ($leading !== '') {
      $ret[] = new CodeSpan($leading);
    }
    $ret[] = new Link(vec[$inner], $path, null);
    if ($trailing !== '') {
      $ret[] = new CodeSpan($trailing);
    }
    return $ret;
  }

  private static function getPath(
    RenderContext $context,
    string $search,
  ): ?string {
    $search = Str\strip_prefix($search, '\\');
    $ends = vec['<', '('];
    foreach ($ends as $end) {
      $idx = Str\search($search, $end);
      if ($idx !== null) {
        $search = Str\slice($search, 0, $idx);
      }
    }

    $parts = Str\split($search, '::');
    $class = $parts[0];
    $method = $parts[1] ?? null;

    if ($method !== null) {
      return self::getPathForMethod($context, $class, $method);
    }

    $def = $context->getDocumentable()['definition'];
    if ($def is ScannedClassish) {
      $path = self::getPathForMethod($context, $def->getName(), $search);
      if ($path !== null) {
        return $path;
      }
    }

    $parent = $context->getDocumentable()['parent']?->getName();
    if ($parent !== null) {
      $path = self::getPathForMethod($context, $parent, $search);
      if ($path !== null) {
        return $path;
      }
    }

    $paths = $context->getPathProvider();
    $prefixes = Vec\concat(vec[''], $context->getImplicitPrefixes());
    return $prefixes
      |> Vec\map(
        $$,
        $p ==> get_path_for_type($paths, $p.$search),
      )
      |> Vec\filter_nulls($$)
      |> C\first($$);
  }

  private static function getPathForMethod(
    RenderContext $context,
    string $class_search,
    string $method_search,
  ): ?string {
    $prefixes = Vec\concat(vec[''], $context->getImplicitPrefixes());
    $index = $context->getPathProvider();
    return $prefixes
      |> Vec\map(
        $$,
        $p ==> vec[
          $index->getPathForClassMethod($p.$class_search, $method_search),
          $index->getPathForInterfaceMethod($p.$class_search, $method_search),
          $index->getPathForTraitMethod($p.$class_search, $method_search),
        ],
      )
      |> Vec\flatten($$)
      |> Vec\filter_nulls($$)
      |> C\first($$);
  }
}
