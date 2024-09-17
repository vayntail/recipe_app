import 'dart:io';
import 'package:flutter/material.dart';
import 'package:recipe_app/app/model/recipe.dart';
import 'package:recipe_app/app/db/recipedb_operations.dart';
import 'package:recipe_app/app/ui/screens/recipe_profile.dart';
import 'package:recipe_app/app/ui/widgets/recipe_button_widget.dart';

class RecipeButton extends StatefulWidget {
  final bool isMealSelection;
  final Recipe recipe;
  final VoidCallback? onDelete; // Callback for deletion
  final Function? addToSelectedMeals;
  final Function? removeFromSelectedMeals;
  final Function? checkIfInSelectedMeals; // Used to check if a recipe is already selected or not, for displaying checkmark

  const RecipeButton({
    super.key,
    required this.isMealSelection,
    required this.recipe,
    this.onDelete,
    this.addToSelectedMeals,
    this.removeFromSelectedMeals,
    this.checkIfInSelectedMeals
  });

  @override
  _RecipeButtonState createState() => _RecipeButtonState();
}

class _RecipeButtonState extends State<RecipeButton> {
  bool _showDeleteOption = false;
  bool? mealButtonChecked = false;


  @override
  Widget build(BuildContext context) {

    
    // MealButton
    if (widget.isMealSelection){
      mealButtonChecked = widget.checkIfInSelectedMeals!(widget.recipe);

      return Row(
      children: [
        Checkbox(
          value: mealButtonChecked, 
          onChanged: (bool? value){
            setState(() {
              mealButtonChecked = value!;
              // Add or Remove to selected meals list
              if (mealButtonChecked==true){
                widget.addToSelectedMeals!(widget.recipe);
              }
              else {
                widget.removeFromSelectedMeals!(widget.recipe);
              }
            });
          }
        ),
        Expanded(
          child: recipeButtonWidget(widget.recipe, true),
        )
      ]
    );
    }


    
    else {
      // Home Recipes Button
      return GestureDetector(
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => RecipeDetailsScreen(recipe: widget.recipe),
            ),
          );
        },
      onLongPress: () {
        setState(() {
          _showDeleteOption = true;
        });
      },
      child: Card(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10),
          side: const BorderSide(
            color: Colors.black,
            width: 1,
          ),
        ),
        child: Stack(
          children: [
            recipeButtonWidget(widget.recipe, true),
            if (_showDeleteOption)
              Positioned(
                top: 8,
                right: 8,
                child: GestureDetector(
                  onTap: _deleteRecipe,
                  child: Container(
                    color: Colors.red,
                    padding: const EdgeInsets.all(8.0),
                    child: const Icon(
                      Icons.delete,
                      color: Colors.white,
                    ),
                  ),
                ),
              ),
          ],
        ),
      ),
    );
    }
  }

  Future<void> _deleteRecipe() async {
    final RecipeOperations recipeOperations = RecipeOperations();

    await recipeOperations.deleteRecipe(widget.recipe.recipeId);
    await recipeOperations.deleteSingleTags();

    if (!mounted) return;

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Recipe deleted')),
    );

    // Call the onDelete callback to refresh the list
    widget.onDelete!();
  }
}
