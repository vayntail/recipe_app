import 'package:flutter/material.dart';
import 'package:recipe_app/app/model/recipe.dart';
import 'dart:io';

// Widget button used for recipe_button
Widget recipeImageWidget(String imagePath, double? height) {
  return Container(
    height: height,
    width: height,
    decoration: BoxDecoration(
      color: Colors.grey[200],
      image: imagePath.isNotEmpty
          ? DecorationImage(

              image: FileImage(File(imagePath)),
              fit: BoxFit.cover,
            )
          : null,
    ),
  );
}
