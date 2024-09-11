import 'package:flutter/material.dart';

import 'package:dotted_border/dotted_border.dart';
import 'package:recipe_app/app/ui/components/calendar.dart';
import 'package:table_calendar/table_calendar.dart';

class CalendarView extends StatefulWidget {
  const CalendarView({super.key});
  @override
  State<CalendarView> createState() => _CalendarViewState();
}

class _CalendarViewState extends State<CalendarView> {
  CalendarFormat calendarFormat = CalendarFormat.week;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Calendar'), actions: <Widget>[
        IconButton(
            icon: const Icon(Icons.calendar_month),
            tooltip: 'Month View',
            onPressed: () {
              setState(() {
                if (calendarFormat == CalendarFormat.month) {
                  calendarFormat = CalendarFormat.week;
                } else {
                  calendarFormat = CalendarFormat.month;
                }
              });
            })
      ]),
      body: Column(children: [
        Calendar(calendarFormat: calendarFormat),
        Expanded(
            child: Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: const Color.fromARGB(255, 255, 231, 231),
                  border: Border.all(
                    color: Colors.black,
                    width: 2.0,
                  ),
                ),
                child: ListView(
                  children: const [
                    Text("Breakfast"),
                    PlanButton(),
                    Text("Lunch"),
                    PlanButton(),
                    Text("Snack"),
                    PlanButton(),
                    Text("Dinner"),
                    PlanButton(),
                  ],
                )))
      ]),
    );
  }
}

class PlanButton extends StatefulWidget {
  const PlanButton({super.key});

  @override
  State<PlanButton> createState() => _PlanButtonState();
}

class _PlanButtonState extends State<PlanButton> {
  @override
  Widget build(BuildContext context) {
    return DottedBorder(
        borderType: BorderType.RRect,
        radius: const Radius.circular(12),
        dashPattern: const [10, 5],
        child: const ClipRRect(
          borderRadius: BorderRadius.all(Radius.circular(12)),
          child: SizedBox(
              height: 100, child: Center(child: Text("Select a Recipe"))),
        ));
  }
}
