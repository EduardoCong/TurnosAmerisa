import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:turnos_amerisa/pages/calendar/calendar_screen.dart';
import 'package:turnos_amerisa/pages/home/config_drawer.dart';
import 'package:turnos_amerisa/pages/home/home_screen.dart';
import 'package:turnos_amerisa/pages/loca.dart';
import 'package:turnos_amerisa/pages/login/login_screen.dart';
import 'package:turnos_amerisa/pages/splashscreen/splash_screen.dart';
// import 'package:turnos_amerisa/pages/rating/rating_screen.dart';
import 'package:turnos_amerisa/pages/turnos/cita_screen.dart';
import 'package:turnos_amerisa/pages/turnos/row_screen.dart';
import 'package:turnos_amerisa/pages/turnos/generar_turno.dart';
import 'package:turnos_amerisa/provider/provider_change.dart';

  void main() {
    WidgetsFlutterBinding.ensureInitialized();
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
              debugShowCheckedModeBanner: false,
              themeMode: notifier.isDark? ThemeMode.dark : ThemeMode.light,
              darkTheme: notifier.isDark? notifier.darkTheme : notifier.lightTheme,
              theme: notifier.lightTheme,
              title: 'Flutter Demo',
              // initialRoute: '/',
              routes: {
                // '/': (context) => SplashScreen(),
                // '/login': (context) => SignInScreen(),
                // '/home': (context) => HomePage(),
                // '/verturno': (context) => VirtualQueueScreen(),
                // '/calendario': (context) => Calendar(),
                // // '/rating': (context) => RatingScreen(),
                // '/turno': (context) => GenerarTurnoView(),
                // '/vercita': (context) => CitaQueueScreen(),
                // '/config': (context) => ConfiguracionView(),
                '/': (context) => TurnosActualesScreen(), 
              },
            );
          },
        ),
      );
    }
  }
