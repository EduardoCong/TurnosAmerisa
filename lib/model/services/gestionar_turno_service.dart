import 'package:http/http.dart' as http;
import 'dart:convert';

const String url = 'http://localhost:3000/models/model_turnos.php';

Future<Map<String, dynamic>> obtenerDatosUsuario(String usuario) async {
  Map<String, String> parametros = {
    'accion': 'Obtenerdatosusuario',
    'datos': usuario,
  };

  var response = await http.post(Uri.parse(url), body: parametros);

  if (response.statusCode == 200) {
    return json.decode(response.body);
  } else {
    throw Exception('Failed to load user data');
  }
}

Future<Map<String, dynamic>> llamarTurno(String usuario, String modulo, String servicio) async {
  Map<String, String> parametros = {
    'accion': 'Llamarturno',
    'usuario': usuario,
    'modulo': modulo,
    'servicio': servicio,
  };

  var response = await http.post(Uri.parse(url), body: parametros);

  if (response.statusCode == 200) {
    return json.decode(response.body);
  } else {
    throw Exception('Failed to call turn');
  }
}

Future<Map<String, dynamic>> llamarTurnoPorId(String usuario, String modulo, String servicio, String idTurno) async {
  Map<String, String> parametros = {
    'accion': 'Llamarturnoporid',
    'usuario': usuario,
    'modulo': modulo,
    'servicio': servicio,
    'id_turno': idTurno,
  };

  var response = await http.post(Uri.parse(url), body: parametros);

  if (response.statusCode == 200) {
    return json.decode(response.body);
  } else {
    throw Exception('Failed to call turn by ID');
  }
}

Future<Map<String, dynamic>> atenderTurno(String usuario, String modulo, String servicio, String idTurno) async {
  Map<String, String> parametros = {
    'accion': 'AtenderTurno',
    'usuario': usuario,
    'modulo': modulo,
    'servicio': servicio,
    'id_turno': idTurno,
  };

  var response = await http.post(Uri.parse(url), body: parametros);

  if (response.statusCode == 200) {
    return json.decode(response.body);
  } else {
    throw Exception('Failed to attend turn');
  }
}

Future<Map<String, dynamic>> finalizarTurno(String usuario, String modulo, String servicio, String idTurno) async {
  Map<String, String> parametros = {
    'accion': 'Finalizarturno',
    'usuario': usuario,
    'modulo': modulo,
    'servicio': servicio,
    'id_turno': idTurno,
  };

  var response = await http.post(Uri.parse(url), body: parametros);

  if (response.statusCode == 200) {
    return json.decode(response.body);
  } else {
    throw Exception('Failed to finish turn');
  }
}

Future<List<dynamic>> listarTurnos() async {
  Map<String, String> parametros = {
    'accion': 'ListarTurnos',
  };

  var response = await http.post(Uri.parse(url), body: parametros);

  if (response.statusCode == 200) {
    var jsonResponse = json.decode(response.body);
    if (jsonResponse.containsKey('data')) {
      return jsonResponse['data'];
    } else {
      throw Exception('No turn data found');
    }
  } else {
    throw Exception('Failed to load turn data');
  }
}
