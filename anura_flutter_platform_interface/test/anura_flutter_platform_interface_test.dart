import 'package:anura_flutter_platform_interface/anura_flutter_platform_interface.dart';
import 'package:flutter_test/flutter_test.dart';

class AnuraFlutterMock extends AnuraFlutterPlatform {
  static const mockPlatformName = 'Mock';

  @override
  Future<String?> getPlatformName() async => mockPlatformName;
}

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();
  group('AnuraFlutterPlatformInterface', () {
    late AnuraFlutterPlatform anuraFlutterPlatform;

    setUp(() {
      anuraFlutterPlatform = AnuraFlutterMock();
      AnuraFlutterPlatform.instance = anuraFlutterPlatform;
    });

    group('getPlatformName', () {
      test('returns correct name', () async {
        expect(
          await AnuraFlutterPlatform.instance.getPlatformName(),
          equals(AnuraFlutterMock.mockPlatformName),
        );
      });
    });
  });
}
