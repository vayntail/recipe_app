import 'package:flutter/material.dart';
import 'package:recipe_app/app/model/recipe.dart';
import 'package:recipe_app/app/ui/widgets/recipe_listview_widgets.dart';
import 'package:recipe_app/app/ui/widgets/texts_widget.dart';

// Widget button used for recipe_button
Widget recipeButtonWidget(Recipe recipe, bool mealButton) {
  return Container(
      padding: const EdgeInsets.only(left: 6, right: 6),
      height: 130,
      width: double.infinity,
      child: Stack(children: [
        Positioned(
          bottom: 0,
          left: 0,
          right: 0,
          child: Container(
              // Container THEME!!
              decoration: BoxDecoration(
                  color: const Color.fromARGB(255, 255, 243, 240),
                  border: Border.all(
                    color: const Color.fromARGB(255, 86, 55, 55),
                    width: 1.8,
                  ),
                  borderRadius: BorderRadius.circular(10)),
              padding: const EdgeInsets.all(8),
              height: 120,
              child: Row(
                children: [
                  // Image
                  recipeImageWidget(recipe.imagePath, 100),

                  // Gap
                  const SizedBox(width: 10),

                  // Text
                  Expanded(
                    child: Stack(children: [
                      // Name and description
                      Expanded(
                          child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          buttonTitleText(recipe.recipeName),
                          buttonDescriptionText(recipe.recipeDescription)
                        ],
                      )),
                    ]),
                  ),
                ],
              )),
        ),
        // cute picture
        const Positioned(
            right: 0,
            top: 0,
            child: SizedBox(
              height: 50,
              width: 50,
              child: Image(
                  image: AssetImage('assets/icons/button_deco.png'),
                  fit: BoxFit.cover),
            )),
        // Time
        Positioned(
            right: 8,
            bottom: 2,
            child: buttonDescriptionText(
                '${recipe.hours}hr. ${recipe.minutes}min.'))
      ]));
}
