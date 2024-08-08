// ignore_for_file: deprecated_member_use

import 'package:flutter/material.dart';
import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:turnos_amerisa/model/servicios_model.dart';
import 'package:turnos_amerisa/pages/home/drawer_screen.dart';
import 'package:turnos_amerisa/services/generar_turno_service.dart';
import 'package:turnos_amerisa/pages/turnos/servicios_select.dart';
import 'dart:async';

import 'package:turnos_amerisa/services/turno_actual_service.dart';

class GenerarTurnoView extends StatefulWidget {
  @override
  _GenerarTurnoViewState createState() => _GenerarTurnoViewState();
}

class _GenerarTurnoViewState extends State<GenerarTurnoView> {
  Servicio? servicioSeleccionado;
  final scaffoldKeyis = GlobalKey<ScaffoldState>();

  String nombre = '';
  String segundoNombre = '';
  String apellido = '';
  String segundoApellido = '';
  String numeroCliente = '';
  String tipoTurno = 'turno';

  String _turnoGenerado = '';

  bool isSunday = false;

  @override
  void initState() {
    super.initState();
    loadUserData();
    checkDayOfWeek();
  }

  Future<void> mostrarDetallesServicio(Servicio servicio) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setInt('id_servicio', servicio.id);
    await prefs.setString('nombre_servicio', servicio.nombre);
    await prefs.setString('color_servicio', servicio.color);
    await prefs.setString('icono_servicio', servicio.icono);
    await prefs.setString('letra_servicio', servicio.letra);
  }

  Future<void> loadUserData() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      nombre = prefs.getString('nombre') ?? '';
      segundoNombre = prefs.getString('segundoNombre') ?? '';
      apellido = prefs.getString('apellido') ?? '';
      segundoApellido = prefs.getString('segundoApellido') ?? '';
      numeroCliente = prefs.getString('numeroCliente') ?? '';
    });
  }

  Future<void> generarTurnoDialog(BuildContext context) async {
    // if (isSunday) {
    //   AwesomeDialog(
    //     context: context,
    //     dialogType: DialogType.info,
    //     width: 400,
    //     buttonsBorderRadius: BorderRadius.all(Radius.circular(2)),
    //     dismissOnTouchOutside: false,
    //     dismissOnBackKeyPress: false,
    //     headerAnimationLoop: true,
    //     animType: AnimType.bottomSlide,
    //     title: 'Los domingos no son laborales.',
    //     titleTextStyle: TextStyle(fontSize: 16),
    //     desc: '¿Desea agendar un cita?',
    //     descTextStyle: TextStyle(color: Colors.black, fontSize: 15),
    //     btnCancel: ElevatedButton(
    //       style: ElevatedButton.styleFrom(
    //         backgroundColor: Colors.red,
    //         elevation: 0,
    //         minimumSize: Size(MediaQuery.of(context).size.width - 46, 50),
    //         shape: RoundedRectangleBorder(
    //           borderRadius: BorderRadius.circular(10),
    //         ),
    //       ),
    //       onPressed: () {
    //         Navigator.pop(context);
    //       },
    //       child: Text(
    //         'No',
    //         style: TextStyle(color: Colors.white),
    //       ),
    //     ),
    //     btnOk: ElevatedButton(
    //       style: ElevatedButton.styleFrom(
    //         backgroundColor: Colors.green,
    //         elevation: 0,
    //         minimumSize: Size(MediaQuery.of(context).size.width - 46, 50),
    //         shape: RoundedRectangleBorder(
    //           borderRadius: BorderRadius.circular(10),
    //         ),
    //       ),
    //       onPressed: () {
    //         Navigator.of(context).pushReplacementNamed('/calendario');
    //       },
    //       child: Text(
    //         'Ir a citas',
    //         style: TextStyle(color: Colors.white),
    //       ),
    //     ),
    //   ).show();
    //   return;
    // }

    // if (DateTime.now().weekday == DateTime.saturday &&
    //     DateTime.now().hour >= 13) {
    //   AwesomeDialog(
    //     context: context,
    //     dialogType: DialogType.info,
    //     width: 400,
    //     buttonsBorderRadius: BorderRadius.all(Radius.circular(2)),
    //     dismissOnTouchOutside: false,
    //     dismissOnBackKeyPress: false,
    //     headerAnimationLoop: true,
    //     animType: AnimType.bottomSlide,
    //     title: 'Los sabados el servicio esta disponible de 9 am a 1 pm.',
    //     titleTextStyle: TextStyle(fontSize: 16),
    //     desc: '¿Desea agendar una cita?',
    //     descTextStyle: TextStyle(color: Colors.black, fontSize: 15),
    //     btnCancel: ElevatedButton(
    //       style: ElevatedButton.styleFrom(
    //         backgroundColor: Colors.red,
    //         elevation: 0,
    //         minimumSize: Size(MediaQuery.of(context).size.width - 46, 50),
    //         shape: RoundedRectangleBorder(
    //           borderRadius: BorderRadius.circular(10),
    //         ),
    //       ),
    //       onPressed: () {
    //         Navigator.pop(context);
    //       },
    //       child: Text(
    //         'No',
    //         style: TextStyle(color: Colors.white),
    //       ),
    //     ),
    //     btnOk: ElevatedButton(
    //       style: ElevatedButton.styleFrom(
    //         backgroundColor: Colors.green,
    //         elevation: 0,
    //         minimumSize: Size(MediaQuery.of(context).size.width - 46, 50),
    //         shape: RoundedRectangleBorder(
    //           borderRadius: BorderRadius.circular(10),
    //         ),
    //       ),
    //       onPressed: () {
    //         Navigator.of(context).pushReplacementNamed('/calendario');
    //       },
    //       child: Text(
    //         'Ir a citas',
    //         style: TextStyle(color: Colors.white),
    //       ),
    //     ),
    //   ).show();
    //   return;
    // }

    // if ((DateTime.now().weekday >= DateTime.monday && DateTime.now().weekday <= DateTime.friday && (DateTime.now().hour < 9 || DateTime.now().hour >= 18))) {
    //   AwesomeDialog(
    //     context: context,
    //     dialogType: DialogType.info,
    //     width: 400,
    //     buttonsBorderRadius: BorderRadius.all(Radius.circular(2)),
    //     dismissOnTouchOutside: false,
    //     dismissOnBackKeyPress: false,
    //     headerAnimationLoop: true,
    //     animType: AnimType.bottomSlide,
    //     title: 'De lunes el servicio esta disponible de 9 am a 6 pm.',
    //     titleTextStyle: TextStyle(fontSize: 16),
    //     desc: '¿Desea agendar una cita?',
    //     descTextStyle: TextStyle(color: Colors.black, fontSize: 15),
    //     btnCancel: ElevatedButton(
    //       style: ElevatedButton.styleFrom(
    //         backgroundColor: Colors.red,
    //         elevation: 0,
    //         minimumSize: Size(MediaQuery.of(context).size.width - 46, 50),
    //         shape: RoundedRectangleBorder(
    //           borderRadius: BorderRadius.circular(10),
    //         ),
    //       ),
    //       onPressed: () {
    //         Navigator.pop(context);
    //       },
    //       child: Text(
    //         'No',
    //         style: TextStyle(color: Colors.white),
    //       ),
    //     ),
    //     btnOk: ElevatedButton(
    //       style: ElevatedButton.styleFrom(
    //         backgroundColor: Colors.green,
    //         elevation: 0,
    //         minimumSize: Size(MediaQuery.of(context).size.width - 46, 50),
    //         shape: RoundedRectangleBorder(
    //           borderRadius: BorderRadius.circular(10),
    //         ),
    //       ),
    //       onPressed: () {
    //         Navigator.of(context).pushReplacementNamed('/calendario');
    //       },
    //       child: Text(
    //         'Ir a citas',
    //         style: TextStyle(color: Colors.white),
    //       ),
    //     ),
    //   ).show();
    //   return;
    // }

    AwesomeDialog(
      context: context,
      dialogType: DialogType.success,
      width: 400,
      buttonsBorderRadius: BorderRadius.all(Radius.circular(2)),
      dismissOnTouchOutside: false,
      dismissOnBackKeyPress: false,
      headerAnimationLoop: true,
      animType: AnimType.bottomSlide,
      title: 'Turno Generado Con Éxito',
      descTextStyle: TextStyle(color: Colors.green, fontSize: 18),
      btnCancel: ElevatedButton(
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.green,
          elevation: 0,
          minimumSize: Size(MediaQuery.of(context).size.width - 46, 50),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
        ),
        onPressed: () {
          generarTurno(context);
        },
        child: Text(
          'Turno generado con exito.',
          style: TextStyle(color: Colors.white),
        ),
      ),
    ).show();
  }

  void checkDayOfWeek() {
    DateTime now = DateTime.now();
    int dayOfWeek = now.weekday;
    if (dayOfWeek == DateTime.sunday) {
      setState(() {
        isSunday = true;
      });
    }
  }

  Future<bool> _showCancelDialog(BuildContext context) async {
    return await showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Center(child: Text("Cancela Turno")),
          content: Text("¿Estás seguro que deseas cancelar el turno?"),
          contentTextStyle: TextStyle(fontSize: 16, color: Colors.black),
          actions: <Widget>[
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                ElevatedButton(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  child: Text(
                    'No',
                    style: TextStyle(color: Colors.white),
                  ),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.red,
                    elevation: 0,
                    fixedSize: Size(120, 50),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                ),
                ElevatedButton(
                  onPressed: () {
                    Navigator.of(context).pushReplacementNamed('/home');
                  },
                  child: Text(
                    'Ir al inicio',
                    style: TextStyle(color: Colors.white),
                  ),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.green,
                    elevation: 0,
                    fixedSize: Size(120, 50),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                ),
              ],
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        return await _showCancelDialog(context);
      },
      child: Scaffold(
        key: scaffoldKeyis,
        appBar: AppBar(
          title: Text('Generar Turno'),
          centerTitle: true,
          automaticallyImplyLeading: false,
          leading: IconButton(
            icon: Icon(Icons.menu),
            onPressed: () {
              scaffoldKeyis.currentState!.openDrawer();
            },
          ),
        ),
        drawer: CustomDrawer(),
        body: SingleChildScrollView(
          padding: EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              imageLogo(),
              SizedBox(height: 20),
              Card(
                elevation: 4.0,
                margin: EdgeInsets.symmetric(vertical: 10.0),
                child: Padding(
                  padding: EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Seleccione el Servicio',
                        style: TextStyle(
                          fontSize: 18.0,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      SizedBox(height: 10.0),
                      ServiciosSelect(
                        onServicioSelected: (servicio) {
                          setState(() {
                            servicioSeleccionado = servicio;
                          });
                          if (servicio != null) {
                            mostrarDetallesServicio(servicio);
                          }
                        },
                      ),
                    ],
                  ),
                ),
              ),
              SizedBox(height: 16.0),
              Center(
                child: Padding(
                  padding: EdgeInsets.only(top: 5),
                  child: ElevatedButton(
                    onPressed: () {
                      generarTurnoDialog(context);
                    },
                    child:
                        Text('Generar', style: TextStyle(color: Colors.white)),
                    style: ElevatedButton.styleFrom(
                        textStyle: TextStyle(fontSize: 16.0),
                        minimumSize:
                            Size(MediaQuery.of(context).size.width - 46, 50),
                        backgroundColor: Color.fromARGB(255, 35, 38, 204),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        )),
                  ),
                ),
              ),
              Center(
                child: Padding(
                  padding: EdgeInsets.only(top: 5),
                  child: ElevatedButton(
                    onPressed: () {
                      AwesomeDialog(
                        context: context,
                        dialogType: DialogType.warning,
                        width: 400,
                        buttonsBorderRadius:
                            BorderRadius.all(Radius.circular(2)),
                        dismissOnTouchOutside: false,
                        dismissOnBackKeyPress: false,
                        headerAnimationLoop: false,
                        animType: AnimType.topSlide,
                        title: 'Cancelar turno?',
                        btnCancel: ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.red,
                            elevation: 0,
                            minimumSize: Size(
                                MediaQuery.of(context).size.width - 46, 50),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10),
                            ),
                          ),
                          onPressed: () {
                            Navigator.pop(context);
                          },
                          child: Text(
                            'No',
                            style: TextStyle(color: Colors.white),
                          ),
                        ),
                        btnOk: ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.green,
                            elevation: 0,
                            minimumSize: Size(
                                MediaQuery.of(context).size.width - 46, 50),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10),
                            ),
                          ),
                          onPressed: () {
                            Navigator.of(context).pushReplacementNamed('/home');
                          },
                          child: Text(
                            'Ir al inicio',
                            style: TextStyle(color: Colors.white),
                          ),
                        ),
                      ).show();
                    },
                    child:
                        Text('Cancelar', style: TextStyle(color: Colors.white)),
                    style: ElevatedButton.styleFrom(
                      textStyle: TextStyle(fontSize: 16.0),
                      minimumSize:
                          Size(MediaQuery.of(context).size.width - 46, 50),
                      backgroundColor: Colors.red,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget imageLogo() {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 14),
      child: Image.asset(
        "assets/amerisalogo.png",
        width: 600,
        height: 200,
      ),
    );
  }

  Future<void> generarTurno(BuildContext context) async {
    Map<String, dynamic> datos = {
      'numero': numeroCliente,
      'pnombre': nombre,
      'snombre': segundoNombre,
      'papellido': apellido,
      'sapellido': segundoApellido,
      'registrarcliente': 'NO',
      'id_servicio': servicioSeleccionado!.id,
      'letra': servicioSeleccionado!.letra,
      'fechaInicio': null,
      'tipo': tipoTurno
    };

    try {
      final result = await ApiService.generarTurno(datos, context);
      _turnoGenerado = result['turno'];

      SharedPreferences prefs = await SharedPreferences.getInstance();
      await prefs.setString('turnoGenerado', _turnoGenerado);

      String turnoActual = '';
      if (servicioSeleccionado != null) {
        String nombreServicio = servicioSeleccionado!.nombre.toLowerCase();
        TurnoScreen turnoScreen = TurnoScreen();
        switch (nombreServicio) {
          case 'carga':
            turnoActual = await turnoScreen.obtenerTurnoCarga();
            break;
          case 'servicio':
            turnoActual = await turnoScreen.obtenerTurnoServicio();
            break;
          case 'cita':
            turnoActual = await turnoScreen.obtenerTurnoCita();
            break;
          case 'visita':
            turnoActual = await turnoScreen.obtenerTurnoVisita();
            break;
          case 'descarga':
            turnoActual = await turnoScreen.obtenerTurnoDescarga();
            break;
          case 'revision':
            turnoActual = await turnoScreen.obtenerTurnoRevision();
            break;
          default:
            print('Servicio no reconocido: $nombreServicio');
            break;
        }
      }

      await prefs.setString('turnoActual', turnoActual);

      Navigator.of(context).pushReplacementNamed('/verturno');
    } catch (e) {
      print('Error al generar turno: $e');
    }
  }
}
