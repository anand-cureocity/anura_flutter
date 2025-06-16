import 'package:anura_flutter_platform_interface/anura_flutter_platform_interface.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';

/// The iOS implementation of [AnuraFlutterPlatform].
class AnuraFlutterIOS extends AnuraFlutterPlatform {
  /// The method channel used to interact with the native platform.
  @visibleForTesting
  final methodChannel = const MethodChannel('anura_flutter_ios');

  /// Registers this class as the default instance of [AnuraFlutterPlatform]
  static void registerWith() {
    AnuraFlutterPlatform.instance = AnuraFlutterIOS();
  }

  @override
  Future<String?> getPlatformName() {
    return methodChannel.invokeMethod<String>('getPlatformName');
  }
}
