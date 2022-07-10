import 'package:flutter/material.dart';
import 'package:trump/repo/auth.repo.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({Key? key}) : super(key: key);

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: TextButton(
          onPressed: () => AuthRepo.googleSignIn(context),
          child: const Text('google login'),
        ),
      ),
    );
  }
}
