import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:flutter/material.dart';
import 'package:turnos_amerisa/model/api.dart';
import 'package:turnos_amerisa/services/generar_turno_service.dart';
import 'package:turnos_amerisa/pages/turnos/servicios_select.dart';

class GenerarTurnoView extends StatefulWidget {
  @override
  _GenerarTurnoViewState createState() => _GenerarTurnoViewState();
}

class _GenerarTurnoViewState extends State<GenerarTurnoView> {
  TextEditingController numeroDocumentoController = TextEditingController();

  Servicio? servicioSeleccionado;
  Cliente? cliente;

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: Text('Generar Turno'),
        centerTitle: true,
        automaticallyImplyLeading: false,
        backgroundColor: Colors.white,
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            imageLogo(),
            SizedBox(height: 20),
            _buildTextField(
              controller: numeroDocumentoController,
              label: 'Número Documento',
              icon: Icons.document_scanner,
            ),
            SizedBox(height: 16.0),
            Center(
              child: ElevatedButton.icon(
                onPressed: () => buscarCliente(context),
                icon: Icon(Icons.search, color: Colors.white),
                label: Text('Buscar Cliente', style: TextStyle(color: Colors.white)),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Color.fromARGB(255, 35, 38, 204),
                  padding: EdgeInsets.symmetric(horizontal: 1.0, vertical: 12.0),
                  textStyle: TextStyle(fontSize: 16.0),
                  minimumSize: Size(MediaQuery.of(context).size.width - 46, 50),
                ),
              ),
            ),
            SizedBox(height: 16.0),
            Card(
              elevation: 4.0,
              margin: EdgeInsets.symmetric(vertical: 10.0),
              child: Padding(
                padding: EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Seleccione el Servicio',
                      style: TextStyle(
                        fontSize: 18.0,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    SizedBox(height: 10.0),
                    ServiciosSelect(
                      onServicioSelected: (servicio) {
                        setState(() {
                          servicioSeleccionado = servicio;
                        });
                      },
                    ),
                  ],
                ),
              ),
            ),
            SizedBox(height: 16.0),
            Center(
              child: Padding(
                padding: const EdgeInsets.only(top: 5),
                child: ElevatedButton.icon(
                  onPressed: (){
                    AwesomeDialog(
                      context: context,
                      dialogType: DialogType.success,
                      borderSide: BorderSide(
                        color: Colors.blue,
                        width: 2,
                      ),
                      width: 280,
                      buttonsBorderRadius: BorderRadius.all(
                        Radius.circular(2)
                      ),
                      dismissOnTouchOutside: true,
                      dismissOnBackKeyPress: false,
                      onDismissCallback: (type) {
                        debugPrint('Dialog Dissmiss from callback $type');
                      },
                      headerAnimationLoop: false,
                      animType: AnimType.bottomSlide,
                      title: 'Turno Generado Con Exito',
                      descTextStyle: TextStyle(color: Colors.green, fontSize: 18),
                      btnOkOnPress: () {
                        generarTurno(context);
                        Navigator.pushNamed(context, '/verturno');
                      },
                    ).show();
                  },
                  icon: Icon(Icons.schedule, color: Colors.white),
                  label: Text('Generar', style: TextStyle(color: Colors.white)),
                  style: ElevatedButton.styleFrom(
                    textStyle: TextStyle(fontSize: 16.0),
                    minimumSize: Size(MediaQuery.of(context).size.width - 46, 50),
                    backgroundColor: Color.fromARGB(255, 35, 38, 204),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget imageLogo(){
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 14),
      child: Image.network(
        "https://pbs.twimg.com/profile_images/814281946180231169/E7Z0c1Hy_400x400.jpg",
        width: 600,
        height: 300,
      ),
    );
  }

  Widget _buildTextField({
    required TextEditingController controller,
    required String label,
    IconData? icon,
  }) {
    return TextField(
      controller: controller,
      decoration: InputDecoration(
        border: OutlineInputBorder(),
        labelText: label,
        prefixIcon: icon != null ? Icon(icon) : null,
      ),
    );
  }

  Future<void> buscarCliente(BuildContext context) async {
    try {
      String? numeroDocumento = numeroDocumentoController.text;
     await ApiService.obtenerCliente(numeroDocumento);
     print('Cliente encontrado');
    } catch (e) {
      Error;
    }
  }

  Future<void> generarTurno(BuildContext context) async {

    Map<String, dynamic> datos = {
      'numero': numeroDocumentoController.text,
      'pnombre': cliente!.pnombre,
      'snombre': cliente!.snombre,
      'papellido': cliente!.papellido,
      'sapellido': cliente!.sapellido,
      'registrarcliente': 'NO',
      'id_servicio': servicioSeleccionado!.id,
      'letra': servicioSeleccionado!.letra,
      'fechaInicio': null,
    };

    try {
      await ApiService.generarTurno(datos, context);
    } catch (e) {
      print('Error al generar turno_: $e');
    }
  }
}