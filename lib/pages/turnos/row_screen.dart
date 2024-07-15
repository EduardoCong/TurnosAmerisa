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

  final scaffoldKey = GlobalKey<ScaffoldState>();

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
      turnos = prefs.getString('ultimoTurno') ?? '';
      nombreServicio = prefs.getString('nombre_servicio');
      letraServicio = prefs.getString('letra_servicio');
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: scaffoldKey,
      appBar: AppBar(
        automaticallyImplyLeading: false,
        // backgroundColor: Color.fromARGB(255, 255, 255, 255),
        leading: IconButton(
          icon: Icon(Icons.menu),
          onPressed: () {
            scaffoldKey.currentState!.openDrawer();
          },
        ),
      ),
      drawer: CustomDrawer(),
      // backgroundColor: Colors.grey[200],
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
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Text(
                    'Ticket Virtual',
                    style: TextStyle(
                      fontSize: 24.0,
                      fontWeight: FontWeight.bold,
                      color: Colors.blue,
                    ),
                  ),
                  SizedBox(height: 16.0),
                  Divider(thickness: 1.0, color: Colors.grey[300]),
                  SizedBox(height: 8.0),
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
                        'Numero del Cliente: $num',
                        style: TextStyle(fontSize: 16.0),
                      ),
                      SizedBox(height: 8.0),
                      Divider(thickness: 1.0, color: Colors.grey[300]),
                      SizedBox(height: 8.0),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            'Su Turno:',
                            style: TextStyle(
                              fontSize: 18.0,
                              fontWeight: FontWeight.bold,
                              color: Colors.blue,
                            ),
                          ),
                          Text(
                            '$turnos',
                            style: TextStyle(fontSize: 20.0, fontWeight: FontWeight.bold),
                          ),
                        ],
                      ),
                      SizedBox(height: 16.0),
                      Divider(thickness: 1.0, color: Colors.grey[300]),
                      SizedBox(height: 8.0),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            'Servicio Elegido:',
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
                      Text(
                        'Letra: $letraServicio',
                        style: TextStyle(fontSize: 16.0),
                      ),
                      SizedBox(height: 200.0),
                      ElevatedButton(
                        onPressed: () {
                          Navigator.of(context).pushReplacementNamed('/home');
                        },
                        child: Text('Volver', style: TextStyle(color: Colors.white)),
                        style: ElevatedButton.styleFrom(
                          textStyle: TextStyle(fontSize: 16.0),
                          minimumSize: Size(MediaQuery.of(context).size.width - 46, 50),
                          backgroundColor: Colors.red,
                        ),
                      ),
                    ],
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
