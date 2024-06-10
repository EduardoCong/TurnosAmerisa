import 'package:http/http.dart' as http;
import 'dart:convert';

const String url = 'http://localhost:3000/models/model_servicios.php';

Future<List<dynamic>> listarServicios() async {
  Map<String, String> parametros = {'accion': 'ListarServicios'};

  var response = await http.post(Uri.parse(url), body: parametros);

  if (response.statusCode == 200) {
    var jsonResponse = json.decode(response.body);
    if (jsonResponse.isNotEmpty) {
      return jsonResponse['data'];
    } else {
      throw Exception('No se encontraron datos de servicios');
    }
  } else {
    throw Exception('Error al cargar los servicios');
  }
}

Future<Map<String, dynamic>> obtenerServicio(String idServicio) async {
  Map<String, String> parametros = {'accion': 'ObtenerServicio', 'datos': idServicio};

  var response = await http.post(Uri.parse(url), body: parametros);

  if (response.statusCode == 200) {
    return json.decode(response.body);
  } else {
    throw Exception('Error al obtener el servicio');
  }
}

Future<Map<String, dynamic>> registrarServicio(String nombreServicio, String colorServicio, String iconoServicio, String letraServicio) async {
  Map<String, String> datos = {
    'accion': 'RegistroServicio',
    'datos': json.encode({
      'nombreservicio': nombreServicio,
      'colorservicio': colorServicio,
      'iconoservicio': iconoServicio,
      'letraservicio': letraServicio,
    })
  };

  var response = await http.post(Uri.parse(url), body: datos);

  if (response.statusCode == 200) {
    return json.decode(response.body);
  } else {
    throw Exception('Error al registrar el servicio');
  }
}

Future<Map<String, dynamic>> actualizarServicio(String idServicio, String nombreServicio, String colorServicio, String iconoServicio, String letraServicio) async {
  Map<String, String> datos = {
    'accion': 'ActualizarServicio',
    'datos': json.encode({
      'idunicodelservicio': idServicio,
      'nombreservicio': nombreServicio,
      'colorservicio': colorServicio,
      'iconoservicio': iconoServicio,
      'letraservicio': letraServicio,
    })
  };

  var response = await http.post(Uri.parse(url), body: datos);

  if (response.statusCode == 200) {
    return json.decode(response.body);
  } else {
    throw Exception('Error al actualizar el servicio');
  }
}

Future<Map<String, dynamic>> actualizarEstadoServicio(String idServicio, String estado) async {
  Map<String, String> parametros = {'accion': 'ActualizarEstado', 'datos': idServicio, 'estado': estado};

  var response = await http.post(Uri.parse(url), body: parametros);

  if (response.statusCode == 200) {
    return json.decode(response.body);
  } else {
    throw Exception('Error al actualizar el estado del servicio');
  }
}
