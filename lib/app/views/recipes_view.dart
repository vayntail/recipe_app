import 'package:flutter/material.dart';
import 'package:recipe_app/app/components/recipe_button1.dart';
import 'package:recipe_app/app/components/search_tags_container.dart';
import 'package:recipe_app/app/screens/new_recipe_screen.dart';
import 'package:recipe_app/app/recipedb_operations.dart';

class RecipesView extends StatefulWidget {
  const RecipesView({super.key});

  @override
  _RecipesViewState createState() => _RecipesViewState();
}

class _RecipesViewState extends State<RecipesView> {
  final RecipeOperations _recipeOperations =
      RecipeOperations(); // Initialize DB operations
  late Future<List<Map<String, dynamic>>> _recipesFuture;

  @override
  void initState() {
    super.initState();
    _recipesFuture =
        _recipeOperations.getRecipes(); // Fetch recipes when state initializes
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Recipes'),
        actions: <Widget>[
          // Add new button
          IconButton(
            icon: const Icon(Icons.add),
            tooltip: 'New Recipe',
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) =>
                        const NewRecipeScreen()), // Go to new recipe screen
              );
            },
          ),
        ],
      ),
      body: Column(
        children: <Widget>[
          const SearchTagsContainer(),
          Expanded(
            child: FutureBuilder<List<Map<String, dynamic>>>(
              future: _recipesFuture,
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                } else if (snapshot.hasError) {
                  return Center(child: Text('Error: ${snapshot.error}'));
                } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                  return const Center(child: Text('No Recipes Found'));
                } else {
                  final recipes = snapshot.data!;
                  return ListView.builder(
                    padding: const EdgeInsets.all(8),
                    itemCount: recipes.length,
                    itemBuilder: (context, index) {
                      final recipe = recipes[index];
                      return RecipeButton1(
                        name: recipe['recipe_name'] ??
                            'No Name', // Ensure default value
                        description:
                            recipe['recipe_description'] ?? 'No Description',
                        minutes: (recipe['hours'] ?? 0) * 60 +
                            (recipe['minutes'] ?? 0), // Handle null
                        imagePath: recipe['image_path'] ?? '', // Handle null
                      );
                    },
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
