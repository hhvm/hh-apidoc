<?hh // strict
/*
 *  Copyright (c) 2018-present, Facebook, Inc.
 *  All rights reserved.
 *
 *  This source code is licensed under the MIT license found in the
 *  LICENSE file in the root directory of this source tree.
 *
 */

namespace Facebook\HHAPIDoc\Exceptions;

/**
 * Exception thrown on undocumented definition
 */
final class UndocumentedDefinitionException extends \Exception {

  <<__Override>>
  public function __construct(
    private string $fieldname,
    private string $fileName,
  ) {
    parent::__construct();
  }

  <<__Override>>
  public function getMessage(): string {
    return "Error while generating documentation: ".
      "Undocumented definition '".
      $this->fieldname.
      "' found ".
      "at path: ".
      $this->fileName."\n";
  }
}
