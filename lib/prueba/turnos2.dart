import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:turnos_amerisa/model/api.dart';
import 'package:turnos_amerisa/model/services/generar_turno_service.dart';
import 'package:turnos_amerisa/prueba/loco.dart';

class GenerarTurnoView2 extends StatefulWidget {
  @override
  _GenerarTurnoView2State createState() => _GenerarTurnoView2State();
}

class _GenerarTurnoView2State extends State<GenerarTurnoView2> {
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
                    controller: numeroController,
                    decoration: InputDecoration(
                      labelText: 'Número',
                    ),
                    readOnly: true,
                  ),
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
                if (servicioSeleccionado != null) {
                  generarTurno(context);
                } else {
                  Fluttertoast.showToast(msg: 'Selecciona un servicio primero');
                }
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
      Fluttertoast.showToast(msg: 'Selecciona un servicio primero');
      return;
    }

    String numeroTexto = numeroController.text;
    if (numeroTexto.isEmpty) {
      Fluttertoast.showToast(msg: 'El número no puede estar vacío');
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
      await ApiService.generarTurno(datos);
      Fluttertoast.showToast(msg: 'Generar turno con datos: $datos');
    } catch (e) {
      Fluttertoast.showToast(msg: 'Error al generar turno: $e');
      print('Error al generar turno: $e');
    }
  }
}
