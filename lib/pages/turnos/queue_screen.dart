import 'package:flutter/material.dart';
import 'package:turnos_amerisa/pages/notification/notification_screen.dart';

class QueueScreen extends StatelessWidget {
  final String turno;

  const QueueScreen({super.key, required this.turno});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Fila Virtual'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text(
              'Turno:',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 10),
            Text(
              turno,
              style: const TextStyle(
                fontSize: 30,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 20),
            Center(
              child: Row(
                children: [
                  ElevatedButton(
                    onPressed: () async{
                      Navigator.pop(context);
                      turnOnNotification();
                    },
                    child: const Text('Aceptar'),
                  ),
                  ElevatedButton(
                    onPressed: () async{
                      Navigator.pop(context);
                      turnOffNotification(context);
                    },
                    child: const Text('Terminar turno'),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
