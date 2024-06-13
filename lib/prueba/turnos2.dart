import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:turnos_amerisa/model/services/cliente_service.dart';

class PruebaDos extends StatefulWidget {
  const PruebaDos({super.key});

  @override
  State<PruebaDos> createState() => _PruebaDosState();
}

class _PruebaDosState extends State<PruebaDos> {
  TextEditingController data = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          children: [
            fieldClienteNum(),
            buttonClientNum()
          ],
        ),
      ),
    );
  }

  Widget fieldClienteNum(){
    return TextFormField(
      controller: data,
    );
  }

  Widget buttonClientNum(){
    return ElevatedButton(
      onPressed: (){
        obtenerCliente(data.text);
      },
      child: Text('Entrar')
    );
  }
}