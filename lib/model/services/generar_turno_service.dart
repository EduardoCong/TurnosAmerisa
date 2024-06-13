import 'package:http/http.dart' as http;
import 'dart:convert';

const String url = 'http://amigos.local/models/model_generar_turno.php';

Future<Map<String, dynamic>> obtenerCliente(int numeroDocumento) async {
  Map<String, String> parametros = {
    'accion': 'ObtenerCliente',
    'datos': numeroDocumento.toString(),
  };

  print('Haciendo solicitud para obtener cliente...');

  var response = await http.post(Uri.parse(url), body: parametros);

  if (response.statusCode == 200) {
    print('Solicitud para obtener cliente completada');
    return json.decode(response.body);
  } else {
    print('Error al cargar cliente');
    throw Exception('Failed to load client');
  }
}

Future<List<dynamic>> verServicios() async {
  Map<String, String> parametros = {
    'accion': 'VerServicios',
  };

  print('Haciendo solicitud para ver servicios...');

  var response = await http.post(Uri.parse(url), body: parametros);

  if (response.statusCode == 200) {
    print('Solicitud para ver servicios completada');
    var jsonResponse = json.decode(response.body);
    if (jsonResponse['status']) {
      return jsonResponse['data'];
    } else {
      print('No se encontraron datos de servicios');
      throw Exception('No data found');
    }
  } else {
    print('Error al cargar servicios');
    throw Exception('Failed to load services');
  }
}

Future<Map<String, dynamic>> generarTurno(Map<String, dynamic> datosCliente) async {
  Map<String, dynamic> datos = {
    'accion': 'GenerarTurno',
    'datos': json.encode(datosCliente),
  };

  print('Haciendo solicitud para generar turno...');

  var response = await http.post(Uri.parse(url), body: datos);

  if (response.statusCode == 200) {
    print('Solicitud para generar turno completada');
    return json.decode(response.body);
  } else {
    print('Error al generar turno');
    throw Exception('Failed to generate turn');
  }
}
