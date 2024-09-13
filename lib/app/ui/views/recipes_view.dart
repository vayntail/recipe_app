import 'package:flutter/material.dart';
import 'package:recipe_app/app/ui/components/recipes_listview.dart';
import 'package:recipe_app/app/ui/screens/new_recipe_screen.dart';
import 'package:recipe_app/app/db/recipedb_operations.dart';

class RecipesView extends StatefulWidget {
  final ValueNotifier<void> notifier;

  const RecipesView({super.key, required this.notifier});

  @override
  State<RecipesView> createState() => _RecipesViewState();
}

class _RecipesViewState extends State<RecipesView> {
  String _searchQuery = '';
  final ValueNotifier<List<String>> _tagsNotifier = ValueNotifier([]);

  @override
  void initState() {
    super.initState();
    _loadTags();
    widget.notifier.addListener(_onNotifierChanged);
  }

  @override
  void dispose() {
    widget.notifier.removeListener(_onNotifierChanged);
    _tagsNotifier.dispose();
    super.dispose();
  }

  void _onNotifierChanged() {
    _loadTags(); // Reload tags when notifier changes
  }

  Future<void> _loadTags() async {
    try {
      final RecipeOperations recipeOperations = RecipeOperations();
      List<String> tags = await recipeOperations.getAllTags();
      print('Loaded Tags: $tags'); // Debug output
      _tagsNotifier.value = tags.toSet().toList(); // Update notifier value
    } catch (e) {
      print('Failed to load tags: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Recipes'),
        actions: <Widget>[
          IconButton(
            icon: const Icon(Icons.add),
            tooltip: 'New Recipe',
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => NewRecipeScreen(
                    onRecipeSaved: () {
                      widget.notifier
                          .notifyListeners(); // Notify listeners after saving a recipe
                    },
                  ),
                ),
              );
            },
          ),
        ],
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(112.0),
          child: Column(
            children: [
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
                      print(
                          'Search Query Updated: $_searchQuery'); // Debug output
                    });
                    // Trigger a refresh of the recipe list
                    widget.notifier.notifyListeners();
                  },
                ),
              ),
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
                                print(
                                    'Selected Tag: $_searchQuery'); // Debug output
                              });
                              // Trigger a refresh of the recipe list
                              widget.notifier.notifyListeners();
                            },
                          ),
                        );
                      }).toList(),
                    ),
                  );
                },
              ),
            ],
          ),
        ),
      ),
      body: RecipesListView(
        searchQuery: _searchQuery,
        notifier: widget.notifier,
      ),
    );
  }
}
