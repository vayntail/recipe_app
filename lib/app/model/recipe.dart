class Recipe {
  // final int id;
  final String name;
  final String imgPath;
  final String description;
  // final int hours;
  final int minutes;
  final List<String> tags;
  // final String directions;


  /// We probably need to put created date here too.

  Recipe({
    // required this.id,
    required this.name,
    required this.imgPath,
    required this.description,
    // required this.hours,
    required this.minutes,
    required this.tags,
    // required this.directions,
  });
}

  /// List of Recipes
  final List<Recipe> recipesList = [
    Recipe(name: "Chili", imgPath: "assets/imgs/chili-img.jpeg", description: "American chili!", minutes: 20, tags: ["american"]),
    Recipe(name: "Kimbap", imgPath: "assets/imgs/kimbap-img.jpg", description: "Korean Kimbap!", minutes: 10, tags: ["korean"]),
    Recipe(name: "Sandwich", imgPath: "assets/imgs/sandwich-img.jpg", description: "Sandwich!", minutes: 10, tags: ["american", "korean"]),
  ];