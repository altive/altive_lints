import 'dart:convert';
import 'dart:io';

import 'package:html/parser.dart';
import 'package:http/http.dart' as http;

typedef Diff = Set<String>;
typedef Diffs = ({Diff inserts, Diff deletes});
const noDiff = (inserts: <String>{}, deletes: <String>{});

/// [uriPath] のURLをスクレイピングして [filePath] のファイルと差分あれば、
/// そのファイルをスクレイピングした内容で上書きする。
///
/// [uriPath] は、スクレイピング先のURLパス。
/// [filePath] は、スクレイピング結果と比較し上書きしたいファイルのパス。
/// [querySelector] は、スクレイピング先のHTMLのクエリセレクタ。
/// [verbose] は、詳細な出力をするかどうか。
Future<Diffs> scrape({
  required String uriPath,
  required String filePath,
  required String querySelector,
  required bool verbose,
}) async {
  final uri = Uri.tryParse(uriPath);
  if (uri == null) {
    stderr.writeln('Invalid URI: $uriPath');
    exit(1);
  }
  if (!await FileSystemEntity.isFile(filePath)) {
    stderr.writeln('Invalid file path: $filePath');
    exit(1);
  }
  final file = File(filePath);

  final oldSets = await _readFile(file, verbose);

  final newRulesText = await _scrape(
    uri: uri,
    querySelector: querySelector,
    verbose: verbose,
  );
  final newSets = newRulesText.split('\n').toSet();

  if (oldSets == newSets) {
    print('No diff.');
    return noDiff;
  }

  final inserts = oldSets.difference(newSets);
  print('inserts length: ${inserts.length}');
  if (verbose && inserts.isNotEmpty) {
    print('[VERBOSE] inserts: $inserts');
  }
  final deletes = newSets.difference(oldSets);
  print('deletes length: ${deletes.length}');
  if (verbose && deletes.isNotEmpty) {
    print('[VERBOSE] deletes: $deletes');
  }

  await _writeToFile(file, newRulesText);

  return (inserts: inserts, deletes: deletes);
}

Future<Diff> _readFile(File file, bool verbose) async {
  final lines = utf8.decoder.bind(file.openRead()).transform(LineSplitter());
  final set = <String>{};
  await for (final line in lines) {
    set.add(line);
  }
  if (verbose) {
    print('[VERBOSE] oldValue: $set');
  }
  return set;
}

Future<String> _scrape({
  required Uri uri,
  required String querySelector,
  required bool verbose,
}) async {
  // scraping HTML.
  final response = await http.get(uri);
  if (response.statusCode != 200) {
    stderr.writeln('Failed to get HTML: ${response.statusCode}');
    exit(1);
  }
  final document = parse(response.body);

  final element = document.querySelectorAll(querySelector).firstOrNull?.text;
  if (element == null) {
    stderr.writeln('No elements found.');
    exit(1);
  }
  if (verbose) {
    print('[VERBOSE] scraped element: $element');
  }
  return element;
}

Future<void> _writeToFile(File file, String value) async {
  await file.writeAsString('$value\n', mode: FileMode.writeOnly);
}
