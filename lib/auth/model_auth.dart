import 'package:firebase_auth/firebase_auth.dart';

class UserModel {
  String? uid, name, email, profilePic, phoneNumber;
  DateTime? signInTime;
  UserModel({
    this.uid,
    this.name,
    this.email,
    this.profilePic,
    this.phoneNumber,
    this.signInTime,
  });

  factory UserModel.fromJson(Map<String, dynamic> json) => UserModel(
        uid: json["id"] ?? "",
        name: json["name"] ?? "",
        email: json["email"] ?? "",
        profilePic: json["profilePic"] ?? "",
        phoneNumber: json["phoneNumber"] ?? "",
        signInTime: json["signInTime"].toDate() ?? DateTime.now(),
      );

  factory UserModel.fromUser(User? user) {
    return UserModel(
      uid: user?.uid ?? "",
      name: user?.displayName ?? "",
      email: user?.email ?? "",
      profilePic: user?.photoURL ?? "",
      phoneNumber: user?.phoneNumber ?? "",
      signInTime: DateTime.now(),
    );
  }

  Map<String, dynamic> toJson() => {
        "id": uid,
        "name": name,
        "email": email,
        "profilePic": profilePic,
        "phoneNumber": phoneNumber,
        "signInTime": signInTime,
      };
}
