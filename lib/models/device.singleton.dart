import 'package:flutter/foundation.dart';

class DeviceSingleton {
  late String deviceName;
  late int deviceId;
  late int deviceColor;

  static final DeviceSingleton _instance = DeviceSingleton._internal();
  DeviceSingleton._internal();
  factory DeviceSingleton() => _instance;

  void printObject() {
    if (kDebugMode) {
      print("========");
      print("deviceName: $deviceName");
      print("deviceId: $deviceId");
      print("deviceColor: ${deviceColor.toString()}");
      print("========");
    }
  }
}
