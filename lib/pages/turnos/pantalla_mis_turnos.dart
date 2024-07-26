// ignore_for_file: deprecated_member_use

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
  List<Turnos> VerMisTurnos = [];
  final MyTurnosService _turnosService = MyTurnosService();
  bool _isDisposed = false;
  int? idCliente;

  Future<void> getDataClienteId() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      idCliente = prefs.getInt('ClienteId');
    });
  }

  @override
  void initState() {
    super.initState();
    getDataClienteId().then((_) {
      fetchTurnos();
    });
  }

  @override
  void dispose() {
    _isDisposed = true;
    super.dispose();
  }

  void fetchTurnos() async {
    while (!_isDisposed) {
      if (idCliente != null) {
        final fetchedTurnos = await _turnosService.fetchMyTurnosVerMisMyTurnos(idCliente!);
        if (!_isDisposed) {
          setState(() {
            VerMisTurnos = fetchedTurnos;
          });
        }
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
        body: Padding(
          padding: EdgeInsets.symmetric(horizontal: 20, vertical: 80),
          child: Column(
            children: [
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
                              'Mis Turnos Pendientes',
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
                              rows: VerMisTurnos.isNotEmpty
                                  ? VerMisTurnos.map<DataRow>((turno) {
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
