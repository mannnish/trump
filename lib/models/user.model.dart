import 'package:firebase_auth/firebase_auth.dart';
import 'package:trump/constants/avatars.dart';

class UserModel {
  String? id;
  String? name;
  String? username;
  String? imageUrl;
  String? email;

  UserModel({
    required this.id,
    required this.name,
    required this.username,
    required this.imageUrl,
    required this.email,
  });

  UserModel.fromUser(User user) {
    id = user.uid;
    name = user.displayName ?? "Name";
    username = user.email!.split('@')[0];
    imageUrl = user.photoURL ?? Avatars.getRandom;
    email = user.email ?? "email";
  }

  UserModel.fromJson(Map<String, dynamic> json) {
    name = json['name'];
    id = json['id'];
    username = json['username'];
    imageUrl = json['imageUrl'];
    email = json['email'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['name'] = name;
    data['id'] = id;
    data['username'] = username;
    data['imageUrl'] = imageUrl;
    data['email'] = email;
    return data;
  }
}
