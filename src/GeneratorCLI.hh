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

use type Facebook\DefinitionFinder\TreeParser;
use type Facebook\CLILib\CLIWithRequiredArguments;
use namespace Facebook\CLILib\CLIOptions;
use namespace HH\Lib\{Str, Vec};

/** The main `hh-apidoc` CLI */
final class GeneratorCLI extends CLIWithRequiredArguments {
  <<__Override>>
  public static function getHelpTextForRequiredArguments(): vec<string> {
    return vec['SOURCE_PATH'];
  }

  private OutputFormat $format = OutputFormat::HTML;
  private ?string $outputRoot = null;
  private int $verbosity = 0;
  private bool $syntaxHighlightingOn = true;

  <<__Override>>
  protected function getSupportedOptions(): vec<CLIOptions\CLIOption> {
    return vec[
      CLIOptions\flag(
        () ==> { $this->verbosity++; },
        "Increase output verbosity",
        '--verbose',
        '-v',
      ),
      CLIOptions\with_required_enum(
        OutputFormat::class,
        $f ==> { $this->format = $f; },
        Str\format(
          "Desired output format (%s). Default: %s",
          Str\join(OutputFormat::getValues(), '|'),
          (string) $this->format,
        ),
        '--format',
        '-f',
      ),
      CLIOptions\with_required_string(
        $s ==> { $this->outputRoot = $s; },
        "Directory for output files. Default: working directory",
        '--output',
        '-o',
      ),
      CLIOptions\flag(
        () ==> {
          $this->syntaxHighlightingOn = false;
        },
        "Generate documentation without syntax highlighting",
        '--no-highlighting',
        '-n',
      ),
    ];
  }

  private function parse(): vec<Documentable> {
    return $this->getArguments()
      |> Vec\map($$, $root ==> \HH\Asio\join(TreeParser::fromPathAsync($root)))
      |> Vec\map($$, $parser ==> Documentables\from_parser($parser))
      |> Vec\flatten($$);
  }

  <<__Override>>
  public async function mainAsync(): Awaitable<int> {
    switch ($this->format) {
      case OutputFormat::MARKDOWN:
        $extension = '.md';
        break;
      case OutputFormat::HTML:
        $extension = '.html';
        break;
    }

    $this->getStdout()->write("Parsing...\n");
    $documentables = $this->parse();
    $index = create_index($documentables);

    $paths = new SingleDirectoryPathProvider($extension);
    $config = shape(
      'format' => $this->format,
      'syntaxHighlighting' => $this->syntaxHighlightingOn,
    );
    $context = new DocumentationBuilderContext($index, $paths, $config);
    $md_builder = new DocumentationBuilder($context);

    if ($this->outputRoot === null) {
      $prefix = '';
    } else {
      $prefix = $this->outputRoot;
      if (!Str\ends_with($prefix, '/')) {
        $prefix .= '/';
      }
    }
    if (!\is_dir($prefix)) {
      \mkdir($prefix);
    }

    $this->getStdout()->write("Generating documentation...\n");
    foreach ($documentables as $documentable) {
      $content = $md_builder->getDocumentation($documentable);
      $path = get_path_for_documentable($paths, $documentable);
      \file_put_contents($prefix.$path, $content);
      $this->verboseWrite($path."\n");
    }
    $this->getStdout()->write("Creating index document...\n");
    \file_put_contents(
      $prefix.'index'.$extension,
      (new IndexDocumentBuilder($context))->getIndexDocument(),
    );

    $this->getStdout()->write("Done.\n");

    return 0;
  }

  /** Write output only if verbose mode is set */
  private function verboseWrite(string $what): void {
    if ($this->verbosity === 0) {
      return;
    }
    $this->getStdout()->write($what);
  }
}
