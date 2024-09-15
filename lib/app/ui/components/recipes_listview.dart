import 'package:flutter/material.dart';
import 'package:recipe_app/app/model/recipe.dart';
import 'package:recipe_app/app/db/recipedb_operations.dart';
import 'recipe_button.dart';

class RecipesListView extends StatefulWidget {
  final bool isMealSelection;
  final ValueNotifier<void>? notifier;
  final Function? addToSelectedMeals;
  final Function? removeFromSelectedMeals;

  const RecipesListView({
    super.key,
    required this.isMealSelection,
    this.addToSelectedMeals,
    this.removeFromSelectedMeals,
    this.notifier,
  });

  @override
  State<RecipesListView> createState() => _RecipesListViewState();
}

class _RecipesListViewState extends State<RecipesListView> {
  final RecipeOperations _recipeOperations = RecipeOperations();
  late Future<List<Recipe>> _recipesFuture;
  String _searchQuery = '';
  final ValueNotifier<List<String>> _tagsNotifier = ValueNotifier([]);

  @override
  void initState() {
    super.initState();
    _fetchRecipes(); // Initialize the Future
    _loadTags();
    widget.notifier
        ?.addListener(_onNotifierChanged); // Listen for notifier changes
  }

  @override
  void dispose() {
    widget.notifier?.removeListener(_onNotifierChanged); // Clean up listener
    _tagsNotifier.dispose();
    super.dispose();
  }

  void _onNotifierChanged() {
    _fetchRecipes(); // Refresh recipes when notifier changes
    _loadTags(); // Refresh tags when notifier changes
  }

  Future<void> _loadTags() async {
    try {
      final RecipeOperations recipeOperations = RecipeOperations();
      List<String> tags = await recipeOperations.getAllTags();
      print(tags); // Debugging: Check if tags are fetched
      _tagsNotifier.value = tags.toSet().toList(); // Update notifier value
    } catch (e) {
      print('Failed to load tags: $e');
    }
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

    if (_searchQuery.isNotEmpty) {
      recipesList = recipesList.where((recipe) {
        final nameMatch = recipe.recipeName
            .toLowerCase()
            .contains(_searchQuery.toLowerCase());
        final tagMatch = recipe.tags.any(
            (tag) => tag.toLowerCase().contains(_searchQuery.toLowerCase()));
        return nameMatch || tagMatch;
      }).toList();
    }

    return recipesList;
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        // Search bar
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: TextField(
            decoration: const InputDecoration(
              hintText: 'Search by recipe or tag...',
              prefixIcon: Icon(Icons.search),
            ),
            onChanged: (query) {
              setState(() {
                _searchQuery = query;
              });
              // Trigger a refresh of the recipe list
              widget.notifier?.notifyListeners();
            },
          ),
        ),
        // Tags Filter
        ValueListenableBuilder<List<String>>(
          valueListenable: _tagsNotifier,
          builder: (context, tags, child) {
            return SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                children: tags.map((tag) {
                  return Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 4.0),
                    child: ChoiceChip(
                      label: Text(tag),
                      selected: _searchQuery == tag,
                      onSelected: (isSelected) {
                        setState(() {
                          _searchQuery = isSelected ? tag : '';
                        });
                        // Trigger a refresh of the recipe list
                        widget.notifier?.notifyListeners();
                      },
                    ),
                  );
                }).toList(),
              ),
            );
          },
        ),
        // Recipe list
        Expanded(
          child: FutureBuilder<List<Recipe>>(
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
                      addToSelectedMeals: widget.addToSelectedMeals,
                      removeFromSelectedMeals: widget.removeFromSelectedMeals,
                      isMealSelection: widget.isMealSelection,
                      recipe: snapshot.data![index],
                      onDelete: () {
                        _fetchRecipes(); // Refresh the list on delete
                        widget.notifier
                            ?.notifyListeners(); // Ensure tag list is updated
                      },
                    );
                  },
                );
              }
            },
          ),
        ),
      ],
    );
  }
}
