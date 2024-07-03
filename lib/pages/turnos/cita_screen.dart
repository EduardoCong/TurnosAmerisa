import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class CitaQueueScreen extends StatefulWidget {
  CitaQueueScreen({Key? key}) : super(key: key);

  @override
  _CitaQueueScreenState createState() => _CitaQueueScreenState();
}

class _CitaQueueScreenState extends State<CitaQueueScreen> {
  
  String name = '';
  String sname = '';
  String apellido = '';
  String sapellido = '';
  String num = '';
  String turnoCita = '';
  String? nombreServicio;
  String? letraServicio;
  String month = '';
  String time = '';
  int year = 0;
  int day = 0;

  @override
  void initState() {
    super.initState();
    loadTicketData();
  }

  Future<void> loadTicketData() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      name = prefs.getString('nombre') ?? '';
      sname = prefs.getString('segundoNombre') ?? '';
      apellido = prefs.getString('apellido') ?? '';
      sapellido = prefs.getString('segundoApellido') ?? '';
      num = prefs.getString('numeroCliente') ?? '';
      turnoCita = prefs.getString('turno') ?? '';
      nombreServicio = prefs.getString('nombreServicio');
      letraServicio = prefs.getString('letraServicio');
      year = prefs.getInt('selected_year') ?? 0;
      month = prefs.getString('selected_month') ?? '';
      day = prefs.getInt('selected_day') ?? 0;
      time = prefs.getString('selected_time') ?? '';
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[200],
      body: SingleChildScrollView(
        child: Container(
          height: 700,
          margin: EdgeInsets.symmetric(horizontal: 16.0, vertical: 70),
          child: Card(
            elevation: 4.0,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12.0),
            ),
            child: Padding(
              padding: EdgeInsets.all(24.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Text(
                    'Ticket Cita',
                    style: TextStyle(
                      fontSize: 24.0,
                      fontWeight: FontWeight.bold,
                      color: Colors.blue,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  SizedBox(height: 24.0),
                  Divider(thickness: 1.0, color: Colors.grey[300]),
                  SizedBox(height: 16.0),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Cliente:',
                        style: TextStyle(
                          fontSize: 16.0,
                          fontWeight: FontWeight.bold,
                          color: Colors.grey[600],
                        ),
                      ),
                      Text(
                        '$name $sname $apellido $sapellido',
                        style: TextStyle(fontSize: 16.0),
                      ),
                      Text(
                        'N° Cliente: $num',
                        style: TextStyle(fontSize: 16.0),
                      ),
                      SizedBox(height: 8.0),
                      Text(
                        'Su Turno:',
                        style: TextStyle(
                          fontSize: 18.0,
                          fontWeight: FontWeight.bold,
                          color: Colors.blue,
                        ),
                      ),
                      Text(
                        '$turnoCita',
                        style: TextStyle(fontSize: 20.0, fontWeight: FontWeight.bold),
                      ),
                    ],
                  ),
                  SizedBox(height: 24.0),
                  Divider(thickness: 1.0, color: Colors.grey[300]),
                  SizedBox(height: 16.0),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'Servicio:',
                        style: TextStyle(
                          fontSize: 18.0,
                          fontWeight: FontWeight.bold,
                          color: Colors.grey[600],
                        ),
                      ),
                      Text(
                        '$nombreServicio',
                        style: TextStyle(fontSize: 16.0),
                      ),
                    ],
                  ),
                  SizedBox(height: 8.0),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'Letra del Servicio:',
                        style: TextStyle(
                          fontSize: 16.0,
                          color: Colors.grey[600],
                        ),
                      ),
                      Text(
                        '$letraServicio',
                        style: TextStyle(fontSize: 16.0),
                      ),
                    ],
                  ),
                  SizedBox(height: 24.0),
                  Divider(thickness: 1.0, color: Colors.grey[300]),
                  SizedBox(height: 16.0),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text('Fecha:'),
                      Text(
                        '$month $day del $year a las $time',
                        style: TextStyle(
                          fontSize: 16.0,
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 150.0),
                  ElevatedButton(
                    onPressed: () {
                      Navigator.of(context).pushReplacementNamed('/home');
                    },
                    child: Text(
                      'Regresar al inicio',
                      style: TextStyle(color: Colors.white),
                    ),
                    style: ElevatedButton.styleFrom(
                      textStyle: TextStyle(fontSize: 16.0),
                      minimumSize: Size(MediaQuery.of(context).size.width - 46, 50),
                      backgroundColor: Colors.red,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
