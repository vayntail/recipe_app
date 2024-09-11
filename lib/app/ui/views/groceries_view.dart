import 'package:flutter/material.dart';

class GroceriesView extends StatefulWidget {
  const GroceriesView({super.key});
  @override
  State<GroceriesView> createState() => _GroceriesViewState();
}

class _GroceriesViewState extends State<GroceriesView> {
  /// List of ingredients
  List<ListItem> itemsList = [
    const ListItem(), // First default
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(title: const Text('Groceries')),
        body: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text("Today's List"),
                Row(
                  children: [
                    // Buttons
                    IconButton(
                        icon: const Icon(Icons.clear_all),
                        tooltip: 'Clear All',
                        onPressed: () {
                          setState(() {
                            itemsList.clear();
                            itemsList.add(const ListItem());
                          });
                        }),
                    IconButton(
                        icon: const Icon(Icons.add),
                        tooltip: 'Add New',
                        onPressed: () {
                          setState(() {
                            itemsList.add(const ListItem());
                          });
                        }),
                  ],
                )
              ],
            ),
            Expanded(
                child: ListView.builder(
                    itemCount: itemsList.length,
                    itemBuilder: (context, index) {
                      debugPrint(itemsList.toString());
                      return itemsList[index];
                    }))
          ],
        ));
  }
}

/// List Item
class ListItem extends StatefulWidget {
  const ListItem({super.key});

  @override
  State<ListItem> createState() => _ListItemState();
}

class _ListItemState extends State<ListItem> {
  bool isChecked = false;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: <Widget>[
        Checkbox(
            value: isChecked,
            onChanged: (bool? value) {
              setState(() {
                isChecked = value!;
              });
            }),
        const Flexible(
          child: TextField(
              decoration: InputDecoration(
            hintText: "Type an ingredient...",
          )),
        ),
      ],
    );
  }
}
