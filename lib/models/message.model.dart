import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class MessageModel {
  DateTime? sentAt;
  String? content;
  String? type;

  String? userId;
  String? deviceName;
  int? deviceId;
  int? deviceColor;

  MessageModel({
    this.sentAt,
    this.userId,
    this.deviceName,
    this.deviceId,
    this.deviceColor,
    this.content,
    this.type,
  });

  deserialize(json, field) {
    try {
      return json.get(field);
    } catch (e) {
      return null;
    }
  }

  MessageModel.fromQuerySnapshot(var json) {
    sentAt = (json.get('sent_at') as Timestamp).toDate();
    userId = deserialize(json, 'user_id');
    deviceName = deserialize(json, 'device_name');
    deviceId = deserialize(json, 'device_id');
    deviceColor = deserialize(json, 'device_color');
    content = deserialize(json, 'content');
    type = deserialize(json, 'type');
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['sent_at'] = sentAt;
    data['user_id'] = userId;
    data['device_name'] = deviceName;
    data['device_id'] = deviceId;
    data['device_color'] = deviceColor;
    data['content'] = content;
    data['type'] = type;
    return data;
  }
}
