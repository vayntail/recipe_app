import 'package:flutter/material.dart';
import 'package:recipe_app/app/db/recipedb_operations.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';

class NewRecipeScreen extends StatefulWidget {
  final VoidCallback onRecipeSaved;

  const NewRecipeScreen({super.key, required this.onRecipeSaved});

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
        // Ensure tags are unique and have valid length
        final uniqueTags =
            _tags.toSet().where((tag) => tag.length <= 15).toList();

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
            await _recipeOperations.addIngredientToRecipe(recipeId, ingredient);
          }
        }

        for (var tag in uniqueTags) {
          print('Adding tag: $tag');
          await _recipeOperations.addTagToRecipeIfNotExists(recipeId, tag);
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: const BackButton(),
        title: const Text('New Recipe'),
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
          _buildTimePickers(),
          _buildTextField(_linkController, 'Add Your Favourite Link'),
          const SizedBox(height: 16),
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
      child: Container(
        height: 200,
        width: double.infinity,
        color: Colors.grey[300],
        child: _imagePath != null
            ? Image.file(File(_imagePath!))
            : const Center(child: Text('Tap to select an image')),
      ),
    );
  }

  Widget _buildTextField(TextEditingController controller, String labelText,
      {int? maxLines,
      FocusNode? focusNode,
      String? Function(String?)? validator}) {
    return TextFormField(
      controller: controller,
      decoration: InputDecoration(
        labelText: labelText,
      ),
      maxLines: maxLines,
      focusNode: focusNode,
      validator: validator,
    );
  }

  Widget _buildTagInputRow() {
    return Row(
      children: [
        Expanded(
          child: _buildTextField(_tagController, 'Tag Name'),
        ),
        const SizedBox(width: 8),
        ElevatedButton(
          onPressed: () {
            if (_tagController.text.isNotEmpty) {
              setState(() {
                if (!_tags.contains(_tagController.text)) {
                  _tags.add(_tagController.text);
                  _selectedTag ??= _tagController.text;
                }
                _tagController.clear();
              });
            }
          },
          child: const Text('Add Tag'),
        ),
        const SizedBox(width: 8),
        DropdownButton<String>(
          value: _tags.isNotEmpty
              ? _selectedTag
              : _tags.isEmpty
                  ? null
                  : _tags.first,
          hint: const Text('Select Tag'),
          onChanged: (String? newValue) {
            setState(() {
              _selectedTag = newValue;
            });
          },
          items: _tags.map<DropdownMenuItem<String>>((String tag) {
            return DropdownMenuItem<String>(
              value: tag,
              child: Text(tag),
            );
          }).toList(),
        ),
      ],
    );
  }

  Widget _buildTimePickers() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Expanded(
          child: DropdownButtonFormField<int>(
            value: _selectedHour,
            items: _hours.map<DropdownMenuItem<int>>((int hour) {
              return DropdownMenuItem<int>(
                value: hour,
                child: Text(hour.toString().padLeft(2, '0')),
              );
            }).toList(),
            onChanged: (int? newValue) {
              setState(() {
                _selectedHour = newValue ?? 0;
              });
            },
            decoration: const InputDecoration(
              labelText: 'Hours',
            ),
          ),
        ),
        const SizedBox(width: 16),
        Expanded(
          child: DropdownButtonFormField<int>(
            value: _selectedMinute,
            items: _minutes.map<DropdownMenuItem<int>>((int minute) {
              return DropdownMenuItem<int>(
                value: minute,
                child: Text(minute.toString().padLeft(2, '0')),
              );
            }).toList(),
            onChanged: (int? newValue) {
              setState(() {
                _selectedMinute = newValue ?? 0;
              });
            },
            decoration: const InputDecoration(
              labelText: 'Minutes',
            ),
          ),
        ),
      ],
    );
  }
}
