import 'dart:io';

import 'package:flutter/foundation.dart';

class SettingsController extends ChangeNotifier {
  int _platform = 0;
  int get platform => _platform;

  void getPlatform() {
    if (kIsWeb) {
      _platform = 1;
      notifyListeners();
    } else if (Platform.isAndroid) {
      _platform = 2;
      notifyListeners();
    } else if (Platform.isIOS) {
      _platform = 3;
      notifyListeners();
    } else if (Platform.isWindows) {
      _platform = 4;
      notifyListeners();
    } else {
      _platform = 0;
      notifyListeners();
    }
  }
}
