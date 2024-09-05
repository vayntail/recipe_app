import 'package:flutter/material.dart';

class CalendarView extends StatelessWidget {
  const CalendarView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Calendar'), actions: <Widget>[
                    IconButton(
              icon: const Icon(Icons.calendar_month),
              tooltip: 'Month View',
              onPressed: () {})
        ]),
      body: const Placeholder(),
    );
  }
}