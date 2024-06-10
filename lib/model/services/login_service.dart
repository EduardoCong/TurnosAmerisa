import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

Future<void> loginUsers(BuildContext context, String usuario, String password) async {
  const String url = 'http://localhost:3000/models/login.php';

  final Map<String, String> queryParams = {
    'accion': 'LoginUsuario',
    'usuario': usuario,
    'password': password,
  };

  try {
    final response = await http.post(Uri.parse(url), body: queryParams);
    
    if (response.statusCode == 200) {
      final responseData = jsonDecode(response.body);
      final int codigo = responseData['codigo'];
      final String mensaje = responseData['usuario'];

      if (codigo == 0) {
        print('Inicio de sesión exitoso: $mensaje');

        SharedPreferences prefs = await SharedPreferences.getInstance();
        await prefs.setBool('isLoggedIn', true);
        await prefs.setString('usuario', usuario);

        Navigator.pushNamed(context, '/turnos');
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

Future<void> logout(BuildContext context) async {
  try {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? usuario = prefs.getString('usuario');
    await prefs.remove('isLoggedIn');
    await prefs.remove('usuario');
    print('Sesión cerrada exitosamente para: $usuario');
    Navigator.pushNamedAndRemoveUntil(context, '/', (route) => false);
  } catch (e) {
    print('Error al cerrar sesión: $e');
  }
}
