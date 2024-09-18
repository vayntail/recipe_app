import 'package:flutter/material.dart';
import 'package:recipe_app/app/main.dart';
import 'package:recipe_app/app/model/recipe.dart';
import 'package:recipe_app/app/ui/screens/new_recipe_screen.dart';
import 'dart:io';
import 'package:recipe_app/app/db/recipedb_operations.dart';
import 'package:recipe_app/app/ui/views/recipes_view.dart';

class RecipeDetailsScreen extends StatefulWidget {
  final Recipe recipe;
  final ValueNotifier<void>? notifier; // Add notifier if used

  const RecipeDetailsScreen({super.key, required this.recipe, this.notifier});

  @override
  State<RecipeDetailsScreen> createState() => _RecipeDetailsScreenState();
}

class _RecipeDetailsScreenState extends State<RecipeDetailsScreen> {
  late Recipe _recipe = widget.recipe;
  final RecipeOperations _recipeOperations = RecipeOperations();

  @override
  void initState() {
    super.initState();
    _recipe = widget.recipe;
  }

  Future<void> _getRecipeFromDatabase() async {
    final updatedRecipe =
        await _recipeOperations.getRecipeFromId(widget.recipe.recipeId);
    setState(() {
      _recipe = updatedRecipe;
    });
    debugPrint(_recipe.toString());
  }

  Future<void> _navigateAndUpdateRecipe() async {
    await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => RecipesView(),
      ),
    );
    await _getRecipeFromDatabase();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: 
        IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: (){
            // Go to main recipes_view screen. This also refreshes it, and removes all navigator history to start from blank.
            Navigator.pushAndRemoveUntil(context, MaterialPageRoute(builder: (_) => MainWrapper()), (r) => false);
          }), 
        title: Text(_recipe.recipeName),
        actions: [
          IconButton(
            icon: const Icon(Icons.edit),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => NewRecipeScreen(
                    onRecipeSaved: (Recipe recipe) {
                      setState(() {
                        _recipe = recipe;
                      });
                    },
                    recipeId: _recipe.recipeId,
                  ),
                ),
              );
            },
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Center(
              child: ClipRRect(
                borderRadius: BorderRadius.circular(10),
                child: _recipe.imagePath.isNotEmpty &&
                        File(_recipe.imagePath).existsSync()
                    ? Image.file(
                        File(_recipe.imagePath),
                        width: 200,
                        height: 200,
                        fit: BoxFit.cover,
                      )
                    : Container(
                        width: 200,
                        height: 200,
                        color: Colors.grey[
                            200], // Optional: Background color when no image
                        child: Center(
                          child: Text(
                            'No Image',
                            style: TextStyle(
                              color: Colors.grey[600],
                              fontSize: 14,
                            ),
                          ),
                        ),
                      ),
              ),
            ),
            const SizedBox(height: 16),
            Text(
              _recipe.recipeName,
              textAlign: TextAlign.center,
              style: const TextStyle(
                fontSize: 26,
                fontWeight: FontWeight.bold,
                color: Colors.black87,
              ),
            ),
            const SizedBox(height: 12),
            Text(
              _recipe.recipeDescription,
              textAlign: TextAlign.center,
              style: const TextStyle(
                fontSize: 16,
                color: Colors.grey,
              ),
            ),
            const SizedBox(height: 24),
            _buildSectionTitle('Tags'),
            Wrap(
              spacing: 8.0,
              runSpacing: 4.0,
              children: (_recipe.tags ?? [])
                  .map((tag) => Chip(
                        label: Text(tag),
                        backgroundColor: Colors.blue[100],
                      ))
                  .toList(),
            ),
            const SizedBox(height: 24),
            _buildSectionTitle('Time'),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.access_time, color: Colors.grey[600]),
                const SizedBox(width: 8),
                Text(
                  '${_recipe.hours}h ${_recipe.minutes}m',
                  style: const TextStyle(fontSize: 16, color: Colors.black87),
                ),
              ],
            ),
            const SizedBox(height: 24),
            if (_recipe.link.isNotEmpty)
              TextButton.icon(
                onPressed: () {
                  // Implement URL launching here
                },
                icon: const Icon(Icons.link, color: Colors.blue),
                label: const Text(
                  'View Recipe Link',
                  style: TextStyle(color: Colors.blue),
                ),
              ),
            const SizedBox(height: 24),
            _buildSectionTitle('Directions'),
            Text(
              _recipe.directions,
              style: const TextStyle(fontSize: 16, color: Colors.black87),
              textAlign: TextAlign.justify,
            ),
            const SizedBox(height: 24),
            _buildSectionTitle('Ingredients'),
            ...(_recipe.ingredients ?? []).map((ingredient) => Padding(
                  padding: const EdgeInsets.symmetric(vertical: 4.0),
                  child: Text(
                    '• $ingredient',
                    style: const TextStyle(fontSize: 16, color: Colors.black87),
                  ),
                )),
          ],
        ),
      ),
    );
  }

  Widget _buildSectionTitle(String title) {
    return Text(
      title,
      style: const TextStyle(
        fontSize: 20,
        fontWeight: FontWeight.bold,
        color: Colors.black87,
      ),
      textAlign: TextAlign.left,
    );
  }
}
