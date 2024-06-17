
// import 'dart:async';

// import 'package:awesome_notifications/awesome_notifications.dart';
// import 'package:flutter/material.dart';
// import 'package:table_calendar/table_calendar.dart';
// import 'package:awesome_dialog/awesome_dialog.dart';
// import 'package:turnos_amerisa/model/event.dart';
// import 'package:turnos_amerisa/model/services/generar_turno_service.dart';
// import 'package:turnos_amerisa/model/services/users_service.dart';

// class Calendar extends StatefulWidget {
//   Calendar({super.key});

//   @override
//   State<Calendar> createState() => _CalendarState();
// }

// class _CalendarState extends State<Calendar> {
//   CalendarFormat _calendarFormat = CalendarFormat.month;
//   DateTime _today = DateTime.now();
//   DateTime? _selectedDay;
//   Map<DateTime, List<Event>> events = {};
//   late final ValueNotifier<List<Event>> _selectedEvents;
//   bool _isTimeSelectorVisible = false;
//   String? _selectedService;
//   String? _selectedTime;
//   final List<String> _services = ["Carga", "Descarga", "Papeleo"];
//   List<String> availableTimes = [
//       '9:00 AM',
//       '11:00 AM',
//       '1:00 PM',
//       '3:00 PM',
//       '5:00 PM'
//     ];
//     late Timer _timer;
//     int _counter = 300;
//     bool _showCounter = true;
//     String? _selectedItem;
//     List<Map<String, dynamic>> _servicios = [];
//     bool _isLoading = true;

//   Future<void> _fetchData() async {
//     try {
//       final servicios = await verServicios();
//       setState(() {
//         _servicios = servicios;
//         _isLoading = false;
//       });
//     } catch (error) {
//       print('Error: $error');
//       setState(() {
//         _isLoading = false;
//       });
//     }
//   }
  
//   void initState() {
//     AwesomeNotifications().isNotificationAllowed().then((isAllowed){
//         if(!isAllowed){
//           AwesomeNotifications().requestPermissionToSendNotifications();
//         }
//       }
//     );
//     super.initState();
//     _fetchData();
//     _startTimer();
//     _selectedDay = _today;
//     _selectedEvents = ValueNotifier(_getEventForDay(_selectedDay!));
//   }

//   @override
//   void dispose() {
//     _timer.cancel();
//     super.dispose();
//   }

//   void _startTimer() {
//     _timer = Timer.periodic(Duration(seconds: 1), (Timer timer) {
//       setState(() {
//         if (_counter > 0) {
//           _counter--;
//         } else {
//           timer.cancel();
//           _showCounter = false;
//           Navigator.pushNamed(context, '/home');
//         }
//       });
//     });
//   }

//   List<Event> _getEventForDay(DateTime day) {
//     return events[day] ?? [];
//   }

//   void _onDaySelected(DateTime selectedDay, DateTime focusedDay) {
//     if (!isSameDay(_selectedDay, selectedDay)) {
//       setState(() {
//         _selectedDay = selectedDay;
//         _today = focusedDay;
//         _selectedEvents.value = _getEventForDay(selectedDay);
//         _isTimeSelectorVisible = true;
//       });
//     }
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         automaticallyImplyLeading: false,
//         title: Text("Agenda tu Cita"),
//         centerTitle: true,
//       ),
//       body: SingleChildScrollView(
//         child: Column(
//           children: [
//             if (_showCounter)
//             countCalendar(),
//             calendarTable(),
//             SizedBox(height: 16),
//             if (_isTimeSelectorVisible)
//             servicesCalendar(),
//             buttonSubmmitTurno()
//           ],
//         ),
//       ),
//     );
//   }

//   void scheduleNotification(){
//     if (_selectedTime != null){
//       String selectedDayFormatted = '${_selectedDay!.day}';
//       String selectedMonth = '${_selectedDay!.month}';
//       AwesomeNotifications().createNotification(
//         content: NotificationContent(
//           id: 2,
//           channelKey: 'basic_channel',
//           title: 'Horario Confirmado el día $selectedDayFormatted de $selectedMonth',
//           body: 'Horario elegida: $_selectedTime',
//           backgroundColor: Colors.blue
//         )
//       );
//     }
//   }

//   Widget calendarTable(){
//     return TableCalendar(
//       focusedDay: _today,
//       firstDay: DateTime.now(),
//       lastDay: DateTime.utc(2030, 3, 14),
//       selectedDayPredicate: ((day) => isSameDay(_selectedDay, day)),
//       calendarFormat: _calendarFormat,
//       startingDayOfWeek: StartingDayOfWeek.monday,
//       onDaySelected: _onDaySelected,
//       eventLoader: _getEventForDay,
//       calendarStyle: CalendarStyle(
//         outsideDaysVisible: false,
//       ),
//       onFormatChanged: (format) {
//         if (_calendarFormat != format) {
//           setState(() {
//             _calendarFormat = format;
//           });
//         }
//       },
//       onPageChanged: (focusedDay) {
//         setState(() {
//           _today = focusedDay;
//         });
//       },
//     );
//   }

//   Widget countCalendar(){
//     return Positioned(
//       top: -40,
//       right: 16,
//       child: Container(
//         padding: EdgeInsets.all(8),
//         decoration: BoxDecoration(
//           color: Colors.blue,
//           borderRadius: BorderRadius.circular(8),
//         ),
//         child: Text(
//           'Tiempo restante: ${_counter ~/ 60}:${(_counter % 60).toString().padLeft(2, '0')}',
//           style: TextStyle(
//             fontSize: 16,
//             fontWeight: FontWeight.w500,
//             color: Colors.white,
//           ),
//         ),
//       ),
//     );
//   }

//   Widget servicesCalendar(){
//     return Padding(
//       padding: EdgeInsets.symmetric(horizontal: 16),
//       child: Column(
//         children: [
//         //   Text("Seleccione un horario disponible:"),
//         //   ...availableTimes.map((time) {
//         //     return ListTile(
//         //       title: Text(time),
//         //       onTap: () {
//         //         setState(() {
//         //           _selectedService = null;
//         //           _selectedTime = time;
//         //         });
//         //         AwesomeDialog(
//         //           context: context,
//         //           dialogType: DialogType.info,
//         //           borderSide: BorderSide(
//         //             color: Colors.blue,
//         //             width: 2,
//         //           ),
//         //           width: 280,
//         //           buttonsBorderRadius: BorderRadius.all(
//         //             Radius.circular(2),
//         //           ),
//         //           dismissOnTouchOutside: true,
//         //           dismissOnBackKeyPress: false,
//         //           onDismissCallback: (type) {
//         //             debugPrint('Dialog Dismiss from callback $type');
//         //           },
//         //           headerAnimationLoop: false,
//         //           animType: AnimType.bottomSlide,
//         //           body: Column(
//         //             children: [
//         //               Text('Has seleccionado el horario de las $time'),
//         //               Text("Seleccione un tipo de servicio:"),
//         //               DropdownButtonFormField<String>(
//         //                 value: _selectedService,
//         //                 items: _services.map((service) {
//         //                   return DropdownMenuItem<String>(
//         //                     value: service,
//         //                     child: Text(service),
//         //                   );
//         //                 }).toList(),
//         //                 onChanged: (value) {
//         //                   setState(() {
//         //                     _selectedService = value;
//         //                   });
//         //                 },
//         //                 decoration: InputDecoration(
//         //                   labelText: 'Tipo de servicio',
//         //                 ),
//         //               ),
//         //             ],
//         //           ),
//         //           btnOkOnPress: () {
//         //             if (_selectedService != null) {
//         //               AwesomeDialog(
//         //                 context: context,
//         //                 dialogType: DialogType.success,
//         //                 borderSide: BorderSide(
//         //                   color: Colors.blue,
//         //                   width: 2,
//         //                 ),
//         //                 width: 280,
//         //                 buttonsBorderRadius: BorderRadius.all(
//         //                   Radius.circular(2),
//         //                 ),
//         //                 dismissOnTouchOutside: true,
//         //                 dismissOnBackKeyPress: false,
//         //                 onDismissCallback: (type) {
//         //                   debugPrint('Dialog Dismiss from callback $type');
//         //                 },
//         //                 headerAnimationLoop: false,
//         //                 animType: AnimType.topSlide,
//         //                 title: 'Generado con éxito',
//         //                 descTextStyle: TextStyle(color: Colors.green, fontSize: 18),
//         //                 btnOkOnPress: () async {
//         //                   _timer.cancel();
//         //                   setState(() {
//         //                     _showCounter = false; 
//         //                   });
//         //                   scheduleNotification();
//         //                   Navigator.pushNamed(context, '/rows');
//         //                 },
//         //               ).show();
//         //             } else {
//         //               AwesomeDialog(
//         //                 context: context,
//         //                 dialogType: DialogType.warning,
//         //                 borderSide: BorderSide(
//         //                   color: Colors.orange,
//         //                   width: 2,
//         //                 ),
//         //                 width: 280,
//         //                 buttonsBorderRadius: BorderRadius.all(
//         //                   Radius.circular(2),
//         //                 ),
//         //                 dismissOnTouchOutside: true,
//         //                 dismissOnBackKeyPress: false,
//         //                 onDismissCallback: (type) {
//         //                   debugPrint('Dialog Dismiss from callback $type');
//         //                 },
//         //                 headerAnimationLoop: false,
//         //                 animType: AnimType.bottomSlide,
//         //                 title: 'Seleccione un servicio',
//         //                 desc: 'Debe seleccionar un tipo de servicio para continuar.',
//         //                 btnOkOnPress: () {},
//         //               ).show();
//         //             }
//         //           },
//         //           btnCancelOnPress: () {},
//         //         ).show();
//         //       },
//         //     );
//         //   }),
//         Text("Seleccione un horario disponible:"),
//         ...availableTimes.map((time) {
//             return ListTile(
//               title: Text(time),
//               onTap: () {
//                 setState(() {
//                   _selectedTime = time;
//                 });
//               }
//             );
//           }
//         ),
//         _isLoading
//               ? CircularProgressIndicator()
//               : DropdownButton<String>(
//                   value: _selectedItem,
//                   onChanged: (String? newValue) {
//                     setState(() {
//                       _selectedItem = newValue;
//                     });
//                   },
//                   items: _servicios.map<DropdownMenuItem<String>>((servicio) {
//                     return DropdownMenuItem<String>(
//                       value: servicio['id'].toString(),
//                       child: Text(servicio['nombre_servicio']),
//                     );
//                   }).toList(),
//                 ),
//         ],
//       ),
//     );
//   }

//   Widget buttonSubmmitTurno(){
//     return ElevatedButton(
//       onPressed: (){
//         // generarTurno();
//         _timer.cancel();
//       setState(() {
//         _showCounter = false; 
//       });
//       scheduleNotification();
//       Navigator.pushNamed(context, '/rows');
//       },
//       child: Text('Genera turno')
//     );
//   }
// }

