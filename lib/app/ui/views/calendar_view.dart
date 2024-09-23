import 'package:flutter/material.dart';
import 'package:dotted_border/dotted_border.dart';
import 'package:recipe_app/app/model/calendar_day.dart';
import 'package:recipe_app/app/model/recipe.dart';
import 'package:recipe_app/app/ui/components/calendar.dart';
import 'package:recipe_app/app/ui/components/recipe_button.dart';
import 'package:recipe_app/app/ui/screens/meal_selection_screen.dart';
import 'package:recipe_app/app/ui/widgets/texts_widget.dart';
import 'package:table_calendar/table_calendar.dart';
import 'package:recipe_app/app/db/calendardb_operations.dart';

class CalendarView extends StatefulWidget {
  const CalendarView({super.key});
  @override
  State<CalendarView> createState() => _CalendarViewState();
}

class _CalendarViewState extends State<CalendarView> {
  CalendarFormat format = CalendarFormat.week;
  DateTime _selectedDay = DateTime.now();
  final CalendarOperations _calendarOperations = CalendarOperations();

  Future<CalendarDay> _loadCalendarDay() async {
    try {
      return await _calendarOperations
          .getCalendarDay(_selectedDay.toIso8601String().split('T')[0]);
    } catch (e) {
      print('Error loading calendar day: $e');
      return CalendarDay(
        day: _selectedDay.toIso8601String().split('T')[0],
        breakfast: [],
        lunch: [],
        dinner: [],
        snacks: [],
      );
    }
  }

  void setSelectedDay(DateTime day) {
    setState(() {
      _selectedDay = day;
    });
  }

  String getDayOfWeek(int weekday) {
    const days = [
      "Monday",
      "Tuesday",
      "Wednesday",
      "Thursday",
      "Friday",
      "Saturday",
      "Sunday"
    ];
    return days[weekday - 1];
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          centerTitle: false,
          title: appBarTitleText("Calendar"), actions: <Widget>[
          IconButton(
            onPressed: () {
              setState(() {
                format = format == CalendarFormat.week
                    ? CalendarFormat.month
                    : CalendarFormat.week;
              });
            },
            icon: const Icon(Icons.calendar_month),
            selectedIcon: const Icon(Icons.calendar_view_week),
          ),
        ],
      ),
      body: Column(
        children: [
          Calendar(format: format, setSelectedDay: setSelectedDay),
          Expanded(
            child: FutureBuilder<CalendarDay>(
              future: _loadCalendarDay(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                } else if (snapshot.hasError) {
                  return Center(child: Text('Error: ${snapshot.error}'));
                } else if (!snapshot.hasData) {
                  return const Center(child: Text('No data available'));
                } else {
                  final calendarDay = snapshot.data!;
                  return ListView(
                    children: [
                      headingText(
                          "${getDayOfWeek(_selectedDay.weekday)}, ${_selectedDay.month}-${_selectedDay.day}"),
                      const Text("Breakfast"),
                      MealTypeColumn(
                        selectedMeals: calendarDay.breakfast,
                        calendarDay: calendarDay,
                        mealType: 1,
                        date: _selectedDay,
                        onMealsUpdated: () => setState(() {}),
                      ),
                      const Text("Lunch"),
                      MealTypeColumn(
                        selectedMeals: calendarDay.lunch,
                        calendarDay: calendarDay,
                        mealType: 2,
                        date: _selectedDay,
                        onMealsUpdated: () => setState(() {}),
                      ),
                      const Text("Dinner"),
                      MealTypeColumn(
                        selectedMeals: calendarDay.dinner,
                        calendarDay: calendarDay,
                        mealType: 3,
                        date: _selectedDay,
                        onMealsUpdated: () => setState(() {}),
                      ),
                      const Text("Snacks"),
                      MealTypeColumn(
                        selectedMeals: calendarDay.snacks,
                        calendarDay: calendarDay,
                        mealType: 4,
                        date: _selectedDay,
                        onMealsUpdated: () => setState(() {}),
                      ),
                    ],
                  );
                }
              },
            ),
          ),
        ],
      ),
    );
  }
}

class MealTypeColumn extends StatelessWidget {
  final List<Recipe> selectedMeals;
  final CalendarDay calendarDay;
  final int mealType;
  final DateTime date;
  final VoidCallback onMealsUpdated;

  const MealTypeColumn({
    super.key,
    required this.selectedMeals,
    required this.calendarDay,
    required this.mealType,
    required this.date,
    required this.onMealsUpdated,
  });

  @override
  Widget build(BuildContext context) {
    if (selectedMeals.isNotEmpty) {
      return Column(
        children: selectedMeals
            .map((meal) => RecipeItem(
                  meal: meal,
                  mealType: mealType,
                  date: date,
                  onDelete: () async {
                    await CalendarOperations().removeMealFromCalendar(
                      date.toIso8601String().split('T')[0],
                      mealType,
                      meal.recipeId,
                    );
                    onMealsUpdated();
                  },
                  onTap: () async {
                    await Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => MealSelectionScreen(
                          selectedMeals: selectedMeals,
                          mealType: mealType,
                          date: date.toIso8601String().split('T')[0],
                        ),
                      ),
                    );
                    onMealsUpdated();
                  },
                ))
            .toList(),
      );
    } else {
      return SelectARecipeButton(
        selectedMeals: selectedMeals,
        calendarDay: calendarDay,
        mealType: mealType,
        date: date,
        onMealsUpdated: onMealsUpdated,
      );
    }
  }
}

class RecipeItem extends StatefulWidget {
  final Recipe meal;
  final int mealType;
  final DateTime date;
  final VoidCallback onDelete;
  final VoidCallback onTap;

  const RecipeItem({
    super.key,
    required this.meal,
    required this.mealType,
    required this.date,
    required this.onDelete,
    required this.onTap,
  });

  @override
  _RecipeItemState createState() => _RecipeItemState();
}

class _RecipeItemState extends State<RecipeItem> {
  bool _showDeleteButton = false;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onLongPress: () {
        setState(() {
          _showDeleteButton = true;
        });
      },
      onTap: () {
        if (_showDeleteButton) {
          setState(() {
            _showDeleteButton = false;
          });
        } else {
          widget.onTap();
        }
      },
      child: Container(
        margin: const EdgeInsets.symmetric(vertical: 4),
        child: Row(
          children: [
            if (_showDeleteButton)
              IconButton(
                icon: const Icon(Icons.remove_circle, color: Colors.red),
                onPressed: () {
                  widget.onDelete();
                  setState(() {
                    _showDeleteButton = false;
                  });
                },
              ),
            Expanded(
              child: RecipeButton(
                isMealSelection: true,
                recipe: widget.meal,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class SelectARecipeButton extends StatelessWidget {
  final List<Recipe> selectedMeals;
  final CalendarDay calendarDay;
  final int mealType;
  final DateTime date;
  final VoidCallback onMealsUpdated;

  const SelectARecipeButton({
    super.key,
    required this.selectedMeals,
    required this.calendarDay,
    required this.mealType,
    required this.date,
    required this.onMealsUpdated,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
        onTap: () async {
          await Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) => MealSelectionScreen(
                        selectedMeals: selectedMeals,
                        mealType: mealType,
                        date: date.toIso8601String().split('T')[0],
                      )));
          onMealsUpdated();
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
