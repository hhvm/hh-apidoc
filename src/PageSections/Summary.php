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

/** A short summary of the current item.
 *
 * This is usually a one-liner, and is the first sentence or line immediately
 * following `/**`.
 */
final class Summary extends PageSection {
  <<__Override>>
  public function getMarkdown(): ?string {
    return $this->docBlock?->getSummary();
  }
}
