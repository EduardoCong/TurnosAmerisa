import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:turnos_amerisa/firebase/firebase_api.dart';
import 'package:turnos_amerisa/pages/home/drawer_screen.dart';
import 'package:turnos_amerisa/services/registrar_dispositivo_service.dart';

class HomePage extends StatefulWidget {
  HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  Future<void> registerDeviceReady() async {
    FirebaseApi firebase = FirebaseApi();
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? tokenFirebase = await firebase.getToken();
    String? plataformUse = await firebase.getPlatform();
    String? idDevice = await firebase.getDeviceId();
    int? idClientes = await prefs.getInt('ClienteId');
    if (idClientes != null &&
        tokenFirebase != null &&
        plataformUse != '' &&
        idDevice != null) {
      await registrarDispositivo
      (idClientes, tokenFirebase, plataformUse, idDevice);
    } else {
      print('Error: No se pudo obtener todos los datos necesarios.');
    }
  }

  @override
  void initState() {
    super.initState();
    registerDeviceReady();
  }

  @override
  Widget build(BuildContext context) {
    final GlobalKey<ScaffoldState> scaffoldKey = GlobalKey<ScaffoldState>();

    return Scaffold(
      key: scaffoldKey,
      appBar: AppBar(
        automaticallyImplyLeading: false,
        // backgroundColor: Color.fromARGB(255, 255, 255, 255),
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
            imageLogo(),
            SizedBox(height: 20),
            buttonsTurnoCita(context)
          ],
        ),
      ),
      // backgroundColor: Colors.white,
    );
  }

  Widget imageLogo() {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 14),
      child: Image.network(
        "https://pbs.twimg.com/profile_images/814281946180231169/E7Z0c1Hy_400x400.jpg",
        width: 600,
        height: 300,
      ),
    );
  }

  Widget buttonsTurnoCita(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          textService(),
          SizedBox(height: 20),
          buttonTurno(context),
          SizedBox(height: 20),
          buttonCita(context)
        ],
      ),
    );
  }

  Widget textService() {
    return Text(
      "¿Qué tipo de atención deseas?",
      style: TextStyle(
        fontSize: 23,
        fontWeight: FontWeight.w500,
      ),
    );
  }

  Widget buttonTurno(BuildContext context) {
    return SizedBox(
      width: 330,
      height: 100,
      child: ElevatedButton.icon(
        onPressed: () {
          Navigator.of(context).pushReplacementNamed('/turno');
        },
        icon: Icon(
          Icons.phone_android,
          color: Colors.white,
        ),
        label: Text("Pedir Turno",
            style: TextStyle(fontSize: 22, color: Colors.white)),
        style: ElevatedButton.styleFrom(
          backgroundColor: Color.fromARGB(255, 35, 38, 204),
          elevation: 0,
          minimumSize: Size(MediaQuery.of(context).size.width - 46, 55),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
        ),
      ),
    );
  }

  Widget buttonCita(BuildContext context) {
    return SizedBox(
      width: 330,
      height: 100,
      child: ElevatedButton.icon(
        onPressed: () {
          Navigator.of(context).pushReplacementNamed('/calendario');
        },
        icon: Icon(
          Icons.calendar_today,
          color: Colors.white,
        ),
        label: Text("Pedir Cita",
            style: TextStyle(fontSize: 22, color: Colors.white)),
        style: ElevatedButton.styleFrom(
          backgroundColor: Color.fromARGB(255, 35, 38, 204),
          elevation: 0,
          minimumSize: Size(MediaQuery.of(context).size.width - 46, 55),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
        ),
      ),
    );
  }
}
