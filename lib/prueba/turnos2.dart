import 'package:flutter/material.dart';
import 'package:turnos_amerisa/model/services/generar_turno_service.dart';

class GenerarTurnoScreen extends StatefulWidget {
  @override
  _GenerarTurnoScreenState createState() => _GenerarTurnoScreenState();
}

class _GenerarTurnoScreenState extends State<GenerarTurnoScreen> {
  final _formKey = GlobalKey<FormState>();
  final Map<String, dynamic> _datosCliente = {};
  bool _cargando = false;
  String? _mensaje;
  List<dynamic> _servicios = [];
  String? _servicioSeleccionado;

  @override
  void initState() {
    super.initState();
    _cargarServicios();
  }

  Future<void> _cargarServicios() async {
    setState(() {
      _cargando = true;
    });

    try {
      final servicios = await verServicios();
      setState(() {
        _servicios = servicios;
        _cargando = false;
      });
    } catch (e) {
      setState(() {
        _mensaje = 'Error al cargar servicios: ${e.toString()}';
        _cargando = false;
      });
    }
  }

  Future<void> _obtenerCliente() async {
    if (_datosCliente['numero'] == null || _datosCliente['numero'].isEmpty) {
      setState(() {
        _mensaje = 'Por favor, ingrese el número de documento';
      });
      return;
    }

    setState(() {
      _cargando = true;
      _mensaje = null;
    });

    try {
      final cliente = await obtenerCliente(_datosCliente['numero']);
      setState(() {
        _datosCliente.addAll(cliente);
        _cargando = false;
      });
    } catch (e) {
      setState(() {
        _mensaje = 'Error al obtener cliente: ${e.toString()}';
        _cargando = false;
      });
    }
  }

  Future<void> _generarTurno() async {
    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();

      if (_servicioSeleccionado == null) {
        setState(() {
          _mensaje = 'Por favor, seleccione un servicio';
        });
        return;
      }

      _datosCliente['servicio'] = _servicioSeleccionado;

      setState(() {
        _cargando = true;
        _mensaje = null;
      });

      try {
        final response = await generarTurno(_datosCliente);
        setState(() {
          _mensaje = 'Turno generado con éxito: ${response['turno']}';
          _cargando = false;
        });
      } catch (e) {
        setState(() {
          _mensaje = 'Error al generar turno: ${e.toString()}';
          _cargando = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Generar Turno'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: _cargando
            ? Center(child: CircularProgressIndicator())
            : Form(
                key: _formKey,
                child: ListView(
                  children: [
                    TextFormField(
                      decoration: InputDecoration(labelText: 'Número de Documento'),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Por favor, ingrese el número de documento';
                        }
                        return null;
                      },
                      onSaved: (value) {
                        _datosCliente['numero'] = value ?? '';
                      },
                    ),
                    ElevatedButton(
                      onPressed: _obtenerCliente,
                      child: Text('Obtener Cliente'),
                    ),
                    if (_datosCliente.isNotEmpty)
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text('Nombre: ${_datosCliente['pnombre'] ?? ''}'),
                          Text('Apellido: ${_datosCliente['sapellido'] ?? ''}'),
                          Text('Email: ${_datosCliente['papellido'] ?? ''}'),
                          Text('Teléfono: ${_datosCliente['sapellido'] ?? ''}'),
                          Text('Teléfono: ${_datosCliente['fecha_nacimiento'] ?? ''}'),
                          Text('Teléfono: ${_datosCliente['sexo'] ?? ''}'),
                        ],
                      ),
                    DropdownButtonFormField<String>(
                      decoration: InputDecoration(labelText: 'Seleccione un Servicio'),
                      value: _servicioSeleccionado,
                      items: _servicios.map<DropdownMenuItem<String>>((dynamic servicio) {
                        return DropdownMenuItem<String>(
                          value: servicio['id_servicio'].toString(),
                          child: Text(servicio['nombre_servicio'] ?? ''),
                        );
                      }).toList(),
                      onChanged: (String? newValue) {
                        setState(() {
                          _servicioSeleccionado = newValue;
                        });
                      },
                      validator: (value) {
                        if (value == null) {
                          return 'Por favor, seleccione un servicio';
                        }
                        return null;
                      },
                    ),
                    SizedBox(height: 20),
                    ElevatedButton(
                      onPressed: _generarTurno,
                      child: Text('Generar Turno'),
                    ),
                    if (_mensaje != null)
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Text(
                          _mensaje!,
                          style: TextStyle(
                            color: _mensaje!.contains('Error') ? Colors.red : Colors.green,
                          ),
                        ),
                      ),
                  ],
                ),
              ),
      ),
    );
  }
}
