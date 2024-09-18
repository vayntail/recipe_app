import 'package:flutter/material.dart';
import 'package:recipe_app/app/model/recipe.dart';
import 'package:recipe_app/app/db/recipedb_operations.dart';
import 'recipe_button.dart';

class RecipesListView extends StatefulWidget {
  final bool isMealSelection;
  final ValueNotifier<void>? notifier;
  final Function? addToSelectedMeals;
  final Function? removeFromSelectedMeals;
  final Function? checkIfInSelectedMeals;
  final Function? refreshScreen;

  const RecipesListView({
    super.key,
    required this.isMealSelection,
    this.addToSelectedMeals,
    this.removeFromSelectedMeals,
    this.notifier, 
    this.checkIfInSelectedMeals,
    this.refreshScreen,
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
    // Fetch the list of recipes
    List<Recipe> recipesList = await _recipeOperations.getRecipes();

    // Update each recipe with its associated tags
    for (var recipe in recipesList) {
      // Fetch tags for the recipe
      final tags = await _recipeOperations.getTagsForRecipe(recipe.recipeId);
      // Set the tags for the recipe
      recipe.tags = tags;
    }

    // Filter recipes based on the search query if it's not empty
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
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Search bar
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: TextField(
            decoration: const InputDecoration(
              contentPadding: EdgeInsets.symmetric(vertical: -5),
              border: OutlineInputBorder(
                gapPadding: 0,
              ),
              fillColor: Color.fromARGB(255, 218, 210, 210),
              filled: true,
              hintText: 'Search by recipe or tag...',
              prefixIcon: Icon(Icons.cake),
            ),
            onChanged: (query) {
              setState(() {
                _searchQuery = query;
              });
              // Trigger a refresh of the recipe list
              _onNotifierChanged();
            },
          ),
        ),
        // Tags Filter
        ValueListenableBuilder<List<String>>(
          valueListenable: _tagsNotifier,
          builder: (context, tags, child) {
            return 
            
            SingleChildScrollView(
              scrollDirection: Axis.horizontal,
                child: Positioned(
                  left: 0,
                  child: Row(
                      children: tags.map((tag) {
                        return ChoiceChip(
                            label: Text(tag),
                            selected: _searchQuery == tag,
                            onSelected: (isSelected) {
                              setState(() {
                                _searchQuery = isSelected ? tag : '';
                              });
                              // Trigger a refresh of the recipe list
                              _onNotifierChanged();
                            },
                    
                        );
                      }).toList(),
                  ),
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
                      checkIfInSelectedMeals: widget.checkIfInSelectedMeals,
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
