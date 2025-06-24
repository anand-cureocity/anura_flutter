import 'package:anura_flutter/models/anura_scanned_data.dart';
import 'package:anura_flutter/models/anura_user_model.dart';
import 'package:anura_flutter_platform_interface/anura_flutter_platform_interface.dart';

AnuraFlutterPlatform get _platform => AnuraFlutterPlatform.instance;

/// Returns the name of the current platform.
Future<AnuraScannedData> launchAnuraScanner(AnuraUserModel userModel) async {
  final platformName = await _platform.launchAnuraScanner(userModel.toJson());
  if (platformName == null) throw Exception('Unable to get Scanned results.');
  return AnuraScannedData.fromJson(platformName);
}
