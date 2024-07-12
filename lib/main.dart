import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:turnos_amerisa/api/firebase_api.dart';
import 'package:turnos_amerisa/firebase_options.dart';
import 'package:turnos_amerisa/pages/calendar/calendar_screen.dart';
import 'package:turnos_amerisa/pages/home/home_screen.dart';
import 'package:turnos_amerisa/pages/login/login_screen.dart';
import 'package:turnos_amerisa/pages/splashscreen/splash_screen.dart';
// import 'package:turnos_amerisa/pages/rating/rating_screen.dart';
import 'package:turnos_amerisa/pages/turnos/cita_screen.dart';
import 'package:turnos_amerisa/pages/turnos/row_screen.dart';
import 'package:turnos_amerisa/pages/turnos/generar_turno.dart';


void main() async {
  await WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  await FirebaseApi().initNotifications();
  runApp(MyApp());
}

class MyApp extends StatefulWidget {
   MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp>{
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Flutter Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      // initialRoute: '/',
      routes: {
        '/': (context) => SplashScreen(),
        '/login': (context) =>  SignInScreen(),
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