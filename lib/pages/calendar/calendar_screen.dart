// ignore_for_file: deprecated_member_use

import 'dart:async';
import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:table_calendar/table_calendar.dart';
import 'package:turnos_amerisa/model/event.dart';
import 'package:turnos_amerisa/model/servicios_model.dart';
import 'package:turnos_amerisa/model/turno_data.dart';
import 'package:turnos_amerisa/pages/home/drawer_screen.dart';
import 'package:turnos_amerisa/pages/turnos/servicios_select.dart';
import 'package:turnos_amerisa/services/generar_turno_service.dart';

class Calendar extends StatefulWidget {
  Calendar({super.key});

  @override
  State<Calendar> createState() => _CalendarState();
}

class _CalendarState extends State<Calendar> {
  Servicio? servicioSeleccionado;
  List<int> serviciosDeshabilitados = [];
  CalendarFormat _calendarFormat = CalendarFormat.month;
  DateTime _today = DateTime.now();
  DateTime? _selectedDay;
  Map<DateTime, List<Event>> events = {};
  late final ValueNotifier<List<Event>> _selectedEvents;
  bool _isServiceSelectorVisible = false;
  bool _isTimeSelectorVisible = false;
  String? _selectedTime;
  late Timer _timer;
  int _counter = 300;
  bool _showCounter = true;
  String nombreCita = '';
  String segundoNombreCita = '';
  String apellidoCita = '';
  String segundoApellidoCita = '';
  String numeroClienteCita = '';

  final scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  void initState() {
    super.initState();
    _startTimer();
    _selectedDay = _today;
    _selectedEvents = ValueNotifier(_getEventForDay(_selectedDay!));
    loadUserData();
  }

  Future<void> mostrarDetallesServicio(Servicio servicio) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setInt('idServicio', servicio.id);
    await prefs.setString('nombreServicio', servicio.nombre);
    await prefs.setString('letraServicio', servicio.letra);
  }

  Future<void> loadUserData() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      nombreCita = prefs.getString('nombre') ?? '';
      segundoNombreCita = prefs.getString('segundoNombre') ?? '';
      apellidoCita = prefs.getString('apellido') ?? '';
      segundoApellidoCita = prefs.getString('segundoApellido') ?? '';
      numeroClienteCita = prefs.getString('numeroCliente') ?? '';
    });
  }

  Future<void> _saveSelectedDateAndTime() async {
    if (_selectedDay != null && _selectedTime != null) {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      await prefs.setInt('selected_year', _selectedDay!.year);
      await prefs.setString('selected_month', DateFormat('MMMM').format(_selectedDay!));
      await prefs.setInt('selected_day', _selectedDay!.day);
      await prefs.setString('selected_time', _selectedTime!);
    }
  }

  Future<void> _saveTurnoInCache(DateTime date, String time, int servicioId) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String turnoKey = '${date.year}-${date.month}-${date.day}-$time-$servicioId';
    await prefs.setBool(turnoKey, true);
  }

  Future<bool> _isTurnoOcupado(DateTime date, String time, int servicioId) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String turnoKey = '${date.year}-${date.month}-${date.day}-$time-$servicioId';
    return prefs.getBool(turnoKey) ?? false;
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
          Navigator.of(context).pushReplacementNamed('/home');
        }
      });
    });
  }

  List<Event> _getEventForDay(DateTime day) {
    return events[day] ?? [];
  }

  void _onDaySelected(DateTime selectedDay, DateTime focusedDay) {
    if (selectedDay.weekday == DateTime.sunday) {
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
          debugPrint('Dialog Dissmiss from callback $type');
        },
        headerAnimationLoop: false,
        animType: AnimType.bottomSlide,
        title: 'No es posible agendar cita',
        desc: 'Los domingos no son días laborales.',
        descTextStyle: TextStyle(color: Colors.green, fontSize: 18),
        btnOkOnPress: () {},
      ).show();
      return;
    }

    if (!isSameDay(_selectedDay, selectedDay)) {
      setState(() {
        _selectedDay = selectedDay;
        _today = focusedDay;
        _selectedEvents.value = _getEventForDay(selectedDay);
        _isServiceSelectorVisible = true;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        return await _showCancelDialog(context);
      },
      child: Scaffold(
        key: scaffoldKey,
        appBar: AppBar(
          automaticallyImplyLeading: false,
          title: Text("Agenda tu Cita"),
          centerTitle: true,
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
              if (_showCounter) calendarTable(),
              SizedBox(height: 16),
              if (_isServiceSelectorVisible) serviceSelector(),
              SizedBox(height: 16),
              if (_isTimeSelectorVisible) timePicker(),
              SizedBox(height: 16),
              if (_selectedDay != null &&
                  servicioSeleccionado != null &&
                  _selectedTime != null)
                buttonSubmit(),
            ],
          ),
        ),
      ),
    );
  }

  Widget calendarTable() {
    return Stack(
      children: [
        TableCalendar(
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
        ),
        if (_showCounter)
          Positioned(
            top: 16,
            right: 60,
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
          ),
      ],
    );
  }

  Widget serviceSelector() {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ServiciosSelect(
            onServicioSelected: (servicio) {
              setState(() {
                servicioSeleccionado = servicio;
                _isTimeSelectorVisible = true;
              });
              if (servicio != null) {
                mostrarDetallesServicio(servicio);
              }
            },
          ),
        ],
      ),
    );
  }

  Widget timePicker() {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (_selectedTime != null)
            Text(
              'Hora seleccionada: $_selectedTime',
              style: TextStyle(fontSize: 16),
            ),
          ElevatedButton(
            child: Text('Seleccionar hora'),
            onPressed: () => _selectTime(context),
          ),
        ],
      ),
    );
  }

  void _selectTime(BuildContext context) async {
    TimeOfDay? selectedTime = await showTimePicker(
      context: context,
      initialTime: TimeOfDay.now(),
      barrierDismissible: true,
    );

    if (selectedTime != null) {
      if (!isTimeWithinAllowedHours(selectedTime)) {
        AwesomeDialog(
          context: context,
          dialogType: DialogType.warning,
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
          headerAnimationLoop: false,
          animType: AnimType.bottomSlide,
          title: 'Horario no disponible',
          desc: 'Por favor, elige una hora entre las 9:00 AM y las 5:40 PM de lunes a viernes.',
          descTextStyle: TextStyle(color: Colors.green, fontSize: 18),
          btnOkOnPress: () {},
        ).show();
        return;
      }
      if (_selectedDay!.weekday == DateTime.saturday &&
          !isTimeWithinSaturdayHours(selectedTime)) {
        AwesomeDialog(
          context: context,
          dialogType: DialogType.warning,
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
          headerAnimationLoop: false,
          animType: AnimType.bottomSlide,
          title: 'Horario no disponible',
          desc: 'Los sábados solo se pueden agendar citas de 9:00 AM a 1:00 PM.',
          descTextStyle: TextStyle(color: Colors.green, fontSize: 18),
          btnOkOnPress: () {},
        ).show();
        return;
      }

      if (selectedTime.minute % 20 != 0) {
      AwesomeDialog(
        context: context,
        dialogType: DialogType.warning,
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
        headerAnimationLoop: false,
        animType: AnimType.bottomSlide,
        title: 'Hora no válida',
        desc: 'Por favor, elige una hora en intervalos de 20 minutos.',
        descTextStyle: TextStyle(color: Colors.green, fontSize: 18),
        btnOkOnPress: () {},
      ).show();
      return;
    }

      String formattedTime = selectedTime.format(context);

      if (await _isTurnoOcupado(_selectedDay!, formattedTime, servicioSeleccionado!.id)) {
        AwesomeDialog(
          context: context,
          dialogType: DialogType.warning,
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
          headerAnimationLoop: false,
          animType: AnimType.bottomSlide,
          title: 'Horario Ocupado.',
          desc: 'Eliga otro horario',
          descTextStyle: TextStyle(color: Colors.green, fontSize: 18),
          btnOkOnPress: () {},
        ).show();
        return;
      }

      setState(() {
        _selectedTime = formattedTime;
      });
      _saveSelectedDateAndTime();
    }
  }

  Future<bool> _showCancelDialog(BuildContext context) async {
    return await showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text("Cancelar Agendar"),
          content: Text("¿Estás seguro que deseas cancelar la agenda?"),
          actions: <Widget>[
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                TextButton(
                  child: Text("No"),
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                ),
                TextButton(
                  child: Text("Sí"),
                  onPressed: () {
                    Navigator.of(context).pushReplacementNamed('/home');
                  },
                ),
              ],
            ),
          ],
        );
      },
    );
  }

  bool isTimeWithinAllowedHours(TimeOfDay selectedTime) {
    return selectedTime.hour >= 9 &&
        (selectedTime.hour < 17 ||
            (selectedTime.hour == 17 && selectedTime.minute <= 40));
  }

  bool isTimeWithinSaturdayHours(TimeOfDay selectedTime) {
    return selectedTime.hour >= 9 && selectedTime.hour <= 13;
  }

  Widget buttonSubmit() {
    return ElevatedButton(
      child: Text('Generar Turno'),
      onPressed: () async {
        await generarTurno(context);
      },
    );
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
          Radius.circular(2)
        ),
        dismissOnTouchOutside: true,
        dismissOnBackKeyPress: false,
        headerAnimationLoop: false,
        animType: AnimType.bottomSlide,
        title: 'Seleccione un servicio',
        descTextStyle: TextStyle(color: Colors.green, fontSize: 18),
        btnOkOnPress: () {},
      ).show();
      return;
    }
    if (_selectedTime != null) {
      String formattedDateTime =
          '${_selectedDay!.year}-${_selectedDay!.month.toString().padLeft(2, '0')}-${_selectedDay!.day.toString().padLeft(2, '0')} $_selectedTime';

      Map<String, dynamic> datos = {
        'numero': numeroClienteCita,
        'pnombre': nombreCita,
        'snombre': segundoNombreCita,
        'papellido': apellidoCita,
        'sapellido': segundoApellidoCita,
        'registrarcliente': 'NO',
        'id_servicio': servicioSeleccionado!.id,
        'letra': servicioSeleccionado!.letra,
        'fechaInicio': '$formattedDateTime',
      };
      try {
        TurnoData? turnoData = await ApiService.generarTurno(datos, context, 'cita');
        if (turnoData != null) {
          print(turnoData.turno);
        }
        await _saveTurnoInCache(_selectedDay!, _selectedTime!, servicioSeleccionado!.id);
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
          headerAnimationLoop: false,
          animType: AnimType.bottomSlide,
          title: 'Turno Generado Con Exito',
          descTextStyle: TextStyle(color: Colors.green, fontSize: 18),
          btnOkOnPress: () {
            Navigator.of(context).pushReplacementNamed('/vercita');
          },
          btnCancelOnPress: (){},
        ).show();
      } catch (e) {
        AwesomeDialog(
          context: context,
          dialogType: DialogType.error,
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
          headerAnimationLoop: false,
          animType: AnimType.bottomSlide,
          title: 'Hubo un error al generar el turo.',
          desc: 'Intente mas tarde',
          descTextStyle: TextStyle(color: Colors.green, fontSize: 18),
          btnOkOnPress: () {},
        ).show();
      }
    }
  }
}
