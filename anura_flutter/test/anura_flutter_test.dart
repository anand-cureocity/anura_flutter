// import 'package:anura_flutter/anura_flutter.dart';
import 'package:anura_flutter_platform_interface/anura_flutter_platform_interface.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:plugin_platform_interface/plugin_platform_interface.dart';

class MockAnuraFlutterPlatform extends Mock
    with MockPlatformInterfaceMixin
    implements AnuraFlutterPlatform {}

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  group('AnuraFlutter', () {
    late AnuraFlutterPlatform anuraFlutterPlatform;

    setUp(() {
      anuraFlutterPlatform = MockAnuraFlutterPlatform();
      AnuraFlutterPlatform.instance = anuraFlutterPlatform;
    });

    group('getPlatformName', () {
      test('returns correct name when platform implementation exists',
          () async {
          //TODO:

        // const platformName = '__test_platform__';
        // when(
        //   () => anuraFlutterPlatform.launchAnuraScanner(),
        // ).thenAnswer((_) async => platformName);

        // final actualPlatformName = await getPlatformName();
        // expect(actualPlatformName, equals(platformName));
      });

      test('throws exception when platform implementation is missing',
          () async {
//TODO

        // when(
        //   () => anuraFlutterPlatform.launchAnuraScanner(),
        // ).thenAnswer((_) async{});

        // expect(getPlatformName, throwsException);
      });
    });
  });
}
