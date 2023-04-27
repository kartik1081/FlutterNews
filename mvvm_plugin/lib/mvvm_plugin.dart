// ignore_for_file: empty_catches

import 'mvvm_plugin_platform_interface.dart';

class MvvmPlugin {
  final instance = MvvmPluginPlatform.instance;

  Future<String?> getPlatformVersion() {
    return instance.getPlatformVersion();
  }

  Future<bool?> checkNetwork() async {
    return instance.checkNetwork();
  }

  void showToast({required String content}) {
    Map<String, String> map = {"toast": content};
    instance.showToast(data: map);
  }

  void pushNotification({required Map<String, dynamic> msg}) {
    instance.pushNotification(msg: msg);
  }

  Future<void> launchUrl({required String url}) async {
    Map<String, String> map = {"url": url};
    instance.launchUrl(data: map);
  }

  void openCamera() {
    instance.openCamera();
  }

  Future<List?> getContacts() async {
    return instance.getContacts();
  }

  void download({required String link}) async {
    Map<String, String> data = {"link": link};
    instance.download(data: data);
  }

  Future<bool?> biometricAuth() async {
    return await instance.biometricAuth();
  }

  Future<void> payWithUpi({required String url}) async {
    Map<String, String> data = {"upiLink": url};
    instance.payWithUpi(data: data);
  }

  void telephoneDetail() {
    instance.telephoneDetails();
  }

  Future<bool?> isKeyguardSecure() async {
    return await instance.isKeyguardSecure();
  }
}
