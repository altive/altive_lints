import 'package:analysis_server_plugin/edit/dart/correction_producer.dart';

/// Retrieves the package name from the pubspec.yaml file.
extension ResolvedCorrectionProducerExtension on ResolvedCorrectionProducer {
  /// Retrieves the package name.
  String? get packageName {
    // Access the ResolvedUnitResult which contains the session and unit.
    final result = unitResult;

    // [Fast] Try to get the URI from the declared fragment (New Analyzer API)
    final uri = result.unit.declaredFragment?.source.uri;

    if (uri != null && uri.isScheme('package')) {
      return uri.pathSegments.first;
    }

    // [Robust] Try to parse pubspec.yaml (for test/bin/example folders)
    try {
      final contextRoot = result.session.analysisContext.contextRoot;

      // Look for pubspec.yaml in the context root
      final pubspecFile = contextRoot.root.getChildAssumingFile('pubspec.yaml');

      if (pubspecFile.exists) {
        final content = pubspecFile.readAsStringSync();
        // Extract the name using Regex to avoid heavy YAML parsing
        final match = RegExp(
          r'^name:\s+([a-zA-Z0-9_]+)',
          multiLine: true,
        ).firstMatch(content);
        return match?.group(1);
      }
    } on Exception catch (_) {
      // Ignore errors (e.g., file read errors)
    }

    return null;
  }
}
