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
  final exampleSource = Directory(
    '${presetSource.path}/example',
  ).absolute;
  final fixture = await Directory.systemTemp.createTemp(
    'altive_lints_v4_split_',
  );

  try {
    final preset = Directory('${fixture.path}/altive_lints');
    final consumer = Directory('${fixture.path}/consumer');
    final flutterApp = Directory('${consumer.path}/apps/flutter_app');
    final dartPackage = Directory('${consumer.path}/packages/dart_package');
    await Directory('${preset.path}/lib').create(recursive: true);
    await flutterApp.create(recursive: true);
    await Directory('${dartPackage.path}/lib').create(recursive: true);

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

workspace:
  - apps/flutter_app
  - packages/dart_package

dev_dependencies:
  altive_lints:
    path: ${jsonEncode(preset.path)}
''');
    await File('${flutterApp.path}/pubspec.yaml').writeAsString('''
name: flutter_app
publish_to: none
resolution: workspace

environment:
  sdk: ^3.12.0

dependencies:
  flutter:
    sdk: flutter

dev_dependencies:
  clock: ^1.1.2
  flutter_test:
    sdk: flutter
''');
    await File('${dartPackage.path}/pubspec.yaml').writeAsString('''
name: dart_package
publish_to: none
resolution: workspace

environment:
  sdk: ^3.12.0

dev_dependencies:
  test: 1.31.0
''');
    await File('${dartPackage.path}/lib/dart_package.dart').writeAsString('''
int add(int left, int right) => left + right;
''');
    await File('${exampleSource.path}/analysis_options.yaml').copy(
      '${consumer.path}/analysis_options.yaml',
    );
    for (final name in ['main.dart', 'assists.dart']) {
      await File(
        '${exampleSource.path}/$name',
      ).copy('${flutterApp.path}/$name');
    }
    final exampleRules = await File(
      '${exampleSource.path}/rules.dart',
    ).readAsString();
    final fixtureRules = File('${flutterApp.path}/rules.dart');
    await fixtureRules.writeAsString(exampleRules);

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
    final testApi = packages.singleWhere(
      (package) => package['name'] == 'test_api',
    );
    if (!(testApi['rootUri']! as String).contains('test_api-0.7.11')) {
      throw StateError(
        'Expected flutter_test to pin test_api 0.7.11, '
        'but found ${testApi['rootUri']}.',
      );
    }

    const expectedDiagnostics = {
      'avoid_consecutive_sliver_to_box_adapter',
      'avoid_hardcoded_color',
      'avoid_hardcoded_japanese',
      'avoid_shrink_wrap_in_list_view',
      'avoid_single_child',
      'prefer_clock_now',
      'prefer_dedicated_media_query_methods',
      'prefer_space_between_elements',
      'prefer_to_include_sliver_in_name',
    };
    final ignoredAnalyzeResult = await _run(
      Platform.resolvedExecutable,
      ['analyze'],
      consumer.path,
    );
    final unexpectedDiagnostics = expectedDiagnostics
        .where(
          (diagnostic) => ignoredAnalyzeResult.stdout.toString().contains(
            diagnostic,
          ),
        )
        .toList();
    if (unexpectedDiagnostics.isNotEmpty) {
      throw StateError(
        'The example ignore prefixes did not suppress these diagnostics: '
        '${unexpectedDiagnostics.join(', ')}',
      );
    }

    await fixtureRules.writeAsString(
      exampleRules.replaceFirst(
        RegExp(r'^// ignore_for_file:.*\n', multiLine: true),
        '',
      ),
    );
    final analyzeResult = await _run(
      Platform.resolvedExecutable,
      ['analyze'],
      consumer.path,
    );
    final analyzeOutput = analyzeResult.stdout.toString();
    final missingDiagnostics = expectedDiagnostics
        .where((diagnostic) => !analyzeOutput.contains(diagnostic))
        .toList();
    if (missingDiagnostics.isNotEmpty) {
      throw StateError(
        'The example did not report these custom diagnostics: '
        '${missingDiagnostics.join(', ')}',
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
