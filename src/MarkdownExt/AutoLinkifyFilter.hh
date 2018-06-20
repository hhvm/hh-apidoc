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

use type Facebook\DefinitionFinder\ScannedClass;
use type Facebook\HHAPIDoc\Documentable;
use type Facebook\Markdown\Inlines\{
  CodeSpan,
  Link,
};
use namespace Facebook\Markdown;
use namespace HH\Lib\{C, Dict, Str, Vec};

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
    if (!$node instanceof CodeSpan) {
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

    $words = Str\split($content, ' ');
    $definition = C\firstx($words);
    $rest = Vec\drop($words, 1) |> Str\join($$, ' ');

    invariant(
      $context instanceof RenderContext,
      'Expected render context to be a %s',
      RenderContext::class,
    );
    $name = $context->getDocumentable()['definition']->getName();

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

    $ret = vec[
      new Link(vec[$node], $path, null),
    ];
    if ($rest !== '') {
      $ret[] = new CodeSpan($rest);
    }
    return $ret;
  }

  private static function getPath(
    RenderContext $context,
    string $search,
  ): ?string {
    $search = Str\strip_prefix($search, '?') |> Str\strip_prefix($$, "\\");
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
    if ($def instanceof ScannedClass) {
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

    $prefixes = Vec\concat(vec[''], $context->getImplicitPrefixes());
    $index = $context->getPathProvider();
    return $prefixes
      |> Vec\map(
        $$,
        $p ==> vec[
          $index->getPathForFunction($p.$search),
          $index->getPathForClass($p.$search),
          $index->getPathForInterface($p.$search),
          $index->getPathForTrait($p.$search),
        ],
      )
      |> Vec\flatten($$)
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
