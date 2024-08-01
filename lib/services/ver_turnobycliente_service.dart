import 'package:http/http.dart' as http;
import 'dart:convert';
import 'dart:io'; 

class Turnos {
  final String turno;
  final String estado;
  final String modulo;
  final String fecha;

  Turnos({
    required this.turno,
    required this.estado,
    required this.modulo,
    required this.fecha,
  });

  factory Turnos.fromJson(Map<String, dynamic> json) {
    return Turnos(
      turno: json['turno'] ?? '',
      estado: json['estado'] ?? '',
      modulo: json['modulo'] ?? '-',
      fecha: json['tiempo_ingreso'] ?? '-', // Almacenar la fecha sin procesar
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
        Uri.parse('http://turnos.soft-box.com.mx/models/model_pantalla.php'),
        body: body,
      );

      if (response.statusCode == 200) {
        final responseData = json.decode(response.body);

        if (responseData['status'] == true) {
          final List<dynamic> turnosData = responseData['data'];
          print(turnosData);
          return turnosData.map((turnoJson) => Turnos.fromJson(turnoJson)).toList();
        } else {
          throw Exception('Error en el servidor: ${responseData['message'] ?? 'Mensaje de error desconocido'}');
        }
      } else {
        throw Exception('Error en la solicitud: ${response.statusCode}');
      }
    } on SocketException {
      throw Exception('Error de conexión. Verifica tu conexión a internet.');
    } on FormatException {
      throw Exception('Error al analizar la respuesta del servidor.');
    } catch (e) {
      print('Error desconocido: $e');
      throw Exception('Ocurrió un error inesperado.');
    }
  }
}
