// ignore_for_file: empty_catches

import 'package:flutter/services.dart';
import 'package:mvvm_plugin/mvvm_plugin.dart';
import 'package:shared_preferences/shared_preferences.dart';

abstract class LocalAuthRepo {
  Future<bool?> isBiometricAvailable({required int platform});
  Future<bool?> isActiveBiometric();
  Future<bool> changeBiometricAvailability(
      {required bool availability, required int platform});
  Future<bool?> checkLocalAuth({required int platform});
  void showToast({required String content, required int platform});
}

class LocalAuthRepoImpl extends LocalAuthRepo {
  final plugin = MvvmPlugin();
  Future<SharedPreferences> pref = SharedPreferences.getInstance();

  @override
  Future<bool?> isBiometricAvailable({required int platform}) async {
    try {
      return await plugin.isKeyguardSecure();
    } on PlatformException {
      showToast(content: "Something went wrong", platform: platform);
      return false;
    }
  }

  @override
  Future<bool?> isActiveBiometric() {
    return pref.then((value) {
      return value.getBool("biometric");
    });
  }

  @override
  Future<bool> changeBiometricAvailability(
      {required bool availability, required int platform}) {
    return pref.then((value) {
      showToast(
          content: availability
              ? "Biometric setup successfully"
              : "Biometric setup rewoked",
          platform: platform);
      return value.setBool("biometric", availability);
    });
  }

  @override
  Future<bool?> checkLocalAuth({required int platform}) {
    try {
      return plugin.biometricAuth().then((value) {
        if (value != null) {
          return value;
        }
        return null;
      });
    } on PlatformException {
      showToast(content: "Something went wrong", platform: platform);
      return Future.value(false);
    }
  }

  @override
  void showToast({required String content, required int platform}) {
    switch (platform) {
      case 1:
        // Web
        break;
      case 2:
        // Android
        try {
          plugin.showToast(content: content);
        } on PlatformException {}
        break;
      case 3:
        //IOS
        break;
      case 4:
        // Windows
        break;
    }
  }
}
