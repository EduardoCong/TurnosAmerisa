import 'package:flutter/material.dart';
import 'package:turnos_amerisa/model/services/generar_turno_service.dart';

class GenerarTurno extends StatefulWidget {
  @override
  _GenerarTurnoState createState() => _GenerarTurnoState();
}

class _GenerarTurnoState extends State<GenerarTurno> {
  final TextEditingController _datosController = TextEditingController();
  Map<String, dynamic>? _respuesta;
  String? _selectedItem;
  List<Map<String, dynamic>> _servicios = [];
  bool _isLoading = true;

  void initState() {
    super.initState();
    _fetchData();
  }

  Future<void> _fetchData() async {
    try {
      final servicios = await verServicios();
      setState(() {
        _servicios = servicios;
        _isLoading = false;
      });
    } catch (error) {
      print('Error: $error');
      setState(() {
        _isLoading = false;
      });
    }
  }

  void _consultarCliente() async {
    int? datos = int.tryParse(_datosController.text);
    if (datos != null) {
      var respuesta = await obtenerCliente(datos);
      setState(() {
        _respuesta = respuesta;
      });
    } else {
      setState(() {
        _respuesta = null;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Generar Turno'),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              TextFormField(
                controller: _datosController,
                decoration: InputDecoration(labelText: 'Número de Datos'),
                keyboardType: TextInputType.number,
              ),
              SizedBox(height: 20),
              ElevatedButton(
                onPressed: _consultarCliente,
                child: Text('Consultar Cliente'),
              ),
              SizedBox(height: 20),
              _respuesta != null
                  ? Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('Documento: ${_respuesta!['documento']}'),
                        Text('Número: ${_respuesta!['numero']}'),
                        Text('Primer Nombre: ${_respuesta!['pnombre']}'),
                        Text('Segundo Nombre: ${_respuesta!['snombre']}'),
                        Text('Primer Apellido: ${_respuesta!['papellido']}'),
                        Text('Segundo Apellido: ${_respuesta!['sapellido']}'),
                      ],
                    )
                  : Container(),
              SizedBox(height: 20),
              _isLoading
                ? CircularProgressIndicator()
                : DropdownButton<String>(
                    value: _selectedItem,
                    onChanged: (String? newValue) {
                      setState(() {
                        _selectedItem = newValue;
                      });
                    },
                    items: _servicios.map<DropdownMenuItem<String>>((servicio) {
                      return DropdownMenuItem<String>(
                        value: servicio['id'].toString(),
                        child: Text(servicio['nombre_servicio']),
                      );
                    }).toList(),
                  ),
              SizedBox(height: 20),
              ElevatedButton(
                onPressed: () async {
                  if (_selectedItem == null) {
                    showDialog(
                      context: context,
                      builder: (context) {
                        return AlertDialog(
                          title: Text('Error'),
                          content: Text('Por favor, seleccione un servicio.'),
                          actions: [
                            TextButton(
                              onPressed: () {
                                Navigator.of(context).pop();
                              },
                              child: Text('OK'),
                            ),
                          ],
                        );
                      },
                    );
                    return;
                  }
                  if (_respuesta == null) {
                    showDialog(
                      context: context,
                      builder: (context) {
                        return AlertDialog(
                          title: Text('Error'),
                          content: Text('Por favor, consulte un cliente primero.'),
                          actions: [
                            TextButton(
                              onPressed: () {
                                Navigator.of(context).pop();
                              },
                              child: Text('OK'),
                            ),
                          ],
                        );
                      },
                    );
                    return;
                  }
        
                  String idServicio = _selectedItem!;
        
                  Map<String, dynamic> datosClientes = {
                    'numero': _respuesta!['numero'],
                    'pnombre': _respuesta!['pnombre'],
                    'snombre': _respuesta!['snombre'],
                    'papellido': _respuesta!['papellido'],
                    'sapellido': _respuesta!['sapellido'],
                    'nombre_servicio': idServicio
                  };
        
        
                  try {
                    Map<String, dynamic> respuesta = await generarTurno(datosClientes);
                    showDialog(
                      context: context,
                      builder: (context) {
                        return SingleChildScrollView(
                          child: AlertDialog(
                            title: Text('Éxito'),
                            content: Text(respuesta['respuesta']),
                            actions: [
                              TextButton(
                                onPressed: () {
                                  Navigator.of(context).pop();
                                },
                                child: Text('OK'),
                              ),
                            ],
                          ),
                        );
                      },
                    );
                  } catch (error) {
                    showDialog(
                      context: context,
                      builder: (context) {
                        return AlertDialog(
                          title: Text('Error'),
                          content: Text('Ha ocurrido un error al generar el turno: $error'),
                          actions: [
                            TextButton(
                              onPressed: () {
                                Navigator.of(context).pop();
                              },
                              child: Text('OK'),
                            ),
                          ],
                        );
                      },
                    );
                  }
                },
                child: Text('Generar turno'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
