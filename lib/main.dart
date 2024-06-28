// ignore_for_file: must_be_immutable

import 'package:awesome_notifications/awesome_notifications.dart';
import 'package:flutter/material.dart';
import 'package:turnos_amerisa/model/sharedPreferences.dart';
import 'package:turnos_amerisa/pages/calendar/calendar_screen.dart';
import 'package:turnos_amerisa/pages/home/home_screen.dart';
import 'package:turnos_amerisa/pages/login/login_screen.dart';
// import 'package:turnos_amerisa/pages/rating/rating_screen.dart';
import 'package:turnos_amerisa/pages/turnos/cita_screen.dart';
import 'package:turnos_amerisa/pages/turnos/row_screen.dart';
import 'package:turnos_amerisa/pages/turnos/generar_turno.dart';


void main(){
  AwesomeNotifications().initialize(
    null,
    [
      NotificationChannel(
        channelKey: 'basic_channel', 
        channelName: 'Basic notification', 
        channelDescription: 'Eduardo')
    ],
    debug: true,
  );
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
   MyApp({super.key});

  SharedPrefsService prefs = SharedPrefsService();

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Flutter Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      initialRoute: '/',
      routes: {
        '/': (context) =>  SignInScreen(),
        '/home': (context) => HomePage(),
        '/verturno': (context) => VirtualQueueScreen(),
        '/calendario': (context) => Calendar(),
        // '/rating': (context) => RatingScreen(),
        '/turno': (context) => GenerarTurnoView(),
        '/vercita': (context) => CitaQueueScreen(),
      },
    );
  }
}