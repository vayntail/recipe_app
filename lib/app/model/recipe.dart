class Recipe {
  final int recipeId;
  final String imagePath;
  final String recipeName;
  final String recipeDescription;
  final int hours;
  final int minutes;
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
    required this.directions,
    required this.link,
    this.tags = const [],
  });
}
