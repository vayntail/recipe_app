import 'dart:io';
import 'package:flutter/material.dart';
import 'package:recipe_app/app/model/recipe.dart';
import 'package:recipe_app/app/db/recipedb_operations.dart';
import 'package:recipe_app/app/ui/screens/recipe_profile.dart';
import 'package:recipe_app/app/ui/widgets/recipe_button/recipe_button_widget.dart';

class RecipeButton extends StatefulWidget {
  final bool isMealSelection;
  final Recipe recipe;
  final VoidCallback? onDelete; // Callback for deletion
  final Function? addToSelectedMeals;
  final Function? removeFromSelectedMeals;
  final Function?
      checkIfInSelectedMeals; // Used to check if a recipe is already selected or not, for displaying checkmark
  final ValueNotifier<void>? notifier; // Add notifier if used

  const RecipeButton({
    super.key,
    required this.isMealSelection,
    required this.recipe,
    this.onDelete,
    this.addToSelectedMeals,
    this.removeFromSelectedMeals,
    this.checkIfInSelectedMeals,
    this.notifier, // Add notifier
  });

  @override
  _RecipeButtonState createState() => _RecipeButtonState();
}

class _RecipeButtonState extends State<RecipeButton> {
  bool _showDeleteOption = false;
  bool? mealButtonChecked = false;

  @override
  Widget build(BuildContext context) {
    if (widget.isMealSelection) {
      mealButtonChecked = widget.checkIfInSelectedMeals?.call(widget.recipe);

      return Row(
        children: [
          Checkbox(
            value: mealButtonChecked,
            tristate: true, // Allow the checkbox to have a null value.
            onChanged: (bool? value) {
              setState(() {
                mealButtonChecked = value!;
                if (mealButtonChecked == true) {
                  widget.addToSelectedMeals?.call(widget.recipe);
                } else {
                  widget.removeFromSelectedMeals?.call(widget.recipe);
                }
              });
            },
          ),
          Expanded(
            child: recipeButtonWidget(widget.recipe, true),
          ),
        ],
      );
    } else {
      return GestureDetector(
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => RecipeDetailsScreen(
                recipe: widget.recipe,
                notifier: widget.notifier, // Pass notifier if used
              ),
            ),
          );
        },
        onLongPress: () {
          setState(() {
            _showDeleteOption = true;
          });
        },
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
              )
          ],
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

    widget.onDelete?.call(); // Ensure onDelete is not null
  }
}
