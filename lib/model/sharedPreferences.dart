// import 'package:flutter/material.dart';
// import 'package:shared_preferences/shared_preferences.dart';

// class SharedPrefsService {
//   Future writeCache({required String key, required String value}) async {
//     final SharedPreferences prefs = await SharedPreferences.getInstance();
//     bool isSaved = await prefs.setString(key, value);
//     debugPrint(isSaved.toString());
//   }

//   Future<String?> readCache({required String key}) async {
//     final SharedPreferences prefs = await SharedPreferences.getInstance();
//     String? value = await prefs.getString(key);
//     debugPrint(value);
//     return value;
//   }

//   Future<bool> removeCache({required String key}) async {
//     final SharedPreferences prefs = await SharedPreferences.getInstance ();
//     bool isCleared = await prefs.remove(key);
//     debugPrint('$key removed: $isCleared');
//     return isCleared;
//   }
// }