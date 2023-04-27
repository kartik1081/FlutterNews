import 'package:plugin_platform_interface/plugin_platform_interface.dart';

import 'mvvm_plugin_method_channel.dart';

abstract class MvvmPluginPlatform extends PlatformInterface {
  /// Constructs a MvvmPluginPlatform.
  MvvmPluginPlatform() : super(token: _token);

  static final Object _token = Object();

  static MvvmPluginPlatform _instance = MethodChannelMvvmPlugin();

  /// The default instance of [MvvmPluginPlatform] to use.
  ///
  /// Defaults to [MethodChannelMvvmPlugin].
  static MvvmPluginPlatform get instance => _instance;

  /// Platform-specific implementations should set this with their own
  /// platform-specific class that extends [MvvmPluginPlatform] when
  /// they register themselves.
  static set instance(MvvmPluginPlatform instance) {
    PlatformInterface.verifyToken(instance, _token);
    _instance = instance;
  }

  Future<String?> getPlatformVersion();
  Future<bool?> checkNetwork();
  void showToast({required Map<String, String> data});
  void pushNotification({required Map<String, dynamic> msg});
  void launchUrl({required Map<String, String> data});
  void openCamera();
  Future<List?> getContacts();
  void download({required Map<String, String> data});
  Future<bool?> biometricAuth();
  Future<void> payWithUpi({required Map<String, String> data});
  void telephoneDetails();
  Future<bool?> isKeyguardSecure();
}
