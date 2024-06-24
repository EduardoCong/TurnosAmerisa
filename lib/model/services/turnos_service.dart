import 'package:http/http.dart' as http;
import 'dart:convert';

const String url = 'http://amigos.local/models/model_turnos.php';

Future<List<dynamic>> verTurnos() async {
  Map<String, String> parametros = {'accion': 'Verturnos'};

  var response = await http.post(Uri.parse(url), body: parametros);

  if (response.statusCode == 200) {
    var jsonResponse = json.decode(response.body);
    if (jsonResponse['status']) {
      return jsonResponse['data'];
    } else {
      throw Exception('No turn data found');
    }
  } else {
    throw Exception('Failed to load turns');
  }
}

Future<Map<String, dynamic>> verTurno() async {
  Map<String, String> parametros = {'accion': 'ver_turno'};

  var response = await http.post(Uri.parse(url), body: parametros);

  if (response.statusCode == 200) {
    return json.decode(response.body);
  } else {
    throw Exception('Failed to load turn details');
  }
}
