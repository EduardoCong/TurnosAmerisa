import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class ApiService {
  static const String baseUrl = 'http://192.168.69.169/models/model_generar_turno.php';

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
        if (jsonData['codigo'] == 0) {
          print('Turno generado');
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
}
