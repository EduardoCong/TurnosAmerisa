import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:turnos_amerisa/pages/home/drawer_screen.dart';
import 'package:turnos_amerisa/provider/provider_change.dart';

class ConfiguracionView extends StatelessWidget {
  ConfiguracionView({super.key});

  final scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: scaffoldKey,
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: Text('Configuraciones'),
        leading: IconButton(
          icon: Icon(Icons.menu),
          onPressed: () {
            scaffoldKey.currentState!.openDrawer();
          },
        ),
      ),
      drawer: CustomDrawer(),
      body: Consumer(
        builder: (context, UiProvider notifier, child) {
          return Column(
            children: [
              ListTile(
                leading: Icon(Icons.dark_mode),
                title: Text('Modo oscuro'),
                trailing: Switch(
                  value: notifier.IsDark,
                  onChanged: (value){
                    notifier.changeTheme();
                  },
                ),
              )
            ],
          );
        }
      ),
    );
  }
}