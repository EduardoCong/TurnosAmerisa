import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:turnos_amerisa/model/turno_data.dart';

class ApiService {
  static const String baseUrl = 'http://turnos.soft-box.com.mx/models/model_generar_turno.php';

  static Future generarTurno(Map<String, dynamic> datos, BuildContext context, String origen) async {
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
          final turnoData = TurnoData(turno: jsonData['turno'], origen: origen);
          await guardarTurnoCache(turnoData);
          return turnoData;

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
  static Future<void> guardarTurnoCache(TurnoData turnoData) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setString('ultimoTurno', turnoData.turno);
  }
}
