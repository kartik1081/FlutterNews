import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';

import 'mvvm_plugin_platform_interface.dart';

class MethodChannelMvvmPlugin extends MvvmPluginPlatform {
  @visibleForTesting
  final methodChannel = const MethodChannel('mvvm_plugin');

  @override
  Future<String?> getPlatformVersion() async {
    final version =
        await methodChannel.invokeMethod<String>('getPlatformVersion');
    return version;
  }

  @override
  Future<bool?> checkNetwork() async {
    final connectivity =
        await methodChannel.invokeMethod<bool>("checkConnectivity");
    return connectivity;
  }

  @override
  void showToast({required Map<String, String> data}) {
    methodChannel.invokeMethod<void>("showToast", data);
  }

  @override
  void launchUrl({required Map<String, String> data}) {
    methodChannel.invokeMethod<void>("openBrowser", data);
  }

  @override
  void pushNotification({required Map<String, dynamic> msg}) {
    methodChannel.invokeMethod<void>("pushNotification", msg);
  }

  @override
  void openCamera() {
    methodChannel.invokeMethod<void>("openCamera");
  }

  @override
  Future<List?> getContacts() async {
    final list = await methodChannel.invokeMethod<List>("getContacts");
    return list;
  }

  @override
  void download({required Map<String, String> data}) {
    methodChannel.invokeMethod<void>("download", data);
  }

  @override
  Future<bool?> biometricAuth() async {
    return await methodChannel.invokeMethod<bool>("biometricAuth");
  }

  @override
  Future<void> payWithUpi({required Map<String, String> data}) async {
    await methodChannel.invokeMethod<void>("makePayment", data);
  }

  @override
  void telephoneDetails() async {
    await methodChannel.invokeMethod<void>('telephoneDetail');
  }

  @override
  Future<bool?> isKeyguardSecure() async{
    return await methodChannel.invokeMethod<bool>("checkBiometric");
  }
}
