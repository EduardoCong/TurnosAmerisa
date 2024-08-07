import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class ApiService {
  static const String baseUrl = 'http://192.168.1.83/models/model_generar_turno.php';

  static Future<Map<String, dynamic>> generarTurno(Map<String, dynamic> datos, BuildContext context) async {
    try {
      String nuevoTurno = await generarTurnoUnico(datos);

      datos['turno'] = nuevoTurno;
      
      var response = await http.post(
        Uri.parse('$baseUrl'),
        body: {
          'accion': 'GenerarTurno',
          'datos': json.encode(datos),
        },
      );

      if (response.statusCode == 200) {
        var jsonData = json.decode(response.body);
        if (jsonData['codigo'] == 0) {
          print('Turno generado: $nuevoTurno');
          print(jsonData);
          return jsonData;
        } else {
          throw Exception('Error al generar turno: ${jsonData['respuesta']}');
        }
      } else {
        throw Exception('Error al generar turno: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Error de red: $e');
    }
  }

  static Future<String> generarTurnoUnico(Map<String, dynamic> datos) async {
    final prefs = await SharedPreferences.getInstance();
    final fechaActual = DateTime.now().toString().substring(0, 10);
    final turnosGeneradosHoy = prefs.getStringList(fechaActual) ?? [];

    String nuevoTurno;
    int contador = turnosGeneradosHoy.length + 1;
    do {
      nuevoTurno = 'C${contador.toString().padLeft(3, '0')}';
      contador++;
    } while (turnosGeneradosHoy.contains(nuevoTurno));

    turnosGeneradosHoy.add(nuevoTurno);
    await prefs.setStringList(fechaActual, turnosGeneradosHoy);

    return nuevoTurno;
  }
}
