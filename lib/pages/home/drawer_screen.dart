import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:flutter/material.dart';

class CustomDrawer extends StatelessWidget {
  const CustomDrawer({super.key});

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: ListView(
        padding: EdgeInsets.zero,
        children: [
          const DrawerHeader(
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
                  'Your App Name',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 20,
                  ),
                ),
              ],
            ),
          ),
          ListTile(
            title: const Text('Home'),
            leading: const Icon(Icons.home),
            onTap: () {
              Navigator.pop(context);
              // Navigate to home screen or perform any action here
            },
          ),
          ListTile(
            title: const Text('Settings'),
            leading: const Icon(Icons.settings),
            onTap: () {
              Navigator.pop(context);
              // Navigate to settings screen or perform any action here
            },
          ),
          const Divider(),
          ListTile(
            title: const Text('Profile'),
            leading: const Icon(Icons.person),
            onTap: () {
              Navigator.pop(context);
              // Navigate to profile screen or perform any action here
            },
          ),
          ListTile(
            title: const Text('Notifications'),
            leading: const Icon(Icons.notifications),
            onTap: () {
              Navigator.pop(context);
              // Navigate to notifications screen or perform any action here
            },
          ),
          ListTile(
            title: const Text('Help & Feedback'),
            leading: const Icon(Icons.help),
            onTap: () {
              Navigator.pop(context);
              // Navigate to help & feedback screen or perform any action here
            },
          ),
          const Divider(),
          ListTile(
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
                  btnOkOnPress: () {
                    Navigator.pushNamed(context, '/');
                  },
                  btnCancelText: 'No',
                  btnCancelOnPress: () {
                  },
                ).show();
            },
          ),
        ],
      ),
    );
  }
}
