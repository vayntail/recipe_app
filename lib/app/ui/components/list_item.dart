import 'package:flutter/material.dart';
import 'package:recipe_app/app/db/grocerydb_operations.dart';
import 'package:recipe_app/app/model/grocery_item.dart';

/// Grocery List Item
class ListItem extends StatefulWidget {
  const ListItem(
      {super.key, required this.groceryItem});
  final GroceryItem groceryItem;

  @override
  State<ListItem> createState() => _ListItemState();
}

class _ListItemState extends State<ListItem> {
  final TextEditingController _textController = TextEditingController();
  final GroceryOperations _groceryOperations = GroceryOperations();
  TextStyle style = const TextStyle();

  // Update GroceryItem in database
  Future<void> updateGroceryItem() async {
    await _groceryOperations.updateGroceryItem(widget.groceryItem);
  }

  // Update Style
  updateStyle() {
    if (widget.groceryItem.boolChecked()) {
      // If checked, put a style that puts checkmark through text
      style = const TextStyle(decoration: TextDecoration.lineThrough);
    } else {
      style = const TextStyle();
    }
  }

  @override
  Widget build(BuildContext context) {
    _textController.text = widget.groceryItem.name;

    return Padding(
      padding: const EdgeInsets.only(right: 8,),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.end,
        children: <Widget>[
          Checkbox(
            
              value: widget.groceryItem.boolChecked(),
              onChanged: (bool? value) {
                setState(() {
                  // If true, set checked to 0(false)
                  if (widget.groceryItem.boolChecked()) {
                    widget.groceryItem.checked = 0;
                  } else {
                    widget.groceryItem.checked = 1;
                  }
                  // update GroceryItem in database
                  updateGroceryItem();
                  updateStyle();
                });
              }),
          Flexible(
            child: TextField(
                controller: _textController,
                onChanged: (text) {
                  // On text changed, update GroceryItem
                  setState(() {
                    widget.groceryItem.name = text;
                    // update GroceryItem in database
                    updateGroceryItem();
                  });
                },
                
                decoration: InputDecoration(
                  enabled: !widget.groceryItem.boolChecked(),
                  hintText: "Type an ingredient...",
                  labelText: widget.groceryItem.name,
                  border: const UnderlineInputBorder(),
                  floatingLabelBehavior: FloatingLabelBehavior.never,
                  contentPadding: const EdgeInsets.all(0),
                  labelStyle: style,
                  focusedBorder: const UnderlineInputBorder(),
                )),
          ),
        ],
      ),
    );
  }
}
