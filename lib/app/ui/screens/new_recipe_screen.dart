import 'package:flutter/material.dart';

class NewRecipeScreen extends StatelessWidget {
  const NewRecipeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: BackButton(),
        title: Text("New Recipe"),
        actions: [IconButton(onPressed: () => {}, icon: Icon(Icons.check))],
      ),
      body: Placeholder(),
    );
  }
}
