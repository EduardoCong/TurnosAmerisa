import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:turnos_amerisa/pages/home/drawer_screen.dart';
import 'package:turnos_amerisa/pages/home/home_screen.dart';

class CitaQueueScreen extends StatefulWidget {
  CitaQueueScreen({Key? key}) : super(key: key);

  @override
  _CitaQueueScreenState createState() => _CitaQueueScreenState();
}

class _CitaQueueScreenState extends State<CitaQueueScreen> {
  String names = '';
  String snames = '';
  String apellidos = '';
  String sapellidos = '';
  String nums = '';
  String turnoCita = '';
  String? nombreServicios;
  String? letraServicios;
  String month = '';
  String time = '';
  int year = 0;
  int day = 0;

  final scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  void initState() {
    super.initState();
    loadDataClienteCita();
  }

  Future<void> loadDataClienteCita() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      names = prefs.getString('nombre') ?? '';
      snames = prefs.getString('segundoNombre') ?? '';
      apellidos = prefs.getString('apellido') ?? '';
      sapellidos = prefs.getString('segundoApellido') ?? '';
      nums = prefs.getString('numeroCliente') ?? '';
      turnoCita = prefs.getString('turno') ?? '';
      nombreServicios = prefs.getString('nombreServicio');
      letraServicios = prefs.getString('letraServicio');
      year = prefs.getInt('selected_year') ?? 0;
      month = prefs.getString('selected_month') ?? '';
      day = prefs.getInt('selected_day') ?? 0;
      time = prefs.getString('selected_time') ?? '';
    });
  }

  Future<void> clearTurnoCitaData() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.remove('turno');
    await prefs.remove('nombreServicio');
    await prefs.remove('letraServicio');
    await prefs.remove('selected_year');
    await prefs.remove('selected_month');
    await prefs.remove('selected_day');
    await prefs.remove('selected_time');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: scaffoldKey,
      appBar: AppBar(
        automaticallyImplyLeading: false,
        backgroundColor: Color.fromARGB(255, 255, 255, 255),
        leading: IconButton(
          icon: Icon(Icons.menu),
          onPressed: () {
            scaffoldKey.currentState!.openDrawer();
          },
        ),
      ),
      drawer: CustomDrawer(),
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
                        '$names $snames $apellidos $sapellidos',
                        style: TextStyle(fontSize: 16.0),
                      ),
                      Text(
                        'N° Cliente: $nums',
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
                        style: TextStyle(
                            fontSize: 20.0, fontWeight: FontWeight.bold),
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
                        '$nombreServicios',
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
                        '$letraServicios',
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
                    onPressed: () async {
                      await clearTurnoCitaData();  // Limpiar los datos específicos antes de navegar
                      Navigator.pushAndRemoveUntil(
                        context,
                        MaterialPageRoute(builder: (context) => HomePage()),
                        (Route<dynamic> route) => false,
                      );
                    },
                    child: Text(
                      'Regresar al inicio',
                      style: TextStyle(color: Colors.white),
                    ),
                    style: ElevatedButton.styleFrom(
                      textStyle: TextStyle(fontSize: 16.0),
                      minimumSize:
                          Size(MediaQuery.of(context).size.width - 46, 50),
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
