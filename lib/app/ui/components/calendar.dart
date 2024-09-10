import 'package:flutter/material.dart';
import 'package:table_calendar/table_calendar.dart';

class Calendar extends StatefulWidget {
  final CalendarFormat calendarFormat;

  const Calendar({ Key? key, required this.calendarFormat}): super(key: key);



  @override
  State<Calendar> createState() => _CalendarState();
}

class _CalendarState extends State<Calendar> {
  DateTime _focusedDay = DateTime.now();
  DateTime? _selectedDay;

  @override
  Widget build(BuildContext context) {
    return TableCalendar(
          focusedDay: _focusedDay,
          firstDay: DateTime.utc(2024, 09, 8), // First accessible day
          lastDay: DateTime.utc(2024, 09, 14), // Last accessible day
          calendarFormat: widget.calendarFormat, // Show as a week view
          startingDayOfWeek: StartingDayOfWeek.sunday, // Start week from Sunday
          headerVisible: false, // Remove top month header
          selectedDayPredicate: (day) {
            return isSameDay(_selectedDay, day);
          },
          onDaySelected: (selectedDay, focusedDay) {
            if (!isSameDay(_selectedDay, selectedDay)){
              setState(() {
                _selectedDay = selectedDay;
                _focusedDay = focusedDay;
              });
            }
          },
          onPageChanged: (focusedDay) {
          _focusedDay = focusedDay;
        },
        );
  }
}