import 'package:http/http.dart' as http;
import 'dart:convert';

const String url = 'http://localhost:3000/models/model_reporte.php';

Future<List<dynamic>> listarReportes(String fechaInicio, String fechaFin) async {
  Map<String, String> parametros = {
    'accion': 'ListarReportes',
    'fechainicio': fechaInicio,
    'fechafin': fechaFin,
  };

  var response = await http.post(Uri.parse(url), body: parametros);

  if (response.statusCode == 200) {
    var jsonResponse = json.decode(response.body);
    if (jsonResponse['status']) {
      return jsonResponse['data'];
    } else {
      throw Exception('No se encontraron datos de reportes');
    }
  } else {
    throw Exception('Error al cargar los reportes');
  }
}