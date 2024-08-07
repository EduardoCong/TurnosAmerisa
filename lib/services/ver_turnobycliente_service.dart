import 'package:http/http.dart' as http;
import 'dart:convert';

class MyTurnosService {
  Future<List<Map<String, dynamic>>> fetchMyTurnosVerMisMyTurnos(int idCliente) async {
    final response = await http.post(
      Uri.parse('http://192.168.1.83/models/model_pantalla.php'),
      body: {'accion': 'VerMisTurnos', 'id': idCliente.toString()},
    );

    print('Request body: ${json.encode({'accion': 'VerMisTurnos', 'id': idCliente})}');
    print('Response status: ${response.statusCode}');
    print('Response body: ${response.body}');

    if (response.statusCode == 200) {
      final responseData = json.decode(response.body);
      if (responseData['status']) {
        final turnosData = responseData['data'] as List<dynamic>;
        return turnosData.map((turnoJson) => turnoJson as Map<String, dynamic>).toList();
      } else {
        throw Exception('Error en el servidor: ${responseData['error']}');
      }
    } else {
      throw Exception('Error en la solicitud: ${response.statusCode}');
    }
  }
}
