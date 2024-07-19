import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:turnos_amerisa/model/sharedPreferences.dart';


class CustomDrawer extends StatefulWidget {
 CustomDrawer({super.key});

  @override
  State<CustomDrawer> createState() => _CustomDrawerState();
}

class _CustomDrawerState extends State<CustomDrawer> {

  SharedPrefsService sharedprefs = SharedPrefsService();

  String name = '';
  String apellido = '';

  Future<void> loadClientData() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      name = prefs.getString('nombre') ?? '';
      apellido = prefs.getString('apellido') ?? '';
    });
  }

  @override
  void initState() {
    super.initState();
    loadClientData();
  }

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: ListView(
        padding: EdgeInsets.zero,
        children: [
          drawer(),
          profiletitle(context),
          hometitle(context),
         Divider(),
          listTurnos(context),
          configMode(context),
          pedirTurno(context),
          pedirCita(context),
         Divider(),
          logouttitle(context)
        ],
      ),
    );
  }

  Widget drawer(){
    return DrawerHeader(
      decoration: BoxDecoration(
        color: Colors.blue,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          CircleAvatar(
            radius: 30,
            backgroundImage: NetworkImage(
                "https://th.bing.com/th/id/OIP.hCfHyL8u8XAbreXuaiTMQgHaHZ?rs=1&pid=ImgDetMain"),
          ),
          SizedBox(height: 10),
          Text(
            '$name $apellido',
            style: TextStyle(
              color: Colors.white,
              fontSize: 20,
            ),
          ),
        ],
      ),
    );
  }

  Widget logouttitle(BuildContext context){
    return ListTile(
      title: Text('Logout'),
      leading: Icon(Icons.exit_to_app),
      onTap: () async {
        AwesomeDialog(context: context,
            dialogType: DialogType.warning,
            borderSide: BorderSide(
              color: Colors.blue,
              width: 2,
            ),
            width: 280,
            buttonsBorderRadius: BorderRadius.all(
              Radius.circular(2),
            ),
            dismissOnTouchOutside: true,
            dismissOnBackKeyPress: false,
            onDismissCallback: (type) {
              debugPrint('Dialog Dismiss from callback $type');
            },
            headerAnimationLoop: false,
            animType: AnimType.topSlide,
            title: '¿Estas seguro que deseas salir de la sesion?',
            descTextStyle: TextStyle(color: Colors.green, fontSize: 18),
            btnOkText: 'Si',
            btnOkOnPress: () async {
              Navigator.of(context).pushReplacementNamed('/');
              bool isRemoved = await sharedprefs.removeCache(key: 'numero');
              if (isRemoved == true) {
                Navigator.of(context).pushReplacementNamed('/login');
              }else{
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text('No se pudo salir de la sesion, intente de nuevo'))
                );
              }
            },
            btnCancelText: 'No',
            btnCancelOnPress: () {
            },
          ).show();
      },
    );
  }

  Widget pedirCita(BuildContext context){
    return ListTile(
      title: Text('Pedir Cita'),
      leading: Icon(Icons.calendar_month_sharp),
      onTap: () {
        if (ModalRoute.of(context)?.settings.name != '/calendario') {
          Navigator.of(context).pushReplacementNamed('/calendario');
        }else{
          Navigator.pop(context);
        }
      },
    );
  }

  Widget pedirTurno(BuildContext context){
    return ListTile(
      title: Text('Pedir Turno'),
      leading: Icon(Icons.arrow_forward),
      onTap: () {
         if (ModalRoute.of(context)?.settings.name != '/turno') {
          Navigator.of(context).pushReplacementNamed('/turno');
        }else{
          Navigator.pop(context);
        }
      },
    );
  }

  Widget listTurnos(BuildContext context){
    return ListTile(
      title: Text('Listado de turnos'),
      leading: Icon(Icons.list),
      onTap: () {
        if (ModalRoute.of(context)?.settings.name != '/listurno') {
          Navigator.of(context).pushReplacementNamed('/listurno');
        }else{
          Navigator.pop(context);
        }
      },
    );
  }

  Widget configMode(BuildContext context){
    return ListTile(
      title: Text('Configuracion'),
      leading: Icon(Icons.settings),
      onTap: () {
        if (ModalRoute.of(context)?.settings.name != '/config') {
          Navigator.of(context).pushReplacementNamed('/config');
        }else{
          Navigator.pop(context);
        }
      },
    );
  }

  Widget profiletitle(BuildContext context){
    return ListTile(
      title: Text('Perfil'),
      leading: Icon(Icons.person),
      onTap: () {
        Navigator.pop(context);
      },
    );
  }

  Widget hometitle(BuildContext context){
    return ListTile(
      title: Text('Inicio'),
      leading: Icon(Icons.home),
      onTap: () {
        if (ModalRoute.of(context)?.settings.name != '/home') {
          Navigator.of(context).pushReplacementNamed('/home');
        }else{
          Navigator.pop(context);
        }
      },
    );
  }
}
