// File generated by FlutterFire CLI.
// ignore_for_file: type=lint
import 'package:firebase_core/firebase_core.dart' show FirebaseOptions;
import 'package:flutter/foundation.dart'
    show defaultTargetPlatform, kIsWeb, TargetPlatform;

/// Default [FirebaseOptions] for use with your Firebase apps.
///
/// Example:
/// ```dart
/// import 'firebase_options.dart';
/// // ...
/// await Firebase.initializeApp(
///   options: DefaultFirebaseOptions.currentPlatform,
/// );
/// ```
class DefaultFirebaseOptions {
  static FirebaseOptions get currentPlatform {
    if (kIsWeb) {
      return web;
    }
    switch (defaultTargetPlatform) {
      case TargetPlatform.android:
        return android;
      case TargetPlatform.iOS:
        return ios;
      case TargetPlatform.macOS:
        return macos;
      case TargetPlatform.windows:
        return windows;
      case TargetPlatform.linux:
        throw UnsupportedError(
          'DefaultFirebaseOptions have not been configured for linux - '
          'you can reconfigure this by running the FlutterFire CLI again.',
        );
      default:
        throw UnsupportedError(
          'DefaultFirebaseOptions are not supported for this platform.',
        );
    }
  }

  static const FirebaseOptions web = FirebaseOptions(
    apiKey: 'AIzaSyDMX4MXZgwxNpMHMQbIu2fI6aKYKw2fJcc',
    appId: '1:660133709842:web:0dc5703edec07b2c52f0cb',
    messagingSenderId: '660133709842',
    projectId: 'pushnotis-50040',
    authDomain: 'pushnotis-50040.firebaseapp.com',
    storageBucket: 'pushnotis-50040.appspot.com',
    measurementId: 'G-GXKVVEV1G7',
  );

  static const FirebaseOptions android = FirebaseOptions(
    apiKey: 'AIzaSyCSCMLWfdp4_L-CssGTJMvI15n7I1nAhMo',
    appId: '1:660133709842:android:a62efdf0a42a34fb52f0cb',
    messagingSenderId: '660133709842',
    projectId: 'pushnotis-50040',
    storageBucket: 'pushnotis-50040.appspot.com',
  );

  static const FirebaseOptions ios = FirebaseOptions(
    apiKey: 'AIzaSyD587ymT5EePNluNDtgyQ78qtr4143ioUc',
    appId: '1:660133709842:ios:ee4e434adab4bfce52f0cb',
    messagingSenderId: '660133709842',
    projectId: 'pushnotis-50040',
    storageBucket: 'pushnotis-50040.appspot.com',
    iosBundleId: 'com.example.turnosAmerisa',
  );

  static const FirebaseOptions macos = FirebaseOptions(
    apiKey: 'AIzaSyD587ymT5EePNluNDtgyQ78qtr4143ioUc',
    appId: '1:660133709842:ios:ee4e434adab4bfce52f0cb',
    messagingSenderId: '660133709842',
    projectId: 'pushnotis-50040',
    storageBucket: 'pushnotis-50040.appspot.com',
    iosBundleId: 'com.example.turnosAmerisa',
  );

  static const FirebaseOptions windows = FirebaseOptions(
    apiKey: 'AIzaSyDMX4MXZgwxNpMHMQbIu2fI6aKYKw2fJcc',
    appId: '1:660133709842:web:4f8fc8e67b18368a52f0cb',
    messagingSenderId: '660133709842',
    projectId: 'pushnotis-50040',
    authDomain: 'pushnotis-50040.firebaseapp.com',
    storageBucket: 'pushnotis-50040.appspot.com',
    measurementId: 'G-8F2WXWTBVZ',
  );
}
