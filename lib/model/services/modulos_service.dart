import 'package:http/http.dart' as http;
import 'dart:convert';

const String url = 'http://localhost:3000/models/model_modulos.php';

Future<List<dynamic>> listarModulos() async {
  Map<String, String> parametros = {'accion': 'ListarModulos'};

  var response = await http.post(Uri.parse(url), body: parametros);

  if (response.statusCode == 200) {
    return json.decode(response.body)['data'];
  } else {
    throw Exception('Failed to load modules');
  }
}

Future<Map<String, dynamic>> obtenerModulo(String idModulo) async {
  Map<String, String> parametros = {'accion': 'ObtenerModulo', 'datos': idModulo};

  var response = await http.post(Uri.parse(url), body: parametros);

  if (response.statusCode == 200) {
    return json.decode(response.body);
  } else {
    throw Exception('Failed to load module details');
  }
}

Future<Map<String, dynamic>> registrarModulo(String nombreModulo) async {
  Map<String, String> datos = {'accion': 'RegistroModulo', 'datos': json.encode({'nombremodulo': nombreModulo})};

  var response = await http.post(Uri.parse(url), body: datos);

  if (response.statusCode == 200) {
    return json.decode(response.body);
  } else {
    throw Exception('Failed to register module');
  }
}

Future<Map<String, dynamic>> actualizarModulo(String idModulo, String nombreModulo) async {
  Map<String, String> datos = {
    'accion': 'ActualizarModulos',
    'datos': json.encode({'idunicodelmodulo': idModulo, 'nombremodulo': nombreModulo})
  };

  var response = await http.post(Uri.parse(url), body: datos);

  if (response.statusCode == 200) {
    return json.decode(response.body);
  } else {
    throw Exception('Failed to update module');
  }
}

Future<Map<String, dynamic>> actualizarEstadoModulo(String idModulo, String estado) async {
  Map<String, String> parametros = {'accion': 'ActualizarEstado', 'datos': idModulo, 'estado': estado};

  var response = await http.post(Uri.parse(url), body: parametros);

  if (response.statusCode == 200) {
    return json.decode(response.body);
  } else {
    throw Exception('Failed to update module status');
  }
}
