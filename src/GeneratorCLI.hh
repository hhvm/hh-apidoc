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

use type Facebook\DefinitionFinder\{
  ScannedClass,
  ScannedFunction,
  ScannedInterface,
  ScannedMethod,
  ScannedTrait,
  TreeParser,
};
use type Facebook\CLILib\CLIWithRequiredArguments;
use namespace Facebook\CLILib\CLIOptions;
use namespace Facebook\Markdown;
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
  private bool $raiseErrorOnUndocumentedDefinitions = false;

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
      CLIOptions\flag(
        () ==> {
          $this->raiseErrorOnUndocumentedDefinitions = true;
        },
        "Raise error on undocumented definitions",
        '--no-undoc-definitions',
        '-u',
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
    $context = new DocumentationBuilderContext(
      $this->format,
      $index,
      $paths,
      $this->syntaxHighlightingOn,
      $this->raiseErrorOnUndocumentedDefinitions,
    );
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

    $documentations = Map {};
    Vec\map(
      $documentables,
      ($documentable) ==> {
        $path = get_path_for_documentable($paths, $documentable);
        $this->verboseWrite($path."\n");
        try {
          $documentation = $md_builder->getDocumentation($documentable);
          $documentations[$path] = $documentation;
        } catch (Exceptions\UndocumentedDefinitionException $e) {
          $this->getStderr()->write($e->getMessage());
          \exit(1);
        }
      },
    );

    Vec\map_with_key(
      $documentations,
      ($path, $content) ==> {
        \file_put_contents($prefix.$path, $content);
      },
    );

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
