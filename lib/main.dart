import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:turnos_amerisa/firebase/firebase_api.dart';
import 'package:turnos_amerisa/firebase_options.dart';
import 'package:turnos_amerisa/pages/notificaciones/llamado_notificacion.dart';
import 'package:turnos_amerisa/pages/calendar/calendar_screen.dart';
import 'package:turnos_amerisa/pages/home/config_drawer.dart';
import 'package:turnos_amerisa/pages/home/home_screen.dart';
import 'package:turnos_amerisa/pages/login/login_screen.dart';
import 'package:turnos_amerisa/pages/rating/rating_screen.dart';
import 'package:turnos_amerisa/pages/splashscreen/splash_screen.dart';
import 'package:turnos_amerisa/pages/turnos/cita_screen.dart';
import 'package:turnos_amerisa/pages/turnos/generar_turno.dart';
import 'package:turnos_amerisa/pages/turnos/pantalla_mis_turnos.dart';
import 'package:turnos_amerisa/pages/turnos/pantalla_turnos.dart';
import 'package:turnos_amerisa/pages/turnos/row_screen.dart';
import 'package:turnos_amerisa/provider/provider_change.dart';

final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  await FirebaseApi().initNotifications();
  await FirebaseApi().setupMessageListeners();
  runApp(MyApp());
}

class MyApp extends StatefulWidget {
  MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => UiProvider()..init(),
      child: Consumer<UiProvider>(
        builder: (context, UiProvider notifier, child) {
          return MaterialApp(
            navigatorKey: navigatorKey,
            debugShowCheckedModeBanner: false,
            themeMode: notifier.isDark ? ThemeMode.dark : ThemeMode.light,
            darkTheme: notifier.darkTheme,
            theme: notifier.lightTheme,
            title: 'Flutter Demo',
            // initialRoute: '/',
            routes: {
              '/': (context) => SplashScreen(),
              '/login': (context) => SignInScreen(),
              '/home': (context) => HomePage(),
              '/verturno': (context) => VirtualQueueScreen(),
              '/calendario': (context) => Calendar(),
              '/rating': (context) => RatingScreen(),
              '/turno': (context) => GenerarTurnoView(),
              '/vercita': (context) => CitaQueueScreen(),
              '/config': (context) => ConfiguracionView(),
              '/listurno': (context) => TurnosVer(),
              '/llamadoTurno': (context) => LlamadoTurnoScreen(),
              '/vermisturnos': (context) => VerMisTurnos()
            },
          );
        },
      ),
    );
  }
}
