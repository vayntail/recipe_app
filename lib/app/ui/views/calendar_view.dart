import 'package:flutter/material.dart';
import 'package:dotted_border/dotted_border.dart';
import 'package:recipe_app/app/model/recipe.dart';
import 'package:recipe_app/app/ui/components/calendar.dart';
import 'package:recipe_app/app/ui/components/recipe_button.dart';
import 'package:recipe_app/app/ui/screens/meal_selection_screen.dart';
import 'package:table_calendar/table_calendar.dart';

class CalendarView extends StatefulWidget {
  const CalendarView({super.key});
  @override
  State<CalendarView> createState() => _CalendarViewState();
}

class _CalendarViewState extends State<CalendarView> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(title: const Text('Calendar'), actions: <Widget>[
          IconButton(
            onPressed: () {},
            icon: const Icon(Icons.calendar_month),
          ),
        ]),
        body: Column(
          children: [
            Expanded(
              child: ListView(children: [
                PlanButton(),
              ]),
            )
          ],
        ));
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
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context, MaterialPageRoute(
            // Swap to meal selection screen
            builder: (context) => const MealSelectionScreen()
          )
        );
      },
        child: DottedBorder(
            borderType: BorderType.RRect,
            radius: const Radius.circular(12),
            dashPattern: const [10, 5],
            child: const ClipRRect(
              borderRadius: BorderRadius.all(Radius.circular(12)),
              child: SizedBox(
                  height: 100, child: Center(child: Text("Select a Recipe"))),
            )));
  }
}
