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

  bool listLoaded = false;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          centerTitle: true,title: appBarTitleText("Groceries")),
        body: Padding(
          padding: const EdgeInsets.only(top: 37, left: 8, right: 8,),
          child: Container(
            decoration: const BoxDecoration(
              
              border: Border(
                top: BorderSide(
                  width: 1.5,
                  color: Colors.black,
                ),
                left: BorderSide(
                  width: 1.5,
                  color: Colors.black,
                ),
                right: BorderSide(
                  width: 1.5,
                  color: Colors.black,
                ),
              ),
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(7),
                topRight: Radius.circular(7)
                )
            ),

            child: Column(
              children: [
              Container(
                decoration: const BoxDecoration(
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(7),
                    topRight: Radius.circular(7)
                  ),
                  color: Color.fromARGB(255, 255, 243, 240),
                  border: Border(bottom: BorderSide(
                    color: Colors.black,
                    width: 1.5,
                    ))
                ),
                padding: const EdgeInsets.only(left: 18, right: 8, top: 20, bottom: 8),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    headingText("Today's List"),
                    Row(
                      children: [
                        // Buttons
                        SizedBox(
                          width: 45,
                          height: 45,
                          child: IconButton(
                              icon: Image.asset('assets/icons/clear.png'),
                              tooltip: 'Clear All',
                              onPressed: () {
                                setState(() {
                                  _clearAllItems();
                                });
                              }),
                        ),
                        SizedBox(
                          width: 45,
                          height: 45,
                          child: IconButton(
                              icon: Image.asset('assets/icons/add2.png'),
                              tooltip: 'Add New',
                              onPressed: () {
                                setState(() {
                                  _addNewGroceryItem();
                                });
                              }),
                        ),
                      ],
                    )
                  ],
                ),
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
                                    return ListItem(groceryItem: snapshot.data[index]);
                                  }),
                  ): Container();
                  })
            ]),
          ),
        ));
  }
}