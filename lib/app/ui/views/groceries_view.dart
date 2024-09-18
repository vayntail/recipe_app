import 'package:flutter/material.dart';
import 'package:recipe_app/app/db/grocerydb_operations.dart';
import 'package:recipe_app/app/model/grocery_item.dart';
import 'package:recipe_app/app/ui/components/list_item.dart';
import 'package:recipe_app/app/ui/widgets/texts_widget.dart';

class GroceriesView extends StatefulWidget {
  const GroceriesView({super.key});
  @override
  State<GroceriesView> createState() => _GroceriesViewState();
}

class _GroceriesViewState extends State<GroceriesView> {
  // Get Grocery List
  final GroceryOperations _groceryOperations = GroceryOperations();
  Future getGroceryList() async {
    List<GroceryItem> groceryList = await _groceryOperations.getGroceryList();

    for (var grocery in groceryList){
      debugPrint(grocery.checked.toString());
    }
    return groceryList;
  }

  // Add new item
  Future<void> _addNewGroceryItem() async {
    // New default item
    await _groceryOperations.insertGroceryItem(GroceryItem(name: "", checked: 0));
  }

  // Clear all items
  _clearAllItems() async {
    await _groceryOperations.clearGroceryList();
  }

        // Refresh the screen
  refreshScreen() {
    setState(() {
      debugPrint("refreshed");
    });
  }


  bool listLoaded = false;
  @override
  Widget build(BuildContext context) {

    
    return Scaffold(
        appBar: AppBar(title: appBarTitleText("Groceries")),
        body: Column(children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              headingText("Today's List"),
              Row(
                children: [
                  // Buttons
                  IconButton(
                      icon: const Icon(Icons.clear_all),
                      tooltip: 'Clear All',
                      onPressed: () {
                        setState(() {
                          _clearAllItems();
                        });
                      }),
                  IconButton(
                      icon: const Icon(Icons.add),
                      tooltip: 'Add New',
                      onPressed: () {
                        setState(() {
                          _addNewGroceryItem();
                        });
                      }),
                ],
              )
            ],
          ),
          // FUTURE BUILDER! from getGroceryList()
          FutureBuilder(
              future: getGroceryList(),
              builder: (context, snapshot) {
                switch (snapshot.connectionState) {
                  case ConnectionState.waiting:
                    return const Text('');
                  default:
                    if (snapshot.hasError) {
                      return Text('Error: ${snapshot.error}');
                    } else {
                      listLoaded = true;
                    }
                }
                return listLoaded? Expanded(
      child: ListView.builder(
          itemCount: snapshot.data.length,
          itemBuilder: (context, index) {
            debugPrint(snapshot.data.toString());
            return ListItem(groceryItem: snapshot.data[index], refreshScreen: refreshScreen,);
          })): Container();
              })
        ]));
  }
}