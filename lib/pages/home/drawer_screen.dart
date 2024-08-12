import 'dart:io';

import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:turnos_amerisa/model/sharedPreferences.dart';
import 'package:turnos_amerisa/pages/subirfotos/subir_fotos.dart';
import 'package:turnos_amerisa/services/subir_fotos_services.dart';

class CustomDrawer extends StatefulWidget {
  CustomDrawer({super.key});

  @override
  State<CustomDrawer> createState() => _CustomDrawerState();
}

class _CustomDrawerState extends State<CustomDrawer> {
  SharedPrefsService sharedprefs = SharedPrefsService();
  XFile? _image;
  final ImagePicker _picker = ImagePicker();
  bool isDisposed = false;
  bool isLoanding = false;

  String name = '';
  String apellido = '';
  int? idCliente;
  String? foto;

  Future<void> loadClientData() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      name = prefs.getString('nombre') ?? '';
      apellido = prefs.getString('apellido') ?? '';
      idCliente = prefs.getInt('ClienteId');
      foto = prefs.getString('fotoPerfil');
    });
  }

  @override
  void initState() {
    super.initState();
    loadClientData();
  }

  @override
  void dispose() {
    super.dispose();
    isDisposed = true;
  }

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: ListView(
        padding: EdgeInsets.zero,
        children: [
          drawer(),
          // profiletitle(context),
          hometitle(context),
          Divider(),
          listTurnos(context),
          VerMisTurnos(context),
          pedirTurno(context),
          pedirCita(context),
          configMode(context),
          Divider(),
          logouttitle(context)
        ],
      ),
    );
  }

  Future<void> _pickImage() async {
    final pickedFile = await _picker.pickImage(source: ImageSource.gallery);
    if (!isDisposed) {
      setState(() {
        _image = pickedFile;
        isLoanding = true;
      });
      if (_image != null) {
        _uploadImageAndSendToServer();
        setState(() {
          isLoanding = false;
        });
      }
    }
  }

  Future<void> _uploadImageAndSendToServer() async {
    if (_image == null || idCliente == null) return;
    try {
      final imageUrl = await uploadImage(File(_image!.path));
      if (imageUrl != null) {
        final success = await subirImagen(idCliente!, imageUrl);

        if (success) {
          setState(() {
            foto = imageUrl;
          });

          SharedPreferences prefs = await SharedPreferences.getInstance();
          await prefs.setString('fotoPerfil', imageUrl);

          AwesomeDialog(
            context: context,
            dialogType: DialogType.success,
            width: 400,
            buttonsBorderRadius: BorderRadius.all(Radius.circular(2)),
            dismissOnTouchOutside: false,
            dismissOnBackKeyPress: false,
            headerAnimationLoop: true,
            animType: AnimType.bottomSlide,
            title: 'Foto Subida Con Éxito',
            descTextStyle: TextStyle(color: Colors.green, fontSize: 18),
            btnCancel: ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.green,
                elevation: 0,
                minimumSize: Size(MediaQuery.of(context).size.width - 46, 50),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
              onPressed: () {
                Navigator.pop(context);
              },
              child: Text(
                'Ok',
                style: TextStyle(color: Colors.white),
              ),
            ),
          ).show();
        } else {
          AwesomeDialog(
            context: context,
            dialogType: DialogType.error,
            width: 400,
            buttonsBorderRadius: BorderRadius.all(Radius.circular(2)),
            dismissOnTouchOutside: false,
            dismissOnBackKeyPress: false,
            headerAnimationLoop: true,
            animType: AnimType.bottomSlide,
            title: 'Hubo un error al subir la imagen',
            descTextStyle: TextStyle(color: Colors.green, fontSize: 18),
            btnCancel: ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.red,
                elevation: 0,
                minimumSize: Size(MediaQuery.of(context).size.width - 46, 50),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
              onPressed: () {
                Navigator.pop(context);
              },
              child: Text(
                'Intentar de nuevo',
                style: TextStyle(color: Colors.white),
              ),
            ),
          ).show();
        }
      } else {
        AwesomeDialog(
            context: context,
            dialogType: DialogType.error,
            width: 400,
            buttonsBorderRadius: BorderRadius.all(Radius.circular(2)),
            dismissOnTouchOutside: false,
            dismissOnBackKeyPress: false,
            headerAnimationLoop: true,
            animType: AnimType.bottomSlide,
            title: 'Hubo un error al subir la imagen',
            descTextStyle: TextStyle(color: Colors.green, fontSize: 18),
            btnCancel: ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.red,
                elevation: 0,
                minimumSize: Size(MediaQuery.of(context).size.width - 46, 50),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
              onPressed: () {
                Navigator.pop(context);
              },
              child: Text(
                'Intentar de nuevo',
                style: TextStyle(color: Colors.white),
              ),
            ),
          ).show();
      }
    } catch (e) {
      print('Error al subir la imagen: $e');
      AwesomeDialog(
            context: context,
            dialogType: DialogType.error,
            width: 400,
            buttonsBorderRadius: BorderRadius.all(Radius.circular(2)),
            dismissOnTouchOutside: false,
            dismissOnBackKeyPress: false,
            headerAnimationLoop: true,
            animType: AnimType.bottomSlide,
            title: 'Hubo un error al subir la imagen',
            descTextStyle: TextStyle(color: Colors.green, fontSize: 18),
            btnCancel: ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.red,
                elevation: 0,
                minimumSize: Size(MediaQuery.of(context).size.width - 46, 50),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
              onPressed: () {
                Navigator.pop(context);
              },
              child: Text(
                'Intentar de nuevo',
                style: TextStyle(color: Colors.white),
              ),
            ),
          ).show();
    }
  }

  void _handleProfilePictureChange() {
    if (_image != null && !isDisposed) {
      AwesomeDialog(
        context: context,
        dialogType: DialogType.warning,
        title: 'Cambiar foto de perfil',
        desc: '¿Deseas cambiar tu foto de perfil?',
        btnCancel: ElevatedButton(
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.red,
            elevation: 0,
            minimumSize: Size(MediaQuery.of(context).size.width - 46, 50),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10),
            ),
          ),
          onPressed: () {
            if (mounted) {
              Navigator.pop(context);
            }
          },
          child: Text(
            'No',
            style: TextStyle(color: Colors.white),
          ),
        ),
        btnOk: ElevatedButton(
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.green,
            elevation: 0,
            minimumSize: Size(MediaQuery.of(context).size.width - 46, 50),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10),
            ),
          ),
          onPressed: () {
            Navigator.pop(context);
            _pickImage();
          },
          child: Text(
            'Si',
            style: TextStyle(color: Colors.white),
          ),
        ),
      ).show();
    } else {
      _pickImage();
    }
  }

  Widget drawer() {
    return DrawerHeader(
      decoration: BoxDecoration(
        color: Color.fromARGB(255, 35, 38, 204),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          GestureDetector(
            onTap: _handleProfilePictureChange,
            child: CircleAvatar(
              radius: 40,
              backgroundImage: foto != null ? NetworkImage(foto!) : null,
              child: foto == null
                  ? Icon(
                      Icons.camera_alt,
                      size: 50,
                      color: Colors.white,
                    )
                  : null,
            ),
          ),
          SizedBox(height: 15),
          Text(
            '$name $apellido',
            style: TextStyle(
                color: Colors.white, fontSize: 22, fontWeight: FontWeight.bold),
          ),
        ],
      ),
    );
  }

  Widget logouttitle(BuildContext context) {
    return ListTile(
      title: Text('Salir Sesión'),
      leading: Icon(Icons.exit_to_app),
      onTap: () async {
        AwesomeDialog(
          context: context,
          dialogType: DialogType.warning,
          width: 400,
          buttonsBorderRadius: BorderRadius.all(
            Radius.circular(2),
          ),
          dismissOnTouchOutside: false,
          dismissOnBackKeyPress: false,
          animType: AnimType.topSlide,
          title: '¿Estas seguro que deseas salir de la sesión?',
          descTextStyle: TextStyle(color: Colors.green, fontSize: 18),
          btnCancel: ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.red,
              elevation: 0,
              minimumSize: Size(MediaQuery.of(context).size.width - 46, 50),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
              ),
            ),
            onPressed: () {
              Navigator.pop(context);
            },
            child: Text(
              'No',
              style: TextStyle(color: Colors.white),
            ),
          ),
          btnOk: ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.green,
              elevation: 0,
              minimumSize: Size(MediaQuery.of(context).size.width - 46, 50),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
              ),
            ),
            onPressed: () async {
              Navigator.of(context).pushReplacementNamed('/');
              bool isRemoved = await sharedprefs.removeCache(key: 'numero');
              if (isRemoved == true) {
                Navigator.of(context).pushReplacementNamed('/login');
              } else {
                ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                    content: Text(
                        'No se pudo salir de la sesión, intente de nuevo')));
              }
            },
            child: Text(
              'Si',
              style: TextStyle(color: Colors.white),
            ),
          ),
        ).show();
      },
    );
  }

  Widget pedirCita(BuildContext context) {
    return ListTile(
      title: Text('Pedir Cita'),
      leading: Icon(Icons.calendar_month_sharp),
      onTap: () {
        if (ModalRoute.of(context)?.settings.name != '/calendario') {
          Navigator.of(context).pushReplacementNamed('/calendario');
        } else {
          Navigator.pop(context);
        }
      },
    );
  }

  Widget pedirTurno(BuildContext context) {
    return ListTile(
      title: Text('Pedir Turno'),
      leading: Icon(Icons.arrow_forward),
      onTap: () {
        if (ModalRoute.of(context)?.settings.name != '/turno') {
          Navigator.of(context).pushReplacementNamed('/turno');
        } else {
          Navigator.pop(context);
        }
      },
    );
  }

  Widget listTurnos(BuildContext context) {
    return ListTile(
      title: Text('Listado de turnos'),
      leading: Icon(Icons.list),
      onTap: () {
        if (ModalRoute.of(context)?.settings.name != '/listurno') {
          Navigator.of(context).pushReplacementNamed('/listurno');
        } else {
          Navigator.pop(context);
        }
      },
    );
  }

  Widget configMode(BuildContext context) {
    return ListTile(
      title: Text('Configuración'),
      leading: Icon(Icons.settings),
      onTap: () {
        if (ModalRoute.of(context)?.settings.name != '/config') {
          Navigator.of(context).pushReplacementNamed('/config');
        } else {
          Navigator.pop(context);
        }
      },
    );
  }

  Widget profiletitle(BuildContext context) {
    return ListTile(
      title: Text('Perfil'),
      leading: Icon(Icons.person),
      onTap: () {
        Navigator.pop(context);
      },
    );
  }

  Widget hometitle(BuildContext context) {
    return ListTile(
      title: Text('Inicio'),
      leading: Icon(Icons.home),
      splashColor: Colors.blue.withOpacity(0.2),
      selectedTileColor: Colors.blue.withOpacity(0.1),
      onTap: () {
        if (ModalRoute.of(context)?.settings.name != '/home') {
          Navigator.of(context).pushReplacementNamed('/home');
        } else {
          Navigator.pop(context);
        }
      },
    );
  }

  Widget VerMisTurnos(BuildContext context) {
    return ListTile(
      title: Text('Ver Mis Turnos'),
      leading: Icon(Icons.view_list_rounded),
      splashColor: Colors.blue.withOpacity(0.2),
      selectedTileColor: Colors.blue.withOpacity(0.1),
      onTap: () {
        if (ModalRoute.of(context)?.settings.name != '/vermisturnos') {
          Navigator.of(context).pushReplacementNamed('/vermisturnos');
        } else {
          Navigator.pop(context);
        }
      },
    );
  }
}
