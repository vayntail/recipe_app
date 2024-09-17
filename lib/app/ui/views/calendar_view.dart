import 'package:flutter/material.dart';
import 'package:dotted_border/dotted_border.dart';
import 'package:recipe_app/app/model/calendar_day.dart';
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
  CalendarFormat format = CalendarFormat.week; // Used to swap when month view button clicked
  DateTime _selectedDay = DateTime.now();

  // place holder calendar
  CalendarDay _calendarDay = CalendarDay(
    breakfast: [], 
    lunch: [], 
    dinner: [], 
    snacks: []
  );

  @override
  Widget build(BuildContext context) {

    // Set the current focused day (Called by calendar.dart)
    setSelectedDay(DateTime day){
      setState(() {
        _selectedDay = day;
      });

      // Get the selected day's Calendar object from the database using day
      CalendarDay getCalendarDay(){
        return _calendarDay;
      }

    }
    // Get day of the week from _selectedDay.weekday
    String getDayOfWeek(int weekday){
      switch (weekday){
        case 1:
          return "Monday";
        case 2:
          return "Tuesday";
        case 3:
          return "Wednesday";
        case 4:
          return "Thursday";
        case 5:
          return "Friday";
        case 6:
          return "Saturday";
        case 7:
          return "Sunday";
        default:
          return "";
      }
    }
    

    return Scaffold(
        appBar: AppBar(title: const Text('Calendar'), actions: <Widget>[
          IconButton(
            onPressed: () {
              setState(() {
                if (format==CalendarFormat.week){
                  format=CalendarFormat.month;
                }
                else {
                  format=CalendarFormat.week;
                }
              });
            },
            icon: const Icon(Icons.calendar_month),
            selectedIcon: const Icon(Icons.calendar_view_week),
          ),
        ]),
        body: Column(
          children: [
            Calendar(format: format, setSelectedDay: setSelectedDay,),
            Expanded(
              child: ListView(children: [
                Text(
                  // Display currently selected date to screen
                  "${getDayOfWeek(_selectedDay.weekday)}, ${_selectedDay.month}-${_selectedDay.day}",
                  style: const TextStyle(fontSize: 23)
                  ),
                const Text("Breakfast"),
                MealTypeColumn(selectedMeals:_calendarDay.breakfast, calendarDay: _calendarDay, mealType: 1,),
                const Text("Lunch"),
                MealTypeColumn(selectedMeals:_calendarDay.lunch, calendarDay: _calendarDay, mealType: 2,),
                const Text("Dinner"),
                MealTypeColumn(selectedMeals:_calendarDay.dinner, calendarDay: _calendarDay, mealType: 3,),
                const Text("Snacks"),
                MealTypeColumn(selectedMeals:_calendarDay.snacks, calendarDay: _calendarDay, mealType: 4,),
              ]),
            )
          ],
        ));
  }
}

class MealTypeColumn extends StatefulWidget {
  final List<Recipe> selectedMeals; // list of recipes for this mealtype from the data base calendar.
  final CalendarDay calendarDay;
  final int mealType; // specify mealtype. 1=breakfast, 2=lunch, 3=dinner 4=snacks
  const MealTypeColumn({super.key, required this.selectedMeals, required this.calendarDay, required this.mealType});

  @override 
  State<MealTypeColumn> createState() => _MealTypeColumnState();
}
class _MealTypeColumnState extends State<MealTypeColumn> {
  @override
  Widget build(BuildContext context) {
    // Display button per element
    if (widget.selectedMeals.isNotEmpty){
        return Column(
            children: [for (var meal in widget.selectedMeals) 
            GestureDetector(
              onTap: () {
                // On click, open MealSelectionScreen to be able to edit
                Navigator.push(
                          context, MaterialPageRoute(
                            builder: (context) => MealSelectionScreen(selectedMeals: widget.selectedMeals, mealType: widget.mealType,)
                          )
                        );
              },
              child: RecipeButton(isMealSelection: true, recipe: meal)
              )]
        );
    }
    else {
      // If there are no saved meals, display a "Select a recipe" button
      return SelectARecipeButton(selectedMeals: widget.selectedMeals, calendarDay: widget.calendarDay, mealType: widget.mealType,);
    }
  }
}






class SelectARecipeButton extends StatefulWidget {
  final List<Recipe> selectedMeals;
  final CalendarDay calendarDay;
  final int mealType; 
  const SelectARecipeButton({super.key, required this.selectedMeals, required this.calendarDay, required this.mealType});
  @override
  State<SelectARecipeButton> createState() => _SelectARecipeButtonState();
}

class _SelectARecipeButtonState extends State<SelectARecipeButton> {
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context, MaterialPageRoute(
            // Swap to meal selection screen on click
            builder: (context) => MealSelectionScreen(selectedMeals: widget.selectedMeals, mealType: widget.mealType,)
          )
        );
      },
      // Visual
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
