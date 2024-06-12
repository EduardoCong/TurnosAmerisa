import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:turnos_amerisa/model/services/login_cliente_service.dart';
import 'package:turnos_amerisa/model/services/login_service.dart';

class CustomDrawer extends StatelessWidget {
  const CustomDrawer({super.key});

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: ListView(
        padding: EdgeInsets.zero,
        children: [
          drawer(),
          hometitle(context),
          configtitle(context),
          const Divider(),
          profiletitle(context),
          notificationstitle(context),
          helptitle(context),
          const Divider(),
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
            'Amerisa Logistics',
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
      title: const Text('Logout'),
      leading: const Icon(Icons.exit_to_app),
      onTap: () async {
        AwesomeDialog(context: context,
            dialogType: DialogType.warning,
            borderSide: const BorderSide(
              color: Colors.blue,
              width: 2,
            ),
            width: 280,
            buttonsBorderRadius: const BorderRadius.all(
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
            descTextStyle: const TextStyle(color: Colors.green, fontSize: 18),
            btnOkText: 'Si',
            btnOkOnPress: (){
              logoutClient(context);
              logout(context);
            },
            btnCancelText: 'No',
            btnCancelOnPress: () {
            },
          ).show();
      },
    );
  }

  Widget helptitle(BuildContext context){
    return ListTile(
      title: const Text('Ayuda'),
      leading: const Icon(Icons.help),
      onTap: () {
        Navigator.pop(context);
      },
    );
  }

  Widget notificationstitle(BuildContext context){
    return ListTile(
      title: const Text('Notificaciones'),
      leading: const Icon(Icons.notifications),
      onTap: () {
        Navigator.pop(context);
      },
    );
  }

  Widget profiletitle(BuildContext context){
    return ListTile(
      title: const Text('Perfil'),
      leading: const Icon(Icons.person),
      onTap: () {
        Navigator.pop(context);
      },
    );
  }

  Widget configtitle(BuildContext context){
    return ListTile(
      title: const Text('Configuracion'),
      leading: const Icon(Icons.settings),
      onTap: () {
        Navigator.pop(context);
      },
    );
  }

  Widget hometitle(BuildContext context){
    return ListTile(
      title: const Text('Inicio'),
      leading: const Icon(Icons.home),
      onTap: () {
        Navigator.pop(context);
      },
    );
  }
}
