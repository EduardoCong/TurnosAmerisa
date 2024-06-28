// ignore_for_file: library_private_types_in_public_api

import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class VirtualQueueScreen extends StatefulWidget {
  VirtualQueueScreen({super.key});

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
  void initState() {
    super.initState();
  }
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Fila Virtual'),
        automaticallyImplyLeading: false,
        centerTitle: true,
      ),
      body: ListView(
        padding: EdgeInsets.all(16),
        children: [
          Card(
            elevation: 4,
            color: Colors.blue,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10),
            ),
            child: Padding(
              padding: EdgeInsets.all(16.0),
              child: Column(
                children: [
                  textsimple(),
                  SizedBox(height: 10),
                  textticketnum(),
                  SizedBox(height: 20),
                  textsimple2(),
                  SizedBox(height: 5),
                  textwaittime(),
                ],
              ),
            ),
          ),
          SizedBox(height: 20),
          _buildListTile('Código de su turno:', queueCode),
          _buildListTile('Próximo turno a ser llamado:', nextNumber),
          _buildListTile('Anden:', branch),
          SizedBox(height: 20),
          buttonAnimated(context),
          SizedBox(height: 10),
          buttonAniBack(context)
        ],
      ),
    );
  }

  Widget textsimple(){
    return Text(
      'Su turno:',
      style: TextStyle(
        fontSize: 20,
        fontWeight: FontWeight.bold,
        color: Colors.white,
      ),
    );
  }

  Widget textticketnum(){
    return Text(
      ticketNumber,
      style: TextStyle(
        fontSize: 30,
        fontWeight: FontWeight.bold,
        color: Colors.white,
      ),
    );
  }

  Widget textsimple2(){
    return Text(
      'Tiempo estimado de espera:',
      style: TextStyle(
        fontSize: 16,
        color: Colors.white,
      ),
    );
  }

  Widget textwaittime(){
    return Text(
      waitTime,
      style: TextStyle(
        fontSize: 20,
        fontWeight: FontWeight.bold,
        color: Colors.white,
      ),
    );
  }

  Widget _buildListTile(String title, String subtitle) {
    return Card(
      elevation: 2,
      child: ListTile(
        title: Text(
          title,
          style: TextStyle(
            fontWeight: FontWeight.bold,
          ),
        ),
        subtitle: Text(subtitle),
      ),
    );
  }

  Widget buttonAnimated(BuildContext context){
    return AnimatedButton(
      text: 'Cancelar',
      width: 200,
      color: Colors.red,
      pressEvent: (){
        AwesomeDialog(
          context: context,
          dialogType: DialogType.success,
          borderSide: BorderSide(
            color: Colors.blue,
            width: 2,
          ),
          width: 280,
          buttonsBorderRadius: BorderRadius.all(
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
          descTextStyle: TextStyle(color: Colors.green, fontSize: 18),
          btnOkOnPress: () {
            Navigator.of(context).pushReplacementNamed('/home');
          },
        ).show();
      }
    );
  }

  Widget buttonAniBack(BuildContext context){
    return AnimatedButton(
      text: 'Volver',
      width: 200,
      color: Colors.greenAccent.shade400,
      pressEvent: (){
        Navigator.of(context).pushReplacementNamed('/home');
      }
    );
  }
}