import 'dart:async';
import 'dart:io';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/foundation.dart';
import 'package:device_info_plus/device_info_plus.dart';
import 'package:turnos_amerisa/main.dart';


class FirebaseApi {
  final _firebaseMessaging = FirebaseMessaging.instance;

  Future<void> initNotifications() async {
    NotificationSettings settings =
        await _firebaseMessaging.requestPermission();
    print('User granted permission: ${settings.authorizationStatus}');
  }

  Future<void> setupMessageListeners() async {
    FirebaseMessaging.onMessage.listen((message){
      _firebaseMessagingForegroundHandler(message);
    });

    FirebaseMessaging.instance.getInitialMessage().then((message) {
      if (message != null) {
        _firebaseMessagingBackgroundHandler(message);
      }
    });

    FirebaseMessaging.onMessageOpenedApp.listen((message){
       _firebaseMessagingBackgroundHandler(message);
    });
  }

  Future<void> _firebaseMessagingForegroundHandler(
      RemoteMessage? message) async {
    print("Foreground Message Received:");
    _printMessageDetails(message!);
    _handleMessageNavigation(message);
  }

  Future<void> _firebaseMessagingBackgroundHandler(
      RemoteMessage? message) async {
    print("Background Message Received:");
    _printMessageDetails(message!);
    _handleMessageNavigation(message);
  }

  void _printMessageDetails(RemoteMessage message) {
    if (message.notification != null) {
      print('Notification title: ${message.notification!.title}');
      print('Notification body: ${message.notification!.body}');
      if (message.data.isNotEmpty) {
        print('Notification data: ${message.data}');
      }
    }
  }

  void _handleMessageNavigation(RemoteMessage message) {
    String? screen = message.data['screen'];
    String? body = message.notification!.body;
    String? title = message.notification!.title;
    if (screen != null) {
      navigatorKey.currentState?.pushReplacementNamed(screen, arguments: {
        'body': body,
        'title': title,
        ...message.data
      });
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
}
