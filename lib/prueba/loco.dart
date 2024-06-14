import 'package:flutter/material.dart';
import 'package:turnos_amerisa/model/services/generar_turno_service.dart';

class DropdownFromAPI extends StatefulWidget {
  @override
  _DropdownFromAPIState createState() => _DropdownFromAPIState();
}

class _DropdownFromAPIState extends State<DropdownFromAPI> {
  String? _selectedItem;
  List<Map<String, dynamic>> _servicios = [];
  bool _isLoading = true;

  @override
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _isLoading
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
    );
  }
}
