// ignore_for_file: deprecated_member_use

import 'dart:async';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:turnos_amerisa/pages/home/drawer_screen.dart';
import 'package:turnos_amerisa/services/ver_turnobycliente_service.dart';

class VerMisTurnos extends StatefulWidget {
  @override
  _VerMisTurnosState createState() => _VerMisTurnosState();
}

class _VerMisTurnosState extends State<VerMisTurnos> {
  final GlobalKey<ScaffoldState> scaffoldKeyos = GlobalKey<ScaffoldState>();
  List<Map<String, dynamic>> turnos = [];
  final MyTurnosService _turnosService = MyTurnosService();
  int? idCliente;
  late PageController _pageController;
  Timer? _updateTimer;
  bool _isDisposed = false;

  Future<void> getDataClienteId() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      idCliente = prefs.getInt('ClienteId');
    });
  }

  @override
  void initState() {
    super.initState();
    _pageController = PageController();
    getDataClienteId().then((_) {
      if (idCliente != null) {
        fetchTurnos();
        _startPeriodicUpdate();
      }
    });
  }

  @override
  void dispose() {
    _isDisposed = true;
    _pageController.dispose();
    _updateTimer?.cancel();
    super.dispose();
  }

  void _startPeriodicUpdate() {
    _updateTimer = Timer.periodic(Duration(seconds: 5), (timer) async {
      if (!_isDisposed) {
        await fetchTurnos();
      }
    });
  }

  Future<void> fetchTurnos() async {
    if (!mounted) return;

    if (idCliente != null) {
      try {
        final fetchedTurnos = await _turnosService.fetchMyTurnosVerMisMyTurnos(idCliente!.toInt());
        if (mounted) {
          setState(() {
            turnos = fetchedTurnos;
          });
        }
      } catch (e) {
        print('Error en fetchTurnos: $e');
      }
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
          title: Text('Mis turnos'),
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
        body: PageView.builder(
          controller: _pageController,
          itemCount: (turnos.length / 10).ceil(),
          itemBuilder: (context, pageIndex) {
            final start = pageIndex * 10;
            final end = (pageIndex + 1) * 10;
            final pageTurnos = turnos.sublist(start, end > turnos.length ? turnos.length : end);

            return Padding(
              padding: EdgeInsets.symmetric(horizontal: 20),
              child: AnimatedSwitcher(
                duration: Duration(seconds: 3),
                transitionBuilder: (Widget child, Animation<double> animation) {
                  return FadeTransition(opacity: animation, child: child);
                },
                child: ListView(
                  key: ValueKey<List<Map<String, dynamic>>>(pageTurnos),
                  children: [
                    Card(
                      child: Padding(
                        padding: EdgeInsets.only(bottom: 15, top: 1),
                        child: Column(
                          children: [
                            SizedBox(height: 16),
                            Text(
                              'Mi Historial de Turnos (Página ${pageIndex + 1})',
                              style: TextStyle(
                                fontSize: 20,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            Divider(),
                            DataTable(
                              columnSpacing: 13,
                              columns: [
                                DataColumn(label: Text('TURNO')),
                                DataColumn(label: Text('ESTADO')),
                                DataColumn(label: Text('MODULO')),
                                DataColumn(label: Text('FECHA')),
                              ],
                              rows: pageTurnos.isNotEmpty
                                  ? pageTurnos.map<DataRow>((turno) {
                                      return DataRow(cells: [
                                        DataCell(Text(turno['turno'] ?? 'No disponible')),
                                        DataCell(Text(turno['estado'] ?? 'No disponible')),
                                        DataCell(Text(turno['modulo'] ?? 'No disponible')),
                                        DataCell(Text(turno['tiempo_ingreso'] ?? 'No disponible')),
                                      ],
                                      mouseCursor: WidgetStateMouseCursor.clickable
                                      );
                                    }).toList()
                                  : [
                                      DataRow(cells: [
                                        DataCell(Text('No hay datos')),
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
            );
          },
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
