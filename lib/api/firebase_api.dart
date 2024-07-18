import 'dart:io';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/foundation.dart';

class FirebaseApi {
  final _firebaseMessaging = FirebaseMessaging.instance;

  Future<void> initNotifications() async {
    await _firebaseMessaging.requestPermission();
  }

  Future<String?> getToken() async {
    final fCMToken = await _firebaseMessaging.getToken();
    print('Token: $fCMToken');
    return fCMToken;
  }

  Future<String> getPlatform() async {
    String device;
    if(kIsWeb){
      device = 'web';
    }
    else if(Platform.isAndroid){
      device = 'android';
    }
    else if(Platform.isIOS){
      device = 'ios';
    }
    else{
      device = 'unknown';
    }
    print(device);
    return device;
  }
}
