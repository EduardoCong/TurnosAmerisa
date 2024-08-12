import 'dart:convert';
import 'package:http/http.dart' as http;

Future<bool> subirImagen(int clienteId, String imageUrl) async {
  final url = Uri.parse('http://192.168.0.17/models/model_subir_foto.php');

  final response = await http.post(
    url,
    body: {
      'accion': 'subirImagen',
      'cliente_id': clienteId.toString(),
      'imagen': imageUrl,
    },
  );

  if (response.statusCode == 200) {
    final jsonResponse = jsonDecode(response.body);

    if (jsonResponse['status']) {
      print(jsonResponse['msg']);
      return true;
    } else {
      print(jsonResponse['msg']);
      return false;
    }
  } else {
    print('Error en la solicitud: ${response.statusCode}');
    return false;
  }
}
