/*
 *  Copyright (c) 2018-present, Facebook, Inc.
 *  All rights reserved.
 *
 *  This source code is licensed under the MIT license found in the
 *  LICENSE file in the root directory of this source tree.
 *
 */

namespace Facebook\HHAPIDoc\PageSections\_Private;

/**
 * @reviewer This is /intentionally/ extremely painfully ugly.
 * Do not accept the PR like this.
 * I am not happy with this approach.
 *
 * This filtering must take place in InterfaceSynopsis::getMarkdown().
 * It reads out the scanned class directly.
 * We should not remove the methods from the class, so getMarkdown() won't find them.
 * That is an even worse solution.
 *
 * getMarkDown() cannot take arguments, because it is an <<__Override>>
 * and the constructor cannot take any new arguments either, because it is a <<__ConsistentConstruct>>.
 * We also can't add a method to the class `->setHidePrivateMethods()`, it's constructor is never called directly.
 * It is called via the <<__ConsistentConstruct>> of PageSection.
 *
 * I would like to discuss a better way to hand this boolean to that method.
 */
final class Globals {
  public static bool $shouldHidePrivateMethods = false;
}
