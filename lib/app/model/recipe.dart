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

  @override
  String toString() {
    return 'Recipe{id: $recipeId, name: $recipeName}';
  }
}
