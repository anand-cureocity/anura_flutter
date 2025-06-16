import 'package:anura_flutter_platform_interface/anura_flutter_platform_interface.dart';

AnuraFlutterPlatform get _platform => AnuraFlutterPlatform.instance;

/// Returns the name of the current platform.
Future<String> getPlatformName() async {
  final platformName = await _platform.getPlatformName();
  if (platformName == null) throw Exception('Unable to get platform name.');
  return platformName;
}
