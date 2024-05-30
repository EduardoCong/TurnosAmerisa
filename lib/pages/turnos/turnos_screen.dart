import 'package:flutter/material.dart';
import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:turnos_amerisa/pages/notification/notification_screen.dart';

class TurnosSchedule extends StatefulWidget {
  const TurnosSchedule({super.key});

  @override
  State<TurnosSchedule> createState() => _TurnosScheduleState();
}

class _TurnosScheduleState extends State<TurnosSchedule> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body:
       ListView(
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Image.network(
              "https://pbs.twimg.com/profile_images/814281946180231169/E7Z0c1Hy_400x400.jpg",
              width: 150,
              height: 180,
            ),
          ),
          Center(
            child: SizedBox(
              width: 350,
              height: 400,
              child: Card(
                color: Colors.grey.shade300,
                margin: const EdgeInsets.only(top: 28),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Padding(
                      padding: EdgeInsets.all(8.0),
                      child: Text(
                        "Turnos",
                        style: TextStyle(
                          fontSize: 30,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                    const Padding(
                      padding: EdgeInsets.all(8.0),
                      child: Text(
                        "Si no tienes un turno, obténgalo aquí:",
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                    const SizedBox(height: 10),
                    AnimatedButton(
                      text: 'Obtener Turno',
                      width: 200,
                      color: Colors.blue,
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
                          title: 'Succes',
                          desc: 'Turno generado',
                          descTextStyle: const TextStyle(color: Colors.green, fontSize: 18),
                          btnOkOnPress: ()async {
                            confirmacionNotification();
                            Navigator.pushNamed(context, '/rows');
                          }
                        ).show();
                      }
                    ),
                    const SizedBox(height: 10),
                    const Padding(
                      padding: EdgeInsets.all(8.0),
                      child: Text(
                        "Si ya cuenta con un código de seguimiento,\ningrese aquí:",
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                    AnimatedButton(
                      text: 'Buscar cita o Turno',
                      color: Colors.blue,
                      width: 200,
                      pressEvent:() {
                        Navigator.pushNamed(context, '/calendario');
                      },
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
      backgroundColor: Colors.white,
    );
  }
}