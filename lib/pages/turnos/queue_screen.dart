import 'package:flutter/material.dart';
import 'package:turnos_amerisa/pages/notification/notification_screen.dart';

class QueueScreen extends StatelessWidget {
  final String turno;

 QueueScreen({super.key,required this.turno});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Fila Virtual'),
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
        stringsimple(),
        SizedBox(height: 10),
        fieldtext(),
        SizedBox(height: 20),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              buttonSubmmit(context),
             SizedBox(width: 10),
              buttonCancel(context)
            ],
          ),
        ],
      ),
    );
  }

  Widget buttonSubmmit(BuildContext context){
    return ElevatedButton(
      onPressed: () async {
        Navigator.pop(context);
        turnOnNotification();
      },
      child: Text('Aceptar'),
    );
  }

  Widget buttonCancel(BuildContext context){
    return ElevatedButton(
      onPressed: () async {
        Navigator.pop(context);
        showNotification(context);
      },
      child: Text('Terminar turno'),
    );
  }

  Widget fieldtext(){
    return Text(
      turno,
      style: TextStyle(
        fontSize: 30,
        fontWeight: FontWeight.bold,
      ),
    );
  }

  Widget stringsimple(){
    return Text(
      'Turno:',
      style: TextStyle(
        fontSize: 20,
        fontWeight: FontWeight.bold,
      ),
    );
  }
}
