import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:turnos_amerisa/pages/home/drawer_screen.dart';

class LlamadoTurnoScreen extends StatefulWidget {
  LlamadoTurnoScreen({Key? key}) : super(key: key);

  @override
  _LlamadoTurnoScreenState createState() => _LlamadoTurnoScreenState();
}

class _LlamadoTurnoScreenState extends State<LlamadoTurnoScreen> {
  String name = '';
  String sname = '';
  String apellido = '';
  String sapellido = '';
  String num = '';

  final scaffoldKeyszs = GlobalKey<ScaffoldState>();

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
    });
  }

  @override
  Widget build(BuildContext context) {
    final args = ModalRoute.of(context)?.settings.arguments as Map<String, dynamic>?;
    final modulo = args?['modulos'];
    final turno = args?['turnos'];
    final usuario = args?['user'];
    final servicio = args?['service'];
    return WillPopScope(
      onWillPop: () async {
        return await _showCancelDialog(context);
      },
      child: Scaffold(
        key: scaffoldKeyszs,
        appBar: AppBar(
          automaticallyImplyLeading: false,
          leading: IconButton(
            icon: Icon(Icons.menu),
            onPressed: () {
              scaffoldKeyszs.currentState!.openDrawer();
            },
          ),
        ),
        drawer: CustomDrawer(),
        body: SingleChildScrollView(
          child: Container(
            margin: EdgeInsets.symmetric(horizontal: 20.0, vertical: 80),
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
                    _buildTicketSectionUsuario(
                        'Usuario que atiende:', usuario ?? 'No existe turno'),
                    _buildTicketSectionTurno('Su turno:', turno ?? ''),
                    _buildTicketSectionModulo('Anden:', modulo ?? ''),
                    _buildTicketSectionServicio('Servicio Elegido:', servicio ?? 'No existe anden'),
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
      ),
    );
  }

  Widget _buildTicketSectionName(String title, String value,
      {Color color = Colors.black}) {
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
                color: color,
              ),
            ),
            Text(
              value,
              style: TextStyle(fontSize: 15.0, fontWeight: FontWeight.bold),
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

  Widget _buildTicketSectionNumber(String title, String value,
      {Color color = Colors.black}) {
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
                color: color,
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

  Widget _buildTicketSectionUsuario(String title, String value,
      {Color color = Colors.black}) {
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
                color: color,
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

  Widget _buildTicketSectionModulo(String title, String value,
      {Color color = Colors.black}) {
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
                color: color,
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

  Widget _buildTicketSectionServicio(String title, String value,
      {Color color = Colors.black}) {
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
                color: color,
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

  Widget _buildTicketSectionTurno(String title, String value,
      {Color color = Colors.black}) {
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
                color: color,
              ),
            ),
            Text(
              value,
              style: TextStyle(fontSize: 15.0, fontWeight: FontWeight.bold),
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

  Future<bool> _showCancelDialog(BuildContext context) async {
    return await showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Center(child: Text("Cancela Turno")),
          content:
              Text("¿Estás seguro que deseas cancelar el agendado de citas?"),
          contentTextStyle: TextStyle(fontSize: 16, color: Colors.black),
          actions: <Widget>[
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                ElevatedButton(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  child: Text(
                    'No',
                    style: TextStyle(color: Colors.white),
                  ),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.red,
                    elevation: 0,
                    fixedSize: Size(120, 50),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                ),
                ElevatedButton(
                  onPressed: () {
                    Navigator.of(context).pushReplacementNamed('/home');
                  },
                  child: Text(
                    'Ir al inicio',
                    style: TextStyle(color: Colors.white),
                  ),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.green,
                    elevation: 0,
                    fixedSize: Size(120, 50),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                ),
              ],
            ),
          ],
        );
      },
    );
  }
}

