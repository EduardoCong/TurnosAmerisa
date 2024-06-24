import 'package:flutter/material.dart';
import 'package:turnos_amerisa/model/api.dart';
import 'package:turnos_amerisa/model/services/generar_turno_service.dart';
import 'package:turnos_amerisa/pages/turnos/servicios_select.dart';

class ActualizarTurnosScreen extends StatefulWidget {
  const ActualizarTurnosScreen({super.key});

  @override
  State<ActualizarTurnosScreen> createState() => _ActualizarTurnosScreenState();
}

class _ActualizarTurnosScreenState extends State<ActualizarTurnosScreen> {

  TextEditingController dateController = TextEditingController();
  TextEditingController turnoController = TextEditingController();

  Servicio? servicioSeleccionado;
  Turno? turnos;

  @override
  Widget build(BuildContext context) {
    return Material(
      child: Padding(
        padding: EdgeInsets.all(8.0),
        child: Container(
          decoration: BoxDecoration(
            color: Colors.white
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              TextField(
                controller: turnoController,
                decoration: InputDecoration(
                  hintText: 'Turno id'
                ),
              ),
              SizedBox(height: 20),
              TextField(
                controller: dateController ,
                decoration: InputDecoration(
                  labelText: 'Fecha',
                  filled: true,
                  prefixIcon: Icon(Icons.calendar_today),
                  enabledBorder: OutlineInputBorder(
                    borderSide: BorderSide.none
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: Colors.blue)
                  )
                ),
                onTap: (){
                  selectDay();
                },
              ),
              SizedBox(height: 20),
              ServiciosSelect(
                onServicioSelected: (servicio) {
                  setState(() {
                    servicioSeleccionado = servicio;
                  });
                },
              ),
              SizedBox(height: 20),
              ElevatedButton(
                onPressed: (){
                  updateTurno();
                },
                child: Text('Actualiza')
              )
            ],
          ),
        ),
      ),
    );
  }

  Future <void> selectDay() async {
    DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime(2100)
    );
    if (picked != null) {
      setState(() {
        dateController.text = picked.toString().split(" ")[0];
      });
    }
  }

  Future<void> updateTurno() async {
    if (servicioSeleccionado == null) {
      Text('Selecciona un servicio');
    }
     Map<String, dynamic> datos = {
      'id_turno': turnos!.id,
      'id_servicio': servicioSeleccionado!.id,
      'fechaInicio': null
     };
    await ApiService.actualizarTurno(datos, context);
  }
}