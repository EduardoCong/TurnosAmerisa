// ignore_for_file: library_private_types_in_public_api
import 'dart:async';
import 'package:flutter/material.dart';

class CountdownWidget extends StatefulWidget {
  final int initialCountdown;

  const CountdownWidget(this.initialCountdown, {super.key});

  @override
  _CountdownWidgetState createState() => _CountdownWidgetState();
}

class _CountdownWidgetState extends State<CountdownWidget> {
  int _countdown = 0;

  @override
  void initState() {
    super.initState();
    startCountdown(widget.initialCountdown, (countdown) {
      setState(() {
        _countdown = countdown;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Text(
      '$_countdown segundos',
      style: const TextStyle(fontSize: 24.0),
    );
  }

  void startCountdown(int initialCountdown, ValueChanged<int> onTick) {
  late Timer timer;
  int countdown = initialCountdown;

  timer = Timer.periodic(const Duration(seconds: 1), (timer) {
    if (countdown < 1) {
      timer.cancel();
    } else {
      onTick(countdown);
      countdown--;
    }
  });
}
}
