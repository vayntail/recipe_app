import 'package:flutter/material.dart';
import 'package:recipe_app/app/ui/widgets/texts_widget.dart';
import 'package:table_calendar/table_calendar.dart';

class Calendar extends StatefulWidget {
  final CalendarFormat format;
  final Function setSelectedDay;
  const Calendar(
      {super.key, required this.format, required this.setSelectedDay});

  @override
  State<Calendar> createState() => _CalendarState();
}

class _CalendarState extends State<Calendar> {
  DateTime _focusedDay = DateTime.now();
  DateTime? _selectedDay;

  @override
  Widget build(BuildContext context) {

    bool setHeader() {
      if (widget.format == CalendarFormat.month) {
        return true;
      } else {
        return false;
      }
    }

    return 
      TableCalendar(
        focusedDay: _focusedDay,
        firstDay: DateTime.utc(2010, 12, 31),
        lastDay: DateTime.utc(2030, 01, 01),
        calendarFormat: widget.format, // View swapper (month or week)
        startingDayOfWeek: StartingDayOfWeek.sunday, // Start week from Sunday
        headerVisible: setHeader(), // Remove top month header
        headerStyle: HeaderStyle(
          formatButtonVisible: false,
        ),
        onPageChanged: (focusedDay) {
          _focusedDay = focusedDay;
          debugPrint("page changed");
        },
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
