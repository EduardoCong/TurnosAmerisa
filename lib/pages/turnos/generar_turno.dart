import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:turnos_amerisa/model/api.dart';
import 'package:turnos_amerisa/services/generar_turno_service.dart';
import 'package:turnos_amerisa/pages/turnos/servicios_select.dart';
import 'dart:async';

class GenerarTurnoView extends StatefulWidget {
  @override
  _GenerarTurnoViewState createState() => _GenerarTurnoViewState();
}

class _GenerarTurnoViewState extends State<GenerarTurnoView> {

  Servicio? servicioSeleccionado;
  List<int> serviciosDeshabilitados = [];

  String nombre = '';
  String segundoNombre = '';
  String apellido = '';
  String segundoApellido = '';
  String numeroCliente = '';

  @override
  void initState() {
    super.initState();
    loadUserData();
  }

  Future <void> mostrarDetallesServicio(Servicio servicio) async {
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

  void verificarHora(BuildContext context) {
    final now = DateTime.now();
    if (now.hour >= 18) {
      AwesomeDialog(
        context: context,
        dialogType: DialogType.warning,
        borderSide: BorderSide(
          color: Colors.red,
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
        title: 'Se han acabado los turnos por hoy',
        desc: 'Desea hacer una cita para otro día?',
        btnOkOnPress: () {
          Navigator.of(context).pushReplacementNamed('/citas');
        },
        btnCancelOnPress: (){},
      ).show();
    } else {
      generarTurnoDialog(context);
    }
  }

  void generarTurnoDialog(BuildContext context) {
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
      title: 'Turno Generado Con Exito',
      descTextStyle: TextStyle(color: Colors.green, fontSize: 18),
      btnOkOnPress: () {
        generarTurno(context);
        Navigator.of(context).pushReplacementNamed('/verturno');
      },
      btnCancelOnPress: (){},
    ).show();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: Text('Generar Turno'),
        centerTitle: true,
        automaticallyImplyLeading: false,
        backgroundColor: Colors.white,
      ),
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

                      }, serviciosDeshabilitados: serviciosDeshabilitados,
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
                    verificarHora(context);
                  },
                  child: Text('Generar', style: TextStyle(color: Colors.white)),
                  style: ElevatedButton.styleFrom(
                    textStyle: TextStyle(fontSize: 16.0),
                    minimumSize: Size(MediaQuery.of(context).size.width - 46, 50),
                    backgroundColor: Color.fromARGB(255, 35, 38, 204),
                  ),
                ),
              ),
            ),
            Center(
              child: Padding(
                padding: const EdgeInsets.only(top: 5),
                child: ElevatedButton(
                  onPressed: (){
                    AwesomeDialog(
                      context: context,
                      dialogType: DialogType.warning,
                      borderSide: BorderSide(
                        color: Colors.red,
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
                      title: 'Cancelado',
                      descTextStyle: TextStyle(color: Colors.green, fontSize: 18),
                      btnOkOnPress: () {
                        Navigator.of(context).pushReplacementNamed('/home');
                      },
                      btnCancelOnPress: (){},
                    ).show();
                  },
                  child: Text('Cancelar', style: TextStyle(color: Colors.white)),
                  style: ElevatedButton.styleFrom(
                    textStyle: TextStyle(fontSize: 16.0),
                    minimumSize: Size(MediaQuery.of(context).size.width - 46, 50),
                    backgroundColor: Colors.red,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget imageLogo(){
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
      await ApiService.generarTurno(datos, context);
    } catch (e) {
      print('Error al generar turno_: $e');
    }
  }
}
