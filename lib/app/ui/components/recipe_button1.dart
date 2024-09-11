import 'dart:io';
import 'package:flutter/material.dart';

class RecipeButton1 extends StatelessWidget {
  const RecipeButton1({
    super.key,
    required this.name,
    required this.description,
    required this.minutes,
    required this.imagePath,
  });

  final String name;
  final String description;
  final int minutes;
  final String imagePath;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        // Handle tap on the card
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
                decoration: BoxDecoration(
                  color: Colors.grey[200],
                  image: imagePath.isNotEmpty
                      ? DecorationImage(
                          image: File(imagePath).existsSync()
                              ? FileImage(
                                  File(imagePath)) // Load image from file path
                              : AssetImage('assets/placeholder.png')
                                  as ImageProvider, // Placeholder image
                          fit: BoxFit.cover,
                        )
                      : null,
                ),
              ),

              /// Horizontal Spacer
              const SizedBox(width: 20),

              /// Name + Description Texts
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      name,
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                      ),
                    ),
                    Text(
                      description,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ],
                ),
              ),

              /// Time Text
              Text("$minutes min."),
            ],
          ),
        ),
      ),
    );
  }
}
