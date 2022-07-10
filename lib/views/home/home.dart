import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:trump/repo/auth.repo.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  String name = "";

  @override
  void initState() {
    super.initState();
    getData();
  }

  getData() {
    User? user = AuthRepo.getUser();
    if (user != null) {
      name = user.displayName!;
    }
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('welcome $name'),
        actions: [
          IconButton(
            onPressed: () => AuthRepo.logout(context),
            icon: const Icon(Icons.logout),
          ),
        ],
      ),
    );
  }
}
