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

use namespace HH\Lib\{C, Str, Vec};

class DeprecationMessage extends PageSection {
  protected function getDeprecationMessage(): ?string {
    $deprecated = $this->definition->getAttributes()['__Deprecated'] ?? null;
    if ($deprecated === null) {
      return null;
    }
    return (string) C\firstx($deprecated);
  }

  public function getMarkdown(): ?string {
    $message = $this->getDeprecationMessage();
    if ($message === null) {
      return null;
    }
    return "**Deprecated:** ".$message;
  }
}
