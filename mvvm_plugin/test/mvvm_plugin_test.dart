import 'package:flutter_test/flutter_test.dart';
import 'package:mvvm_plugin/mvvm_plugin.dart';
import 'package:mvvm_plugin/mvvm_plugin_platform_interface.dart';
import 'package:mvvm_plugin/mvvm_plugin_method_channel.dart';
import 'package:plugin_platform_interface/plugin_platform_interface.dart';

class MockMvvmPluginPlatform
    with MockPlatformInterfaceMixin
    implements MvvmPluginPlatform {
  @override
  Future<String?> getPlatformVersion() => Future.value('42');

  @override
  Future<bool?> checkNetwork() => Future.value(false);

  @override
  void pushNotification({required Map<String, dynamic> msg}) {}

  @override
  void showToast({required Map<String, String> data}) {}

  @override
  void launchUrl({required Map<String, String> data}) {}

  @override
  void openCamera() {}

  @override
  Future<List> getContacts() => Future.value([]);

  @override
  void download({required Map<String, String> data}) {}

  @override
  Future<bool?> biometricAuth() => Future.value(false);

  void main() {
    final MvvmPluginPlatform initialPlatform = MvvmPluginPlatform.instance;

    test('$MethodChannelMvvmPlugin is the default instance', () {
      expect(initialPlatform, isInstanceOf<MethodChannelMvvmPlugin>());
    });

    test('getPlatformVersion', () async {
      MvvmPlugin mvvmPlugin = MvvmPlugin();
      MockMvvmPluginPlatform fakePlatform = MockMvvmPluginPlatform();
      MvvmPluginPlatform.instance = fakePlatform;

      expect(await mvvmPlugin.getPlatformVersion(), '42');
    });

    test("checkConnectivity", () async {
      MvvmPlugin mvvmPlugin = MvvmPlugin();
      MockMvvmPluginPlatform fakePlatform = MockMvvmPluginPlatform();
      MvvmPluginPlatform.instance = fakePlatform;

      expect(await mvvmPlugin.checkNetwork(), false);
    });
  }

  @override
  Future<void> payWithUpi({required Map<String, String> data}) =>
      Future.value();

  @override
  void telephoneDetails() {}

  @override
  Future<bool?> isKeyguardSecure() => Future.value(false);
}
