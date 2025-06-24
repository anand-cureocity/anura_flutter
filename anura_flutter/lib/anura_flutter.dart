import 'package:anura_flutter/models/anura_user_model.dart';
import 'package:anura_flutter_platform_interface/anura_flutter_platform_interface.dart';

AnuraFlutterPlatform get _platform => AnuraFlutterPlatform.instance;

/// Returns the name of the current platform.
Future<void> launchAnuraScanner(AnuraUserModel userModel) async {
  final platformName = await _platform.launchAnuraScanner(userModel.toJson());
  // if (platformName == null) throw Exception('Unable to get platform name.');
  return platformName;
}
