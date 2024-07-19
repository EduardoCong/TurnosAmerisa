import 'package:http/http.dart' as http;

class TurnoScreen {
  final String apiUrl =
      'http://192.168.1.83/models/registrar_dispositivo.php';

  Future<String> obtenerTurnoCarga() async {
    try {
      var response = await http.post(
        Uri.parse(apiUrl),
        body: {
          'accion': 'TurnoActualCarga',
        },
      );

      if (response.statusCode == 200) {
        return response.body;
      } else {
        return 'Error al obtener turno de Carga. Código de estado: ${response.statusCode}';
      }
    } catch (e) {
      return 'Error en la solicitud: $e';
    }
  }

  Future<String> obtenerTurnoServicio() async {
    try {
      var response = await http.post(
        Uri.parse(apiUrl),
        body: {
          'accion': 'TurnoActualServicio',
        },
      );

      if (response.statusCode == 200) {
        return response.body;
      } else {
        return 'Error al obtener turno de Servicio. Código de estado: ${response.statusCode}';
      }
    } catch (e) {
      return 'Error en la solicitud: $e';
    }
  }

  Future<String> obtenerTurnoCita() async {
    try {
      var response = await http.post(
        Uri.parse(apiUrl),
        body: {
          'accion': 'TurnoActualCita',
        },
      );

      if (response.statusCode == 200) {
        return response.body;
      } else {
        return 'Error al obtener turno de Cita. Código de estado: ${response.statusCode}';
      }
    } catch (e) {
      return 'Error en la solicitud: $e';
    }
  }

  Future<String> obtenerTurnoVisita() async {
    try {
      var response = await http.post(
        Uri.parse(apiUrl),
        body: {
          'accion': 'TurnoActualVisita',
        },
      );

      if (response.statusCode == 200) {
        return response.body;
      } else {
        return 'Error al obtener turno de Visita. Código de estado: ${response.statusCode}';
      }
    } catch (e) {
      return 'Error en la solicitud: $e';
    }
  }

  Future<String> obtenerTurnoDescarga() async {
    try {
      var response = await http.post(
        Uri.parse(apiUrl),
        body: {
          'accion': 'TurnoActualDescarga',
        },
      );

      if (response.statusCode == 200) {
        return response.body;
      } else {
        return 'Error al obtener turno de Descarga. Código de estado: ${response.statusCode}';
      }
    } catch (e) {
      return 'Error en la solicitud: $e';
    }
  }

  Future<String> obtenerTurnoRevision() async {
    try {
      var response = await http.post(
        Uri.parse(apiUrl),
        body: {
          'accion': 'TurnoActualRevision',
        },
      );

      if (response.statusCode == 200) {
        return response.body;
      } else {
        return 'Error al obtener turno de Revisión. Código de estado: ${response.statusCode}';
      }
    } catch (e) {
      return 'Error en la solicitud: $e';
    }
  }
}
