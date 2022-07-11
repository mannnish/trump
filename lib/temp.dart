import 'package:device_info_plus/device_info_plus.dart';
import 'package:flutter/material.dart';

class TempPage extends StatefulWidget {
  const TempPage({Key? key}) : super(key: key);

  @override
  State<TempPage> createState() => _TempPageState();
}

class _TempPageState extends State<TempPage> {
  var data = {};

  @override
  void initState() {
    super.initState();
    get();
  }

  get() async {
    final deviceInfoPlugin = DeviceInfoPlugin();
    final deviceInfo = await deviceInfoPlugin.deviceInfo;
    final map = deviceInfo.toMap();
    // platform for laptop
    // model for phone
    setState(() {
      data = map;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Text(data.toString()),
      ),
    );
  }
}
