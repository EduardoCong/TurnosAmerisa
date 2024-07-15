import 'package:http/http.dart' as http;

class ApiTurnos {
  String url = 'http://localhost:3000/models/model_gestionar_turno.php';

  Future<String> obtenerTurnoActualCarga() async {
    try {
      final response =
          await http.post(Uri.parse(url), body: {'accion': 'TurnoActualCarga'});
      if (response.statusCode == 200) {
        print(response.body);
        return response.body;
      } else {
        throw Exception('Error en la solicitud: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Error en la solicitud: $e');
    }
  }

  Future<String> obtenerTurnoActualServicio() async {
    try {
      final response =
          await http.post(Uri.parse(url), body: {'accion': 'TurnoActualServicio'});
      if (response.statusCode == 200) {
        print(response.body);
        return response.body;
      } else {
        throw Exception('Error en la solicitud: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Error en la solicitud: $e');
    }
  }

  Future<String> obtenerTurnoActualCita() async {
    try {
      final response =
          await http.post(Uri.parse(url), body: {'accion': 'TurnoActualCita'});
      if (response.statusCode == 200) {
        print(response.body);
        return response.body;
      } else {
        throw Exception('Error en la solicitud: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Error en la solicitud: $e');
    }
  }
  Future<String> obtenerTurnoActualVisita() async {
    try {
      final response =
          await http.post(Uri.parse(url), body: {'accion': 'TurnoActualVisita'});
      if (response.statusCode == 200) {
        print(response.body);
        return response.body;
      } else {
        throw Exception('Error en la solicitud: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Error en la solicitud: $e');
    }
  }
  Future<String> obtenerTurnoActualDescarga() async {
    try {
      final response =
          await http.post(Uri.parse(url), body: {'accion': 'TurnoActualDescarga'});
      if (response.statusCode == 200) {
        print(response.body);
        return response.body;
      } else {
        throw Exception('Error en la solicitud: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Error en la solicitud: $e');
    }
  }
  Future<String> obtenerTurnoActualRevision() async {
    try {
      final response =
          await http.post(Uri.parse(url), body: {'accion': 'TurnoActualRevision'});
      if (response.statusCode == 200) {
        print(response.body);
        return response.body;
      } else {
        throw Exception('Error en la solicitud: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Error en la solicitud: $e');
    }
  }
}
