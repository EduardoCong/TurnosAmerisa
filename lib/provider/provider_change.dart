import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class UiProvider extends ChangeNotifier{
  bool isDark = false;
  bool get IsDark => isDark;

  late SharedPreferences storage;

  final darkTheme = ThemeData(
    primaryColor: Colors.black12,brightness: Brightness.dark,
    primaryColorDark: Colors.black12
  );

  final lightTheme = ThemeData(
    primaryColor: Colors.white,
    brightness: Brightness.light,
    primaryColorLight: Colors.white
  );

  changeTheme(){
    isDark = !isDark;
    storage.setBool('isDark', isDark);
    notifyListeners();
  }
  

  Future<void>init()async{
    storage= await SharedPreferences.getInstance();
    isDark = storage.getBool('isDark') ?? false;
    notifyListeners();
  }
}