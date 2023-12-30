import 'package:args/args.dart';

const argUri = 'uri';
const argFile = 'file';
const argQuerySelector = 'query-selector';
const argFilteringPrefix = 'filtering-prefix';

ArgParser buildParser() {
  return ArgParser()
    ..addOption(
      argUri,
      abbr: 'u',
      mandatory: true,
      help: 'URI to scrape.',
    )
    ..addOption(
      argFile,
      abbr: 'f',
      mandatory: true,
      help: 'Path to the file to compare against.',
    )
    ..addOption(
      argQuerySelector,
      abbr: 'q',
      mandatory: true,
      help: 'HTML query selector for the result.',
    )
    ..addOption(
      argFilteringPrefix,
      abbr: 'p',
      help: 'Filtering prefix for the result.',
    )
    // common flags.
    ..addFlag(
      'help',
      abbr: 'h',
      negatable: false,
      help: 'Print this usage information.',
    )
    ..addFlag(
      'verbose',
      abbr: 'v',
      negatable: false,
      help: 'Show additional command output.',
    )
    ..addFlag(
      'version',
      negatable: false,
      help: 'Print the tool version.',
    );
}
