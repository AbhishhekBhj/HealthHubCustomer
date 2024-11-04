import 'dart:developer';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:healthhubcustomer/Controller/repositories/calories_repo.dart';
import 'package:healthhubcustomer/Model/data/meal_time_response.dart';
import 'package:healthhubcustomer/View/widgets/buttons/healthhub_custom_button.dart';
import 'package:healthhubcustomer/View/widgets/textfields/custom_textfield.dart';
import 'package:healthhubcustomer/colors/colors.dart';
import 'package:provider/provider.dart';
import '../../Controller/providers/calories_provider.dart';
import '../../Controller/providers/food_provider.dart';
import '../../Controller/repositories/food_repo.dart';
import '../../Model/data/food_item.dart';
import '../widgets/custom_appbar.dart';
import '../widgets/tiles/food_details.dart';

class MakeCaloricIntake extends StatefulWidget {
  MakeCaloricIntake({super.key, required this.foodItems});
  final FoodItems foodItems;

  @override
  State<MakeCaloricIntake> createState() => _MakeCaloricIntakeState();
}

class _MakeCaloricIntakeState extends State<MakeCaloricIntake> {
  List<FoodItemCategoryData> foodsCategories = [];

  final TextEditingController _caloriesController = TextEditingController();
  late CaloriesProvider _caloriesProvider;
  late FoodProvider _foodProvider;
  CaloriesRepo caloriesRepo = CaloriesRepo();
  FoodRepo foodRepo = FoodRepo();

  ValueNotifier<int> selectedMealTime = ValueNotifier<int>(1);




    List<int> mealTimes = [];

  @override
  void initState() {
    super.initState();
    _foodProvider = Provider.of<FoodProvider>(context, listen: false);
    _caloriesProvider = Provider.of<CaloriesProvider>(context, listen: false);

    // mealTimes = _foodProvider.mealTimes.map((e) => e.id).toSet().toList();
    loadFoodItemsCategories();
  }


  void callBack(){
    _caloriesProvider.getTodaysCaloricIntake();

    Future.delayed(const Duration(seconds: 1), () {
      context.push('/mainhome');
    });

  }

  void loadFoodItemsCategories() async {
    foodsCategories =
        await foodRepo.getFoodItemCategories(foodId: widget.foodItems.id);
    setState(() {}); // Refresh UI after loading categories
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(





      
      appBar: customAppBar(title: "Make Caloric Intake", context: context),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Display the food item details
            FoodItemDetailsTile(
              foodItem: widget.foodItems,
            ),
            
            const SizedBox(height: 8),
          foodsCategories.isNotEmpty
  ? Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          "Food Categories",
          style: Theme.of(context).textTheme.headlineSmall?.copyWith(
            fontWeight: FontWeight.bold,
            color: Colors.green[700],
          ),
        ),
        const SizedBox(height: 8),
        ...foodsCategories.map((category) {
          return Card(
            color: Colors.green[50],
            elevation: 4,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
            margin: const EdgeInsets.symmetric(vertical: 8),
            child: ListTile(
              contentPadding: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
              leading: Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: Colors.greenAccent[100],
                ),
                child: Icon(Icons.local_dining, color: Colors.green[700]),
              ),
              title: Text(
                category.categoryName ?? "N/A",
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                  color: Colors.green[900],
                ),
              ),
            ),
          );
        }).toList(),
      ],
    )
  : const Center(child: CircularProgressIndicator()),

  const SizedBox(height: 16),



  Container(
  width: double.infinity, // Takes full width
  child: Column(
    mainAxisSize: MainAxisSize.min, // Adjusts based on content height
    children: [
      HealthhubCustomButton(
        height: 50,
        backgroundColor: appMainColor,
        textColor: Colors.white,
        text: "Add to Caloric Intake",
        onPressed: () {
         showCupertinoDialog(
  context: context,
  builder: (context) {
    return CupertinoAlertDialog(
      title: const Text("Add to Caloric Intake"),
      content: Column(
        children: [
          const Text("Select Meal Time"),

          // Meal Time Dropdown
          ValueListenableBuilder<int>(
            valueListenable: selectedMealTime,
            builder: (context, value, child) {
              return DropdownButton<int>(
                value: value,
                items: _foodProvider.mealTimes.map((mealTime) {
                  return DropdownMenuItem<int>(
                    value: mealTime.id,
                    child: Text(mealTime.mealTimeName ?? "N/A"),
                  );
                }).toList(),
                onChanged: (value) {
                  log("Selected meal time: $value");
                  selectedMealTime.value = value ?? 1;
                },
              );
            },
          ),
          const SizedBox(height: 16), 
          TextFormField(
            
            controller: _caloriesController,
            keyboardType: TextInputType.number,
            decoration: const InputDecoration(
              labelText: "Enter Serving Size",
              hintText: "Enter the calories for this food item",
            ),
          )
        ],
      ),
      actions: [
        CupertinoDialogAction(
          onPressed: () {
            Navigator.of(context).pop(); // Close the dialog
          },
          child: const Text("Cancel"),
        ),
        CupertinoDialogAction(
          onPressed: () async {

            bool caloricPostSuccess = await caloriesRepo.makeCaloricIntakeWithoutMeal(
              foodItemId: widget.foodItems.id,
              isFromMeal: false,
              mealTimeId: selectedMealTime.value,
              servingSizeConsumed: int.parse(_caloriesController.text),
            );


            if(caloricPostSuccess){
              callBack();
            }
            
          },
          child: const Text("Add"),
        ),
      ],
    );
  },
);

          
          // Your button action here
        },
      ),
    ],
  ),
),


            // Additional widgets or content can be added here if needed
          ],
        ),
      ),

      

    );
  }
}
