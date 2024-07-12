import 'dart:async';
import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:table_calendar/table_calendar.dart';
import 'package:turnos_amerisa/model/event.dart';
import 'package:turnos_amerisa/model/servicios_model.dart';
import 'package:turnos_amerisa/pages/turnos/servicios_select.dart';
import 'package:turnos_amerisa/services/generar_turno_service.dart';

class Calendar extends StatefulWidget {
  Calendar({Key? key}) : super(key: key);

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

      // Verificar si ya existe una cita programada para esta fecha y hora
      String formattedDateTime = '${_selectedDay!.year}-${_selectedDay!.month.toString().padLeft(2, '0')}-${_selectedDay!.day.toString().padLeft(2, '0')} $_selectedTime';
      int? storedServiceId = prefs.getInt('storedServiceId');
      String? storedDateTime = prefs.getString('storedDateTime');

      if (formattedDateTime == storedDateTime && servicioSeleccionado!.id == storedServiceId) {
        AwesomeDialog(
          context: context,
          dialogType: DialogType.info,
          title: 'Cita ya generada',
          desc: 'Ya has generado una cita para este servicio en esta fecha y hora.',
          btnOkOnPress: () {},
        ).show();
        return;
      }
    }
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
    if (!isSameDay(_selectedDay, selectedDay)) {
      setState(() {
        _selectedDay = selectedDay;
        _today = focusedDay;
        _selectedEvents.value = _getEventForDay(selectedDay);
        _isTimeSelectorVisible = true;
        _selectedTime = null; // Resetear el tiempo seleccionado al cambiar el día
        servicioSeleccionado = null; // Resetear el servicio seleccionado al cambiar el día
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
              calendarTable(),
            SizedBox(height: 16),
            if (_isTimeSelectorVisible)
              servicesCalendar(),
          ],
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

  Widget servicesCalendar() {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(height: 8),
          if (_selectedDay != null)
            Text(
              'Fecha seleccionada: ${DateFormat('dd/MM/yyyy').format(_selectedDay!)}',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
          SizedBox(height: 16),
          ServiciosSelect(
            onServicioSelected: (servicio) {
              setState(() {
                servicioSeleccionado = servicio;
              });
              if (servicio != null) {
                mostrarDetallesServicio(servicio);
              }
            },
          ),
          SizedBox(height: 16),
          if (servicioSeleccionado != null)
            Text(
              'Servicio seleccionado: ${servicioSeleccionado!.nombre}',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
          SizedBox(height: 8),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              ElevatedButton(
                child: Text('Selecciona una hora'),
                onPressed: () => _selectTime(context),
              ),
            ],
          ),
          SizedBox(height: 16),
          if (_selectedTime != null)
            ElevatedButton(
              onPressed: () {
                _saveSelectedDateAndTime(); // Guarda la fecha y hora seleccionadas primero

                // Aquí se mostrará el diálogo de confirmación antes de generar el turno
                AwesomeDialog(
                  context: context,
                  dialogType: DialogType.success,
                  borderSide: const BorderSide(
                    color: Colors.blue,
                    width: 2,
                  ),
                  width: 280,
                  buttonsBorderRadius: const BorderRadius.all(
                    Radius.circular(2),
                  ),
                  dismissOnTouchOutside: false,
                  dismissOnBackKeyPress: false,
                  onDismissCallback: (type) {
                    debugPrint('Dialog Dismiss from callback $type');
                  },
                  headerAnimationLoop: false,
                  animType: AnimType.topSlide,
                  title: 'Cita Generada',
                  descTextStyle: const TextStyle(color: Colors.green, fontSize: 18),
                  btnOkOnPress: () async {
                    generarTurnoSchedule(context); // Llama a la función para generar el turno
                  },
                ).show();
              },
              child: Text('Generar Turno'),
              style: ElevatedButton.styleFrom(
                textStyle: TextStyle(fontSize: 16.0),
                minimumSize: Size(MediaQuery.of(context).size.width - 46, 50),
                backgroundColor: Color.fromARGB(255, 35, 38, 204),
              ),
            ),
        ],
      ),
    );
  }

  void _selectTime(BuildContext context) async {
    if (_selectedDay == null) {
      AwesomeDialog(
        context: context,
        dialogType: DialogType.warning,
        title: 'Selecciona una Fecha',
        desc: 'Debes seleccionar una fecha antes de elegir un horario.',
        btnCancelOnPress: () {},
      ).show();
      return;
    }

    if (servicioSeleccionado == null) {
      AwesomeDialog(
        context: context,
        dialogType: DialogType.warning,
        title: 'Selecciona un Servicio',
        desc: 'Debes seleccionar un servicio antes de elegir un horario.',
        btnCancelOnPress: () {},
      ).show();
      return;
    }

    TimeOfDay? pickedTime = await showTimePicker(
      context: context,
      initialTime: TimeOfDay.now(),
    );

    if (pickedTime != null) {
      setState(() {
        _selectedTime = '${pickedTime.hour}:${pickedTime.minute.toString().padLeft(2, '0')}';
      });
    }

    // Verificar si el tiempo seleccionado está disponible
    if (_isTimeDisabled(DateTime(_selectedDay!.year, _selectedDay!.month, _selectedDay!.day), _selectedTime!)) {
      AwesomeDialog(
        context: context,
        dialogType: DialogType.error,
        title: 'Hora no disponible',
        desc: 'La hora seleccionada ya está reservada. Por favor, elige otro horario.',
        btnCancelOnPress: () {},
      ).show();
      setState(() {
        _selectedTime = null;
      });
    }
  }

  bool _isTimeDisabled(DateTime selectedDateTime, String time) {
    List<Event> eventsForSelectedDay = events[selectedDateTime] ?? [];
    return eventsForSelectedDay.any((event) => event.time == time && event.servicioId == servicioSeleccionado!.id);
  }

  Future<void> generarTurnoSchedule(BuildContext context) async {
    if (servicioSeleccionado == null || _selectedTime == null || _selectedDay == null) {
      return;
    }

    String formattedDateTime = '${_selectedDay!.year}-${_selectedDay!.month.toString().padLeft(2, '0')}-${_selectedDay!.day.toString().padLeft(2, '0')} $_selectedTime';

    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? storedDateTime = prefs.getString('storedDateTime');
    int? storedServiceId = prefs.getInt('storedServiceId');

    if (formattedDateTime == storedDateTime && servicioSeleccionado!.id == storedServiceId) {
      AwesomeDialog(
        context: context,
        dialogType: DialogType.info,
        title: 'Cita ya generada',
        desc: 'Ya has generado una cita para este servicio en esta fecha y hora.',
        btnOkOnPress: () {},
      ).show();
      return;
    }

    // Guardar los nuevos datos seleccionados
    await prefs.setString('storedDateTime', formattedDateTime);
    await prefs.setInt('storedServiceId', servicioSeleccionado!.id);

    Map<String, dynamic> datos = {
      'numero': numeroClienteCita,
      'pnombre': nombreCita,
      'snombre': segundoNombreCita,
      'papellido': apellidoCita,
      'sapellido': segundoApellidoCita,
      'registrarcliente': 'NO',
      'id_servicio': servicioSeleccionado!.id,
      'letra': servicioSeleccionado!.letra,
      'fechaInicio': formattedDateTime,
    };
    try {
      await ApiService.generarTurno(datos, context);
      _timer.cancel();
      setState(() {
        _showCounter = false;
      });
      Navigator.of(context).pushReplacementNamed('/vercita');
    } catch (e) {
      print('Error al generar turno: $e');
    }
  }
}
