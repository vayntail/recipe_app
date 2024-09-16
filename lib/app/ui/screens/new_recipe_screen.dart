import 'package:flutter/material.dart';
import 'package:recipe_app/app/db/recipedb_operations.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';

class NewRecipeScreen extends StatefulWidget {
  final VoidCallback onRecipeSaved;
  final int? recipeId; // Optional parameter to handle recipe updates

  const NewRecipeScreen(
      {super.key, required this.onRecipeSaved, this.recipeId});

  @override
  _NewRecipeScreenState createState() => _NewRecipeScreenState();
}

class _NewRecipeScreenState extends State<NewRecipeScreen>
    with SingleTickerProviderStateMixin {
  // Controllers
  final _formKey = GlobalKey<FormState>(); // Key to manage form validation
  final TextEditingController _recipeNameController = TextEditingController();
  final TextEditingController _directionsController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();
  final TextEditingController _linkController = TextEditingController();
  final TextEditingController _tagController = TextEditingController();

  final ImagePicker _picker = ImagePicker();
  String? _imagePath;
  int _selectedHour = 0;
  int _selectedMinute = 0;

  final List<int> _hours = List<int>.generate(24, (i) => i);
  final List<int> _minutes = List<int>.generate(60, (i) => i);
  final List<String> _tags = [];
  String? _selectedTag;

  final RecipeOperations _recipeOperations = RecipeOperations();

  late final TabController _tabController;

  // Ingredient controllers and focus nodes
  List<TextEditingController> _ingredientControllers =
      List.generate(4, (_) => TextEditingController());
  List<FocusNode> _ingredientFocusNodes = List.generate(4, (_) => FocusNode());

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);

    // Load recipe data if recipeId is provided
    if (widget.recipeId != null) {
      _loadRecipeData(widget.recipeId!);
    }
  }

  @override
  void dispose() {
    _recipeNameController.dispose();
    _directionsController.dispose();
    _descriptionController.dispose();
    _linkController.dispose();
    _tagController.dispose();
    _tabController.dispose();

    // Dispose ingredient controllers and focus nodes
    for (var controller in _ingredientControllers) {
      controller.dispose();
    }
    for (var focusNode in _ingredientFocusNodes) {
      focusNode.dispose();
    }

    super.dispose();
  }

  Future<void> _pickImage() async {
    final XFile? pickedFile =
        await _picker.pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      setState(() {
        _imagePath = pickedFile.path;
        print('Image path: $_imagePath'); // Print the image path here
      });
    }
  }

  Future<void> _saveRecipe() async {
    if (_formKey.currentState?.validate() ?? false) {
      try {
        final uniqueTags =
            _tags.toSet().where((tag) => tag.length <= 15).toList();
        if (widget.recipeId != null) {
          // Update existing recipe
          await _recipeOperations.updateRecipe(
            widget.recipeId!,
            _recipeNameController.text,
            _descriptionController.text,
            _imagePath ?? '',
            _selectedHour,
            _selectedMinute,
            _directionsController.text,
            _linkController.text,
            uniqueTags,
            _ingredientControllers.map((e) => e.text).toList(),
          );
        } else {
          // Insert new recipe
          final int recipeId = await _recipeOperations.insertRecipe(
            _recipeNameController.text,
            _descriptionController.text,
            _imagePath ?? '',
            _selectedHour,
            _selectedMinute,
            _directionsController.text,
            _linkController.text,
          );

          print('Recipe ID: $recipeId');

          for (var controller in _ingredientControllers) {
            String ingredient = controller.text;
            if (ingredient.isNotEmpty) {
              print('Adding ingredient: $ingredient');
              await _recipeOperations.addIngredientToRecipe(
                  recipeId, ingredient);
            }
          }

          for (var tag in uniqueTags) {
            print('Adding tag: $tag');
            await _recipeOperations.addTagToRecipeIfNotExists(recipeId, tag);
          }
        }

        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Recipe Saved Successfully')),
        );
        Navigator.pop(context); // Navigate back after saving
        _resetIngredients();
        widget.onRecipeSaved();
      } catch (e) {
        print('Error saving recipe: $e');
      }
    }
  }

  void _resetIngredients() {
    setState(() {
      for (var controller in _ingredientControllers) {
        controller.dispose();
      }
      for (var focusNode in _ingredientFocusNodes) {
        focusNode.dispose();
      }
      _ingredientControllers = List.generate(4, (_) => TextEditingController());
      _ingredientFocusNodes = List.generate(4, (_) => FocusNode());
    });
  }

  Future<void> _loadRecipeData(int recipeId) async {
    try {
      final recipes = await _recipeOperations.getRecipes();
      final recipe = recipes.firstWhere((r) => r.recipeId == recipeId);

      final tags = recipe.tags ?? [];
      final ingredients = recipe.ingredients ?? [];

      setState(() {
        _recipeNameController.text = recipe.recipeName;
        _descriptionController.text = recipe.recipeDescription;
        _imagePath = recipe.imagePath;
        if (_imagePath == '') _imagePath = null;
        _selectedHour = recipe.hours;
        _selectedMinute = recipe.minutes;
        _directionsController.text = recipe.directions;
        _linkController.text = recipe.link;

        _tags.clear();
        _tags.addAll(tags);

        _ingredientControllers = List.generate(
          ingredients.length,
          (index) => TextEditingController(text: ingredients[index]),
        );
      });
    } catch (e) {
      print('Error loading recipe data: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Error loading recipe data')),
      );
    }
  }

  void _addTag() {
    final tag = _tagController.text.trim();
    if (tag.isNotEmpty && !_tags.contains(tag)) {
      setState(() {
        _tags.add(tag);
        _tagController.clear();
        _selectedTag = null; // Reset selected tag
      });
    }
  }

  void _removeTag(String tag) {
    setState(() {
      _tags.remove(tag);
      if (_selectedTag == tag) {
        _selectedTag = null; // Clear selected tag if it's removed
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: const BackButton(),
        title: Text(widget.recipeId != null ? 'Edit Recipe' : 'New Recipe'),
        bottom: TabBar(
          controller: _tabController,
          tabs: const [
            Tab(text: 'Recipe'),
            Tab(text: 'Details'),
          ],
        ),
        actions: [
          IconButton(
            onPressed: _saveRecipe,
            icon: const Icon(Icons.check),
          ),
        ],
      ),
      body: Form(
        key: _formKey,
        child: TabBarView(
          controller: _tabController,
          children: [
            _buildRecipeTab(),
            _buildDetailsTab(),
          ],
        ),
      ),
    );
  }

  Widget _buildRecipeTab() {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        children: [
          _buildImagePicker(),
          _buildTextField(_recipeNameController, 'Recipe Name',
              validator: (value) {
            if (value == null || value.isEmpty) {
              return 'Recipe Name is required';
            }
            return null;
          }),
          const SizedBox(height: 16),
          _buildTextField(_descriptionController, 'Recipe Description',
              maxLines: 2, validator: (value) {
            if (value == null || value.isEmpty) {
              return 'Recipe Description is required';
            }
            return null;
          }),
          const SizedBox(height: 16),
          _buildTagInputRow(),
          const SizedBox(height: 16),
          _buildTagDropdown(), // Add dropdown here
          const SizedBox(height: 16),
          _buildTimePickers(),
          _buildTextField(_linkController, 'Add Your Favourite Link'),
        ],
      ),
    );
  }

  Widget _buildDetailsTab() {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        children: [
          _buildTextField(_directionsController, 'Directions', maxLines: 5),
          const SizedBox(height: 16),

          // Ingredients section
          Expanded(
            child: ListView.builder(
              itemCount: _ingredientControllers.length,
              itemBuilder: (context, index) {
                return Padding(
                  padding: const EdgeInsets.symmetric(vertical: 8.0),
                  child: _buildTextField(
                    _ingredientControllers[index],
                    'Ingredient ${index + 1}',
                    focusNode: _ingredientFocusNodes[index],
                  ),
                );
              },
            ),
          ),
          const SizedBox(height: 16),
          ElevatedButton(
            onPressed: () {
              setState(() {
                _ingredientControllers.add(TextEditingController());
                _ingredientFocusNodes.add(FocusNode());
              });
            },
            child: const Text('Add Ingredient'),
          ),
        ],
      ),
    );
  }

  Widget _buildImagePicker() {
    return GestureDetector(
      onTap: _pickImage,
      child: _imagePath != null
          ? Image.file(
              File(_imagePath!),
              fit: BoxFit.cover,
              width: double.infinity,
              height: 200,
            )
          : Container(
              color: const Color.fromARGB(255, 255, 255, 255),
              width: double.infinity,
              height: 200,
              child: Center(child: Text('Tap to select image')),
            ),
    );
  }

  Widget _buildTextField(
    TextEditingController controller,
    String hint, {
    int maxLines = 1,
    String? Function(String?)? validator,
    FocusNode? focusNode,
  }) {
    return TextFormField(
      controller: controller,
      maxLines: maxLines,
      decoration: InputDecoration(
        hintText: hint,
        border: OutlineInputBorder(),
      ),
      validator: validator,
      focusNode: focusNode,
    );
  }

  Widget _buildTagInputRow() {
    return Row(
      children: [
        Expanded(
          child: TextFormField(
            controller: _tagController,
            decoration: const InputDecoration(
              hintText: 'Add Tag',
              border: OutlineInputBorder(),
            ),
          ),
        ),
        IconButton(
          onPressed: _addTag,
          icon: const Icon(Icons.add),
        ),
        IconButton(
          onPressed:
              _selectedTag != null ? () => _removeTag(_selectedTag!) : null,
          icon: const Icon(Icons.remove),
        ),
      ],
    );
  }

  Widget _buildTagDropdown() {
    return DropdownButtonFormField<String>(
      value: _selectedTag,
      items: _tags
          .map((tag) => DropdownMenuItem<String>(
                value: tag,
                child: Text(tag),
              ))
          .toList(),
      onChanged: (value) {
        setState(() {
          _selectedTag = value;
        });
      },
      decoration: const InputDecoration(
        labelText: 'Select Tag',
        border: OutlineInputBorder(),
      ),
    );
  }

  Widget _buildTimePickers() {
    return Row(
      children: [
        Expanded(
          child: DropdownButtonFormField<int>(
            value: _selectedHour,
            items: _hours
                .map((hour) => DropdownMenuItem<int>(
                      value: hour,
                      child: Text(hour.toString().padLeft(2, '0')),
                    ))
                .toList(),
            onChanged: (value) {
              setState(() {
                _selectedHour = value ?? 0;
              });
            },
            decoration: const InputDecoration(
              labelText: 'Hours',
              border: OutlineInputBorder(),
            ),
          ),
        ),
        const SizedBox(width: 16),
        Expanded(
          child: DropdownButtonFormField<int>(
            value: _selectedMinute,
            items: _minutes
                .map((minute) => DropdownMenuItem<int>(
                      value: minute,
                      child: Text(minute.toString().padLeft(2, '0')),
                    ))
                .toList(),
            onChanged: (value) {
              setState(() {
                _selectedMinute = value ?? 0;
              });
            },
            decoration: const InputDecoration(
              labelText: 'Minutes',
              border: OutlineInputBorder(),
            ),
          ),
        ),
      ],
    );
  }
}
