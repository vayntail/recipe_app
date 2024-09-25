import 'package:flutter/material.dart';
import 'package:recipe_app/app/model/recipe.dart';
import 'package:recipe_app/app/db/recipedb_operations.dart';
import 'package:recipe_app/app/ui/widgets/recipe_listview_widgets.dart';
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
  String _sortBy = 'chronological';
  bool _sortAscending = true;

  @override
  void initState() {
    super.initState();
    _fetchRecipes();
    _loadTags();
    widget.notifier?.addListener(_onNotifierChanged);
  }

  @override
  void dispose() {
    widget.notifier?.removeListener(_onNotifierChanged);
    _tagsNotifier.dispose();
    super.dispose();
  }

  void _onNotifierChanged() {
    _fetchRecipes();
    _loadTags();
  }

  Future<void> _loadTags() async {
    try {
      List<String> tags = await _recipeOperations.getAllTags();
      _tagsNotifier.value = tags.toSet().toList();
    } catch (e) {
      print('Failed to load tags: $e');
    }
  }

  Future<void> _fetchRecipes() async {
    setState(() {
      _recipesFuture = _getSortedRecipes();
    });
  }

  Future<List<Recipe>> _getSortedRecipes() async {
    List<Recipe> recipes = await _recipeOperations.getSortedRecipes(
      sortBy: _sortBy,
      ascending: _sortAscending,
    );

    if (_searchQuery.isNotEmpty) {
      recipes = recipes.where((recipe) {
        final nameMatch = recipe.recipeName
            .toLowerCase()
            .contains(_searchQuery.toLowerCase());
        final tagMatch = recipe.tags.any(
            (tag) => tag.toLowerCase().contains(_searchQuery.toLowerCase()));
        return nameMatch || tagMatch;
      }).toList();
    }

    return recipes;
  }

  void _showSortOptions() {
    showModalBottomSheet(
      context: context,
      builder: (BuildContext context) {
        return Container(
          padding: const EdgeInsets.all(16),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              ListTile(
                title: const Text('Sort by'),
                trailing: DropdownButton<String>(
                  value: _sortBy,
                  onChanged: (String? newValue) {
                    if (newValue != null) {
                      setState(() {
                        _sortBy = newValue;
                      });
                      _fetchRecipes();
                      Navigator.pop(context);
                    }
                  },
                  items: <String>['chronological', 'alphabetical']
                      .map<DropdownMenuItem<String>>((String value) {
                    return DropdownMenuItem<String>(
                      value: value,
                      child: Text(value.capitalize()),
                    );
                  }).toList(),
                ),
              ),
              SwitchListTile(
                title: const Text('Ascending Order'),
                value: _sortAscending,
                onChanged: (bool value) {
                  setState(() {
                    _sortAscending = value;
                  });
                  _fetchRecipes();
                  Navigator.pop(context);
                },
              ),
            ],
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        searchBar((query) {
          setState(() {
            _searchQuery = query;
          });
          _onNotifierChanged();
        }),
        Row(
          children: [
            IconButton(
              icon: const Icon(Icons.filter_list),
              onPressed: _showSortOptions,
            ),
            Expanded(
              child: ValueListenableBuilder<List<String>>(
                valueListenable: _tagsNotifier,
                builder: (context, tags, child) {
                  return tagsFilter(tags, _searchQuery, (isSelected, tag) {
                    setState(() {
                      _searchQuery = isSelected ? tag : '';
                    });
                    _onNotifierChanged();
                  });
                },
              ),
            ),
          ],
        ),
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
                        _fetchRecipes();
                        widget.notifier?.notifyListeners();
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

extension StringExtension on String {
  String capitalize() {
    return "${this[0].toUpperCase()}${this.substring(1)}";
  }
}
