import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:turnos_amerisa/model/api.dart';

class ApiService {
  static const String baseUrl = 'http://amigos.local/models/model_generar_turno.php';

  static Future<Cliente?> obtenerCliente(int numeroDocumento) async {
    try {
      var response = await http.post(
        Uri.parse('$baseUrl/model_generar_turno.php'),
        body: {
          'accion': 'ObtenerCliente',
          'datos': numeroDocumento.toString(),
        },
      );
      
      if (response.statusCode == 200) {
        var jsonData = json.decode(response.body);
        if (jsonData['codigo'] == 0) {
          return Cliente.fromJson(jsonData);
        } else {
          return null;
        }
      } else {
        throw Exception('Error al obtener cliente');
      }
    } catch (e) {
      throw Exception('Error de red: $e');
    }
  }

  static Future<Modulo?> obtenerModulo(int idModulo) async {
    try {
      var response = await http.post(
        Uri.parse('http://amigos.local/models/model_modulos.php'),
        body: {
          'accion': 'ObtenerModulo',
          'datos': idModulo.toString(),
        },
      );
      
      if (response.statusCode == 200) {
        var jsonData = json.decode(response.body);
        if (jsonData['codigo'] == 0) {
          return Modulo.fromJson(jsonData);
        } else {
          return null;
        }
      } else {
        throw Exception('Error al obtener cliente');
      }
    } catch (e) {
      throw Exception('Error de red: $e');
    }
  }

  // static Future<Servicio> seleccionarServicio(int idServicio) async {
  //   try {
  //     var url = Uri.parse('$baseUrl/selectServicio.php');
  //     var response = await http.post(
  //       url,
  //       body: {'accion': 'selectServicio', 'id': idServicio.toString()},
  //     );

  //     if (response.statusCode == 200) {
  //       var jsonData = json.decode(response.body);
  //       if (jsonData['status']) {
  //         var servicioData = jsonData['data'][0];
  //         return Servicio.fromJson(servicioData);
  //       } else {
  //         throw Exception(jsonData['msg']);
  //       }
  //     } else {
  //       throw Exception('Error en la solicitud: ${response.statusCode}');
  //     }
  //   } catch (e) {
  //     throw Exception('Error de red: $e');
  //   }
  // }

  static Future<Turno> generarTurno(Map<String, dynamic> datos) async {
    try {
      var response = await http.post(
        Uri.parse('$baseUrl/model_generar_turno.php'),
        body: {
          'accion': 'GenerarTurno',
          'datos': json.encode(datos),
        },
      );
      
      if (response.statusCode == 200) {
        var jsonData = json.decode(response.body);
        if (jsonData['codigo'] == 0) {
          return Turno.fromJson(jsonData);
        } else {
          throw Exception('Error al generar turno: ${jsonData['respuesta']}');
        }
      } else {
        throw Exception('Error al generar turno: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Error de red: $e');
    }
  }

  static Future<Turno> actualizarTurno(Map<String, dynamic> datos) async {
    try {
      var response = await http.post(
        Uri.parse('$baseUrl/model_generar_turno.php'),
        body: {
          'accion': 'ActualizarTurno',
          'datos': json.encode(datos),
        },
      );
      
      if (response.statusCode == 200) {
        var jsonData = json.decode(response.body);
        if (jsonData['codigo'] == 0) {
          return Turno.fromJson(jsonData);
        } else {
          throw Exception('Error al actualizar turno: ${jsonData['respuesta']}');
        }
      } else {
        throw Exception('Error al actualizar turno: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Error de red: $e');
    }
  }
}
