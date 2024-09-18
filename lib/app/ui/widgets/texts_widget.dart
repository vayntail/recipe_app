import 'dart:io';
import 'package:flutter/material.dart';

// Different styles of text
Widget appBarTitleText(String title) {
  return Text(
    style: const TextStyle(
      fontSize: 34,
      color: Color.fromARGB(255, 58, 46, 45),
      fontFamily: 'Mansalva'
    ),
    title
  );
}

Widget headingText(String text){
  return Text(
    style: const TextStyle(
      fontSize: 30,
    ),
    text
  );
}