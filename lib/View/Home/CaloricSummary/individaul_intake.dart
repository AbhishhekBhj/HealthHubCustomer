import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:go_router/go_router.dart';
import 'package:healthhubcustomer/Controller/providers/calories_provider.dart';
import 'package:healthhubcustomer/Controller/repositories/calories_repo.dart';
import 'package:healthhubcustomer/Model/data/caloric_intake.dart';
import 'package:healthhubcustomer/Model/data/food_item.dart';
import 'package:healthhubcustomer/View/widgets/custom_appbar.dart';
import 'package:healthhubcustomer/colors/colors.dart';
import 'package:provider/provider.dart';

import '../../../Controller/providers/food_provider.dart';

class IndividaulIntake extends StatefulWidget {
  const IndividaulIntake({super.key, required this.caloricIntakeData});

  final CaloricIntakeDetail caloricIntakeData;

  @override
  State<IndividaulIntake> createState() => _IndividualIntakeState();
}

class _IndividualIntakeState extends State<IndividaulIntake> {
  late final ValueNotifier<bool> isChanged;
  late final ValueNotifier<FoodItems> givenFoodItem;
  late final ValueNotifier<int> givenServingSize;
  late final ValueNotifier<int> givenMealTime;
  late FoodProvider foodProvider;
  late CaloriesProvider caloriesProvider;
  CaloriesRepo caloriesRepo = CaloriesRepo();

  @override
  void initState() {
    super.initState();
    isChanged = ValueNotifier(false);
    givenFoodItem = ValueNotifier(widget.caloricIntakeData.foodItem!);
    givenServingSize = ValueNotifier(widget.caloricIntakeData.servingSizeConsumed!);
    givenMealTime = ValueNotifier(widget.caloricIntakeData.mealTimeId??0);
    foodProvider = Provider.of<FoodProvider>(context, listen: false);
    caloriesProvider = Provider.of<CaloriesProvider>(context, listen: false);
  }

  @override
  void dispose() {
    isChanged.dispose();
    givenFoodItem.dispose();
    givenServingSize.dispose();
    givenMealTime.dispose();
    super.dispose();
  }

  void callBack() {
    isChanged.value = true;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: customAppBar(title: "Intake Report", context: context),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildHeader(context),
            const SizedBox(height: 20),
            _buildIntakeDetails(context),

           Center(
             child: ValueListenableBuilder<bool>(
               valueListenable: isChanged,
               builder: (context, changed, child) {
                 return Visibility(
                   visible: changed,
                   child: ElevatedButton(
                     onPressed: () async {
                      bool isUpdateSuccess = await  caloriesRepo.editCaloricIntake(
                        foodItemId: givenFoodItem.value.id,
                        id: widget.caloricIntakeData.id,
                        mealTimeId: givenMealTime.value,
                        servingSizeConsumed: givenServingSize.value,
                      ); 

                      if(isUpdateSuccess){
                        Fluttertoast.showToast(
                          msg: "Caloric Intake Updated Successfully",
                          toastLength: Toast.LENGTH_SHORT,
                          gravity: ToastGravity.BOTTOM,
                          timeInSecForIosWeb: 1,
                          backgroundColor: Colors.green,
                          textColor: Colors.white,
                          fontSize: 16.0,
                        );
                        caloriesProvider.getTodaysCaloricIntake();
                        context.push("/mainhome");
                      }
                      else{
                        Fluttertoast.showToast(
                          msg: "Failed to Update Caloric Intake",
                          toastLength: Toast.LENGTH_SHORT,
                          gravity: ToastGravity.BOTTOM,
                          timeInSecForIosWeb: 1,
                          backgroundColor: Colors.red,
                          textColor: Colors.white,
                          fontSize: 16.0,
                        );
                      }
                     },
                     style: ElevatedButton.styleFrom(
                       foregroundColor: Colors.white,
                       backgroundColor: appMainColor,
                       shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
                       ),
                     ),
                     child: const Text("Save Changes"),
                   ),
                 );
               },
             ),
           )

          ],
        ),
      ),
    );
  }

  Widget _buildHeader(BuildContext context) {
    var mealTimeSelected = Provider.of<FoodProvider>(context)
        .mealTimes
        .where((element) => element.id == widget.caloricIntakeData.mealTimeId)
        .first
        .mealTimeName;
    return Center(
      child: Column(
        children: [
          const Text(
            "Calories Consumed",
            style: TextStyle(
              fontSize: 26,
              fontWeight: FontWeight.bold,
              color: Colors.blueAccent,
            ),
          ),
          const SizedBox(height: 8),
          Container(
            padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 20),
            decoration: BoxDecoration(
              color: Colors.orangeAccent.withOpacity(0.2),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Text(
              "${widget.caloricIntakeData.totalCalories ?? 'N/A'} kcal",
              style: const TextStyle(
                fontSize: 32,
                fontWeight: FontWeight.bold,
                color: Colors.orangeAccent,
              ),
            ),
          ),
          const SizedBox(height: 16),
          
          DropdownButtonFormField<int>(
            decoration: InputDecoration(
              labelText: "Meal Time",
              labelStyle: const TextStyle(
                color: appMainColor,
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
              contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: const BorderSide(color: Colors.blueAccent),
              ),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: const BorderSide(color: Colors.blueAccent),
              ),
            ),
            dropdownColor: Colors.white,
            value: givenMealTime.value,
            items: foodProvider.mealTimes
                .map(
                  (mealTime) => DropdownMenuItem<int>(
          value: mealTime.id,
          child: Text(
            mealTime.mealTimeName,
            style: const TextStyle(color: Colors.black87, fontSize: 16),
          ),
                  ),
                )
                .toList(),
            onChanged: (value) {
              givenMealTime.value = value!;
              isChanged.value = true;
            },
            style: const TextStyle(color: Colors.black87, fontSize: 16),
          ),
          
          const SizedBox(height: 8),
          Text(
            "Date: ${widget.caloricIntakeData.createdAt != null ? _formatDate(widget.caloricIntakeData.createdAt!) : 'N/A'}",
            style: TextStyle(fontSize: 16, color: Colors.grey[600]),
          ),
        ],
      ),
    );
  }

  Widget _buildIntakeDetails(BuildContext context) {
    return Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      elevation: 6,
      child: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [Colors.white, Colors.blue.withOpacity(0.1)],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
          borderRadius: BorderRadius.circular(16),
        ),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                "Food Item",
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: Colors.blueAccent,
                ),
              ),
              const SizedBox(height: 8),
              Row(
                children: [
                  ValueListenableBuilder<FoodItems>(
                    valueListenable: givenFoodItem,
                    builder: (context, foodItem, _) {
                      return Text(
                        foodItem.foodName ?? "N/A",
                        style: const TextStyle(fontSize: 16, color: Colors.black87),
                      );
                    },
                  ),
                  const Spacer(),
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      foregroundColor: Colors.white,
                      backgroundColor: appMainColor,
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                    ),
                    onPressed: () {
                      context.push<bool>(
                        "/foodLog",
                        extra: {
                          'isFromEdit': true,
                          'foodItem': givenFoodItem.value,
                          
                          'callBack': (FoodItems? newFoodItem) {
                            if (newFoodItem != null) {
                              givenFoodItem.value = newFoodItem;
                             
                              isChanged.value = true;
                            }
                          },
                        },
                      );
                    },
                    child: const Text("Change"),
                  ),
                ],
              ),
              const Divider(thickness: 1, color: Colors.grey),
              _buildDetailRow(
                "Is From Meal:",
                widget.caloricIntakeData.isFromMeal == true ? "Yes" : "No",
              ),
              ValueListenableBuilder<FoodItems>(
                valueListenable: givenFoodItem,
                builder: (context, foodItem, _) {
                  return _buildDetailRow(
                    "Calories:",
                    "${foodItem.calories ?? 'N/A'} kcal",
                  );
                },
              ),
              ValueListenableBuilder<int>(
                valueListenable: givenServingSize,
                builder: (context, servingSize, _) {
                  return GestureDetector(
                    onTap: (){
                      showDialog(context: context, builder: (context) {

                        return AlertDialog(
                          title: Text("Edit Serving Size"),
                          content: TextField(
                            keyboardType: TextInputType.number,
                            decoration: InputDecoration(
                              hintText: "Enter serving size",
                            ),
                            onChanged: (value) {
                              givenServingSize.value = int.parse(value);
                            },
                          ),
                          actions: [
                            TextButton(
                              onPressed: () {
                                Navigator.pop(context);
                              },
                              child: Text("Cancel"),
                            ),
                            ElevatedButton(
                              onPressed: () {
                                Navigator.pop(context);
                                isChanged.value = true;
                              },
                              child: Text("Save"),
                            ),
                          ],
                        );
                        
                      },);
                    },
                    child: _buildDetailRow(
                      "Serving Size:",
                      servingSize.toString(),
                    ),
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildDetailRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w600,
              color: Colors.grey[800],
            ),
          ),
          Container(
            padding: const EdgeInsets.symmetric(vertical: 4, horizontal: 10),
            decoration: BoxDecoration(
              color: Colors.grey[200],
              borderRadius: BorderRadius.circular(10),
            ),
            child: Text(
              value,
              style: const TextStyle(fontSize: 16, color: Colors.black),
            ),
          ),
        ],
      ),
    );
  }

  String _formatDate(DateTime date) {
    return "${date.day}/${date.month}/${date.year}";
  }
}
