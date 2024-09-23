import 'package:flutter/material.dart';
import 'package:recipe_app/app/model/recipe.dart';
import 'package:dotted_border/dotted_border.dart';
import 'package:recipe_app/app/ui/themes/theme_controller.dart';
import 'dart:io';

import 'package:recipe_app/app/ui/widgets/texts_widget.dart';
// Search bar
Widget searchBar(Function onChanged){
  return Padding(
          padding: const EdgeInsets.all(8.0),
          child: Padding(
            padding: const EdgeInsets.only(right: 70),
            child: TextField(
              decoration: InputDecoration(
                contentPadding: const EdgeInsets.symmetric(vertical: -10),
                enabledBorder: searchBarBorder(),
                border: searchBarBorder(),
                focusedBorder: searchBarBorder(),
                fillColor: Colors.transparent,
                filled: true,
                hintText: 'Search by recipe or tag...',
                prefixIcon: SizedBox(width: 10, height: 10, child: Image.asset("assets/icons/search.png")),
              ),
              onChanged: (query) {
                onChanged(query);
              },
            ),
          ),
        );
}
searchBarBorder(){
  return const OutlineInputBorder(
                borderSide: BorderSide(color: Color.fromARGB(255, 68, 62, 62), width: 1),
              );
}


// Tags Filter
Widget tagsFilter(List<String>tags, String searchQuery, Function onSelected){
  return SingleChildScrollView(
              scrollDirection: Axis.horizontal,
                child: Padding(
                  padding: const EdgeInsets.only(),
                  child: Positioned(
                    left: 0,
                    child: Row(
                        children: tags.map((tag) {
                          return Padding(
                            padding: const EdgeInsets.only(left: 3, right: 3),
                            child: ChoiceChip(

                              selectedColor: const Color.fromARGB(255, 234, 197, 191),
                              backgroundColor: const Color.fromARGB(255, 243, 230, 226),
                              showCheckmark: false,
                                label:
                        
                                 buttonDescriptionText(tag),
                       
                                selected: searchQuery == tag,
                                onSelected: (isSelected){
                                  onSelected(isSelected, tag);
                                },
                                                  
                            ),
                          );
                        }).toList(),
                    ),
                  ),
                ),

            );
}

// Home Recipe Button
Widget recipeImageWidget(String imagePath, double? height) {
  double borderRadius = 10;
  return DottedBorder(
    borderType: BorderType.RRect,
    dashPattern: [6, 3, 6, 3],
    
    color: const Color.fromARGB(255, 0, 0, 0),
    radius: Radius.circular(borderRadius),
    child: ClipRRect(
      borderRadius: BorderRadius.circular(borderRadius),
      child: Container(
        height: height,
        width: height,
        decoration: BoxDecoration(
          color: const Color.fromARGB(147, 255, 247, 247),
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
                    color: const Color.fromARGB(255, 88, 79, 79),
                    fontSize: 14,
                  ),
                ),
              )
            : null,
      ),
    ),
  );
}