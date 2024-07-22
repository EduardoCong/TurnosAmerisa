import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:turnos_amerisa/pages/home/drawer_screen.dart';

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
  String month = '';
  String time = '';
  int year = 0;
  int day = 0;
  String turnoCurrent = '';

  final scaffoldKeyz = GlobalKey<ScaffoldState>();

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
      turnoCita = prefs.getString('turnoCita') ?? '';
      nombreServicio = prefs.getString('nombreServicio');
      year = prefs.getInt('selected_year') ?? 0;
      month = prefs.getString('selected_month') ?? '';
      day = prefs.getInt('selected_day') ?? 0;
      time = prefs.getString('selected_time') ?? '';
      turnoCurrent = prefs.getString('turnoActualCita') ?? '';
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: scaffoldKeyz,
      appBar: AppBar(
        automaticallyImplyLeading: false,
        leading: IconButton(
          icon: Icon(Icons.menu),
          onPressed: () {
            scaffoldKeyz.currentState!.openDrawer();
          },
        ),
      ),
      drawer: CustomDrawer(),
      body: SingleChildScrollView(
        child: Container(
          margin: EdgeInsets.symmetric(horizontal: 20.0, vertical: 30),
          child: Container(
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(15.0),
              boxShadow: [
                BoxShadow(
                  color: Colors.grey.withOpacity(0.5),
                  spreadRadius: 2,
                  blurRadius: 5,
                  offset: Offset(0, 3),
                ),
              ],
            ),
            child: Padding(
              padding: EdgeInsets.all(25.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Text(
                    'Ticket Cita Virtual',
                    style: TextStyle(
                      fontSize: 24.0,
                      fontWeight: FontWeight.bold,
                      color: Colors.blue[700],
                    ),
                  ),
                  SizedBox(height: 20.0),
                  _buildTicketSectionNames('Cliente', '$name $sname $apellido $sapellido'),
                  _buildTicketSectionNumero('Número de Cliente', num),
                  _buildTicketSectionTurnoCita('Su Turno', turnoCita, isBold: true, color: Colors.red),
                  _buildTicketSectionCurrentTurno('Turno Actual \nde ${nombreServicio??''.toLowerCase()}', turnoCurrent, isBold: true, color: Colors.green),
                  _buildTicketSectionServicio('Servicio Elegido', nombreServicio ?? ''),
                  _buildTicketSectionDate('Fecha', 'Para el $day $month $year a las $time'),
                  _buildTicketSectionAnden('Anden', 'Por seleccionar'),
                  SizedBox(height: 20.0),
                  ElevatedButton(
                    onPressed: () {
                      Navigator.of(context).pushReplacementNamed('/home');
                    },
                    child: Text(
                      'Regresar al inicio',
                      style: TextStyle(color: Colors.white),
                    ),
                    style: ElevatedButton.styleFrom(
                      textStyle: TextStyle(fontSize: 18.0),
                      padding: EdgeInsets.symmetric(horizontal: 40, vertical: 15),
                      backgroundColor: Colors.red,
                      fixedSize: Size(400, 70),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10)
                      )
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

  Widget _buildTicketSectionNames(String title, String value,
      {bool isBold = false, Color color = Colors.black}) {
    return Column(
      children: [
        SizedBox(height: 10.0),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              title,
              style: TextStyle(
                fontSize: 18.0,
                fontWeight: isBold ? FontWeight.bold : FontWeight.normal,
                color: color,
              ),
            ),
            Text(
              value,
              style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold),
            ),
          ],
        ),
        SizedBox(height: 10.0),
        Divider(
          thickness: 1.0,
          color: Colors.grey[300],
        ),
      ],
    );
  }

  Widget _buildTicketSectionNumero(String title, String value,
      {bool isBold = false, Color color = Colors.grey}) {
    return Column(
      children: [
        SizedBox(height: 10.0),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              title,
              style: TextStyle(
                fontSize: 16.0,
                fontWeight: isBold ? FontWeight.bold : FontWeight.normal,
                color: color,
              ),
            ),
            Text(
              value,
              style: TextStyle(fontSize: 13.0, fontWeight: FontWeight.bold),
            ),
          ],
        ),
        SizedBox(height: 10.0),
        Divider(
          thickness: 1.0,
          color: Colors.grey[300],
        ),
      ],
    );
  }

  Widget _buildTicketSectionTurnoCita(String title, String value,
      {bool isBold = false, Color color = Colors.grey}) {
    return Column(
      children: [
        SizedBox(height: 10.0),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              title,
              style: TextStyle(
                fontSize: 16.0,
                fontWeight: isBold ? FontWeight.bold : FontWeight.normal,
                color: color,
              ),
            ),
            Text(
              value,
              style: TextStyle(fontSize: 13.0, fontWeight: FontWeight.bold),
            ),
          ],
        ),
        SizedBox(height: 10.0),
        Divider(
          thickness: 1.0,
          color: Colors.grey[300],
        ),
      ],
    );
  }

  Widget _buildTicketSectionCurrentTurno(String title, String value,
      {bool isBold = false, Color color = Colors.grey}) {
    return Column(
      children: [
        SizedBox(height: 10.0),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              title,
              style: TextStyle(
                fontSize: 16.0,
                fontWeight: isBold ? FontWeight.bold : FontWeight.normal,
                color: color,
              ),
            ),
            Text(
              value,
              style: TextStyle(fontSize: 13.0, fontWeight: FontWeight.bold),
            ),
          ],
        ),
        SizedBox(height: 10.0),
        Divider(
          thickness: 1.0,
          color: Colors.grey[300],
        ),
      ],
    );
  }

  Widget _buildTicketSectionServicio(String title, String value,
      {bool isBold = false, Color color = Colors.grey}) {
    return Column(
      children: [
        SizedBox(height: 10.0),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              title,
              style: TextStyle(
                fontSize: 16.0,
                fontWeight: isBold ? FontWeight.bold : FontWeight.normal,
                color: color,
              ),
            ),
            Text(
              value,
              style: TextStyle(fontSize: 13.0, fontWeight: FontWeight.bold),
            ),
          ],
        ),
        SizedBox(height: 10.0),
        Divider(
          thickness: 1.0,
          color: Colors.grey[300],
        ),
      ],
    );
  }

  Widget _buildTicketSectionDate(String title, String value,
      {bool isBold = false, Color color = Colors.grey}) {
    return Column(
      children: [
        SizedBox(height: 10.0),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              title,
              style: TextStyle(
                fontSize: 16.0,
                fontWeight: isBold ? FontWeight.bold : FontWeight.normal,
                color: color,
              ),
            ),
            Text(
              value,
              style: TextStyle(fontSize: 13.0, fontWeight: FontWeight.bold),
            ),
          ],
        ),
        SizedBox(height: 10.0),
        Divider(
          thickness: 1.0,
          color: Colors.grey[300],
        ),
      ],
    );
  }

  Widget _buildTicketSectionAnden(String title, String value,
      {bool isBold = false, Color color = Colors.grey}) {
    return Column(
      children: [
        SizedBox(height: 10.0),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              title,
              style: TextStyle(
                fontSize: 16.0,
                fontWeight: isBold ? FontWeight.bold : FontWeight.normal,
                color: color,
              ),
            ),
            Text(
              value,
              style: TextStyle(fontSize: 13.0, fontWeight: FontWeight.bold),
            ),
          ],
        ),
        SizedBox(height: 10.0),
        Divider(
          thickness: 1.0,
          color: Colors.grey[300],
        ),
      ],
    );
  }
}
