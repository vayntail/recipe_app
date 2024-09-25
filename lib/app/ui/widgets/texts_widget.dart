import 'package:flutter/material.dart';

// Different styles of text
Widget appBarTitleText(String title) {
  return Text(
      style: const TextStyle(
          decoration: TextDecoration.underline,
          fontSize: 34,
          color: Color.fromARGB(255, 58, 46, 45),
          fontFamily: 'Mansalva'),
      title);
}

Widget headingText(String text) {
  return Text(
      style: const TextStyle(
        fontSize: 30,
      ),
      text);
}

Widget buttonTitleText(String title) {
  return Text(
      style: const TextStyle(
        fontSize: 30,
        color: Color.fromARGB(255, 71, 48, 43),
      ),
      title);
}

Widget buttonDescriptionText(String description) {
  return Text(
      style: const TextStyle(
        fontSize: 18,
        color: Color.fromARGB(255, 117, 101, 100),
      ),
      description);
}
