import 'package:flutter/material.dart';
import 'package:recipe_app/app/db/recipedb_operations.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';

class NewRecipeScreen extends StatefulWidget {
  const NewRecipeScreen({super.key});

  @override
  _NewRecipeScreenState createState() => _NewRecipeScreenState();
}

class _NewRecipeScreenState extends State<NewRecipeScreen>
    with SingleTickerProviderStateMixin {
  // Controllers
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

  // Ingredient controllers
  List<TextEditingController> _ingredientControllers =
      List.generate(4, (_) => TextEditingController());

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

    // Dispose ingredient controllers
    for (var controller in _ingredientControllers) {
      controller.dispose();
    }
    super.dispose();
  }

  Future<void> _pickImage() async {
    final XFile? pickedFile =
        await _picker.pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      setState(() {
        _imagePath = pickedFile.path;
      });
    }
  }

  Future<void> _saveRecipe() async {
    final int recipeId = await _recipeOperations.insertRecipe(
      _recipeNameController.text,
      _descriptionController.text,
      _imagePath ?? '',
      _selectedHour,
      _selectedMinute,
      _directionsController.text,
      _linkController.text,
    );

    // Save ingredients
    for (var controller in _ingredientControllers) {
      String ingredient = controller.text;
      if (ingredient.isNotEmpty) {
        await _recipeOperations.addIngredientToRecipe(recipeId, ingredient);
      }
    }

    // Save tags
    for (String tag in _tags) {
      await _recipeOperations.addTagToRecipe(recipeId, tag);
    }

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Recipe Saved Successfully')),
    );

    // Function to reset to 4 text boxes after saving
    _resetIngredients();
  }

  void _resetIngredients() {
    setState(() {
      _ingredientControllers = List.generate(4, (_) => TextEditingController());
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
          )
        ],
      ),
      body: TabBarView(
        controller: _tabController,
        children: [
          _buildRecipeTab(),
          _buildDetailsTab(),
        ],
      ),
    );
  }

  Widget _buildRecipeTab() {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        children: [
          _buildImagePicker(),
          _buildTextField(_recipeNameController, 'Recipe Name'),
          const SizedBox(height: 16),
          _buildTextField(_descriptionController, 'Recipe Description',
              maxLines: 2),
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
                      _ingredientControllers[index], 'Ingredient ${index + 1}'),
                );
              },
            ),
          ),
          const SizedBox(height: 16),

          ElevatedButton(
            onPressed: () {
              setState(() {
                _ingredientControllers.add(TextEditingController());
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
      {int? maxLines}) {
    return TextField(
      controller: controller,
      decoration: InputDecoration(labelText: labelText),
      maxLines: maxLines,
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
            setState(() {
              _tags.add(_tagController.text);
              _tagController.clear();
            });
          },
          child: const Text('Add Tag'),
        ),
        const SizedBox(width: 8),
        DropdownButton<String>(
          value: _selectedTag,
          hint: const Text('Tags'),
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
        DropdownButton<int>(
          value: _selectedHour,
          onChanged: (int? newValue) {
            setState(() {
              _selectedHour = newValue!;
            });
          },
          items: _hours.map<DropdownMenuItem<int>>((int value) {
            return DropdownMenuItem<int>(
              value: value,
              child: Text('$value Hours'),
            );
          }).toList(),
        ),
        DropdownButton<int>(
          value: _selectedMinute,
          onChanged: (int? newValue) {
            setState(() {
              _selectedMinute = newValue!;
            });
          },
          items: _minutes.map<DropdownMenuItem<int>>((int value) {
            return DropdownMenuItem<int>(
              value: value,
              child: Text('$value Minutes'),
            );
          }).toList(),
        ),
      ],
    );
  }
}
