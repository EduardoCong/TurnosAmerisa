import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

import 'package:turnos_amerisa/pages/home/drawer_screen.dart';

class TurnosVer extends StatefulWidget {
  @override
  _TurnosVerState createState() => _TurnosVerState();
}

class _TurnosVerState extends State<TurnosVer> {
  final scaffoldKey = GlobalKey<ScaffoldState>();
  List turnosVer = [];
  String formattedDate = '';
  String formattedTime = '';

  @override
  void initState() {
    super.initState();
    fetchTurnosVer();
  }

  void fetchTurnosVer() async {
    final response = await http.post(
      Uri.parse('http://192.168.1.83/models/model_pantalla.php'),
      body: {'accion': 'Verturnos'},
    );
    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      if (data['status']) {
        setState(() {
          turnosVer = data['data'];
        });
      } else {
        setState(() {
          turnosVer = [];
        });
      }
    } else {
      setState(() {
        turnosVer = [];
      });
    }
    Future.delayed(Duration(seconds: 9), fetchTurnosVer);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        key: scaffoldKey,
        automaticallyImplyLeading: false,
        centerTitle: true,
        title: Text('Turnos'),
        leading: IconButton(
          icon: Icon(Icons.menu),
          onPressed: () {
            scaffoldKey.currentState!.openDrawer();
          },
        ),
      ),
      drawer: CustomDrawer(),
      body: SingleChildScrollView(
        child: Column(
          children: [
            MarqueeWidget(
              text: 'Comuniquese a la linea de atencion al usuario',
              style: TextStyle(fontSize: 24, color: Colors.white),
            ),
            Row(
              children: [
                Expanded(
                  child: DataTable(
                    columns: [
                      DataColumn(label: Text('TURNO')),
                      DataColumn(label: Text('ESTADO')),
                      DataColumn(label: Text('MODULO')),
                    ],
                    rows: turnosVer.isNotEmpty
                        ? turnosVer.map<DataRow>((turno) {
                            return DataRow(cells: [
                              DataCell(Text(turno['turno'])),
                              DataCell(Text(turno['estado'])),
                              DataCell(Text(turno['modulo'] ?? '-')),
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
                ),
                Expanded(
                  child: Column(
                    children: [
                      Text(
                        formattedDate,
                        style: TextStyle(fontSize: 24),
                      ),
                      Text(
                        formattedTime,
                        style: TextStyle(fontSize: 48),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
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
