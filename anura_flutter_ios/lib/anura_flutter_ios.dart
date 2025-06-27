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
  Future<Map<String, dynamic>?> launchAnuraScanner(
      Map<String, dynamic> user) async {
    final data = await methodChannel.invokeMethod<Map<Object?, Object?>>(
      'launchAnuraScanner',
      user,
    );

    final cast = castMapRecursively(data);
    return cast;
  }
}

Map<String, dynamic> castMapRecursively(Map<Object?, Object?>? input) {
  if (input == null) return {};

  final result = <String, dynamic>{};

  input.forEach((key, value) {
    if (key == null) return; // Skip null keys

    final stringKey = key.toString();

    if (value is Map<Object?, Object?>) {
      result[stringKey] = castMapRecursively(value); // Recurse into map
    } else if (value is List) {
      result[stringKey] = value.map((item) {
        if (item is Map<Object?, Object?>) {
          return castMapRecursively(item); // Recurse into map inside list
        }
        return item;
      }).toList();
    } else {
      result[stringKey] = value; // Keep value, even if null
    }
  });

  return result;
}
