import 'package:flutter/material.dart';
import 'package:turnos_amerisa/pages/turnos/queue_screen.dart';

class ListTurn extends StatelessWidget {
  final List<String> turnos = ['A1', 'A2', 'A3'];

  ListTurn({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Turnos'),
        actions: [
          IconButton(
            onPressed: () {
              Navigator.pushNamed(context, '/rating');
            },
            icon: const Icon(Icons.queue),
          ),
        ],
      ),
      body: ListView.builder(
        itemCount: turnos.length,
        itemBuilder: (context, index) {
          return TurnoItem(turno: turnos[index], onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => QueueScreen(turno: turnos[index]),
              ),
            );
          });
        },
      ),
    );
  }
}

class TurnoItem extends StatelessWidget {
  final String turno;
  final VoidCallback onTap;

  const TurnoItem({super.key, required this.turno, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return ListTile(
      title: Text('Turno: $turno'),
      onTap: onTap,
    );
  }
}
