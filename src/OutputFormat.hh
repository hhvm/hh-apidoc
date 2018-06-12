<?hh // strict
/*
 *  Copyright (c) 2018-present, Facebook, Inc.
 *  All rights reserved.
 *
 *  This source code is licensed under the MIT license found in the
 *  LICENSE file in the root directory of this source tree.
 *
 */

namespace Facebook\HHAPIDoc;

/** The format of documentation to generate */
enum OutputFormat: string {
  /** GitHub Flavored Markdown */
  MARKDOWN = 'markdown';
  /** @selfdocumenting */
  HTML = 'html';
}
