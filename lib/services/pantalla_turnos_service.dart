import 'package:http/http.dart' as http;
import 'dart:convert';

class Turno {
  final String turno;
  final String estado;
  final String modulo;

  Turno({required this.turno, required this.estado, required this.modulo});

  factory Turno.fromJson(Map<String, dynamic> json) {
    return Turno(
      turno: json['turno'] ?? '',
      estado: json['estado'] ?? '',
      modulo: json['modulo'] ?? '-',
    );
  }
}

class TurnosService {
  Future<List<Turno>> fetchTurnosVer() async {
    try {
      final response = await http.post(
        Uri.parse('http://192.168.0.17/models/model_pantalla.php'),
        body: {'accion': 'Verturnos'},
      );
      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        if (data['status']) {
          return (data['data'] as List)
              .map((turnoJson) => Turno.fromJson(turnoJson))
              .toList();
        } else {
          return [];
        }
      } else {
        return [];
      }
    } catch (e) {
      return [];
    }
  }
}
