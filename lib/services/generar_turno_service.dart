import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:turnos_amerisa/model/api.dart';

class ApiService {
  static const String baseUrl = 'http://turnos.soft-box.com.mx/models/model_generar_turno.php';

  static Future<Cliente?> obtenerCliente(String numeroDocumento) async {
    try {
      var response = await http.post(
        Uri.parse('$baseUrl'),
        body: {
          'accion': 'ObtenerCliente',
          'datos': numeroDocumento,
        },
      );
      
      if (response.statusCode == 200) {
        var jsonData = json.decode(response.body);
        if (jsonData['codigo'] == 0) {
          print('Cliente obtenido');
          return Cliente.fromJson(jsonData);
        } else {
          return null;
        }
      } else {
        throw Exception('Error al obtener cliente');
      }
    } catch (e) {
      throw Exception('Error de red: $e');
    }
  }

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
        if (jsonData['codigo'] == 0) {
          print('Turno generado');
          print(jsonData);
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