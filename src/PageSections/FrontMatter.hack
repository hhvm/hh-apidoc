/*
 *  Copyright (c) 2018-present, Facebook, Inc.
 *  All rights reserved.
 *
 *  This source code is licensed under the MIT license found in the
 *  LICENSE file in the root directory of this source tree.
 *
 */

namespace Facebook\HHAPIDoc\PageSections;

use function Facebook\HHAPIDoc\get_path_for_documentable;
use namespace HH\Lib\{Dict, Str};

/** Renders 'front matter' (metadata) at the start of a document */
final class FrontMatter extends PageSection {
  const type TConfig = shape(
    ?'constantFields' => dict<string, string>,
    ?'permalinkPrefix' => string,
  );

  <<__Override>>
  public function getMarkdown(): ?string {
    $config = $this->context->getConfiguration()['frontMatter'] ?? null;
    if ($config === null) {
      return null;
    }

    $fields = $config['constantFields'] ?? dict[];
    $def = $this->documentable['definition'];

    $fields['title'] = $def->getName();
    $path = get_path_for_documentable(
      $this->context->getPathProvider(),
      $this->documentable,
    );
    if ($path is nonnull) {
      // Docusaurus
      $fields['id'] = \basename($path)
        |> Str\strip_suffix($$, '.md')
        |> Str\strip_suffix($$, '.html');
      // Jekyll
      $fields['docid'] = $fields['id'];
      $pp = $config['permalinkPrefix'] ?? null;
      if ($pp !== null) {
        if ($path !== null) {
          $fields['permalink'] = $pp.$path
            |> Str\strip_suffix($$, '.md')
            |> Str\strip_suffix($$, '.html')
            |> $$.'/';
        }
      }
    }

    return Dict\map_with_key($fields, ($k, $v) ==> $k.': '.$v)
      |> Str\join($$, "\n")
      |> "---\n".$$."\n---\n";
  }
}
