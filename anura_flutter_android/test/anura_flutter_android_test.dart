import 'package:anura_flutter_android/anura_flutter_android.dart';
import 'package:anura_flutter_platform_interface/anura_flutter_platform_interface.dart';
import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  group('AnuraFlutterAndroid', () {
    const kPlatformName = 'Android';
    late AnuraFlutterAndroid anuraFlutter;
    late List<MethodCall> log;

    setUp(() async {
      anuraFlutter = AnuraFlutterAndroid();

      log = <MethodCall>[];
      TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger
          .setMockMethodCallHandler(anuraFlutter.methodChannel, (methodCall) async {
        log.add(methodCall);
        switch (methodCall.method) {
          case 'getPlatformName':
            return kPlatformName;
          default:
            return null;
        }
      });
    });

    test('can be registered', () {
      AnuraFlutterAndroid.registerWith();
      expect(AnuraFlutterPlatform.instance, isA<AnuraFlutterAndroid>());
    });

    test('getPlatformName returns correct name', () async {
      final name = await anuraFlutter.getPlatformName();
      expect(
        log,
        <Matcher>[isMethodCall('getPlatformName', arguments: null)],
      );
      expect(name, equals(kPlatformName));
    });
  });
}
