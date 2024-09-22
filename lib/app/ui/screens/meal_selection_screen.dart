import 'package:flutter/material.dart';
import 'package:recipe_app/app/model/recipe.dart';
import 'package:recipe_app/app/ui/components/recipes_listview.dart';
import 'package:recipe_app/app/db/calendardb_operations.dart';

class MealSelectionScreen extends StatefulWidget {
  final List<Recipe> selectedMeals;
  final int mealType;
  final String date;

  const MealSelectionScreen({
    super.key,
    required this.selectedMeals,
    required this.mealType,
    required this.date,
  });

  @override
  State<MealSelectionScreen> createState() => _MealSelectionScreenState();
}

class _MealSelectionScreenState extends State<MealSelectionScreen> {
  final CalendarOperations _calendarOperations = CalendarOperations();

  void addToSelectedMeals(Recipe recipe) {
    setState(() {
      widget.selectedMeals.add(recipe);
    });
  }

  void removeFromSelectedMeals(Recipe recipe) {
    setState(() {
      widget.selectedMeals.remove(recipe);
    });
  }

  bool checkIfInSelectedMeals(Recipe recipe) {
    return widget.selectedMeals.contains(recipe);
  }

  Future<void> saveMealsToCalendar() async {
    for (var recipe in widget.selectedMeals) {
      await _calendarOperations.addMealToCalendar(
        widget.date,
        widget.mealType,
        recipe.recipeId,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Select Recipes"),
        actions: [
          IconButton(
            icon: const Icon(Icons.check),
            onPressed: () async {
              await saveMealsToCalendar();
              Navigator.pop(context);
            },
          ),
        ],
      ),
      body: RecipesListView(
        addToSelectedMeals: addToSelectedMeals,
        removeFromSelectedMeals: removeFromSelectedMeals,
        checkIfInSelectedMeals: checkIfInSelectedMeals,
        isMealSelection: true,
      ),
    );
  }
}
