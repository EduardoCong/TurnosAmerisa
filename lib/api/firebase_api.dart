import 'package:firebase_messaging/firebase_messaging.dart';

class FirebaseApi {
  //crear una instancia de firebase messaging
  final _firebaseMessaging = FirebaseMessaging.instance;

  //funcion para incializar notificaciones
  Future<void> initNotifications() async {
    //request permissions from user(will promt user)
    await _firebaseMessaging.requestPermission();

    //fetch the FCM Token for this device

    final fCMToken = await _firebaseMessaging.getToken();

    //print token
    print('Token: $fCMToken');
  }
}
