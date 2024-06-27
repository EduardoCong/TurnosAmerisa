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
  TextEditingController pnombreController = TextEditingController();
  TextEditingController snombreController = TextEditingController();
  TextEditingController papellidoController = TextEditingController();
  TextEditingController sapellidoController = TextEditingController();
  TextEditingController documentoController = TextEditingController();

  Servicio? servicioSeleccionado;

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
            Visibility(
              visible: false,
              child: _buildClienteInfoSection(),
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
                    generarTurno(context);
                    Navigator.pushNamed(context, '/verturno');
                  },
                  icon: Icon(Icons.schedule, color: Colors.white),
                  label: Text('Generar', style: TextStyle(color: Colors.white)),
                  style: ElevatedButton.styleFrom(
                    // padding: EdgeInsets.symmetric(horizontal: 16.0, vertical: 12.0),
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

  Widget _buildClienteInfoSection() {
    return Card(
      elevation: 4.0,
      margin: EdgeInsets.symmetric(vertical: 10.0),
      child: Padding(
        padding: EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Información del Cliente',
              style: TextStyle(
                fontSize: 18.0,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 10.0),
            _buildTextField(
              controller: pnombreController,
              label: 'Primer Nombre',
            ),
            SizedBox(height: 8.0),
            _buildTextField(
              controller: snombreController,
              label: 'Segundo Nombre',
            ),
            SizedBox(height: 8.0),
            _buildTextField(
              controller: papellidoController,
              label: 'Primer Apellido',
            ),
            SizedBox(height: 8.0),
            _buildTextField(
              controller: sapellidoController,
              label: 'Segundo Apellido',
            ),
            SizedBox(height: 8.0),
            _buildTextField(
              controller: documentoController,
              label: 'Documento',
            ),
          ],
        ),
      ),
    );
  }

  Future<void> buscarCliente(BuildContext context) async {
    String? numeroDocumento = numeroDocumentoController.text;
    try {
      if (numeroDocumento.isNotEmpty) {
        Cliente? cliente = await ApiService.obtenerCliente(numeroDocumento);

        if (cliente != null) {
          setState(() {
            numeroDocumentoController.text = cliente.numero;
            pnombreController.text = cliente.pnombre;
            snombreController.text = cliente.snombre;
            papellidoController.text = cliente.papellido;
            sapellidoController.text = cliente.sapellido;
            documentoController.text = cliente.documento;
          });
          print('Cliente encontrado');
        } else {
          numeroDocumentoController.text = '';
          pnombreController.text = '';
          snombreController.text = '';
          papellidoController.text = '';
          sapellidoController.text = '';
          documentoController.text = '';
          print('No se encontraron datos de cliente');
        }
      } else {
        print('Ingrese un número de documento válido');
      }
    } catch (e) {
      print('Error al buscar cliente: $e');
    }
  }

  Future<void> generarTurno(BuildContext context) async {
    // if (servicioSeleccionado == null) {
    //   _showWarningDialog(context, 'Selecciona un servicio primero');
    //   return;
    // }

    // String numeroTexto = numeroController.text;
    // if (numeroTexto.isEmpty) {
    //   _showWarningDialog(context, 'Ingresa un número');
    //   return;
    // }

    Map<String, dynamic> datos = {
      'numero': numeroDocumentoController.text,
      'documento': documentoController.text,
      'pnombre': pnombreController.text,
      'snombre': snombreController.text,
      'papellido': papellidoController.text,
      'sapellido': sapellidoController.text,
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
