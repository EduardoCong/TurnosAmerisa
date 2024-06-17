import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

import 'package:turnos_amerisa/model/api.dart';

class ServiciosSelect extends StatefulWidget {
  final Function(Servicio?) onServicioSelected;

  const ServiciosSelect({Key? key, required this.onServicioSelected}) : super(key: key);

  @override
  _ServiciosSelectState createState() => _ServiciosSelectState();
}

class _ServiciosSelectState extends State<ServiciosSelect> {
  Servicio? servicioSeleccionado;
  List<Servicio> servicios = [];

  @override
  void initState() {
    super.initState();
    cargarServicios();
  }

  Future<void> cargarServicios() async {
    try {
      final response = await http.post(
        Uri.parse('http://amigos.local/models/model_generar_turno.php'),
        body: {'accion': 'VerServicios'},
      );

      if (response.statusCode == 200) {
        var jsonData = json.decode(response.body);
        if (jsonData['status']) {
          List<dynamic> data = jsonData['data'];
          setState(() {
            servicios = data.map((item) => Servicio.fromJson(item)).toList();
          });
          Fluttertoast.showToast(msg: 'Servicios cargados correctamente');
        } else {
          Fluttertoast.showToast(msg: 'Error: ${jsonData['msg']}');
        }
      } else {
        Fluttertoast.showToast(msg: 'Error en la conexión: ${response.statusCode}');
      }
    } catch (e) {
      Fluttertoast.showToast(msg: 'Error: $e');
      print(e);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: servicios.isEmpty
          ? CircularProgressIndicator()
          : DropdownButtonFormField<Servicio>(
              value: servicioSeleccionado,
              onChanged: (Servicio? value) {
                setState(() {
                  servicioSeleccionado = value;
                });
                widget.onServicioSelected(value);
              },
              items: servicios.map((Servicio servicio) {
                return DropdownMenuItem<Servicio>(
                  value: servicio,
                  child: Text(servicio.nombre),
                );
              }).toList(),
              decoration: InputDecoration(
                labelText: 'Seleccionar Servicio',
                border: OutlineInputBorder(),
              ),
            ),
    );
  }
}
