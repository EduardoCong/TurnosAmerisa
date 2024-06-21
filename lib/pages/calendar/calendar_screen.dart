
import 'dart:async';

import 'package:awesome_notifications/awesome_notifications.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:table_calendar/table_calendar.dart';
import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:turnos_amerisa/model/api.dart';
import 'package:turnos_amerisa/model/event.dart';
import 'package:turnos_amerisa/model/services/generar_turno_service.dart';
import 'package:turnos_amerisa/prueba/loco.dart';

class Calendar extends StatefulWidget {
  Calendar({super.key});

  @override
  State<Calendar> createState() => _CalendarState();
}

class _CalendarState extends State<Calendar> {
  TextEditingController numeroDocumentoController = TextEditingController();
  TextEditingController numeroController = TextEditingController();
  TextEditingController pnombreController = TextEditingController();
  TextEditingController snombreController = TextEditingController();
  TextEditingController papellidoController = TextEditingController();
  TextEditingController sapellidoController = TextEditingController();

  Servicio? servicioSeleccionado;

  CalendarFormat _calendarFormat = CalendarFormat.month;
  DateTime _today = DateTime.now();
  DateTime? _selectedDay;
  Map<DateTime, List<Event>> events = {};
  late final ValueNotifier<List<Event>> _selectedEvents;
  bool _isTimeSelectorVisible = false;
  String? _selectedTime;
  List<String> availableTimes = ['9:00 AM','9:20 AM','9:40 AM','10:00 AM','10:20 AM','10:40 AM','11:00 AM','11:20 AM','11:40 AM','12:00 PM','12:20 PM','12:40 AM','1:00 PM','1:20 AM','1:40 AM',
  
  ];
    late Timer _timer;
    int _counter = 300;
    bool _showCounter = true;

  
  void initState() {
    AwesomeNotifications().isNotificationAllowed().then((isAllowed){
        if(!isAllowed){
          AwesomeNotifications().requestPermissionToSendNotifications();
        }
      }
    );
    super.initState();
    _startTimer();
    _selectedDay = _today;
    _selectedEvents = ValueNotifier(_getEventForDay(_selectedDay!));
  }

  @override
  void dispose() {
    _timer.cancel();
    super.dispose();
  }

  void _startTimer() {
    _timer = Timer.periodic(Duration(seconds: 1), (Timer timer) {
      setState(() {
        if (_counter > 0) {
          _counter--;
        } else {
          timer.cancel();
          _showCounter = false;
          Navigator.pushNamed(context, '/home');
        }
      });
    });
  }

  List<Event> _getEventForDay(DateTime day) {
    return events[day] ?? [];
  }

  void _onDaySelected(DateTime selectedDay, DateTime focusedDay) {
    if (!isSameDay(_selectedDay, selectedDay)) {
      setState(() {
        _selectedDay = selectedDay;
        _today = focusedDay;
        _selectedEvents.value = _getEventForDay(selectedDay);
        _isTimeSelectorVisible = true;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: Text("Agenda tu Cita"),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            if (_showCounter)
            countCalendar(),
            calendarTable(),
            SizedBox(height: 16),
            if (_isTimeSelectorVisible)
            servicesCalendar(),
            buttonSubmmitTurno()
          ],
        ),
      ),
    );
  }

  void scheduleNotification(){
    if (_selectedTime != null){
      String selectedDayFormatted = '${_selectedDay!.day}';
      String selectedMonth = '${_selectedDay!.month}';
      AwesomeNotifications().createNotification(
        content: NotificationContent(
          id: 2,
          channelKey: 'basic_channel',
          title: 'Horario Confirmado el día $selectedDayFormatted de $selectedMonth',
          body: 'Horario elegida: $_selectedTime',
          backgroundColor: Colors.blue
        )
      );
    }
  }

  Widget calendarTable(){
    return TableCalendar(
      focusedDay: _today,
      firstDay: DateTime.now(),
      lastDay: DateTime.utc(2030, 3, 14),
      selectedDayPredicate: ((day) => isSameDay(_selectedDay, day)),
      calendarFormat: _calendarFormat,
      startingDayOfWeek: StartingDayOfWeek.monday,
      onDaySelected: _onDaySelected,
      eventLoader: _getEventForDay,
      calendarStyle: CalendarStyle(
        outsideDaysVisible: false,
      ),
      onFormatChanged: (format) {
        if (_calendarFormat != format) {
          setState(() {
            _calendarFormat = format;
          });
        }
      },
      onPageChanged: (focusedDay) {
        setState(() {
          _today = focusedDay;
        });
      },
    );
  }

  Widget countCalendar(){
    return Positioned(
      top: -40,
      right: 16,
      child: Container(
        padding: EdgeInsets.all(8),
        decoration: BoxDecoration(
          color: Colors.blue,
          borderRadius: BorderRadius.circular(8),
        ),
        child: Text(
          'Tiempo restante: ${_counter ~/ 60}:${(_counter % 60).toString().padLeft(2, '0')}',
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w500,
            color: Colors.white,
          ),
        ),
      ),
    );
  }

  Widget servicesCalendar(){
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 16),
      child: Column(
        children: [
          Text("Seleccione un horario disponible:"),
          ...availableTimes.map((time) {
            return ListTile(
              title: Text(time),
              onTap: () {
                setState(() {
                  _selectedTime = time;
                });
                alertDialog();
              },
            );
          }),
        ],
      ),
    );
  }

  Future alertDialog(){
    return showDialog(
      context: context,
      builder: (BuildContext context){
        return AlertDialog(
          content: GetDatos(),
        );
      }
    );
  }

  Widget buttonSubmmitTurno(){
    return ElevatedButton(
      onPressed: ()async {
        _timer.cancel();
      setState(() {
        _showCounter = false; 
      });
      scheduleNotification();
      Navigator.pushNamed(context, '/rows');
      },
      child: Text('Genera turno')
    );
  }

  Future<void> buscarCliente(BuildContext context) async {
  String? numeroDocumento = numeroDocumentoController.text;
    try {
      if (numeroDocumento.isNotEmpty) {
        int numeroDocumentoInt = int.tryParse(numeroDocumento) ?? 0;

        Cliente? cliente = await ApiService.obtenerCliente(numeroDocumentoInt);

        if (cliente != null) {
          setState(() {
            numeroController.text = cliente.numero.toString();
            pnombreController.text = cliente.pnombre;
            snombreController.text = cliente.snombre;
            papellidoController.text = cliente.papellido;
            sapellidoController.text = cliente.sapellido;
          });
          Fluttertoast.showToast(msg: 'Cliente encontrado');
        } else {
          setState(() {
            numeroController.text = '';
            pnombreController.text = '';
            snombreController.text = '';
            papellidoController.text = '';
            sapellidoController.text = '';
          });
          Fluttertoast.showToast(msg: 'No se encontraron datos de cliente');
        }
      } else {
        Fluttertoast.showToast(msg: 'Ingrese un número de documento válido');
      }
    } catch (e) {
      Fluttertoast.showToast(msg: 'Error al buscar cliente: $e');
      print('Error al buscar cliente: $e');
    }
  }

  Future<void> generarTurno(BuildContext context) async {
    if (servicioSeleccionado == null) {
      AwesomeDialog(
            context: context,
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
            title: 'Selecciona un servicio primero',
            descTextStyle: TextStyle(color: Colors.green, fontSize: 18),
            btnOkOnPress: () async {
            },
          ).show();
      return;
    }

    String numeroTexto = numeroController.text;
    if (numeroTexto.isEmpty) {
      AwesomeDialog(
            context: context,
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
            title: 'Ingresa un numero',
            descTextStyle: TextStyle(color: Colors.green, fontSize: 18),
            btnOkOnPress: () async {
              Navigator.pushNamed(context, '/rows');
            },
          ).show();
      return;
    }
    if (_selectedTime != null) {
    String formattedDateTime = '${_selectedDay!.year}-${_selectedDay!.month.toString().padLeft(2, '0')}-${_selectedDay!.day.toString().padLeft(2, '0')} $_selectedTime';
    int? amigos = int.tryParse(numeroTexto);
    Map<String, dynamic> datos = {
      'numero': amigos,
      'pnombre': pnombreController.text,
      'snombre': snombreController.text,
      'papellido': papellidoController.text,
      'sapellido': sapellidoController.text,
      'registrarcliente': 'NO',
      'id_servicio': servicioSeleccionado!.id,
      'letra': servicioSeleccionado!.letra,
      'fechaInicio': '$formattedDateTime',
    };
    try {
      await ApiService.generarTurno(datos,context);
    } catch (e) {
      print('Error al generar turno: $e');
    }
    } else {}
  }

  Widget GetDatos(){
    return  SingleChildScrollView(
      padding: EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          TextField(
            controller: numeroDocumentoController,
            decoration: InputDecoration(
              hintText: 'Número Documento',
            ),
          ),
          SizedBox(height: 16.0),
          ElevatedButton(
            onPressed: () => buscarCliente(context),
            child: Text('Buscar Cliente'),
          ),
          SizedBox(height: 16.0),
          Visibility(
            visible: true,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                TextField(
                  controller: pnombreController,
                  decoration: InputDecoration(
                    labelText: 'Primer Nombre',
                  ),
                  readOnly: true,
                ),
                TextField(
                  controller: snombreController,
                  decoration: InputDecoration(
                    labelText: 'Segundo Nombre',
                  ),
                  readOnly: true,
                ),
                TextField(
                  controller: papellidoController,
                  decoration: InputDecoration(
                    labelText: 'Primer Apellido',
                  ),
                  readOnly: true,
                ),
                TextField(
                  controller: sapellidoController,
                  decoration: InputDecoration(
                    labelText: 'Segundo Apellido',
                  ),
                  readOnly: true,
                ),
              ],
            ),
          ),
          SizedBox(height: 16.0),
          ServiciosSelect(
            onServicioSelected: (servicio) {
              setState(() {
                servicioSeleccionado = servicio;
              });
            },
          ),
          SizedBox(height: 16.0),
          ElevatedButton(
            onPressed: () {
              generarTurno(context);
            },
            child: Text('Generar Turno'),
          ),
        ],
      ),
    );
  }
}

