import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart' as fauth;
import 'package:google_sign_in/google_sign_in.dart' as gsignin;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:trump/views/home/home.dart';
import 'package:trump/views/root/splash_screen.dart';

class AuthRepo {
  static fauth.User? getUser() {
    fauth.FirebaseAuth auth = fauth.FirebaseAuth.instance;
    final fauth.User? currentUser = auth.currentUser;
    return currentUser;
  }

  static void googleSignIn(context) async {
    fauth.FirebaseAuth auth = fauth.FirebaseAuth.instance;
    final googleSignIn = gsignin.GoogleSignIn();

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
        print("error === user null");
      } else {
        // final fauth.User? currentUser = auth.currentUser;
        // good to go
        Navigator.of(context, rootNavigator: true).push(
          MaterialPageRoute(builder: (_) => const HomePage()),
        );
      }
      return null;
    } catch (e) {
      print("error === $e");
    }
  }

  static void logout(context) async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    sharedPreferences.clear();
    try {
      fauth.FirebaseAuth auth = fauth.FirebaseAuth.instance;
      final googleSignIn = gsignin.GoogleSignIn();
      googleSignIn.signOut();
      auth.signOut();
    } catch (e) {}
    Navigator.push(context, MaterialPageRoute(builder: (_) => const SplashScreen()));
  }
}
