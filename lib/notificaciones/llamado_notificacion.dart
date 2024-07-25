import 'package:flutter/material.dart';

class LlamadoTurnoScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final args =
        ModalRoute.of(context)?.settings.arguments as Map<String, dynamic>?;
    final title = args?['title'];
    final body = args?['body'];

    return Scaffold(
      appBar: AppBar(
        title: Text(title ?? 'Llamado de Turno'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text(
              body ?? 'Detalles del llamado:',
              style: Theme.of(context).textTheme.titleLarge,
            ),
            Center(
              child: Padding(
                padding: EdgeInsets.only(top: 5),
                child: ElevatedButton(
                  onPressed: () {
                    Navigator.of(context).pushReplacementNamed('/home');
                  },
                  child: Text('Ir a inicio', style: TextStyle(color: Colors.white)),
                  style: ElevatedButton.styleFrom(
                      textStyle: TextStyle(fontSize: 16.0),
                      minimumSize:
                          Size(MediaQuery.of(context).size.width - 46, 50),
                      backgroundColor: Colors.red,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      )),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
