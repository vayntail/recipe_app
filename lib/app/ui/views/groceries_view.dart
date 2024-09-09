import 'package:flutter/material.dart';

class GroceriesView extends StatelessWidget {
  const GroceriesView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Groceries')),
      body: const Placeholder(),
    );
  }
}