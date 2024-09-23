import 'package:flutter/material.dart';
import 'package:recipe_app/app/ui/widgets/texts_widget.dart';
import 'package:recipe_app/app/db/database.dart';

class SettingsView extends StatelessWidget {
  const SettingsView({super.key});

  Future<void> _deleteDatabase(BuildContext context) async {
    try {
      await DatabaseHelper().resetDatabase();

      // Show a success message
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Database deleted successfully')),
      );
    } catch (e) {
      // Show an error message if something goes wrong
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error deleting database: $e')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: false,title: appBarTitleText("Settings")),
      body: const Column(
        children: [
          const SizedBox(height: 20),
          ElevatedButton(
            onPressed: () => _showDeleteConfirmationDialog(context),
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.red,
              foregroundColor: Colors.white,
            ),
            child: const Text('Delete Database'),
          ),
        ],
      ),
    );
  }

  void _showDeleteConfirmationDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Delete Database'),
          content: const Text(
              'Are you sure you want to delete the entire database? This action cannot be undone.'),
          actions: <Widget>[
            TextButton(
              child: const Text('Cancel'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            TextButton(
              child: const Text('Delete'),
              onPressed: () {
                Navigator.of(context).pop();
                _deleteDatabase(context);
              },
            ),
          ],
        );
      },
    );
  }
}
