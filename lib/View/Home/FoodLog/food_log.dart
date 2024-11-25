import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:healthhubcustomer/Controller/providers/food_provider.dart';
import 'package:healthhubcustomer/View/widgets/tiles/custom_food_list_tile.dart';
import 'package:healthhubcustomer/colors/colors.dart';
import 'package:hive/hive.dart';
import 'package:provider/provider.dart';

class FoodLogPage extends StatefulWidget {
   FoodLogPage({super.key, this.isFromEdit=false, this.callBack});


  bool? isFromEdit;
  Function? callBack;

  @override
  _FoodLogPageState createState() => _FoodLogPageState();
}

class _FoodLogPageState extends State<FoodLogPage> {
  final TextEditingController foodNameController = TextEditingController();
  final ScrollController scrollController = ScrollController();
  final ValueNotifier<int> pageNumber = ValueNotifier<int>(1);

  @override
  void initState() {
    super.initState();

      final foodProvider = Provider.of<FoodProvider>(context, listen: false);
        foodProvider.getFoodCategories();

    // Scroll listener for lazy loading
    scrollController.addListener(() {
      if (scrollController.position.pixels ==
              scrollController.position.maxScrollExtent &&
          !foodProvider.isFoodItemLoading) {
        foodProvider.getFoodItemByName(
          foodName: foodNameController.text,
          pageNumber: ++pageNumber.value,
          pageSize: 20,
        );

      }
    });
  }

  void searchFood(FoodProvider foodProvider) {
    if (foodNameController.text.isNotEmpty) {
      pageNumber.value = 1; // Reset page number for new search
      foodProvider.clearFoodItems(); // Clear previous results
      foodProvider.getFoodItemByName(
        foodName: foodNameController.text,
        pageNumber: pageNumber.value,
        pageSize: 20,
        isNewSearch: true,
      );
    }
  }

  @override
  void dispose() {
    foodNameController.dispose();
    scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final foodProvider = Provider.of<FoodProvider>(context, listen: false);

    return SafeArea(
      child: Scaffold(
        floatingActionButton: FloatingActionButton(
          onPressed: () {
            showFilterBottomSheet(context, foodProvider);
          },
          child: Container(
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              boxShadow: [
                BoxShadow(
                  color:
                      Colors.black.withOpacity(0.2), // Subtle shadow for depth
                  spreadRadius: 2,
                  blurRadius: 6,
                  offset: const Offset(0, 4), // Shadow position
                ),
              ],
            ),
            padding: const EdgeInsets.all(15.0), // Adds padding around the icon
            child: const Icon(
              Icons.filter_list, // Filter icon
              size: 30,
              color: Colors.white,
            ),
          ),
        ),
        body: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            children: [
              TextField(
                controller: foodNameController,
                decoration: InputDecoration(
                  hintText:
                widget.isFromEdit == true ? "Edit food item" : "Search for a food item"
,
                  
                  
                  suffixIcon: IconButton(
                    icon: const Icon(Icons.search),
                    onPressed: () => searchFood(foodProvider),
                  ),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12.0),
                  ),
                ),
              ),
              
              const SizedBox(height: 16.0),
              Expanded(
                child: Consumer<FoodProvider>(
                  builder: (context, foodProvider, child) {
                    if (foodProvider.error != null) {
                      return Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text('Error: ${foodProvider.error}'),
                            ElevatedButton(
                              onPressed: () => searchFood(foodProvider),
                              child: const Text('Retry'),
                            ),
                          ],
                        ),
                      );
                    }

                    if (foodProvider.isInitialLoading) {
                      return const Center(child: CircularProgressIndicator());
                    }

                    if (foodProvider.foodItems.isEmpty) {
                      return const Center(
                        child: Text("Search for a food item to see results"),
                      );
                    }

                    return RefreshIndicator(
                      onRefresh: () async {
                        pageNumber.value = 1;
                        await foodProvider.getFoodItemByName(
                          foodName: foodNameController.text,
                          pageNumber: pageNumber.value,
                          pageSize: 20,
                          isNewSearch: true,
                        );
                      },
                      child: CupertinoScrollbar(
                        controller: scrollController,
                        child: ListView.builder(
                          controller: scrollController,
                          itemCount: foodProvider.foodItems.length +
                              (foodProvider.isFoodItemLoading ? 1 : 0),
                          itemBuilder: (context, index) {
                            if (index == foodProvider.foodItems.length) {
                              return const Padding(
                                padding: EdgeInsets.symmetric(vertical: 16.0),
                                child:
                                    Center(child: CircularProgressIndicator()),
                              );
                            }

                            final foodItem = foodProvider.foodItems[index];
                            return CustomFoodListTile(foodItem: foodItem, isFromFoodItem: widget.isFromEdit,
                            callBack: widget.callBack,
                            
                            );
                          },
                        ),
                      ),
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

 Widget buildFoodItemCategoryBoxes(FoodProvider foodProvider) {
  return Container(
    child: ListView.separated(
      separatorBuilder: (context, index) => const SizedBox(width: 8),
      shrinkWrap: true,
      scrollDirection: Axis.horizontal,
      itemCount: foodProvider.foodCategories.length,
      itemBuilder: (context, index) {
        return Container(
          decoration: BoxDecoration(
            color: appMainColor, // Background color
            borderRadius: BorderRadius.circular(12),
            boxShadow: [
              BoxShadow(
                color: Colors.grey.withOpacity(0.2),
                blurRadius: 8,
                offset: const Offset(0, 4), // Shadow position
              ),
            ],
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center, // Center text
            children: [
              // Optionally add an icon here, you can use a suitable icon for the category
              const Icon(
                Icons.category, // Replace with an appropriate icon
                size: 24,
                color: Colors.white, // Adjust icon color as needed
              ),
              const SizedBox(height: 8), // Spacing between icon and text
              Text(
                foodProvider.foodCategories[index].categoryName??"",
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold, // Make text bold
                  color: Colors.white, // Text color
                ),
                textAlign: TextAlign.center, // Center the text
              ),
            ],
          ),
        );
      },
    ),
  );
}


  Future<dynamic> showFilterBottomSheet(
      BuildContext context, FoodProvider foodProvider) {
    return showModalBottomSheet(
      enableDrag: true,
      isScrollControlled: true,
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) {
        return Container(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          height: 400, // Increased height for sort order options
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.1),
                blurRadius: 10,
                spreadRadius: 2,
              ),
            ],
          ),
          child: ListView(
            children: [
              Center(
                child: Container(
                  width: 40,
                  height: 4,
                  margin: const EdgeInsets.only(bottom: 20),
                  decoration: BoxDecoration(
                    color: Colors.grey[300],
                    borderRadius: BorderRadius.circular(2),
                  ),
                ),
              ),
              const Text(
                "Sort Options",
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: Colors.black87,
                ),
              ),
              const SizedBox(height: 10),
              Divider(color: Colors.grey[300]),
              // Sort by Name
              ListTile(
                leading: const Icon(Icons.sort_by_alpha, color: Colors.blue),
                title: const Text(
                  "Sort by Name",
                  style: TextStyle(fontSize: 16, color: Colors.black87),
                ),
                onTap: () {
                  _showSortOrderDialog(context, foodProvider, "Name");
                },
              ),
              Divider(color: Colors.grey[300]),
              // Sort by Calories
              ListTile(
                leading: const Icon(Icons.local_fire_department,
                    color: Colors.redAccent),
                title: const Text(
                  "Sort by Calories",
                  style: TextStyle(fontSize: 16, color: Colors.black87),
                ),
                onTap: () {
                  _showSortOrderDialog(context, foodProvider, "Calories");
                },
              ),
              Divider(color: Colors.grey[300]),
              // Sort by Protein
              ListTile(
                leading: const Icon(Icons.fitness_center, color: Colors.green),
                title: const Text(
                  "Sort by Protein",
                  style: TextStyle(fontSize: 16, color: Colors.black87),
                ),
                onTap: () {
                  _showSortOrderDialog(context, foodProvider, "Protein");
                },
              ),
              Divider(color: Colors.grey[300]),
              // Sort by Fat
              ListTile(
                leading: const Icon(Icons.fastfood, color: Colors.orange),
                title: const Text(
                  "Sort by Fat",
                  style: TextStyle(fontSize: 16, color: Colors.black87),
                ),
                onTap: () {
                  _showSortOrderDialog(context, foodProvider, "Fat");
                },
              ),
              Divider(color: Colors.grey[300]),
              // Sort by Carbs
              ListTile(
                leading: const Icon(Icons.rice_bowl, color: Colors.brown),
                title: const Text(
                  "Sort by Carbs",
                  style: TextStyle(fontSize: 16, color: Colors.black87),
                ),
                onTap: () {
                  _showSortOrderDialog(context, foodProvider, "Carbs");
                },
              ),
            ],
          ),
        );
      },
    );
  }

// Show sort order dialog
  void _showSortOrderDialog(
      BuildContext context, FoodProvider foodProvider, String sortingFactor) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text("Select Sort Order"),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              ListTile(
                title: const Text("Low to High"),
                onTap: () {
                  foodProvider.sortBy(sortingFactor, ascending: true);
                  Navigator.pop(context);
                  Navigator.pop(context); // Close the bottom sheet
                },
              ),
              ListTile(
                title: const Text("High to Low"),
                onTap: () {
                  foodProvider.sortBy(sortingFactor, ascending: false);
                  Navigator.pop(context);
                  Navigator.pop(context); // Close the bottom sheet
                },
              ),
            ],
          ),
        );
      },
    );
  }
}
