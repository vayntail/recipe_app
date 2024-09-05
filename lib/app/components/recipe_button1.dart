import 'package:flutter/material.dart';

class RecipeButton1 extends StatelessWidget {
  const RecipeButton1(
      {super.key,
      required this.name,
      required this.description,
      required this.minutes});

  final String name;
  final String description;
  final int minutes;

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
                    Text(name),
                    Text(description),
                  ],
                ),
              ),

              /// Time Text
              Text("${minutes}min."),
            ],
          ),
        ),
      ),
    );
  }
}
