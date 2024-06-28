import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

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
        SharedPreferences prefs = await SharedPreferences.getInstance();
        await prefs.setBool('isLoggedIn', true);
        await prefs.setString('numero_cliente', usuario);     

        Navigator.pushNamed(context, '/home');
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

Future<void> logoutClient(BuildContext context) async {
  try {
    SharedPreferences prefs = await SharedPreferences.getInstance();

    String? usuario = prefs.getString('numero_cliente');

    await prefs.remove('isLoggedIn');
    await prefs.remove('numero_cliente');
    print('Sesión cerrada exitosamente para: $usuario');

    Navigator.pushNamedAndRemoveUntil(context, '/', (route) => false);
    
  } catch (e) {
    print('Error al cerrar sesión: $e');
  }
}