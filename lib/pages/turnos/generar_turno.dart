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
  final scaffoldKey = GlobalKey<ScaffoldState>();

  String nombre = '';
  String segundoNombre = '';
  String apellido = '';
  String segundoApellido = '';
  String numeroCliente = '';

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
    if (isSunday) {
      AwesomeDialog(
        context: context,
        dialogType: DialogType.warning,
        borderSide: BorderSide(
          color: Colors.red,
          width: 2,
        ),
        width: 280,
        buttonsBorderRadius: BorderRadius.all(Radius.circular(2)),
        dismissOnTouchOutside: true,
        dismissOnBackKeyPress: false,
        headerAnimationLoop: false,
        animType: AnimType.bottomSlide,
        title: 'No es posible generar turno',
        desc: '¿Desea agendar un cita?',
        descTextStyle: TextStyle(color: Colors.red, fontSize: 18),
        btnCancelText: 'No',
        btnCancelOnPress: () {},
        btnOkText: 'Si',
        btnOkOnPress: () {
          Navigator.of(context).pushReplacementNamed('/calendario');
        },
      ).show();
      return;
    }

    if (DateTime.now().weekday == DateTime.saturday &&
        DateTime.now().hour >= 13) {
      AwesomeDialog(
        context: context,
        dialogType: DialogType.info,
        borderSide: BorderSide(
          color: Colors.blue,
          width: 2,
        ),
        width: 280,
        buttonsBorderRadius: BorderRadius.all(Radius.circular(2)),
        dismissOnTouchOutside: true,
        dismissOnBackKeyPress: false,
        headerAnimationLoop: false,
        animType: AnimType.bottomSlide,
        title: '¿Desea agendar una cita?',
        descTextStyle: TextStyle(color: Colors.blue, fontSize: 18),
        btnCancelText: 'No',
        btnCancelOnPress: () {},
        btnOkText: 'Sí',
        btnOkOnPress: () {
          Navigator.of(context).pushReplacementNamed('/calendario');
        },
      ).show();
      return;
    }

    AwesomeDialog(
      context: context,
      dialogType: DialogType.success,
      borderSide: BorderSide(
        color: Colors.blue,
        width: 2,
      ),
      width: 280,
      buttonsBorderRadius: BorderRadius.all(Radius.circular(2)),
      dismissOnTouchOutside: true,
      dismissOnBackKeyPress: false,
      headerAnimationLoop: false,
      animType: AnimType.bottomSlide,
      title: 'Turno Generado Con Éxito',
      descTextStyle: TextStyle(color: Colors.green, fontSize: 18),
      btnOkOnPress: () {
        generarTurno(context);
      },
      btnCancelOnPress: () {},
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
          title: Text("Cancela Turno"),
          content: Text("¿Estás seguro que deseas cancelar el turno?"),
          actions: <Widget>[
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                TextButton(
                  child: Text("No"),
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                ),
                TextButton(
                  child: Text("Sí"),
                  onPressed: () {
                    Navigator.of(context).pushReplacementNamed('/home');
                  },
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
        key: scaffoldKey,
        // backgroundColor: Colors.white,
        appBar: AppBar(
          title: Text('Generar Turno'),
          centerTitle: true,
          automaticallyImplyLeading: false,
          // backgroundColor: Color.fromARGB(255, 255, 255, 255),
          leading: IconButton(
            icon: Icon(Icons.menu),
            onPressed: () {
              scaffoldKey.currentState!.openDrawer();
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
                  padding: const EdgeInsets.only(top: 5),
                  child: ElevatedButton(
                    onPressed: () {
                      generarTurnoDialog(context);
                    },
                    child: Text('Generar', style: TextStyle(color: Colors.white)),
                    style: ElevatedButton.styleFrom(
                      textStyle: TextStyle(fontSize: 16.0),
                      minimumSize:
                          Size(MediaQuery.of(context).size.width - 46, 50),
                      backgroundColor: Color.fromARGB(255, 35, 38, 204),
                    ),
                  ),
                ),
              ),
              Center(
                child: Padding(
                  padding: const EdgeInsets.only(top: 5),
                  child: ElevatedButton(
                    onPressed: () {
                      AwesomeDialog(
                        context: context,
                        dialogType: DialogType.warning,
                        borderSide: BorderSide(
                          color: Colors.red,
                          width: 2,
                        ),
                        width: 280,
                        buttonsBorderRadius: BorderRadius.all(Radius.circular(2)),
                        dismissOnTouchOutside: true,
                        dismissOnBackKeyPress: false,
                        headerAnimationLoop: false,
                        animType: AnimType.bottomSlide,
                        title: 'Cancelado',
                        descTextStyle:
                            TextStyle(color: Colors.green, fontSize: 18),
                        btnOkOnPress: () {
                          Navigator.of(context).pushReplacementNamed('/home');
                        },
                        btnCancelOnPress: () {},
                      ).show();
                    },
                    child:
                        Text('Cancelar', style: TextStyle(color: Colors.white)),
                    style: ElevatedButton.styleFrom(
                      textStyle: TextStyle(fontSize: 16.0),
                      minimumSize:
                          Size(MediaQuery.of(context).size.width - 46, 50),
                      backgroundColor: Colors.red,
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
      child: Image.network(
        "https://pbs.twimg.com/profile_images/814281946180231169/E7Z0c1Hy_400x400.jpg",
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
