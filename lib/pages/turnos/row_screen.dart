import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:turnos_amerisa/pages/home/drawer_screen.dart';

class VirtualQueueScreen extends StatefulWidget {
  VirtualQueueScreen({Key? key}) : super(key: key);

  @override
  _VirtualQueueScreenState createState() => _VirtualQueueScreenState();
}

class _VirtualQueueScreenState extends State<VirtualQueueScreen> {
  String name = '';
  String sname = '';
  String apellido = '';
  String sapellido = '';
  String num = '';
  String turnos = '';
  String? nombreServicio;
  String? letraServicio;
  String currentTurn = '';

  final scaffoldKeysz = GlobalKey<ScaffoldState>();

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
      turnos = prefs.getString('turnoGenerado') ?? '';
      nombreServicio = prefs.getString('nombre_servicio');
      letraServicio = prefs.getString('letra_servicio');
      currentTurn = prefs.getString('turnoActual') ?? '';
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: scaffoldKeysz,
      appBar: AppBar(
        automaticallyImplyLeading: false,
        leading: IconButton(
          icon: Icon(Icons.menu),
          onPressed: () {
            scaffoldKeysz.currentState!.openDrawer();
          },
        ),
      ),
      drawer: CustomDrawer(),
      body: SingleChildScrollView(
        child: Container(
          margin: EdgeInsets.symmetric(horizontal: 20.0, vertical: 10),
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
                    'Ticket Virtual',
                    style: TextStyle(
                      fontSize: 28.0,
                      fontWeight: FontWeight.bold,
                      color: Colors.blue[700],
                    ),
                  ),
                  SizedBox(height: 20.0),
                  _buildTicketSectionName(
                      'Cliente:', '$name $sname $apellido $sapellido',),
                  _buildTicketSectionNumber('Número de Cliente:', num),
                  _buildTicketSectionTurno(
                      'Su Turno:', turnos),
                  _buildTicketSectionTurnoActual('Turno Actual:', currentTurn),
                  _buildTicketSectionServicio('Servicio Elegido:', nombreServicio ?? ''),
                  _buildTicketSectionAnden('Anden:', 'Por Seleccionar'),

                  SizedBox(height: 40.0),
                  ElevatedButton(
                    onPressed: () {
                      Navigator.of(context).pushReplacementNamed('/home');
                    },
                    child: Text('Volver', style: TextStyle(color: Colors.white)),
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

  Widget _buildTicketSectionName(String title, String value) {
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
                fontWeight: FontWeight.bold ,
                color: Colors.black,
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

  Widget _buildTicketSectionNumber(String title, String value) {
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
                fontWeight: FontWeight.bold,
                color: Colors.black,
              ),
            ),
            Text(
              value,
              style: TextStyle(fontSize: 16.0, fontWeight: FontWeight.bold),
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

  Widget _buildTicketSectionTurno(String title, String value) {
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
                fontWeight: FontWeight.bold,
                color: Colors.black,
              ),
            ),
            Text(
              value,
              style: TextStyle(fontSize: 16.0, fontWeight: FontWeight.bold),
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

  Widget _buildTicketSectionServicio(String title, String value) {
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
                fontWeight: FontWeight.bold,
                color: Colors.black,
              ),
            ),
            Text(
              value,
              style: TextStyle(fontSize: 16.0, fontWeight: FontWeight.bold),
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

  Widget _buildTicketSectionAnden(String title, String value) {
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
                fontWeight: FontWeight.bold,
                color: Colors.black,
              ),
            ),
            Text(
              value,
              style: TextStyle(fontSize: 16.0, fontWeight: FontWeight.bold),
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

  Widget _buildTicketSectionTurnoActual(String title, String value) {
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
                fontWeight: FontWeight.bold,
                color: Colors.black,
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

