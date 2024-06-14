import 'package:http/http.dart' as http;
import 'dart:convert';

const String url = 'http://amigos.local/models/model_generar_turno.php';

Future<Map<String, dynamic>?> obtenerCliente(int datos) async {
  var body = {'accion': 'ObtenerCliente', 'datos': datos.toString()};

  try {
    var response = await http.post(Uri.parse(url), body: body);

    if (response.statusCode == 200) {
      var jsonResponse = json.decode(response.body);
      return jsonResponse;
    } else {
      throw Exception('Error al obtener cliente: ${response.reasonPhrase}');
    }
  } catch (e) {
    print('Error: $e');
    return null;
  }
}

  Future<List<Map<String, dynamic>>> verServicios() async {
    final response = await http.post(
      Uri.parse(url),
      body: {'accion': 'VerServicios'},
    );

    if (response.statusCode == 200) {
      final Map<String, dynamic> data = json.decode(response.body);
      if (data['status'] == true) {
        return List<Map<String, dynamic>>.from(data['data']);
      } else {
        throw Exception(data['msg']);
      }
    } else {
      throw Exception('Failed to load data');
    }
  }


Future<Map<String, dynamic>> generarTurno(Map<String, dynamic> datosCliente) async {
  Map<String, dynamic> datos = {
    'accion': 'GenerarTurno',
    'datos': json.encode(datosCliente),
  };

  var response = await http.post(Uri.parse(url), body: datos);

  if (response.statusCode == 200) {
    print('Turno generado con exito');
    return json.decode(response.body);
  } else {
    print('Error al generar turno');
    throw Exception('Failed to generate turn');
  }
}
