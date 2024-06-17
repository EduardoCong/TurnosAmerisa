// import 'package:flutter/material.dart';
// import 'package:fluttertoast/fluttertoast.dart';
// import 'package:turnos_amerisa/model/api.dart';
// import 'package:turnos_amerisa/model/services/generar_turno_service.dart';


// class GenerarTurnoController {
//   TextEditingController numeroDocumentoController = TextEditingController();
//   TextEditingController numeroController = TextEditingController();
//   TextEditingController pnombreController = TextEditingController();
//   TextEditingController snombreController = TextEditingController();
//   TextEditingController papellidoController = TextEditingController();
//   TextEditingController sapellidoController = TextEditingController();

//   List<Servicio> servicios = [];
//   Servicio? servicioSeleccionado;

//   Future<void> buscarCliente(BuildContext context) async {
//     String numeroDocumento = numeroDocumentoController.text;

//     try {
//       Cliente? cliente = await ApiService.obtenerCliente(numeroDocumento);

//       if (cliente != null) {
//         numeroController.text = cliente.numero.toString();
//         pnombreController.text = cliente.pnombre;
//         snombreController.text = cliente.snombre;
//         papellidoController.text = cliente.papellido;
//         sapellidoController.text = cliente.sapellido;
//         Fluttertoast.showToast(msg: 'Cliente encontrado');
//       } else {
//         Fluttertoast.showToast(msg: 'No se encontraron datos de cliente');
//       }
//     } catch (e) {
//       Fluttertoast.showToast(msg: 'Error: $e');
//     }
//   }

//   Future<void> generarTurno(BuildContext context) async {
//     Map<String, dynamic> datos = {
//       'numero': numeroController.text,
//       'pnombre': pnombreController.text,
//       'snombre': snombreController.text,
//       'papellido': papellidoController.text,
//       'sapellido': sapellidoController.text,
//       'registrarcliente': 'NO', // Puedes manejar esto dinámicamente según la lógica de tu app
//       'id_servicio': servicioSeleccionado!.id,
//       'letra': servicioSeleccionado!.letra,
//       'fechaInicio': null, // Puedes manejar la fecha aquí si es necesario
//     };

//     try {
//       // Aquí llamarías a ApiService.generarTurno(datos) según tu implementación actual
//       Fluttertoast.showToast(msg: 'Generar turno con datos: $datos');
//     } catch (e) {
//       Fluttertoast.showToast(msg: 'Error al generar turno: $e');
//     }
//   }
// }
