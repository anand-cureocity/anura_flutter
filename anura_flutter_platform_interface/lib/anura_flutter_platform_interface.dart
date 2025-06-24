import 'package:anura_flutter_platform_interface/src/method_channel_anura_flutter.dart';
import 'package:plugin_platform_interface/plugin_platform_interface.dart';

/// The interface that implementations of anura_flutter must implement.
///
/// Platform implementations should extend this class
/// rather than implement it as `AnuraFlutter`.
/// Extending this class (using `extends`) ensures that the subclass will get
/// the default implementation, while platform implementations that `implements`
///  this interface will be broken by newly added [AnuraFlutterPlatform] methods
abstract class AnuraFlutterPlatform extends PlatformInterface {
  /// Constructs a AnuraFlutterPlatform.
  AnuraFlutterPlatform() : super(token: _token);

  static final Object _token = Object();

  static AnuraFlutterPlatform _instance = MethodChannelAnuraFlutter();

  /// The default instance of [AnuraFlutterPlatform] to use.
  ///
  /// Defaults to [MethodChannelAnuraFlutter].
  static AnuraFlutterPlatform get instance => _instance;

  /// Platform-specific plugins should set this with their own platform-specific
  /// class that extends [AnuraFlutterPlatform] when they register themselves.
  static set instance(AnuraFlutterPlatform instance) {
    PlatformInterface.verify(instance, _token);
    _instance = instance;
  }

  /// Return the current platform name.
  Future<Map<String,dynamic>?> launchAnuraScanner(Map<String, dynamic> user);
}
