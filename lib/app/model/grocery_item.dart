class GroceryItem {
  int? id;
  String name;
  int checked;

  GroceryItem({
    this.id,
    required this.name,
    required this.checked,
  });

  // Return a bool for whether GroceryItem is checked or not.
  bool boolChecked() {
    return checked==1?true:false;
  }

  // Convert a GroceryItem into Map. The keys must correspond to names in database.
  Map<String, Object?> toMap() {
    return {
      "grocery_id": id,
      "grocery_name": name,
      "checked": checked,
    };
  }
  
  // Implement toString to make it easier to see information
  @override
  String toString() {
    return 'GroceryItem{id: $id, name: $name, checked: $checked}';
  }
}
