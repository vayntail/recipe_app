import 'package:flutter/material.dart';
import 'package:recipe_app/app/model/recipe.dart';
import 'package:recipe_app/app/ui/widgets/recipe_image_widget.dart';
import 'package:recipe_app/app/ui/themes/theme_controller.dart';

// Widget button used for recipe_button
Widget recipeButtonWidget(Recipe recipe, bool mealButton) {
  double? height;
  double? imgHeight;
  if (mealButton){
    height = 100;
    imgHeight = 80;
  }
  return Container(
      // Container THEME!!
      decoration: BoxDecoration(
        border: Border.all(
          color: const Color.fromARGB(255, 175, 175, 175),
          width: 2,
        ),
        borderRadius: BorderRadius.circular(10)
      ),
      padding: EdgeInsets.all(8),
      height: height,
      child: Row(
        children: [
          // Image
          recipeImageWidget(recipe.imagePath, imgHeight),

          // Text
          Stack(children: [
            // Name and description
            Expanded(
                child: Column(
              children: [
                Text(recipe.recipeName),
                Text(recipe.recipeDescription)
              ],
            )),
            // Time
          ])
        ],
      ));
}
