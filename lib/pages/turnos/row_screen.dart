// ignore_for_file: library_private_types_in_public_api

import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:flutter/material.dart';

class VirtualQueueScreen extends StatefulWidget {
  const VirtualQueueScreen({super.key});

  @override
  _VirtualQueueScreenState createState() => _VirtualQueueScreenState();
}

class _VirtualQueueScreenState extends State<VirtualQueueScreen> {
  String ticketNumber = 'A2';
  String waitTime = '2 min';
  String queueCode = '4P96B7AL';
  String nextNumber = 'A1';
  String branch = '44';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Fila Virtual'),
        automaticallyImplyLeading: false,
        centerTitle: true,
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          Card(
            elevation: 4,
            color: Colors.blue,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10),
            ),
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                children: [
                  const Text(
                    'Su turno:',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                  const SizedBox(height: 10),
                  Text(
                    ticketNumber,
                    style: const TextStyle(
                      fontSize: 30,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                  const SizedBox(height: 20),
                  const Text(
                    'Tiempo estimado de espera:',
                    style: TextStyle(
                      fontSize: 16,
                      color: Colors.white,
                    ),
                  ),
                  const SizedBox(height: 5),
                  Text(
                    waitTime,
                    style: const TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 20),
          _buildListTile('Código de su turno:', queueCode),
          _buildListTile('Próximo turno a ser llamado:', nextNumber),
          _buildListTile('Anden:', branch),
          const SizedBox(height: 20),
          AnimatedButton(
            text: 'Cancelar',
            width: 200,
            color: Colors.red,
            pressEvent: (){
              AwesomeDialog(
                context: context,
                dialogType: DialogType.success,
                borderSide: const BorderSide(
                  color: Colors.blue,
                  width: 2,
                ),
                width: 280,
                buttonsBorderRadius: const BorderRadius.all(
                  Radius.circular(2)
                ),
                dismissOnTouchOutside: true,
                dismissOnBackKeyPress: false,
                onDismissCallback: (type) {
                  debugPrint('Dialog Dissmiss from callback $type');
                },
                headerAnimationLoop: false,
                animType: AnimType.bottomSlide,
                title: 'Turno Cancelado',
                descTextStyle: const TextStyle(color: Colors.green, fontSize: 18),
                btnOkOnPress: () {
                  Navigator.pop(context);
                },
              ).show();
            }
          ),
          const SizedBox(height: 10),
          AnimatedButton(
            text: 'Volver',
            width: 200,
            color: Colors.greenAccent.shade400,
            pressEvent: (){
              Navigator.pushNamed(context, '/rating');
            }
          )
        ],
      ),
    );
  }

  Widget _buildListTile(String title, String subtitle) {
    return Card(
      elevation: 2,
      child: ListTile(
        title: Text(
          title,
          style: const TextStyle(
            fontWeight: FontWeight.bold,
          ),
        ),
        subtitle: Text(subtitle),
      ),
    );
  }
}