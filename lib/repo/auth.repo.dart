// ignore_for_file: empty_catches, avoid_print
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart' as fauth;
import 'package:google_sign_in/google_sign_in.dart' as gsignin;
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:trump/constants/appconfig.dart';
import 'package:trump/models/user.model.dart';
import 'package:trump/views/home/home.dart';
import 'package:trump/views/root/splash_screen.dart';

class AuthRepo {
  static fauth.User? getUser() {
    fauth.FirebaseAuth auth = fauth.FirebaseAuth.instance;
    final fauth.User? currentUser = auth.currentUser;
    return currentUser;
  }

  static Future<bool> userExists(String uid) async {
    bool exists = false;
    DocumentSnapshot ds = await FirebaseFirestore.instance.collection(Collections.user).doc(uid).get();
    exists = ds.exists;
    return exists;
  }

  static void googleSignIn(context) async {
    fauth.FirebaseAuth auth = fauth.FirebaseAuth.instance;
    final googleSignIn = gsignin.GoogleSignIn();
    // TODO : show loader
    try {
      googleSignIn.signOut();
      auth.signOut();
    } catch (e) {}

    try {
      final gsignin.GoogleSignInAccount? googleSignInAccount = await googleSignIn.signIn();
      final gsignin.GoogleSignInAuthentication googleSignInAuthentication = await googleSignInAccount!.authentication;

      final fauth.AuthCredential credential = fauth.GoogleAuthProvider.credential(
        accessToken: googleSignInAuthentication.accessToken,
        idToken: googleSignInAuthentication.idToken,
      );

      final fauth.UserCredential authResult = await auth.signInWithCredential(credential);
      final fauth.User? user = authResult.user;

      if (user == null) {
        // TODO : error toast
        print("error === user null");
      } else {
        if (!await userExists(user.uid)) {
          // TODO : onboarding screens
          UserModel userModel = UserModel.fromUser(user);
          await FirebaseFirestore.instance.collection(Collections.user).doc(user.uid).set(
                userModel.toJson(),
              );
        }
        Navigator.of(context, rootNavigator: true).push(
          MaterialPageRoute(builder: (_) => HomePage(uid: user.uid)),
        );
      }
      return null;
    } catch (e) {
      print("error === $e");
    }
  }

  static void logout(context) {
    try {
      fauth.FirebaseAuth auth = fauth.FirebaseAuth.instance;
      final googleSignIn = gsignin.GoogleSignIn();
      googleSignIn.signOut();
      auth.signOut();
      googleSignIn.disconnect();
    } catch (e) {}
    Navigator.push(context, MaterialPageRoute(builder: (_) => const SplashScreen()));
  }
}
