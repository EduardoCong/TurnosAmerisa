import 'package:http/http.dart' as http;
import 'dart:convert';

const String url = 'http://localhost:3000/config/funciones.php';

Future<List<dynamic>> listarUsuarios() async {
  var response = await http.get(Uri.parse(url + '?accion=usuarios'));

  if (response.statusCode == 200) {
    return json.decode(response.body);
  } else {
    throw Exception('Error al cargar los usuarios');
  }
}

Future<List<dynamic>> listarServicios() async {
  var response = await http.get(Uri.parse(url + '?accion=servicios'));

  if (response.statusCode == 200) {
    return json.decode(response.body);
  } else {
    throw Exception('Error al cargar los servicios');
  }
}

Future<List<dynamic>> listarServicios1() async {
  var response = await http.get(Uri.parse(url + '?accion=servicios1'));

  if (response.statusCode == 200) {
    return json.decode(response.body);
  } else {
    throw Exception('Error al cargar los servicios');
  }
}

Future<List<dynamic>> listarTurnosEnPantalla() async {
  var response = await http.get(Uri.parse(url + '?accion=turno_en_pantalla'));

  if (response.statusCode == 200) {
    return json.decode(response.body);
  } else {
    throw Exception('Error al cargar los turnos en pantalla');
  }
}

Future<List<dynamic>> listarTurnosHoy() async {
  var response = await http.get(Uri.parse(url + '?accion=turnos_ver_hoy'));

  if (response.statusCode == 200) {
    return json.decode(response.body);
  } else {
    throw Exception('Error al cargar los turnos de hoy');
  }
}

Future<List<dynamic>> listarTurnosHoyAtendidos() async {
  var response = await http.get(Uri.parse(url + '?accion=turnos_ver_hoy_atendidos'));

  if (response.statusCode == 200) {
    return json.decode(response.body);
  } else {
    throw Exception('Error al cargar los turnos de hoy atendidos');
  }
}

Future<Map<String, dynamic>> obtenerTurnosEnEspera() async {
  var response = await http.get(Uri.parse(url + '?accion=turnos_en_espera'));

  if (response.statusCode == 200) {
    return json.decode(response.body);
  } else {
    throw Exception('Error al obtener los turnos en espera');
  }
}

Future<Map<String, dynamic>> obtenerTurnosAtendidos() async {
  var response = await http.get(Uri.parse(url + '?accion=turnos_atendidos'));

  if (response.statusCode == 200) {
    return json.decode(response.body);
  } else {
    throw Exception('Error al obtener los turnos atendidos');
  }
}
