/*
 *  Copyright (c) 2018-present, Facebook, Inc.
 *  All rights reserved.
 *
 *  This source code is licensed under the MIT license found in the
 *  LICENSE file in the root directory of this source tree.
 *
 */

namespace Facebook\HHAPIDoc\PageSections;

use type Facebook\HHAPIDoc\DocBlock\DocBlock;
use type Facebook\DefinitionFinder\{
  ScannedClass,
  ScannedClassish,
  ScannedInterface,
  ScannedMethod,
  ScannedTrait,
};
use namespace HH\Lib\{C, Dict, Keyset, Str, Vec};

/** Render the outline of a class, interface, or trait */
final class InterfaceSynopsis extends PageSection {
  private function walkMethods(
    ScannedClassish $c,
  ): dict<string, (ScannedClassish, ScannedMethod)> {
    if ($c === null) {
      return dict[];
    }

    $methods =
      Dict\pull($c->getMethods(), $m ==> tuple($c, $m), $m ==> $m->getName());

    $parents = Vec\filter_nulls(
      Vec\concat(vec[$c->getParentClassName()], $c->getInterfaceNames()),
    );

    $index = $this->context->getIndex();
    foreach ($parents as $parent) {
      $parent = $index['classes'][$parent]['definition'] ??
        $index['interfaces'][$parent]['definition'] ??
        null;
      if (!$parent is ScannedClassish) {
        continue;
      }
      foreach ($this->walkMethods($parent) as $name => $data) {
        if (C\contains_key($methods, $name)) {
          continue;
        }
        $methods[$name] = $data;
      }
    }

    return $methods;
  }

  <<__Override>>
  public function getMarkdown(): ?string {
    $c = $this->definition;
    if (!$c is ScannedClassish) {
      return null;
    }

    $methods = vec($this->walkMethods($c));
    $defining_classes = Keyset\map($methods, $cm ==> $cm[0]->getName());

    $public_methods = vec[];
    $protected_methods = vec[];
    $private_methods = vec[];
    foreach ($defining_classes as $dc) {
      $suffix = $dc === $c->getName() ? '' : ' (`'.$dc.'`)';
      $public_methods[] = $this->getMethodList(
        '### Public Methods'.$suffix,
        Vec\filter(
          $methods,
          $cm ==> $dc === $cm[0]->getName() && $cm[1]->isPublic(),
        ),
      );
      $protected_methods[] = $this->getMethodList(
        '### Protected Methods'.$suffix,
        Vec\filter(
          $methods,
          $cm ==> $dc === $cm[0]->getName() && $cm[1]->isProtected(),
        ),
      );
      if ($dc !== $c) {
        // Never show inherited private methods
        continue;
      }
      if ($this->context->getConfiguration()['hidePrivateMethods']) {
        continue;
      }
      $private_methods[] = $this->getMethodList(
        '### Private Methods'.$suffix,
        Vec\filter(
          $methods,
          $cm ==> $dc === $cm[0]->getName() && $cm[1]->isPrivate(),
        ),
      );
    }

    return "## Interface Synopsis\n\n".
      $this->getInheritanceInformation($c).
      "\n\n".
      (
        Vec\concat($public_methods, $protected_methods, $private_methods)
        |> Vec\filter_nulls($$)
        |> Str\join($$, "\n\n")
      );
  }

  private function getMethodList(
    string $header,
    vec<(ScannedClassish, ScannedMethod)> $methods,
  ): ?string {
    if (C\is_empty($methods)) {
      return null;
    }
    return $methods
      |> Vec\sort_by(
        $$,
        $cm ==> ($cm[1]->isStatic() ? 'a' : 'b').$cm[1]->getName(),
      )
      |> Vec\map($$, $cm ==> $this->getMethodListItem($cm[0], $cm[1]))
      |> Str\join($$, "\n")
      |> $header."\n\n".$$."\n";
  }

  private function getMethodListItem(
    ScannedClassish $defining_class,
    ScannedMethod $m,
  ): string {
    $ns = $defining_class->getNamespaceName();
    $docs = DocBlock::nullable($m->getDocComment());

    $signature = ($m->isStatic() ? '::' : '->').
      $m->getName().
      _Private\stringify_generics($ns, $m->getGenericTypes()).
      _Private\stringify_parameters(
        $defining_class->getNamespaceName(),
        _Private\StringifyFormat::ONE_LINE,
        $m,
        $docs,
      );

    $rt = $m->getReturnType();
    if ($rt !== null) {
      $signature .= ': '._Private\stringify_typehint($ns, $rt);
    }

    $markdown = Str\format(
      '- [`%s`](%s)',
      $signature,
      $this->getLinkPathForMethod($defining_class, $m) as nonnull,
    );

    $summary = $docs?->getSummary();
    if ($summary !== null) {
      $markdown .= "\\\n".$summary;
    }

    return $markdown;
  }

  private function getLinkPathForClassish(ScannedClassish $c): ?string {
    $pp = $this->context->getPathProvider();
    if ($c is ScannedClass) {
      return $pp->getPathForClass($c->getName());
    }
    if ($c is ScannedInterface) {
      return $pp->getPathForInterface($c->getName());
    }
    if ($c is ScannedTrait) {
      return $pp->getPathForTrait($c->getName());
    }
    invariant_violation("Don't know how to handle type %s", \get_class($c));
  }

  private function getLinkPathForMethod(
    ScannedClassish $c,
    ScannedMethod $m,
  ): ?string {
    $pp = $this->context->getPathProvider();
    if ($c is ScannedClass) {
      return $pp->getPathForClassMethod($c->getName(), $m->getName());
    }
    if ($c is ScannedInterface) {
      return $pp->getPathForInterfaceMethod($c->getName(), $m->getName());
    }
    if ($c is ScannedTrait) {
      return $pp->getPathForTraitMethod($c->getName(), $m->getName());
    }
    invariant_violation("Don't know how to handle type %s", \get_class($c));
  }

  private function getInheritanceInformation(ScannedClassish $c): string {
    $ret = '';

    $ns = $c->getNamespaceName();
    if ($ns !== '') {
      $ret .= 'namespace '.$ns.";\n\n";
    }

    if ($c->isAbstract()) {
      $ret .= 'abstract ';
    }
    if ($c->isFinal()) {
      $ret .= 'final ';
    }

    if ($c is ScannedClass) {
      $ret .= 'class ';
    } else if ($c is ScannedInterface) {
      $ret .= 'interface ';
    } else if ($c is ScannedTrait) {
      $ret .= 'trait ';
    } else {
      invariant_violation("Don't know what a %s is.", \get_class($c));
    }

    $ret .= $c->getShortName();

    $p = $c->getParentClassInfo();
    if ($p !== null) {
      $ret .= ' extends '._Private\stringify_typehint($ns, $p);
    }
    $interfaces = $c->getInterfaceInfo();
    if ($interfaces) {
      $ret .= $interfaces
        |> Vec\map($$, $i ==> _Private\stringify_typehint($ns, $i))
        |> Str\join($$, ', ')
        |> ' implements '.$$;
    }

    $ret .= ' {...}';

    return "```Hack\n".$ret."\n```";
  }
}
