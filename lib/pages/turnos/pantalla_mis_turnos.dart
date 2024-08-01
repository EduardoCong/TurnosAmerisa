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
  List<Turnos> turnos = [];
  final MyTurnosService _turnosService = MyTurnosService();
  bool _isDisposed = false;
  int? idCliente;
  late PageController _pageController;
  bool _loading = true;

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
      fetchTurnos();
    });
  }

  @override
  void dispose() {
    _isDisposed = true;
    _pageController.dispose();
    super.dispose();
  }

  Future<void> fetchTurnos() async {
    setState(() {
      _loading = true;
    });
    if (idCliente != null) {
      final fetchedTurnos = await _turnosService.fetchMyTurnosVerMisMyTurnos(idCliente!);
      if (!_isDisposed) {
        setState(() {
          turnos = fetchedTurnos;
          _loading = false;
        });
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
        body: _loading
            ? Center(child: CircularProgressIndicator())
            : PageView.builder(
                controller: _pageController,
                itemCount: (turnos.length / 10).ceil(),
                itemBuilder: (context, pageIndex) {
                  final start = pageIndex * 10;
                  final end = (pageIndex + 1) * 10;
                  final pageTurnos = turnos.sublist(start, end > turnos.length ? turnos.length : end);

                  return Padding(
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
                                  'Mi Historial de Turnos (Página ${pageIndex + 1})',
                                  style: TextStyle(
                                    fontSize: 20,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                Divider(),
                                DataTable(
                                  columnSpacing: 18,
                                  columns: [
                                    DataColumn(label: Text('TURNO')),
                                    DataColumn(label: Text('ESTADO')),
                                    DataColumn(label: Text('MODULO')),
                                    DataColumn(label: Text('FECHA')),
                                  ],
                                  rows: pageTurnos.isNotEmpty
                                      ? pageTurnos.map<DataRow>((turno) {
                                          return DataRow(cells: [
                                            DataCell(Text(turno.turno)),
                                            DataCell(Text(turno.estado)),
                                            DataCell(Text(turno.modulo)),
                                            DataCell(Text(turno.fecha)),
                                          ]);
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
