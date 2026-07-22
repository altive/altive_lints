import 'dart:convert';
import 'dart:io';

Future<void> main() async {
  final repository = Directory.current.absolute;
  final presetSource = Directory(
    '${repository.path}/packages/altive_lints',
  ).absolute;
  final pluginPath = Directory(
    '${repository.path}/packages/altive_lints_plugin',
  ).absolute.path;
  final fixture = await Directory.systemTemp.createTemp(
    'altive_lints_v4_split_',
  );

  try {
    final preset = Directory('${fixture.path}/altive_lints');
    final consumer = Directory('${fixture.path}/consumer');
    await Directory('${preset.path}/lib').create(recursive: true);
    await Directory('${consumer.path}/lib').create(recursive: true);

    final sourcePubspec = await File(
      '${presetSource.path}/pubspec.yaml',
    ).readAsString();
    if (RegExp('^dependencies:', multiLine: true).hasMatch(sourcePubspec)) {
      throw StateError('altive_lints must not have runtime dependencies.');
    }
    await File('${preset.path}/pubspec.yaml').writeAsString('''
name: altive_lints
version: 4.0.0

environment:
  sdk: ^3.10.0
''');
    await File(
      '${presetSource.path}/lib/all_lint_rules.yaml',
    ).copy('${preset.path}/lib/all_lint_rules.yaml');
    await File(
      '${presetSource.path}/lib/altive_lints_preset.yaml',
    ).copy('${preset.path}/lib/altive_lints_preset.yaml');
    final options = await File(
      '${presetSource.path}/lib/altive_lints.yaml',
    ).readAsString();
    final localOptions = options.replaceFirst(
      'version: ^1.0.0',
      'path: ${jsonEncode(pluginPath)}',
    );
    if (localOptions == options) {
      throw StateError('Could not replace the published plugin constraint.');
    }
    await File(
      '${preset.path}/lib/altive_lints.yaml',
    ).writeAsString(localOptions);

    await File('${consumer.path}/pubspec.yaml').writeAsString('''
name: altive_lints_v4_split_fixture
publish_to: none

environment:
  sdk: ^3.12.0

dev_dependencies:
  altive_lints:
    path: ${jsonEncode(preset.path)}
  flutter_test:
    sdk: flutter
  test: 1.31.0
  test_api: 0.7.11
''');
    await File('${consumer.path}/analysis_options.yaml').writeAsString('''
include: package:altive_lints/altive_lints.yaml
''');
    await File('${consumer.path}/lib/main.dart').writeAsString('''
void main() {
  print('\u3053\u3093\u306b\u3061\u306f');
}
''');

    await _run('flutter', ['pub', 'get'], consumer.path);

    final packageConfig =
        jsonDecode(
              await File(
                '${consumer.path}/.dart_tool/package_config.json',
              ).readAsString(),
            )
            as Map<String, Object?>;
    final packages = (packageConfig['packages']! as List<Object?>)
        .cast<Map<String, Object?>>();
    final packageNames = packages.map((package) => package['name']).toSet();
    if (packageNames.contains('altive_lints_plugin')) {
      throw StateError(
        'altive_lints_plugin leaked into the consuming pub workspace.',
      );
    }
    final analyzer = packages.singleWhere(
      (package) => package['name'] == 'analyzer',
    );
    if (!(analyzer['rootUri']! as String).contains('analyzer-12.1.0')) {
      throw StateError(
        'Expected the consuming workspace to resolve analyzer 12.1.0, '
        'but found ${analyzer['rootUri']}.',
      );
    }

    final analyzeResult = await _run(
      Platform.resolvedExecutable,
      ['analyze'],
      consumer.path,
    );
    if (!analyzeResult.stdout.toString().contains('avoid_hardcoded_japanese')) {
      throw StateError(
        'The separately resolved plugin did not report its custom lint.',
      );
    }
  } finally {
    await fixture.delete(recursive: true);
  }
}

Future<ProcessResult> _run(
  String executable,
  List<String> arguments,
  String workingDirectory,
) async {
  final result = await Process.run(
    executable,
    arguments,
    workingDirectory: workingDirectory,
    environment: {'DART_SUPPRESS_ANALYTICS': 'true'},
  );
  stdout.write(result.stdout);
  stderr.write(result.stderr);
  if (result.exitCode != 0) {
    throw ProcessException(
      executable,
      arguments,
      'Command failed with exit code ${result.exitCode}.',
      result.exitCode,
    );
  }
  return result;
}
