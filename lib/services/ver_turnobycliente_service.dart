import 'package:http/http.dart' as http;
import 'dart:convert';

class Turnos {
  final String turno;
  final String estado;
  final String modulo;

  Turnos({required this.turno, required this.estado, required this.modulo});

  factory Turnos.fromJson(Map<String, dynamic> json) {
    return Turnos(
      turno: json['turno'] ?? '',
      estado: json['estado'] ?? '',
      modulo: json['modulo'] ?? '-',
    );
  }
}

class MyTurnosService {
  Future<List<Turnos>> fetchMyTurnosVerMisMyTurnos(int idCliente) async {
    Map<String, String> body = {
      'accion': 'VerMisTurnos',
      'id': idCliente.toString(),
    };

    try {
      final response = await http.post(
        Uri.parse('http://192.168.1.83/models/model_pantalla.php'),
        body: body,
      );

      if (response.statusCode == 200) {
        final data = json.decode(response.body);

        if (data['status']) {
          return (data['data'] as List)
              .map((turnoJson) => Turnos.fromJson(turnoJson))
              .toList();
        } else {
          return [];
        }
      } else {
        throw Exception('Error en la respuesta del servidor: ${response.statusCode}');
      }
    } catch (e) {
      print('Error fetching turnos: $e');
      return [];
    }
  }
}
