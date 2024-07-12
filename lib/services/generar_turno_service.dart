import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class ApiService {
  static const String baseUrl = 'http://turnos.soft-box.com.mx/models/model_generar_turno.php';

  static Future generarTurno(Map<String, dynamic> datos, BuildContext context) async {
    try {
      var response = await http.post(
        Uri.parse('$baseUrl'),
        body: {
          'accion': 'GenerarTurno',
          'datos': json.encode(datos),
        },
      );
      
      if (response.statusCode == 200) {
        var jsonData = json.decode(response.body);
        print('pasa esto ${jsonData['codigo']}');
        String turno = jsonData['turno'];
        if (jsonData['codigo'] == 0) {
          print('Turno generado');
          print(jsonData);
          SharedPreferences prefs = await SharedPreferences.getInstance();
          await prefs.setString('turno', turno);
          final String turnos = await prefs.getString('turno') ?? '';
          print(turnos);
          Navigator.of(context).pushReplacementNamed('/verturno');
          return false;

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
}
