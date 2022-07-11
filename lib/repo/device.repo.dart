import 'dart:io';
import 'package:device_info_plus/device_info_plus.dart';
import 'package:flutter/material.dart';
import 'package:trump/models/device.singleton.dart';

class DeviceRepo {
  static int mod = 1000007;
  static int hash(String s) {
    int hash = 0;
    for (int i = 0; i < s.length; i++) {
      hash = ((hash << 5) - hash + s.codeUnitAt(i)) % mod;
      hash |= 0;
    }
    return hash;
  }

  static Future<void> processThisDevice() async {
    final deviceInfoPlugin = DeviceInfoPlugin();
    final deviceInfo = await deviceInfoPlugin.deviceInfo;
    final map = deviceInfo.toMap();
    String deviceName;
    try {
      if (Platform.isAndroid || Platform.isIOS) {
        deviceName = map["model"];
      } else {
        deviceName = map["platform"];
      }
    } catch (e) {
      deviceName = map["platform"];
    }
    DeviceSingleton instance = DeviceSingleton();
    instance.deviceName = deviceName;
    instance.deviceId = hash(deviceName);
    instance.deviceColor = hashToColor(instance.deviceId);
    instance.printObject();
  }

  static List<Color> colorCodes = [
    const Color(0xff00FFFF),
    const Color(0xff0000FF),
    const Color(0xff00008B),
    const Color(0xff800080),
    const Color(0xffA52A2A),
    const Color(0xff008000),
    const Color(0xffFF00FF),
    const Color(0xffFFCE44),
  ];
  static int hashToColor(int hash) {
    return colorCodes[hash % colorCodes.length].value;
  }
}
