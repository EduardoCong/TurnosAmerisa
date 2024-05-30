import 'package:flutter/material.dart';
import 'package:turnos_amerisa/pages/home/drawer_screen.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    final GlobalKey<ScaffoldState> scaffoldKey = GlobalKey<ScaffoldState>();

    return Scaffold(
      key: scaffoldKey,
      appBar: AppBar(
        title: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Center(
                child: Image.network(
                  "https://pbs.twimg.com/profile_images/814281946180231169/E7Z0c1Hy_400x400.jpg",
                  width: 100,
                  height: 100,
                ),
              ),
            ),
        backgroundColor: const Color.fromARGB(255, 255, 255, 255),
        leading: IconButton(
          icon: const Icon(Icons.menu),
          onPressed: () {
            scaffoldKey.currentState!.openDrawer();
          },
        ),
      ),
     drawer: const CustomDrawer(),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text(
              "¿Qué tipo de atención deseas?",
              style: TextStyle(
                fontSize: 23,
                fontWeight: FontWeight.w500,
              ),
            ),
            const SizedBox(height: 10),
            ElevatedButton(
              child: const ListTile(
                contentPadding: EdgeInsets.symmetric(vertical: 20, horizontal: 80),
                title: Text("Pedir Turno"),
                leading: Icon(Icons.phone_android),
              ),
              onPressed: () {
                Navigator.pushNamed(context, '/turnos');
              },
            ),
            const SizedBox(height: 10),
            SizedBox(
              child: ElevatedButton(
                child: const ListTile(
                  contentPadding: EdgeInsets.symmetric(vertical: 20, horizontal: 80),
                  title: Text("Pedir Cita"),
                  leading: Icon(Icons.calendar_month),
                ),
                onPressed: () {
                  Navigator.pushNamed(context, '/calendario');
                },
              ),
            ),
          ],
        ),
      ),
      backgroundColor: Colors.white,
    );
  }
}
