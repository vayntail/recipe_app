import 'package:flutter/material.dart';
import 'package:table_calendar/table_calendar.dart';

class Calendar extends StatefulWidget {
  final CalendarFormat format;
  final Function setSelectedDay;
  const Calendar({super.key, required this.format, required this.setSelectedDay});

  @override
  State<Calendar> createState() => _CalendarState();
}

class _CalendarState extends State<Calendar> {
  DateTime _focusedDay = DateTime.now();
  DateTime? _selectedDay;

  @override
  Widget build(BuildContext context) {
    // Set first accessible day (Need to change later)
    DateTime firstAccessibleDay = DateTime.utc(2024, 09, 8);
    // Set last accessible day, set to current day for now
    DateTime lastAccessibleDay = DateTime.now();

    return TableCalendar(
      focusedDay: _focusedDay,
      firstDay: firstAccessibleDay,
      lastDay: lastAccessibleDay,
      calendarFormat: widget.format, // View swapper (month or week)
      startingDayOfWeek: StartingDayOfWeek.sunday, // Start week from Sunday
      headerVisible: false, // Remove top month header
      selectedDayPredicate: (day) {
        return isSameDay(_selectedDay, day);
      },
      onDaySelected: (selectedDay, focusedDay) {
        if (!isSameDay(_selectedDay, selectedDay)) {
          setState(() {
            _selectedDay = selectedDay;
            _focusedDay = focusedDay;
            widget.setSelectedDay(_focusedDay);
          });
        }
      },
    );
  }
}
