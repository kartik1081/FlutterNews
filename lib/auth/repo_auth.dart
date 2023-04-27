import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/services.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:mvvm/auth/model_auth.dart';
import 'package:mvvm_plugin/mvvm_plugin.dart';

abstract class AuthRepo {
  Stream<User?> isLoggedIn();
  Future<void> signinWithGoogle({required int platform});
  void signOut();
  void deleteUser();
  void showToast({required String content, required int platform});
}

class AuthRepoImpl extends AuthRepo {
  final plugin = MvvmPlugin();
  final GoogleSignIn _googleSignIn = GoogleSignIn();
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  @override
  Stream<User?> isLoggedIn() {
    return _auth.authStateChanges();
  }

  @override
  Future<void> signinWithGoogle({required int platform}) async {
    GoogleSignInAccount? googleUser;
    try {
      googleUser = await _googleSignIn.signIn();
    } on PlatformException {
      showToast(content: "Google sign-in cancelled", platform: platform);
    }
    if (googleUser != null) {
      googleUser.authentication.then(
        (googleAuth) {
          final credential = GoogleAuthProvider.credential(
            accessToken: googleAuth.accessToken,
            idToken: googleAuth.idToken,
          );
          FirebaseAuth.instance.signInWithCredential(credential).then(
            (userCredential) {
              Map<String, dynamic> data =
                  UserModel.fromUser(userCredential.user).toJson();
              if (userCredential.additionalUserInfo!.isNewUser) {
                _firestore.collection("users").doc(data["id"]).set(data);
              } else {
                _firestore
                    .collection("users")
                    .doc(data["id"])
                    .update({"signInTime": DateTime.now()});
              }
            },
          );
        },
      );
    }
  }

  @override
  void signOut() {
    _auth.signOut().whenComplete(() => _googleSignIn.signOut());
  }

  @override
  void deleteUser() {
    _auth.currentUser!.delete().whenComplete(() => _googleSignIn.signOut());
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
