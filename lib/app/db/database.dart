import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

class DatabaseHelper {
  // Singleton pattern: Private constructor
  static final DatabaseHelper _instance = DatabaseHelper._internal();

  // Factory constructor
  factory DatabaseHelper() => _instance;

  DatabaseHelper._internal();

  // The database instance
  static Database? _database;

  // Getter for the database instance
  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDatabase();
    return _database!;
  }

  // Method to delete the database and reset the instance
  Future<void> resetDatabase() async {
    final databasePath = await getDatabasesPath();
    final path = join(databasePath, 'recipesapp.db');
    await deleteDatabase(path);
    _database = null; // Reset the singleton instance
  }

  // Method to initialize the database
  Future<Database> _initDatabase() async {
    final databasePath = await getDatabasesPath();
    final path = join(databasePath, 'recipesapp.db');

    return await openDatabase(
      path,
      version: 1,
      onCreate: (db, version) async {
        // Create recipes table
        await db.execute('''
          CREATE TABLE recipes (
            recipe_id INTEGER PRIMARY KEY AUTOINCREMENT,
            image_path TEXT, 
            recipe_name TEXT CHECK(length(recipe_name) <= 20),
            recipe_description TEXT CHECK(length(recipe_description) <= 70),
            hours INTEGER CHECK(hours >= 0 AND hours <= 24),
            minutes INTEGER CHECK(minutes >= 0 AND minutes < 60),
            directions TEXT CHECK(length(directions) <= 1000),
            link TEXT CHECK(length(link) <= 100)
          )
        ''');

        // Create meal table
        await db.execute('''
          CREATE TABLE meal (
            meal_id INTEGER PRIMARY KEY AUTOINCREMENT,
            date TEXT,
            type_id INTEGER,
            recipe_id INTEGER,
            FOREIGN KEY (recipe_id) REFERENCES recipes (recipe_id),
            FOREIGN KEY (type_id) REFERENCES meal_types (type_id)
          )
        ''');

        // Create meal types
        await db.execute('''
          CREATE TABLE meal_types (
            type_id INTEGER PRIMARY KEY AUTOINCREMENT,
            type_name TEXT UNIQUE
          )
        ''');

        // Insert default meal types
        await db.execute('''
          INSERT INTO meal_types (type_name) VALUES 
          ('Breakfast'), ('Lunch'), ('Dinner'), ('Snack')
        ''');

        // Create calendar table
        await db.execute('''
          CREATE TABLE calendar (
            calendar_id INTEGER PRIMARY KEY AUTOINCREMENT,
            date TEXT
          )
        ''');

        // Create ingredients table
        await db.execute('''
          CREATE TABLE ingredients (
            ingredient_id INTEGER PRIMARY KEY AUTOINCREMENT,
            recipe_id INTEGER,
            ingredient_name TEXT CHECK(length(ingredient_name) <= 20),
            FOREIGN KEY (recipe_id) REFERENCES recipes (recipe_id)
          )
        ''');

        // Create tag table
        await db.execute('''
          CREATE TABLE tag (
            tag_id INTEGER PRIMARY KEY AUTOINCREMENT,
            tag_name TEXT CHECK(length(tag_name) <= 15)
          )
        ''');

        // Create recipe_tag table
        await db.execute('''
          CREATE TABLE recipe_tag (
            recipe_id INTEGER,
            tag_id INTEGER,
            FOREIGN KEY (recipe_id) REFERENCES recipes (recipe_id) ON DELETE CASCADE,
            FOREIGN KEY (tag_id) REFERENCES tag (tag_id) ON DELETE CASCADE,
            PRIMARY KEY (recipe_id, tag_id)
          )
        ''');

        // Create grocery_list table
        await db.execute('''
          CREATE TABLE grocery_list (
            grocery_id INTEGER PRIMARY KEY AUTOINCREMENT NOT NULL,
            grocery_name TEXT CHECK(length(grocery_name) <= 20),
            checked INTEGER
          )
        ''');
      },
    );
  }
}
