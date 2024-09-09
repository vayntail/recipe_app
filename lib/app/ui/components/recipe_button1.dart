import 'dart:io';

import 'package:flutter/material.dart';
import 'package:recipe_app/app/model/recipe.dart';

class RecipeButton1 extends StatelessWidget {
  const RecipeButton1(
      {super.key,
      required this.recipe});

  final Recipe recipe;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        // On Card Pressed
      },
      child: Card(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10),
          side: const BorderSide(
            color: Colors.black,
            width: 1,
          ),
        ),
        child: Container(
          color: Colors.white,
          height: 115,
          padding:
              const EdgeInsets.only(bottom: 8, top: 8, left: 15, right: 15),
          child: Row(
            children: [
              /// Picture Image
              Container(
                height: 100,
                width: 100,
                color: Colors.grey[200],
                child:  Image(image: AssetImage(recipe.imgPath)),
              ),

              /// Horizontal Spacer
              const SizedBox(
                width: 20,
              ),

              /// Name + Description Texts
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(recipe.name),
                    Text(recipe.description),
                  ],
                ),
              ),

              /// Time Text
              Text("${recipe.minutes}min."),
            ],
          ),
        ),
      ),
    );
  }
}
