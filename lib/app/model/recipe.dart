class Recipe {
  final int recipeId;
  final String imagePath;
  final String recipeName;
  final String recipeDescription;
  final int hours;
  final int minutes;
  List<String> ingredients;
  final String directions;
  final String link;
  List<String> tags;

  Recipe({
    required this.recipeId,
    required this.imagePath,
    required this.recipeName,
    required this.recipeDescription,
    required this.hours,
    required this.minutes,
    this.ingredients = const [], // Default to empty list if not provided
    required this.directions,
    required this.link,
    this.tags = const [], // Default to empty list if not provided
  });
// Add this method to create a Recipe object from a map
  factory Recipe.fromMap(Map<String, dynamic> map) {
    return Recipe(
      recipeId: map['recipe_id'] as int,
      imagePath: map['image_path'] as String,
      recipeName: map['recipe_name'] as String,
      recipeDescription: map['recipe_description'] as String,
      hours: map['hours'] as int,
      minutes: map['minutes'] as int,
      directions: map['directions'] as String,
      link: map['link'] as String,
      tags: (map['tags'] as List<dynamic>?)?.cast<String>() ?? [],
    );
  }
  @override
  String toString() {
    return 'Recipe{id: $recipeId, name: $recipeName}';
  }
}
