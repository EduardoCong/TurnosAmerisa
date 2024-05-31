// ignore_for_file: use_build_context_synchronously

import 'package:awesome_notifications/awesome_notifications.dart';
import 'package:flutter/material.dart';

void confirmacionNotification() {
  AwesomeNotifications().createNotification(
    content: NotificationContent(
      id: 1,
      channelKey: 'basic_channel',
      title: '¡Turno generado exitosamente!✅',
      body: 'Por favor, espera hasta que sea tu turno.',
      backgroundColor: Colors.blue,
    ),
  );
}

void turnOnNotification() {
  AwesomeNotifications().createNotification(
    content: NotificationContent(
      id: 3,
      channelKey: 'basic_channel',
      title: '¡Es tu turno ahora!✅',
      body: 'Por favor, pasa al anden 5.',
      summary: 'Tienes 10 minutos para ir al lugar',
      backgroundColor: Colors.blue,
    ),
  );
}

void showNotification(BuildContext context) async {
  NotificationActionButton button = NotificationActionButton(
    key: 'OPEN_PAGE',
    label: 'Calificanos',
  );
  AwesomeNotifications().createNotification(
    content: NotificationContent(
      id: 10,
      channelKey: 'basic_channel',
      title: '¡Turno terminado!',
      body: '¡Gracias!',
    ),
    actionButtons: [button],
  );
  await Future.delayed(const Duration(seconds: 1));
  Navigator.pushNamed(context, '/rating');
}
