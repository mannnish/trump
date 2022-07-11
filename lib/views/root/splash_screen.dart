import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:trump/repo/auth.repo.dart';
import 'package:trump/repo/device.repo.dart';
import 'package:trump/views/home/home.dart';
import 'package:trump/views/root/login.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({Key? key}) : super(key: key);

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    process();
  }

  process() async {
    await Future.delayed(const Duration(milliseconds: 200));
    await DeviceRepo.processThisDevice();
    User? user = AuthRepo.getUser();
    if (user != null) {
      Navigator.of(context, rootNavigator: true).push(
        MaterialPageRoute(builder: (_) => HomePage(uid: user.uid)),
      );
    } else {
      Navigator.of(context, rootNavigator: true).push(
        MaterialPageRoute(builder: (_) => const LoginScreen()),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: Center(child: Text('splash')),
    );
  }
}
