import 'package:flutter/material.dart';
import 'package:recipe_app/app/model/recipe.dart';
import 'package:recipe_app/app/ui/components/recipes_listview.dart';

class MealSelectionScreen extends StatefulWidget {
  const MealSelectionScreen({super.key});

  @override
  State<MealSelectionScreen> createState() => _MealSelectionScreenState();
}

class _MealSelectionScreenState extends State<MealSelectionScreen> {

  // TEMP selected meals list
  List<Recipe> selectedMeals = [];

  // Functions used in recipes_listview and recipe_button
  addToSelectedMeals(Recipe recipe){
    selectedMeals.add(recipe);
    debugPrint(selectedMeals.toString()); // Testing
  }
  removeFromSelectedMeals(Recipe recipe){
    selectedMeals.remove(recipe);
    debugPrint(selectedMeals.toString()); // Testing
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Select Recipes"),
        actions: [
          IconButton(
            icon: const Icon(Icons.check),
            onPressed: (){}
            ), 
        ],
        ),
      body: RecipesListView(
        addToSelectedMeals: addToSelectedMeals,
        removeFromSelectedMeals: removeFromSelectedMeals,
        isMealSelection: true,
        ),
    );
    
  }
}