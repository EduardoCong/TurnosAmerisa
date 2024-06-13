import 'dart:async';
import 'package:flutter/material.dart';
import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:turnos_amerisa/pages/notification/notification_screen.dart';

class TurnosSchedule extends StatefulWidget {
  TurnosSchedule({super.key});

  @override
  State<TurnosSchedule> createState() => _TurnosScheduleState();
}

class _TurnosScheduleState extends State<TurnosSchedule> {
  late Timer _timer;
  int _counter = 300;
  bool _showCounter = true;

  @override
  void initState() {
    super.initState();
    _startTimer();
  }

  @override
  void dispose() {
    _timer.cancel();
    super.dispose();
  }

  void _startTimer() {
    _timer = Timer.periodic(Duration(seconds: 1), (Timer timer) {
      setState(() {
        if (_counter > 0) {
          _counter--;
        } else {
          timer.cancel();
          _showCounter = false;
          Navigator.pushNamed(context, '/home');
        }
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          ListView(
            children: [
              logoTurnos(),
              Center(
                child: SizedBox(
                  width: 350,
                  height: 400,
                  child: Card(
                    color: Colors.grey.shade300,
                    margin: EdgeInsets.only(top: 28),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        textturno(),
                        textturno2(), 
                        obtenerTurno(),
                        SizedBox(height: 10),
                        Padding(
                          padding: EdgeInsets.all(8.0),
                          child: Text(
                            "Si ya cuenta con un código de seguimiento,\ningrese aquí:",
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ),
                        buttonSchedule(),
                        SizedBox(height: 24),
                        buttonBack()
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
          if (_showCounter)
            countTurno()
        ],
      ),
      backgroundColor: Colors.white,
    );
  }

  Widget logoTurnos(){
    return Padding(
      padding: EdgeInsets.all(8.0),
      child: Image.network(
        "https://pbs.twimg.com/profile_images/814281946180231169/E7Z0c1Hy_400x400.jpg",
        width: 150,
        height: 180,
      ),
    );
  }

  Widget countTurno(){
    return Positioned(
      top: 200,
      right: 16,
      child: Container(
        padding: EdgeInsets.all(8),
        decoration: BoxDecoration(
          color: Colors.blue,
          borderRadius: BorderRadius.circular(8),
        ),
        child: Text(
          'Tiempo restante: ${_counter ~/ 60}:${(_counter % 60).toString().padLeft(2, '0')}',
            style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w500,
            color: Colors.white,
          ),
        ),
      ),
    );
  }

  Widget textturno(){
    return Padding(
      padding: EdgeInsets.all(8.0),
      child: Text(
        "Turnos",
        style: TextStyle(
          fontSize: 30,
          fontWeight: FontWeight.w500,
        ),
      ),
    );
  }

  Widget textturno2(){
    return Padding(
      padding: EdgeInsets.all(8.0),
      child: Text(
        "Si no tienes un turno, obténgalo aquí:",
        style: TextStyle(
          fontSize: 16,
          fontWeight: FontWeight.w500,
        ),
      ),
    );
  }

  Widget obtenerTurno(){
    return AnimatedButton(
      text: 'Obtener Turno',
      width: 200,
      color: Colors.blue,
      pressEvent: () {
        _timer.cancel();
        setState(() {
          _showCounter = false; 
        }
      );
      AwesomeDialog(
          context: context,
          dialogType: DialogType.success,
          borderSide: BorderSide(
            color: Colors.blue,
            width: 2,
          ),
          width: 280,
          buttonsBorderRadius:
              BorderRadius.all(
                  Radius.circular(2)),
          dismissOnTouchOutside: true,
          dismissOnBackKeyPress: false,
          onDismissCallback: (type) {
            debugPrint(
                'Dialog Dissmiss from callback $type');
          },
          headerAnimationLoop: false,
          animType: AnimType.bottomSlide,
          title: 'Succes',
          desc: 'Turno generado',
          descTextStyle: TextStyle(
              color: Colors.green, fontSize: 18),
          btnOkOnPress: () async {
            confirmacionNotification();
            Navigator.pushNamed(context, '/rows');
        }).show();
      }
    );
  }

  Widget textturno3(){
    return Padding(
      padding: EdgeInsets.all(8.0),
      child: Text(
        "Si ya cuenta con un código de seguimiento,\ningrese aquí:",
        style: TextStyle(
          fontSize: 16,
          fontWeight: FontWeight.w500,
        ),
      ),
    );
  }

  Widget buttonSchedule(){
    return AnimatedButton(
      text: 'Buscar cita o Turno',
      color: Colors.blue,
      width: 200,
      pressEvent: () {
        Navigator.pushNamed(context, '/calendario');
      },
    );
  }

  Widget buttonBack(){
    return AnimatedButton(
      text: 'Volver',
      color: Colors.blue,
      width: 200,
      pressEvent: () {
        Navigator.pushNamed(context, '/home');
      },
    );
  }
}
