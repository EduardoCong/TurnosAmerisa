
import 'package:awesome_notifications/awesome_notifications.dart';
import 'package:flutter/material.dart';
import 'package:table_calendar/table_calendar.dart';
import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:turnos_amerisa/model/event.dart';

class Calendar extends StatefulWidget {
  const Calendar({super.key});

  @override
  State<Calendar> createState() => _CalendarState();
}

class _CalendarState extends State<Calendar> {
  CalendarFormat _calendarFormat = CalendarFormat.month;
  DateTime _today = DateTime.now();
  DateTime? _selectedDay;
  Map<DateTime, List<Event>> events = {};
  late final ValueNotifier<List<Event>> _selectedEvents;
  bool _isTimeSelectorVisible = false;
  String? _selectedService;
  String? _selectedTime;
  final List<String> _services = ["Carga", "Descarga", "Papeleo"];
  List<String> availableTimes = [
      '9:00 AM',
      '11:00 AM',
      '1:00 PM',
      '3:00 PM',
      '5:00 PM'
    ];

  @override
  void initState() {
    AwesomeNotifications().isNotificationAllowed().then((isAllowed){
        if(!isAllowed){
          AwesomeNotifications().requestPermissionToSendNotifications();
        }
      }
    );
    super.initState();
    _selectedDay = _today;
    _selectedEvents = ValueNotifier(_getEventForDay(_selectedDay!));
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
        title: const Text("Agenda tu Cita"),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        child: Column(
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
              calendarStyle: const CalendarStyle(
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
            const SizedBox(height: 16),
            if (_isTimeSelectorVisible)
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: Column(
                  children: [
                    const Text("Seleccione un horario disponible:"),
                    ...availableTimes.map((time) {
                      return ListTile(
                        title: Text(time),
                        onTap: () {
                          setState(() {
                            _selectedService = null;
                            _selectedTime = time;
                          });
                          AwesomeDialog(
                            context: context,
                            dialogType: DialogType.info,
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
                            animType: AnimType.bottomSlide,
                            body: Column(
                              children: [
                                Text('Has seleccionado el horario de las $time'),
                                const Text("Seleccione un tipo de servicio:"),
                                DropdownButtonFormField<String>(
                                  value: _selectedService,
                                  items: _services.map((service) {
                                    return DropdownMenuItem<String>(
                                      value: service,
                                      child: Text(service),
                                    );
                                  }).toList(),
                                  onChanged: (value) {
                                    setState(() {
                                      _selectedService = value;
                                    });
                                  },
                                  decoration: const InputDecoration(
                                    labelText: 'Tipo de servicio',
                                  ),
                                ),
                              ],
                            ),
                            btnOkOnPress: () {
                              if (_selectedService != null) {
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
                                  dismissOnTouchOutside: true,
                                  dismissOnBackKeyPress: false,
                                  onDismissCallback: (type) {
                                    debugPrint('Dialog Dismiss from callback $type');
                                  },
                                  headerAnimationLoop: false,
                                  animType: AnimType.topSlide,
                                  title: 'Generado con éxito',
                                  descTextStyle: const TextStyle(color: Colors.green, fontSize: 18),
                                  btnOkOnPress: () async {
                                    scheduleNotification();
                                    Navigator.pushNamed(context, '/rows');
                                  },
                                ).show();
                              } else {
                                AwesomeDialog(
                                  context: context,
                                  dialogType: DialogType.warning,
                                  borderSide: const BorderSide(
                                    color: Colors.orange,
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
                                  animType: AnimType.bottomSlide,
                                  title: 'Seleccione un servicio',
                                  desc: 'Debe seleccionar un tipo de servicio para continuar.',
                                  btnOkOnPress: () {},
                                ).show();
                              }
                            },
                            btnCancelOnPress: () {},
                          ).show();
                        },
                      );
                    }),
                  ],
                ),
              ),
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
          body: 'Horario elegido: $_selectedTime',
          backgroundColor: Colors.blue
        )
      );
    }
  }
}

