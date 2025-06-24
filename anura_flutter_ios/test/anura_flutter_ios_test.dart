import 'package:anura_flutter_ios/anura_flutter_ios.dart';
import 'package:anura_flutter_platform_interface/anura_flutter_platform_interface.dart';
import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  group('AnuraFlutterIOS', () {
    const kPlatformName = 'iOS';
    late AnuraFlutterIOS anuraFlutter;
    late List<MethodCall> log;

    setUp(() async {
      anuraFlutter = AnuraFlutterIOS();

      log = <MethodCall>[];
      TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger
          .setMockMethodCallHandler(anuraFlutter.methodChannel,
              (methodCall) async {
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
      AnuraFlutterIOS.registerWith();
      expect(AnuraFlutterPlatform.instance, isA<AnuraFlutterIOS>());
    });

    test('getPlatformName returns correct name', () async {
      //TODO
      
      // final name = await anuraFlutter.launchAnuraScanner();
      // expect(
      //   log,
      //   <Matcher>[isMethodCall('getPlatformName', arguments: null)],
      // );
      // expect(name, equals(kPlatformName));
    });
  });
}
