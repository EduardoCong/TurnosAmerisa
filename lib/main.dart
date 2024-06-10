import 'package:awesome_notifications/awesome_notifications.dart';
import 'package:flutter/material.dart';
import 'package:turnos_amerisa/pages/calendar/calendar_screen.dart';
import 'package:turnos_amerisa/pages/home/home_screen.dart';
import 'package:turnos_amerisa/pages/login/login_screen.dart';
import 'package:turnos_amerisa/pages/rating/rating_screen.dart';
import 'package:turnos_amerisa/pages/turnos/list_screen.dart';
import 'package:turnos_amerisa/pages/turnos/row_screen.dart';
import 'package:turnos_amerisa/pages/turnos/turnos_screen.dart';
import 'package:turnos_amerisa/prueba/loco.dart';
import 'package:turnos_amerisa/prueba/turnos2.dart';


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
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

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
        '/home': (context) => const HomePage(),
        '/turnos': (context) => const TurnosSchedule(),
        '/rows': (context) => const VirtualQueueScreen(),
        '/calendario': (context) => const Calendar(),
        '/list': (context) => ListTurn(),
        '/rating': (context) => const RatingScreen(),
        // '/listuser': (context) =>  UserFetch(),
        // '/turnos': (context) => GenerarTurnoScreen(),
      },
    );
  }
}