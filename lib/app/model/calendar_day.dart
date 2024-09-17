import 'package:recipe_app/app/model/recipe.dart';

class CalendarDay {
  int? calendarId;
  String? day;
  List<Recipe> breakfast;
  List<Recipe> lunch;
  List<Recipe> dinner;
  List<Recipe> snacks;

  CalendarDay({
    this.calendarId,
    this.day,
    required this.breakfast,
    required this.lunch,
    required this.dinner,
    required this.snacks,
  });
}