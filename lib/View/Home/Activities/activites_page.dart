import 'package:flutter/material.dart';
import 'package:healthhubcustomer/Controller/providers/food_provider.dart';
import 'package:provider/provider.dart';

class FoodLogPage extends StatefulWidget {
  const FoodLogPage({super.key});

  @override
  State<FoodLogPage> createState() => _FoodLogPageState();
}

class _FoodLogPageState extends State<FoodLogPage> {
  @override
  void initState() {
    super.initState();
    final foodProvider = context.read<FoodProvider>();
    foodProvider.getFoodCategories(); // Fetch categories on initialization
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Food Log'),
      ),
      body: Consumer<FoodProvider>(
        builder: (context, foodProvider, child) {
          // Check loading state
          if (foodProvider.foodCategories.isEmpty ) {
            return const Center(child: CircularProgressIndicator());
          }

          

          // Check for empty categories
          if (foodProvider.foodCategories.isEmpty) {
            return const Center(child: Text('No food categories available.'));
          }

          // Build the list view if data is available
          return RefreshIndicator(
            onRefresh: () async {
               foodProvider.getFoodCategories(); // Refresh data
            },
            child: ListView.builder(
              itemCount: foodProvider.foodCategories.length,
              itemBuilder: (context, index) {
                final category = foodProvider.foodCategories[index];
                return ListTile(
                  title: Text(category.categoryName ?? ""),
                );
              },
            ),
          );
        },
      ),
    );
  }
}
