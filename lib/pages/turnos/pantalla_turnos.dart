import 'dart:async';
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
  final TurnosService _turnosService = TurnosService();
  bool _isDisposed = false;
  Timer? _updateTimer;

  @override
  void initState() {
    super.initState();
    fetchTurnos(initialLoad: true);
    _startPeriodicUpdate();
  }

  @override
  void dispose() {
    _isDisposed = true;
    _updateTimer?.cancel();
    super.dispose();
  }

  Future<void> fetchTurnos({bool initialLoad = false}) async {
    if (!_isDisposed) {
      final fetchedTurnos = await _turnosService.fetchTurnosVer();
      if (!_isDisposed && mounted) {
        setState(() {
          turnosVer = fetchedTurnos;
        });
      }
    }
  }

  void _startPeriodicUpdate() {
    _updateTimer = Timer.periodic(Duration(seconds: 5), (timer) async {
      if (!_isDisposed) {
        await fetchTurnos();
      }
    });
  }

  Future<void> _refreshTurnos() async {
    await fetchTurnos();
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
        body: RefreshIndicator(
          onRefresh: _refreshTurnos,
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: 20),
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
                        AnimatedSwitcher(
                          duration: Duration(milliseconds: 300),
                          transitionBuilder: (Widget child, Animation<double> animation) {
                            return FadeTransition(opacity: animation, child: child);
                          },
                          child: turnosVer.isNotEmpty
                              ? DataTable(
                                  key: ValueKey<List<Turno>>(turnosVer),
                                  columns: [
                                    DataColumn(label: Text('TURNO')),
                                    DataColumn(label: Text('ESTADO')),
                                    DataColumn(label: Text('MODULO')),
                                  ],
                                  rows: turnosVer.map<DataRow>((turno) {
                                    return DataRow(cells: [
                                      DataCell(Text(turno.turno)),
                                      DataCell(Text(turno.estado)),
                                      DataCell(Text(turno.modulo)),
                                    ]);
                                  }).toList(),
                                )
                              : DataTable(
                                  key: ValueKey('NoTurnos'),
                                  columns: [
                                    DataColumn(label: Text('SIN TURNOS DEL DÍA')),
                                  ], rows: [],
                                ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
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
          content: Text("¿Estás seguro que deseas salir de la pantalla?"),
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
