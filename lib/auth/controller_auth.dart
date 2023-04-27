import 'package:flutter/material.dart';
import 'package:mvvm/auth/model_auth.dart';
import 'package:mvvm/auth/repo_auth.dart';

class AuthController extends ChangeNotifier {
  final AuthRepo repo;
  AuthController({required this.repo});

  bool _loading = false;
  bool _isLoggedIn = false;
  UserModel? _userModel;

  bool get loading => _loading;
  bool get isLoggedIn => _isLoggedIn;
  UserModel? get userModel => _userModel;

  void checkSignInStatus() {
    repo.isLoggedIn().listen((user) {
      _isLoggedIn = user != null;
      _userModel = UserModel.fromUser(user);
      notifyListeners();
    });
  }

  void signinWithGoogle({required int platform}) {
    _loading = true;
    repo.signinWithGoogle(platform: platform).then((value) {
      _loading = false;
      notifyListeners();
    });
    notifyListeners();
  }

  void signOut() {
    repo.signOut();
  }

  void deleteUser() {
    repo.deleteUser();
  }
}
