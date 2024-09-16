import 'dart:io';
import 'package:flutter/material.dart';
import 'package:recipe_app/app/model/recipe.dart';
import 'package:recipe_app/app/db/recipedb_operations.dart';

class RecipeButton extends StatefulWidget {
  final bool isMealSelection;
  final Recipe recipe;
  final VoidCallback onDelete; // Callback for deletion
  final Function? addToSelectedMeals;
  final Function? removeFromSelectedMeals;

  const RecipeButton({
    super.key,
    required this.isMealSelection,
    required this.recipe,
    required this.onDelete,
    this.addToSelectedMeals,
    this.removeFromSelectedMeals
  });

  @override
  _RecipeButtonState createState() => _RecipeButtonState();
}

class _RecipeButtonState extends State<RecipeButton> {
  bool _showDeleteOption = false;
  bool? mealButtonChecked = false;


  @override
  Widget build(BuildContext context) {
    return GestureDetector(
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
            Container(
              color: Colors.white,
              height: 115,
              padding:
                  const EdgeInsets.only(bottom: 8, top: 8, left: 15, right: 15),
              child: Row(
                children: [
                  Container(
                    height: 100,
                    width: 100,
                    decoration: BoxDecoration(
                      color: Colors.grey[200],
                      image: widget.recipe.imagePath.isNotEmpty &&
                              File(widget.recipe.imagePath).existsSync()
                          ? DecorationImage(
                              image: FileImage(File(widget.recipe.imagePath)),
                              fit: BoxFit.cover,
                            )
                          : null, // No image
                    ),
                    child: widget.recipe.imagePath.isEmpty ||
                            !File(widget.recipe.imagePath).existsSync()
                        ? Center(
                            child: Text(
                              'No Image',
                              style: TextStyle(
                                color: Colors.grey[600],
                                fontSize: 14,
                              ),
                            ),
                          )
                        : null,
                  ),
                  const SizedBox(width: 20),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          widget.recipe.recipeName,
                          style: const TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 16,
                          ),
                        ),
                        Text(
                          widget.recipe.recipeDescription,
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                        ),
                        Wrap(
                          children: widget.recipe.tags
                              .map((tag) => Chip(label: Text(tag)))
                              .toList(),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
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
    widget.onDelete();
  }
}
