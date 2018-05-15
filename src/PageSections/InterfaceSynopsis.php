<?hh // strict
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
  ScannedBasicClass,
  ScannedClass,
  ScannedInterface,
  ScannedMethod,
  ScannedTrait,
};
use namespace HH\Lib\{Str, Vec};

class InterfaceSynopsis extends PageSection {
  public function getMarkdown(): ?string {
    $c = $this->definition;
    if (!$c instanceof ScannedClass) {
      return null;
    }

    return
      "## Interface Synopsis\n\n".
      $this->getInheritanceInformation($c)."\n\n".
      $this->getMethodList($c);
  }

  protected function getMethodList(
    ScannedClass $c,
  ): string {
    return $c->getMethods()
      |> Vec\sort_by($$, $m ==> $m->getName())
      |> Vec\map($$, $m ==> $this->getMethodListItem($c, $m))
      |> Str\join($$, "\n");
  }

  protected function getMethodListItem(
    ScannedClass $c,
    ScannedMethod $m,
  ): string {
    $docs = DocBlock::nullable($m->getDocComment());

    $ret = $m->isStatic() ? '::' : '->';
    $ret .= $m->getName();
    $ret .= _Private\stringify_generics($m->getGenericTypes());
    $ret .= _Private\stringify_parameters(
      _Private\StringifyFormat::ONE_LINE,
      $m,
      $docs,
    );

    $rt = $m->getReturnType();
    if ($rt !== null) {
      $ret .= ': '._Private\stringify_typehint($rt);
    }

    $summary = $docs?->getSummary();

    return \sprintf(
      '- [`%s`](%s)%s',
      $ret,
      $this->getLinkPathForMethod($c, $m),
      $summary === null ? '' : "\\\n".$summary,
    );
  }

  protected function getLinkPathForMethod(
    ScannedClass $c,
    ScannedMethod $m,
  ): ?string {
    $pp = $this->context->getPathProvider();
    if ($c instanceof ScannedBasicClass) {
      return $pp->getPathForClassMethod($c->getName(), $m->getName());
    }
    if ($c instanceof ScannedInterface) {
      return $pp->getPathForInterfaceMethod($c->getName(), $m->getName());
    }
    if ($c instanceof ScannedTrait) {
      return $pp->getPathForTraitMethod($c->getName(), $m->getName());
    }
    invariant_violation(
      "Don't know how to handle type %s",
      \get_class($c),
    );
  }

  protected function getInheritanceInformation(
    ScannedClass $c,
  ): string {
    $ret = '';

    $ns = $c->getNamespaceName();
    if ($ns !== '') {
      $ret .= 'namespace '.$ns." {\n";
    }

    if ($c instanceof ScannedBasicClass) {
      $ret .= 'class ';
    } else if ($c instanceof ScannedInterface) {
      $ret .= 'interface ';
    } else if ($c instanceof ScannedTrait) {
      $ret .= 'trait ';
    } else {
      invariant_violation(
        "Don't know what a %s is.",
        \get_class($c),
      );
    }

    $ret .= $c->getShortName().' ';

    if (($p = $c->getParentClassName()) !== null) {
      $ret .= 'extends '.$p.' ';
    }
    if ($interfaces = $c->getInterfaceNames()) {
      $ret .= 'implements '.Str\join($interfaces, ', ');
    }

    $ret .= ' {...}';

    if ($ns !== '') {
      $ret .= "\n}";
    }

    return "```Hack\n".$ret."\n```";
  }
}
