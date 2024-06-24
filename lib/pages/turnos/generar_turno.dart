import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:turnos_amerisa/model/api.dart';
import 'package:turnos_amerisa/model/services/generar_turno_service.dart';
import 'package:turnos_amerisa/pages/turnos/servicios_select.dart';

class GenerarTurnoView extends StatefulWidget {
  @override
  _GenerarTurnoViewState createState() => _GenerarTurnoViewState();
}

class _GenerarTurnoViewState extends State<GenerarTurnoView> {
    TextEditingController numeroDocumentoController = TextEditingController();
    TextEditingController numeroController = TextEditingController();
    TextEditingController pnombreController = TextEditingController();
    TextEditingController snombreController = TextEditingController();
    TextEditingController papellidoController = TextEditingController();
    TextEditingController sapellidoController = TextEditingController();


  Servicio? servicioSeleccionado;

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Generar Turno'),
        automaticallyImplyLeading: false,
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            TextField(
              controller: numeroDocumentoController,
              decoration: InputDecoration(
                hintText: 'Número Documento',
              ),
            ),
            SizedBox(height: 16.0),
            ElevatedButton(
              onPressed: () => buscarCliente(context),
              child: Text('Buscar Cliente'),
            ),
            SizedBox(height: 16.0),
            Visibility(
              visible: true,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  TextField(
                    controller: pnombreController,
                    decoration: InputDecoration(
                      labelText: 'Primer Nombre',
                    ),
                    readOnly: true,
                  ),
                  TextField(
                    controller: snombreController,
                    decoration: InputDecoration(
                      labelText: 'Segundo Nombre',
                    ),
                    readOnly: true,
                  ),
                  TextField(
                    controller: papellidoController,
                    decoration: InputDecoration(
                      labelText: 'Primer Apellido',
                    ),
                    readOnly: true,
                  ),
                  TextField(
                    controller: sapellidoController,
                    decoration: InputDecoration(
                      labelText: 'Segundo Apellido',
                    ),
                    readOnly: true,
                  ),
                ],
              ),
            ),
            SizedBox(height: 16.0),
            ServiciosSelect(
              onServicioSelected: (servicio) {
                setState(() {
                  servicioSeleccionado = servicio;
                });
              },
            ),
            SizedBox(height: 16.0),
            ElevatedButton(
              onPressed: () {
                generarTurno(context);
              },
              child: Text('Generar Turno'),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> buscarCliente(BuildContext context) async {
  String? numeroDocumento = numeroDocumentoController.text;
    try {
      if (numeroDocumento.isNotEmpty) {
        int numeroDocumentoInt = int.tryParse(numeroDocumento) ?? 0;

        Cliente? cliente = await ApiService.obtenerCliente(numeroDocumentoInt);

        if (cliente != null) {
          setState(() {
            numeroController.text = cliente.numero.toString();
            pnombreController.text = cliente.pnombre;
            snombreController.text = cliente.snombre;
            papellidoController.text = cliente.papellido;
            sapellidoController.text = cliente.sapellido;
          });
          Fluttertoast.showToast(msg: 'Cliente encontrado');
        } else {
          setState(() {
            numeroController.text = '';
            pnombreController.text = '';
            snombreController.text = '';
            papellidoController.text = '';
            sapellidoController.text = '';
          });
          Fluttertoast.showToast(msg: 'No se encontraron datos de cliente');
        }
      } else {
        Fluttertoast.showToast(msg: 'Ingrese un número de documento válido');
      }
    } catch (e) {
      Fluttertoast.showToast(msg: 'Error al buscar cliente: $e');
      print('Error al buscar cliente: $e');
    }
  }

  Future<void> generarTurno(BuildContext context) async {
    if (servicioSeleccionado == null) {
      AwesomeDialog(
            context: context,
            dialogType: DialogType.warning,
            borderSide: BorderSide(
              color: Colors.blue,
              width: 2,
            ),
            width: 280,
            buttonsBorderRadius: BorderRadius.all(
              Radius.circular(2),
            ),
            dismissOnTouchOutside: true,
            dismissOnBackKeyPress: false,
            onDismissCallback: (type) {
              debugPrint('Dialog Dismiss from callback $type');
            },
            headerAnimationLoop: false,
            animType: AnimType.topSlide,
            title: 'Selecciona un servicio primero',
            descTextStyle: TextStyle(color: Colors.green, fontSize: 18),
            btnOkOnPress: () async {
            },
          ).show();
      return;
    }

    String numeroTexto = numeroController.text;
    if (numeroTexto.isEmpty) {
      AwesomeDialog(
            context: context,
            dialogType: DialogType.warning,
            borderSide: BorderSide(
              color: Colors.blue,
              width: 2,
            ),
            width: 280,
            buttonsBorderRadius: BorderRadius.all(
              Radius.circular(2),
            ),
            dismissOnTouchOutside: true,
            dismissOnBackKeyPress: false,
            onDismissCallback: (type) {
              debugPrint('Dialog Dismiss from callback $type');
            },
            headerAnimationLoop: false,
            animType: AnimType.topSlide,
            title: 'Ingresa un numero',
            descTextStyle: TextStyle(color: Colors.green, fontSize: 18),
            btnOkOnPress: () async {
              // Navigator.pushNamed(context, '/rows');
            },
          ).show();
      return;
    }
    int? amigos = int.tryParse(numeroTexto);
    Map<String, dynamic> datos = {
      'numero': amigos,
      'pnombre': pnombreController.text,
      'snombre': snombreController.text,
      'papellido': papellidoController.text,
      'sapellido': sapellidoController.text,
      'registrarcliente': 'NO',
      'id_servicio': servicioSeleccionado!.id,
      'letra': servicioSeleccionado!.letra,
      'fechaInicio': null,
    };
    try {
      await ApiService.generarTurno(datos,context);
    } catch (e) {
      print('Error al generar turno: $e');
    }
  }
}
