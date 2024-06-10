import 'dart:convert';
import 'package:http/http.dart' as http;

const String baseUrl = 'http://localhost:3000/models/model_clientes.php';

Future<List<dynamic>> listarClientes() async {
  final response = await http.post(
    Uri.parse(baseUrl),
    body: {'accion': 'ListarClientes'},
  );

  if (response.statusCode == 200) {
    final jsonResponse = jsonDecode(response.body);
    return jsonResponse['data'];
  } else {
    throw Exception('Error al listar clientes');
  }
}

Future<Map<String, dynamic>> obtenerCliente(String documento) async {
  final response = await http.post(
    Uri.parse(baseUrl),
    body: {'accion': 'ObtenerCliente', 'datos': documento},
  );

  if (response.statusCode == 200) {
    final jsonResponse = jsonDecode(response.body);
    return jsonResponse;
  } else {
    throw Exception('Error al obtener el cliente');
  }
}

Future<void> registrarCliente(Map<String, dynamic> datosCliente) async {
  final response = await http.post(
    Uri.parse(baseUrl),
    body: {'accion': 'RegistroCliente', 'datos': jsonEncode(datosCliente)},
  );

  if (response.statusCode != 200) {
    throw Exception('Error al registrar el cliente');
  }
}

Future<void> actualizarCliente(Map<String, dynamic> datosCliente) async {
  final response = await http.post(
    Uri.parse(baseUrl),
    body: {'accion': 'ActualizarCliente', 'datos': jsonEncode(datosCliente)},
  );

  if (response.statusCode != 200) {
    throw Exception('Error al actualizar el cliente');
  }
}

Future<void> actualizarEstadoCliente(String idCliente, String estado) async {
  final response = await http.post(
    Uri.parse(baseUrl),
    body: {'accion': 'ActualizarEstado', 'datos': jsonEncode({'idCliente': idCliente, 'estado': estado})},
  );

  if (response.statusCode != 200) {
    throw Exception('Error al actualizar el estado del cliente');
  }
}

