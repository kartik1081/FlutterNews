// ignore_for_file: empty_catches

import 'package:flutter/foundation.dart';
import 'package:mvvm/local_auth/repo_local_auth.dart';
import 'package:mvvm_plugin/mvvm_plugin.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LocalAuthController extends ChangeNotifier {
  final LocalAuthRepo repo;
  LocalAuthController({required this.repo});

  final plugin = MvvmPlugin();
  late SharedPreferences pref;

  bool _localAuth = false;
  bool _isBiometricAvailable = true;
  bool _isActiveBiometric = true;

  bool get localAuth => _localAuth;
  bool get isBiometricAvailable => _isBiometricAvailable;
  bool get isActiveBiometric => _isActiveBiometric;

  Future<void> checkLocalAuth({required int platform}) async {
    repo.isBiometricAvailable(platform: platform).then((value) async {
      if (value != null) {
        if (value) {
          await repo.isActiveBiometric().then((value) async {
            if (value != null) {
              _isActiveBiometric = value;
              if (value) {
                await repo.checkLocalAuth(platform: platform).then((value) {
                  if (value != null) {
                    if (value) {
                      _localAuth = value;
                      notifyListeners();
                    }
                  }
                });
              } else {
                repo.showToast(
                  content: "Setup Biometric from setting",
                  platform: platform,
                );
              }
              notifyListeners();
            } else {
              changeBiometricAvailability(biometric: false, platform: platform);
            }
          });
        }
        _isBiometricAvailable = value;
        notifyListeners();
      }
    });
    // repo.isBiometricAvailable(platform: platform).then((value) {
    //   if (value != null) {
    //     if (value) {
    //     }
    //     _isBiometricAvailable = value;
    //     notifyListeners();
    //   }
    // });
  }

  void changeBiometricAvailability(
      {required bool biometric, required int platform}) {
    repo.changeBiometricAvailability(
        availability: biometric, platform: platform);
    _isActiveBiometric = biometric;
    notifyListeners();
  }
}
