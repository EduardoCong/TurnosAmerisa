import 'package:http/http.dart' as http;
import 'dart:convert';

const String url = 'http://localhost:3000/models/model_usuario.php';

Future<List<dynamic>> listarUsuarios() async {
  Map<String, String> parametros = {'accion': 'ListarUsuarios'};

  var response = await http.post(Uri.parse(url), body: parametros);

  print(url);
  print(response);

  if (response.statusCode == 200) {
    var jsonResponse = json.decode(response.body);
    print(jsonResponse);
    if (jsonResponse.isNotEmpty) {
      return jsonResponse['data'];
      
    } else {
      throw Exception('No se encontraron datos de usuarios');
    }
  } else {
    throw Exception('Error al cargar los usuarios');
  }
}

Future<Map<String, dynamic>> obtenerUsuario(String idUsuario) async {
  Map<String, String> parametros = {'accion': 'Obtenerusuario', 'datos': idUsuario};

  var response = await http.post(Uri.parse(url), body: parametros);

  if (response.statusCode == 200) {
    return json.decode(response.body);
  } else {
    throw Exception('Error al obtener el usuario');
  }
}

Future<Map<String, dynamic>> registrarUsuario(Map<String, dynamic> datosUsuario) async {
  Map<String, String> datos = {
    'accion': 'RegistroUsuario',
    'datos': json.encode(datosUsuario)
  };

  var response = await http.post(Uri.parse(url), body: datos);

  if (response.statusCode == 200) {
    return json.decode(response.body);
  } else {
    throw Exception('Error al registrar el usuario');
  }
}

Future<Map<String, dynamic>> actualizarUsuario(Map<String, dynamic> datosUsuario) async {
  Map<String, String> datos = {
    'accion': 'ActualizarUsuario',
    'datos': json.encode(datosUsuario)
  };

  var response = await http.post(Uri.parse(url), body: datos);

  if (response.statusCode == 200) {
    return json.decode(response.body);
  } else {
    throw Exception('Error al actualizar el usuario');
  }
}

Future<Map<String, dynamic>> actualizarEstadoUsuario(String idUsuario, String estado) async {
  Map<String, String> parametros = {'accion': 'ActualizarEstado', 'datos': idUsuario, 'estado': estado};

  var response = await http.post(Uri.parse(url), body: parametros);

  if (response.statusCode == 200) {
    return json.decode(response.body);
  } else {
    throw Exception('Error al actualizar el estado del usuario');
  }
}

Future<List<dynamic>> verServicios() async {
  Map<String, String> parametros = {'accion': 'VerServicios'};

  var response = await http.post(Uri.parse(url), body: parametros);

  if (response.statusCode == 200) {
    var jsonResponse = json.decode(response.body);
    if (jsonResponse['status']) {
      return jsonResponse['data'];
    } else {
      throw Exception('No se encontraron datos de servicios');
    }
  } else {
    throw Exception('Error al cargar los servicios');
  }
}

Future<List<dynamic>> verModulos() async {
  Map<String, String> parametros = {'accion': 'VerModulos'};

  var response = await http.post(Uri.parse(url), body: parametros);

  if (response.statusCode == 200) {
    var jsonResponse = json.decode(response.body);
    if (jsonResponse['status']) {
      return jsonResponse['data'];
    } else {
      throw Exception('No se encontraron datos de módulos');
    }
  } else {
    throw Exception('Error al cargar los módulos');
  }
}

Future<List<dynamic>> verNiveles() async {
  Map<String, String> parametros = {'accion': 'VerNiveles'};

  var response = await http.post(Uri.parse(url), body: parametros);

  if (response.statusCode == 200) {
    var jsonResponse = json.decode(response.body);
    if (jsonResponse['status']) {
      return jsonResponse['data'];
    } else {
      throw Exception('No se encontraron datos de niveles de acceso');
    }
  } else {
    throw Exception('Error al cargar los niveles de acceso');
  }
}
