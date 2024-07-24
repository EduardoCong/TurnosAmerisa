import 'dart:async';
import 'dart:io';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/foundation.dart';
import 'package:device_info_plus/device_info_plus.dart';

class FirebaseApi {
  final _firebaseMessaging = FirebaseMessaging.instance;

  Future<void> initNotifications() async {
    NotificationSettings settings =
        await _firebaseMessaging.requestPermission();
    print('User granted permission: ${settings.authorizationStatus}');
  }

  Future<void> setupMessageListeners() async {
    FirebaseMessaging.onMessage.listen(_firebaseMessagingForegroundHandler);

    FirebaseMessaging.instance.getInitialMessage().then((message) {
      if (message != null) {
        _firebaseMessagingBackgroundHandler(message);
      }
    });

    FirebaseMessaging.onMessageOpenedApp
        .listen(_firebaseMessagingBackgroundHandler);
  }

  Future<void> _firebaseMessagingForegroundHandler(
      RemoteMessage? message) async {
    print("Foreground Message Received:");
    _printMessageDetails(message!);
  }

  Future<void> _firebaseMessagingBackgroundHandler(
      RemoteMessage? message) async {
    print("Background Message Received:");
    _printMessageDetails(message!);
  }

  void _printMessageDetails(RemoteMessage message) {
    if (message.notification != null) {
      String thing = message.data['screen'];
      print('Notification title: ${message.notification!.title}');
      print('Notification body: ${message.notification!.body}');
      print('Notification data: ${thing}');
    }
  }

  Future<String?> getToken() async {
    final fCMToken = await _firebaseMessaging.getToken();
    print('Token normal: $fCMToken');
    return fCMToken;
  }

  Future<String> getPlatform() async {
    String device;
    if (kIsWeb) {
      device = 'web';
    } else if (Platform.isAndroid) {
      device = 'android';
    } else if (Platform.isIOS) {
      device = 'ios';
    } else {
      device = 'unknown';
    }
    print('plataforma : $device');
    return device;
  }

  Future<String?> getDeviceId() async {
    DeviceInfoPlugin deviceInfo = DeviceInfoPlugin();

    String? deviceId;

    if (Platform.isAndroid) {
      AndroidDeviceInfo androidInfo = await deviceInfo.androidInfo;
      deviceId = androidInfo.id;
    } else if (Platform.isIOS) {
      IosDeviceInfo iosInfo = await deviceInfo.iosInfo;
      deviceId = iosInfo.identifierForVendor;
    }
    print(deviceId);
    return deviceId;
  }
}
