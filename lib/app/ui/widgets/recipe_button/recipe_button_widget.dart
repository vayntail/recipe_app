import 'package:flutter/material.dart';
import 'package:recipe_app/app/model/recipe.dart';
import 'package:dotted_border/dotted_border.dart';
import 'package:recipe_app/app/ui/themes/theme_controller.dart';
import 'dart:io';

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
                  color: const Color.fromARGB(255, 243, 236, 236),
                  border: Border.all(
                    color: const Color.fromARGB(255, 175, 175, 175),
                    width: 2,
                  ),
                  borderRadius: BorderRadius.circular(10)),
              padding: const EdgeInsets.all(8),
              height: 120,
              child: Row(
                children: [
                  // Image
                  recipeImageWidget(recipe.imagePath, 100),

                  // Gap
                  const SizedBox(
                    width: 10
                  ),

                  // Text
                  Stack(children: [
                    // Name and description
                    Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        buttonTitleText(recipe.recipeName),
                        buttonDescriptionText(recipe.recipeDescription)
                      ],
                    )),
                    // Time
                  ])
                ],
              )),
        ),
        // cute picture
        const Positioned(
            right: 0,
            top: 0,
            child: SizedBox(
              height: 30,
              width: 30,
              child: Image(
                  image: AssetImage('assets/Layer1.png'), fit: BoxFit.cover),
            )),
      ]));
}


// Widget button used for recipe_button
Widget recipeImageWidget(String imagePath, double? height) {
  double borderRadius = 10;

  return DottedBorder(
    borderType: BorderType.RRect,
    dashPattern: [6, 3, 6, 3],
    color: const Color.fromARGB(255, 97, 87, 84),
    radius: Radius.circular(borderRadius),
    child: ClipRRect(
      borderRadius: BorderRadius.circular(borderRadius),
      child: Container(
        height: height,
        width: height,
        decoration: BoxDecoration(
          color: Colors.grey[200],
          image: imagePath.isNotEmpty && File(imagePath).existsSync()
              ? DecorationImage(
                  image: FileImage(File(imagePath)),
                  fit: BoxFit.cover,
                )
              : null, // No image
        ),
        child: imagePath.isEmpty || !File(imagePath).existsSync()
            ? Center(
                child: Text(
                  'No Image',
                  style: TextStyle(
                    color: Colors.grey[600],
                    fontSize: 14,
                  ),
                ),
              )
            : null,
      ),
    ),
  );
}


Widget buttonTitleText(String title) {
  return Text(
    style: const TextStyle(
      fontSize: 30,
      color: Color.fromARGB(255, 71, 48, 43),
    ),
    title
  );
}

Widget buttonDescriptionText(String description) {
  return Text(
    style: const TextStyle(
      fontSize: 18,
      color: Color.fromARGB(255, 168, 157, 156),
    ),
    description
  );
}