import 'package:http/http.dart' as http;
import 'dart:convert';

Future<void> registrarDispositivo(int clienteId, String tokenDispositivo,
    String plataforma) async {
  String url = 'http://192.168.0.17/models/model_registrar_dispositivo.php';

  Map<String, String> body = {
    'accion': 'RegistrarDispositivo',
    'cliente_id': clienteId.toString(),
    'token_dispositivo': tokenDispositivo,
    'plataforma': plataforma,
  };

  try {
    var response = await http.post(
      Uri.parse(url),
      body: body,
      headers: {
        'Content-Type': 'application/x-www-form-urlencoded',
      },
    );
    try {
      if (response.statusCode == 200) {
        var jsonResponse = jsonDecode(response.body);
        int codigo = jsonResponse['codigo'];
        String mensaje = jsonResponse['mensaje'];

        switch (codigo) {
          case 0:
            print(mensaje);
            break;
          case 1:
            print("Error: $mensaje");
            break;
          case 3:
            print("Error: $mensaje");
            break;
          default:
            print("Error desconocido");
            break;
        }
      } else {
        print("Error - Código de estado: ${response.statusCode}");
        print("Error - Respuesta del servidor: ${response.body}");
      }
    }catch (e) {
      print("Excepción: $e");
    }
  } catch (e) {
    print("Excepción: $e");
  }
}
