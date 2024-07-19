  import 'dart:convert';
  import 'package:flutter/material.dart';
  import 'package:http/http.dart' as http;
  import 'package:shared_preferences/shared_preferences.dart';

  const String url = 'http://192.168.1.83:80/models/login.php';


  Future<bool> loginClients(BuildContext context, String usuario, String password) async {
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
        final String nombre = responseData['nombre'];
        final String segundoNombre = responseData['segundo nombre'];
        final String apellido = responseData['apellido'];
        final String segundoApellido = responseData['segundo apellido'];
        print(responseData);
        // final String idCliente = responseData['id'];
        if (codigo == 0) {
          print('Inicio de sesión exitoso: $mensaje');

          SharedPreferences prefs = await SharedPreferences.getInstance();
          await prefs.setString('nombre', nombre);
          await prefs.setString('segundoNombre', segundoNombre);
          await prefs.setString('apellido', apellido);
          await prefs.setString('segundoApellido', segundoApellido);
          await prefs.setString('numeroCliente', usuario);
          await prefs.setString('password', password);
          // await prefs.setString('idCliente', idCliente);

          return true;

        } else {
          print('Error en el inicio de sesión: $mensaje');
          return false;
          
        }
      } else {
        print('Error en la solicitud HTTP: ${response.reasonPhrase}');
        return false;
      }
    } catch (e) {
      print('Error: $e');
      return false;
    }
  }