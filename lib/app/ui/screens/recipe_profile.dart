import 'package:flutter/material.dart';
import 'package:recipe_app/app/model/recipe.dart';
import 'package:recipe_app/app/ui/screens/new_recipe_screen.dart';
import 'dart:io';

class RecipeDetailsScreen extends StatelessWidget {
  final Recipe recipe;

  const RecipeDetailsScreen({Key? key, required this.recipe}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(recipe.recipeName),
        actions: [
          IconButton(
            icon: const Icon(Icons.edit),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => NewRecipeScreen(
                    onRecipeSaved: () {
                      // Optionally, you can use this callback to refresh data
                      Navigator.pop(context); // Go back to the details screen
                    },
                    recipeId: recipe.recipeId, // Pass the recipe ID for editing
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
                child: recipe.imagePath.isNotEmpty &&
                        File(recipe.imagePath).existsSync()
                    ? Image.file(
                        File(recipe.imagePath),
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
              recipe.recipeName,
              textAlign: TextAlign.center,
              style: const TextStyle(
                fontSize: 26,
                fontWeight: FontWeight.bold,
                color: Colors.black87,
              ),
            ),
            const SizedBox(height: 12),
            Text(
              recipe.recipeDescription,
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
              children: (recipe.tags ?? [])
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
                  '${recipe.hours}h ${recipe.minutes}m',
                  style: const TextStyle(fontSize: 16, color: Colors.black87),
                ),
              ],
            ),
            const SizedBox(height: 24),
            if (recipe.link.isNotEmpty)
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
              recipe.directions,
              style: const TextStyle(fontSize: 16, color: Colors.black87),
              textAlign: TextAlign.justify,
            ),
            const SizedBox(height: 24),
            _buildSectionTitle('Ingredients'),
            ...(recipe.ingredients ?? []).map((ingredient) => Padding(
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
