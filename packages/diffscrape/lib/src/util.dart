import 'package:args/args.dart';

void printUsage(ArgParser argParser) {
  print('Usage: dart diffscrape.dart <flags> [arguments]');
  print(argParser.usage);
}
