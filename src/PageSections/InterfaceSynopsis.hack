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
use namespace HH\Lib\{C, Str, Vec};

/** Render the outline of a class, interface, or trait */
final class InterfaceSynopsis extends PageSection {
  <<__Override>>
  public function getMarkdown(): ?string {
    $c = $this->definition;
    if (!$c is ScannedClassish) {
      return null;
    }

    $methods = vec[
      $this->getMethodList(
        '### Public Methods',
        $c,
        Vec\filter($c->getMethods(), $m ==> $m->isPublic()),
      ),
      $this->getMethodList(
        '### Protected Methods',
        $c,
        Vec\filter($c->getMethods(), $m ==> $m->isProtected()),
      ),
      $this->getMethodList(
        '### Private Methods',
        $c,
        Vec\filter($c->getMethods(), $m ==> $m->isPrivate()),
      ),
    ];

    return "## Interface Synopsis\n\n".
      $this->getInheritanceInformation($c).
      "\n\n".
      ($methods |> Vec\filter_nulls($$) |> Str\join($$, "\n\n"));
  }

  private function getMethodList(
    string $header,
    ScannedClassish $c,
    vec<ScannedMethod> $methods,
  ): ?string {
    if (C\is_empty($methods)) {
      return null;
    }
    return $methods
      |> Vec\sort_by($$, $m ==> ($m->isStatic() ? 'a' : 'b').$m->getName())
      |> Vec\map($$, $m ==> $this->getMethodListItem($c, $m))
      |> Str\join($$, "\n")
      |> $header."\n\n".$$."\n";
  }

  private function getMethodListItem(
    ScannedClassish $c,
    ScannedMethod $m,
  ): string {
    $ns = $c->getNamespaceName();
    $docs = DocBlock::nullable($m->getDocComment());

    $ret = $m->isStatic() ? '::' : '->';
    $ret .= $m->getName();
    $ret .= _Private\stringify_generics($ns, $m->getGenericTypes());
    $ret .= _Private\stringify_parameters(
      $c->getNamespaceName(),
      _Private\StringifyFormat::ONE_LINE,
      $m,
      $docs,
    );

    $rt = $m->getReturnType();
    if ($rt !== null) {
      $ret .= ': '._Private\stringify_typehint($ns, $rt);
    }

    $summary = $docs?->getSummary();

    return \sprintf(
      '- [`%s`](%s)%s',
      $ret,
      $this->getLinkPathForMethod($c, $m),
      $summary === null ? '' : "\\\n".$summary,
    );
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
