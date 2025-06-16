import 'package:anura_flutter_platform_interface/anura_flutter_platform_interface.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';

/// The Android implementation of [AnuraFlutterPlatform].
class AnuraFlutterAndroid extends AnuraFlutterPlatform {
  /// The method channel used to interact with the native platform.
  @visibleForTesting
  final methodChannel = const MethodChannel('anura_flutter_android');

  /// Registers this class as the default instance of [AnuraFlutterPlatform]
  static void registerWith() {
    AnuraFlutterPlatform.instance = AnuraFlutterAndroid();
  }

  @override
  Future<String?> getPlatformName() {
    return methodChannel.invokeMethod<String>('getPlatformName');
  }
}
