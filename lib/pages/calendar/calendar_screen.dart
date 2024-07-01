import 'dart:async';
import 'package:awesome_notifications/awesome_notifications.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart'; // Importa el paquete intl
import 'package:shared_preferences/shared_preferences.dart';
import 'package:table_calendar/table_calendar.dart';
import 'package:turnos_amerisa/model/api.dart';
import 'package:turnos_amerisa/model/event.dart';
import 'package:turnos_amerisa/services/generar_turno_service.dart';
import 'package:turnos_amerisa/pages/turnos/servicios_select.dart';

class Calendar extends StatefulWidget {
  Calendar({super.key});

  @override
  State<Calendar> createState() => _CalendarState();
}

class _CalendarState extends State<Calendar> {
  Servicio? servicioSeleccionado;

  CalendarFormat _calendarFormat = CalendarFormat.month;
  DateTime _today = DateTime.now();
  DateTime? _selectedDay;
  Map<DateTime, List<Event>> events = {};
  late final ValueNotifier<List<Event>> _selectedEvents;
  bool _isTimeSelectorVisible = false;
  String? _selectedTime;
  List<String> availableTimes = ['9:00 AM','9:20 AM','9:40 AM','10:00 AM','10:20 AM','10:40 AM','11:00 AM','11:20 AM','11:40 AM','12:00 PM','12:20 PM','12:40 PM','1:00 PM','1:20 AM','1:40 AM',
  '2:00 PM','2:20 PM','2:40 PM','3:00 PM','3:20 PM','3:40 PM','4:00 PM','4:20 PM','4:40 PM','5:00 PM','5:20 PM','5:40 AM','6:00 PM'];
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
    AwesomeNotifications().isNotificationAllowed().then((isAllowed) {
      if (!isAllowed) {
        AwesomeNotifications().requestPermissionToSendNotifications();
      }
    });
    super.initState();
    _startTimer();
    _selectedDay = _today;
    _selectedEvents = ValueNotifier(_getEventForDay(_selectedDay!));
    loadUserData();
  }

  Future<void> mostrarDetallesServicio(Servicio servicios) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setInt('idServicio', servicios.id);
    await prefs.setString('nombreServicio', servicios.nombre);
    await prefs.setString('letraServicio', servicios.letra);
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
              calendarTable(),
            SizedBox(height: 16),
            if (_isTimeSelectorVisible)
              servicesCalendar(),
          ],
        ),
      ),
    );
  }

  void scheduleNotification() {
    if (_selectedTime != null) {
      String selectedDayFormatted = '${_selectedDay!.day}';
      String selectedMonth = '${_selectedDay!.month}';
      AwesomeNotifications().createNotification(
        content: NotificationContent(
          id: 2,
          channelKey: 'basic_channel',
          title: 'Horario Confirmado el día $selectedDayFormatted de $selectedMonth',
          body: 'Horario elegida: $_selectedTime',
          backgroundColor: Colors.blue,
        ),
      );
    }
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
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                _selectedTime ?? '',
                style: TextStyle(fontSize: 16),
              ),
              ElevatedButton(
                child: Text('Selecciona una hora'),
                onPressed: () => _selectTime(context),
              ),
            ],
          ),
        ],
      ),
    );
  }

  void _selectTime(BuildContext context) async {
    String? selectedTime = await showDialog<String>(
      context: context,
      builder: (BuildContext context) {
        return SimpleDialog(
          title: Text('Seleccione un horario'),
          children: availableTimes.map((time) {
            return SimpleDialogOption(
              onPressed: () {
                Navigator.pop(context, time);
              },
              child: Text(time),
            );
          }).toList(),
        );
      },
    );

    if (selectedTime != null) {
      setState(() {
        _selectedTime = selectedTime;
      });
      _saveSelectedDateAndTime();
      alertDialog();
    }
  }

  Future alertDialog() {
    return showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          content: GetDatos(),
        );
      },
    );
  }

  Future<void> generarTurno(BuildContext context) async {
    if (servicioSeleccionado == null) {
      Text('Selecciona un servicio');
      return;
    }
    if (_selectedTime != null) {
      String formattedDateTime = '${_selectedDay!.year}-${_selectedDay!.month.toString().padLeft(2, '0')}-${_selectedDay!.day.toString().padLeft(2, '0')} $_selectedTime';

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
        await ApiService.generarTurno(datos, context);
      } catch (e) {
        print('Error al generar turno: $e');
      }
    } else {}
  }

  Widget GetDatos() {
    return SingleChildScrollView(
      padding: EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
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
          SizedBox(height: 16.0),
          ElevatedButton(
            onPressed: () {
              generarTurno(context);
              _timer.cancel();
              setState(() {
                _showCounter = false;
              });
              scheduleNotification();
              Navigator.of(context).pushReplacementNamed('/vercita');
            },
            child: Text('Generar Turno'),
          ),
        ],
      ),
    );
  }
}
