import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

const String url = 'http://turnos.soft-box.com.mx/models/login.php';


Future<void> loginClients(BuildContext context, String usuario, String password) async {
  final Map<String, String> queryParams = {
    'accion': 'LoginCliente',
    'numero_cliente': usuario,
    'password_cliente': password,
  };

  try {
    final response = await http.post(Uri.parse(url), body: queryParams);
    
    if (response.statusCode == 200) {
      final responseData = jsonDecode(response.body);
      final int codigo = responseData['codigo'];
      final String mensaje = responseData['mensaje'];
      if (codigo == 0) {
        print('Inicio de sesión exitoso: $mensaje');    

      } else {
        print('Error en el inicio de sesión: $mensaje');
        
      }
    } else {
      print('Error en la solicitud HTTP: ${response.reasonPhrase}');
    }
  } catch (e) {
    print('Error: $e');
  }
}