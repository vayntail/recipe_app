import 'package:flutter/material.dart';
import 'package:recipe_app/app/model/recipe.dart';
import 'package:recipe_app/app/ui/components/recipes_listview.dart';

class MealSelectionScreen extends StatefulWidget {
  final List<Recipe> selectedMeals;
  final int mealType;
  
  const MealSelectionScreen({super.key, required this.selectedMeals, required this.mealType});

  @override
  State<MealSelectionScreen> createState() => _MealSelectionScreenState();
}

class _MealSelectionScreenState extends State<MealSelectionScreen> {

  // Functions used in recipes_listview and recipe_button
  addToSelectedMeals(Recipe recipe){
    widget.selectedMeals.add(recipe);
    debugPrint(widget.selectedMeals.toString()); // Testing
  }
  removeFromSelectedMeals(Recipe recipe){
    widget.selectedMeals.remove(recipe);
    debugPrint(widget.selectedMeals.toString()); // Testing
  }
  checkIfInSelectedMeals(Recipe recipe){
    // Used to check whether or not to display checkmarked in buttons
    return widget.selectedMeals.contains(recipe);
  }

  // When done pressed, save the selected meals to calendar
  saveMealsToCalendar(){
    // depending on meal type

  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Select Recipes"),
        actions: [
          IconButton(
            icon: const Icon(Icons.check),
            onPressed: (){
              saveMealsToCalendar();
              Navigator.pop(context);
            }
            ), 
        ],
        ),
      body: RecipesListView(
        addToSelectedMeals: addToSelectedMeals,
        removeFromSelectedMeals: removeFromSelectedMeals,
        checkIfInSelectedMeals: checkIfInSelectedMeals,
        isMealSelection: true,
        // send over 
        ),
    );
    
  }
}