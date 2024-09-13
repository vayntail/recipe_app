import 'package:flutter/material.dart';
import 'package:recipe_app/app/model/recipe.dart';
import 'package:recipe_app/app/db/recipedb_operations.dart';
import 'recipe_button.dart';

class RecipesListView extends StatefulWidget {
  final String searchQuery;
  final ValueNotifier<void> notifier;

  const RecipesListView({
    super.key,
    required this.searchQuery,
    required this.notifier,
  });

  @override
  State<RecipesListView> createState() => _RecipesListViewState();
}

class _RecipesListViewState extends State<RecipesListView> {
  final RecipeOperations _recipeOperations = RecipeOperations();
  late Future<List<Recipe>> _recipesFuture;

  @override
  void initState() {
    super.initState();
    _fetchRecipes(); // Initialize the Future
    widget.notifier
        .addListener(_onNotifierChanged); // Listen for notifier changes
  }

  @override
  void dispose() {
    widget.notifier.removeListener(_onNotifierChanged); // Clean up listener
    super.dispose();
  }

  void _onNotifierChanged() {
    _fetchRecipes(); // Refresh recipes when notifier changes
  }

  Future<void> _fetchRecipes() async {
    setState(() {
      _recipesFuture = _getRecipes();
    });
  }

  Future<List<Recipe>> _getRecipes() async {
    List<Recipe> recipesList = await _recipeOperations.getRecipes();

    for (var recipe in recipesList) {
      final tags = await _recipeOperations.getTagsForRecipe(recipe.recipeId);
      recipe.tags = tags.map((tag) => tag['tag_name'] as String).toList();
    }

    if (widget.searchQuery.isNotEmpty) {
      print('Filtering recipes with search query: ${widget.searchQuery}');
      recipesList = recipesList.where((recipe) {
        final nameMatch = recipe.recipeName
            .toLowerCase()
            .contains(widget.searchQuery.toLowerCase());
        final tagMatch = recipe.tags.any((tag) =>
            tag.toLowerCase().contains(widget.searchQuery.toLowerCase()));
        print(
            'Recipe: ${recipe.recipeName}, Name Match: $nameMatch, Tag Match: $tagMatch');
        return nameMatch || tagMatch;
      }).toList();
    }

    print('Filtered recipes count: ${recipesList.length}');
    return recipesList;
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<Recipe>>(
      future: _recipesFuture,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        } else if (snapshot.hasError) {
          return Center(child: Text('Error: ${snapshot.error}'));
        } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
          return const Center(child: Text('No recipes found.'));
        } else {
          return ListView.builder(
            itemCount: snapshot.data!.length,
            itemBuilder: (context, index) {
              return RecipeButton(
                recipe: snapshot.data![index],
                onDelete: () {
                  _fetchRecipes(); // Refresh the list on delete
                  widget.notifier
                      .notifyListeners(); // Ensure tag list is updated
                },
              );
            },
          );
        }
      },
    );
  }
}
