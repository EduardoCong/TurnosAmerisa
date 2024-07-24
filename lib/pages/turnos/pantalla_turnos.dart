import 'package:flutter/material.dart';
import 'package:turnos_amerisa/services/pantalla_turnos_service.dart';
import 'package:turnos_amerisa/pages/home/drawer_screen.dart';

class TurnosVer extends StatefulWidget {
  @override
  _TurnosVerState createState() => _TurnosVerState();
}

class _TurnosVerState extends State<TurnosVer> {
  final GlobalKey<ScaffoldState> scaffoldKeyos = GlobalKey<ScaffoldState>();
  List<Turno> turnosVer = [];
  String formattedDate = '';
  String formattedTime = '';
  final TurnosService _turnosService = TurnosService();
  bool _isDisposed = false;

  @override
  void initState() {
    super.initState();
    fetchTurnos();
  }

  @override
  void dispose() {
    _isDisposed = true;
    super.dispose();
  }

  void fetchTurnos() async {
    while (!_isDisposed) {
      final fetchedTurnos = await _turnosService.fetchTurnosVer();
      if (!_isDisposed) {
        setState(() {
          turnosVer = fetchedTurnos;
        });
      }
      await Future.delayed(Duration(seconds: 9));
    }
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        return await _showCancelDialog(context);
      },
      child: Scaffold(
        key: scaffoldKeyos,
        appBar: AppBar(
          centerTitle: true,
          title: Text('Turnos'),
          leading: IconButton(
            icon: Icon(Icons.menu),
            onPressed: () {
              if (scaffoldKeyos.currentState != null) {
                scaffoldKeyos.currentState!.openDrawer();
              }
            },
          ),
        ),
        drawer: CustomDrawer(),
        body: Padding(
          padding: EdgeInsets.symmetric(horizontal: 20, vertical: 80),
          child: Column(
            children: [
              Text(
                'Comuniquese a la línea de atención al usuario',
                style: TextStyle(
                  fontSize: 16,
                  color: Colors.black,
                  fontWeight: FontWeight.bold,
                ),
                textAlign: TextAlign.center,
              ),
              SizedBox(height: 16),
              Expanded(
                child: ListView(
                  children: [
                    Card(
                      child: Padding(
                        padding: EdgeInsets.only(bottom: 15, top: 1),
                        child: Column(
                          children: [
                            SizedBox(height: 16),
                            Text(
                              'Lista de Turnos',
                              style: TextStyle(
                                fontSize: 20,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            Divider(),
                            DataTable(
                              columns: [
                                DataColumn(label: Text('TURNO')),
                                DataColumn(label: Text('ESTADO')),
                                DataColumn(label: Text('MODULO')),
                              ],
                              rows: turnosVer.isNotEmpty
                                  ? turnosVer.map<DataRow>((turno) {
                                      return DataRow(cells: [
                                        DataCell(Text(turno.turno)),
                                        DataCell(Text(turno.estado)),
                                        DataCell(Text(turno.modulo)),
                                      ]);
                                    }).toList()
                                  : [
                                      DataRow(cells: [
                                        DataCell(Text('No hay datos')),
                                        DataCell(Text('No hay datos')),
                                        DataCell(Text('No hay datos')),
                                      ])
                                    ],
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Future<bool> _showCancelDialog(BuildContext context) async {
    return await showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Center(child: Text("Salir de la pantalla turnos")),
          content:
              Text("¿Estás seguro que deseas salir de la pantalla?"),
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

class MarqueeWidget extends StatefulWidget {
  final String text;
  final TextStyle style;

  MarqueeWidget({required this.text, required this.style});

  @override
  _MarqueeWidgetState createState() => _MarqueeWidgetState();
}

class _MarqueeWidgetState extends State<MarqueeWidget> {
  @override
  Widget build(BuildContext context) {
    return Container(
      height: 50,
      child: ListView(
        scrollDirection: Axis.horizontal,
        children: [
          Center(
            child: Text(widget.text, style: widget.style),
          ),
        ],
      ),
    );
  }
}