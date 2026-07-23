import 'dart:async';

import 'package:analysis_server_plugin/src/correction/fix_generators.dart';
import 'package:analysis_server_plugin/src/plugin_server.dart';
import 'package:altive_lints_plugin/altive_lints_plugin.dart';
import 'package:analyzer/src/test_utilities/mock_sdk.dart';
import 'package:analyzer_plugin/channel/channel.dart';
import 'package:analyzer_plugin/protocol/protocol.dart' as protocol;
import 'package:analyzer_plugin/protocol/protocol_common.dart' as protocol;
import 'package:analyzer_plugin/protocol/protocol_generated.dart' as protocol;
import 'package:analyzer_plugin/src/protocol/protocol_internal.dart'
    as protocol;
import 'package:analyzer_testing/resource_provider_mixin.dart';
import 'package:test/test.dart';

void main() {
  test('the plugin server registers and applies every assist', () async {
    final harness = _AssistHarness();
    addTearDown(harness.dispose);
    await harness.start();

    await harness.expectSingleAssist(
      fileName: 'method.dart',
      source: '''
class MyClass {
  void myMethod() {}
}
''',
      selection: 'myMethod',
      expected: '''
class MyClass {
  /// {@macro test_package.MyClass.myMethod}
  void myMethod() {}
}
''',
    );
    await harness.expectSingleAssist(
      fileName: 'template.dart',
      source: 'class MyClass {}\n',
      selection: 'MyClass',
      expected:
          [
            '/// {@template test_package.MyClass}',
            '/// ',
            '/// {@endtemplate}',
            'class MyClass {}',
          ].join('\n') +
          '\n',
    );
    await harness.expectSingleAssist(
      fileName: 'wrap.dart',
      source: '''
/// Existing documentation.
class MyClass {}
''',
      selection: 'Existing',
      expected: '''
/// {@template test_package.MyClass}
/// Existing documentation.
/// {@endtemplate}
class MyClass {}
''',
    );
  });
}

class _AssistHarness with ResourceProviderMixin {
  final channel = _FakeChannel();
  late final PluginServer _server;

  String get _byteStorePath => convertPath('/byteStore');
  String get _packagePath => convertPath('/test_package');
  String get _sdkPath => convertPath('/sdk');

  void dispose() {
    registeredFixGenerators
      ..clearLintProducers()
      ..clearWarningProducers();
    channel.close();
  }

  Future<void> expectSingleAssist({
    required String fileName,
    required String source,
    required String selection,
    required String expected,
  }) async {
    final filePath = join(_packagePath, 'lib', fileName);
    newFile(filePath, source);
    await channel.sendRequest(
      protocol.AnalysisHandleWatchEventsParams([
        protocol.WatchEvent(protocol.WatchEventType.ADD, filePath),
      ]),
    );

    final selectionOffset = source.indexOf(selection) + 1;
    final result = await _server.handleEditGetAssists(
      protocol.EditGetAssistsParams(filePath, selectionOffset, 0),
    );
    expect(result.assists, hasLength(1));

    final edits = result.assists.single.change.edits.single.edits;
    expect(protocol.SourceEdit.applySequence(source, edits), expected);
  }

  Future<void> start() async {
    createMockSdk(
      resourceProvider: resourceProvider,
      root: getFolder(_sdkPath),
    );
    newFile(join(_packagePath, 'pubspec.yaml'), 'name: test_package\n');
    newAnalysisOptionsYamlFile(_packagePath, '''
plugins:
  altive_lints_plugin:
    path: /altive_lints_plugin
''');

    _server = PluginServer(
      resourceProvider: resourceProvider,
      plugins: [plugin],
    );
    await _server.initialize();
    _server.start(channel);
    await _server.handlePluginVersionCheck(
      protocol.PluginVersionCheckParams(_byteStorePath, _sdkPath, '0.0.1'),
    );
    await channel.sendRequest(
      protocol.AnalysisSetContextRootsParams([
        protocol.ContextRoot(_packagePath, []),
      ]),
    );
  }
}

class _FakeChannel implements PluginCommunicationChannel {
  final _completers = <String, Completer<protocol.Response>>{};
  final _notifications = StreamController<protocol.Notification>();
  void Function(protocol.Request)? _onRequest;
  var _id = 0;

  @override
  void close() {
    _notifications.close();
  }

  @override
  void listen(
    void Function(protocol.Request request)? onRequest, {
    void Function()? onDone,
    Function? onError,
    Function? onNotification,
  }) {
    _onRequest = onRequest;
  }

  @override
  void sendNotification(protocol.Notification notification) {
    _notifications.add(notification);
  }

  Future<protocol.Response> sendRequest(protocol.RequestParams parameters) {
    final request = parameters.toRequest((_id++).toString());
    final completer = Completer<protocol.Response>();
    _completers[request.id] = completer;
    _onRequest!(request);
    return completer.future;
  }

  @override
  void sendResponse(protocol.Response response) {
    _completers.remove(response.id)?.complete(response);
  }
}
