import 'package:args/args.dart';
import 'package:diffscrape/diffscrape.dart';
import 'package:diffscrape/src/arg.dart';
import 'package:diffscrape/src/util.dart';

const String version = '0.0.1';

void main(List<String> arguments) {
  final argParser = buildParser();
  final ArgResults results;
  try {
    results = argParser.parse(arguments);
  } on FormatException catch (e) {
    // Print usage information if an invalid argument was provided.
    print(e.message);
    print('');
    printUsage(argParser);
    return;
  }

  if (results.wasParsed('help')) {
    printUsage(argParser);
    return;
  }
  if (results.wasParsed('version')) {
    print('diffscrape version: $version');
    return;
  }

  final verbose = results.wasParsed('verbose');

  print('Positional arguments: ${results.rest}');
  if (verbose) {
    print('[VERBOSE] All arguments: ${results.arguments}');
  }
  scrape(
    uriPath: results[argUri] as String,
    filePath: results[argFile] as String,
    querySelector: results[argQuerySelector] as String,
    verbose: verbose,
  );
}
