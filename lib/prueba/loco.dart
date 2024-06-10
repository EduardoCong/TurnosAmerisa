import 'package:flutter/material.dart';
import 'package:turnos_amerisa/model/services/users_service.dart';

class UserFetch extends StatefulWidget {
  @override
  _UserFetchState createState() => _UserFetchState();
}

class _UserFetchState extends State<UserFetch> {
  List<dynamic> _usuarios = [];
  bool _cargando = true;

  @override
  void initState() {
    super.initState();
    _cargarUsuarios();
  }

  Future<void> _cargarUsuarios() async {
    try {
      final usuarios = await listarUsuarios();
      setState(() {
        _usuarios = usuarios;
        _cargando = false;
      });
    } catch (e) {
      print(e);
      setState(() {
        _cargando = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Lista de usuarios'),
        automaticallyImplyLeading: false,
      ),
      body: _cargando
          ? Padding(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
            child: Center(child: CircularProgressIndicator()),
          )
          : _usuarios.isNotEmpty
              ? ListView.builder(
                  itemCount: _usuarios.length,
                  itemBuilder: (context, index) { 
                    final usuario = _usuarios[index] ?? {};
                    return Card(
                      margin: EdgeInsets.symmetric(vertical: 10, horizontal: 15),
                      child: Padding(
                        padding: const EdgeInsets.all(10.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            ListTile(
                              leading: CircleAvatar(
                                child: Text(usuario['id_usuario'].toString()),
                              ),
                              title: Text('${usuario['nombres'] ?? ''} ${usuario['apellidos'] ?? ''}', style: TextStyle(fontWeight: FontWeight.bold)),
                              subtitle: Text(usuario['usuario'] ?? ''),
                            ),
                            Divider(),
                            Padding(
                              padding: const EdgeInsets.only(left: 16.0),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  RichText(
                                    text: TextSpan(
                                      text: 'Cedula: ',
                                      style: TextStyle(fontWeight: FontWeight.bold, color: Colors.black),
                                      children: [
                                        TextSpan(
                                          text: usuario['cedula'] ?? '',
                                          style: TextStyle(fontWeight: FontWeight.normal),
                                        ),
                                      ],
                                    ),
                                  ),
                                  SizedBox(height: 5),
                                  RichText(
                                    text: TextSpan(
                                      text: 'Contrasena: ',
                                      style: TextStyle(fontWeight: FontWeight.bold, color: Colors.black),
                                      children: [
                                        TextSpan(
                                          text: usuario['password'] ?? '',
                                          style: TextStyle(fontWeight: FontWeight.normal),
                                        ),
                                      ],
                                    ),
                                  ),
                                  SizedBox(height: 5),
                                  RichText(
                                    text: TextSpan(
                                      text: 'Servicio: ',
                                      style: TextStyle(fontWeight: FontWeight.bold, color: Colors.black),
                                      children: [
                                        TextSpan(
                                          text: usuario['servicio'] ?? '',
                                          style: TextStyle(fontWeight: FontWeight.normal),
                                        ),
                                      ],
                                    ),
                                  ),
                                  SizedBox(height: 5),
                                  RichText(
                                    text: TextSpan(
                                      text: 'Modulo: ',
                                      style: TextStyle(fontWeight: FontWeight.bold, color: Colors.black),
                                      children: [
                                        TextSpan(
                                          text: usuario['modulo'] ?? '',
                                          style: TextStyle(fontWeight: FontWeight.normal),
                                        ),
                                      ],
                                    ),
                                  ),
                                  SizedBox(height: 5),
                                  RichText(
                                    text: TextSpan(
                                      text: 'Estado: ',
                                      style: TextStyle(fontWeight: FontWeight.bold, color: Colors.black),
                                      children: [
                                        TextSpan(
                                          text: usuario['estado'] ?? '',
                                          style: TextStyle(fontWeight: FontWeight.normal),
                                        ),
                                      ],
                                    ),
                                  ),
                                  SizedBox(height: 5),
                                  RichText(
                                    text: TextSpan(
                                      text: 'Nivel: ',
                                      style: TextStyle(fontWeight: FontWeight.bold, color: Colors.black),
                                      children: [
                                        TextSpan(
                                          text: usuario['nivel'] ?? '',
                                          style: TextStyle(fontWeight: FontWeight.normal),
                                        ),
                                      ],
                                    ),
                                  ),
                                  SizedBox(height: 5),
                                  RichText(
                                    text: TextSpan(
                                      text: 'Fecha de Registro: ',
                                      style: TextStyle(fontWeight: FontWeight.bold, color: Colors.black),
                                      children: [
                                        TextSpan(
                                          text: usuario['fecha_registro'] ?? '',
                                          style: TextStyle(fontWeight: FontWeight.normal),
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                )
              : Center(child: Text('No se encontraron datos de usuarios')),
    );
  }
}
