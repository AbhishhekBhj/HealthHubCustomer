import 'dart:developer';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:healthhubcustomer/Controller/providers/food_provider.dart';
import 'package:healthhubcustomer/colors/colors.dart';
import 'package:provider/provider.dart';
import 'package:syncfusion_flutter_charts/charts.dart';
import '../../../Controller/providers/auth_provider.dart';
import '../../../Controller/providers/calories_provider.dart';

class CaloricSummary extends StatelessWidget {
  CaloricSummary({super.key});

  ValueNotifier<int> selectedIndex = ValueNotifier<int>(0);
  ValueNotifier<int> selectedMealId = ValueNotifier<int>(0);

  @override
  Widget build(BuildContext context) {
    var provider = Provider.of<CaloriesProvider>(context);
    var foodProvider = Provider.of<FoodProvider>(context);
    var authProvider = Provider.of<AuthProvider>(context);
    var caloriesProvider = Provider.of<CaloriesProvider>(context);

    Map<String, dynamic> userAcheivedMap = {
      "caloriesAcheived":
          caloriesProvider.caloricIntakeData?.totalData?.totalCalories,
      "proteinAcheived":
          caloriesProvider.caloricIntakeData?.totalData?.totalProtein,
      "carbsAcheived":
          caloriesProvider.caloricIntakeData?.totalData?.totalCarbs,
      "fatAcheived": caloriesProvider.caloricIntakeData?.totalData?.totalFat,
      "sugarAcheived":
          caloriesProvider.caloricIntakeData?.totalData?.totalSugar,
      "cholesterolAcheived":
          caloriesProvider.caloricIntakeData?.totalData?.totalCholesterol,
    };

    Map<String, dynamic> userGoalsMap = {
      "caloriesGoals": authProvider.user.tdee,
      "proteinGoals": authProvider.user.dailyProteinGoal,
      "carbsGoals": authProvider.user.dailyCarbohydratesGoal,
      "fatGoals": authProvider.user.dailyFatGoal,
      "sugarGoals": authProvider.user.dailySugarGoal,
      "cholesterolGoals": authProvider.user.dailyCholesterolGoal,
    };

    if (foodProvider.mealTimes.isEmpty) {
      foodProvider.getMealTimes();
    }

    if (provider.caloricIntakeData == null) {
      provider.getTodaysCaloricIntake();
    }

    return Scaffold(
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          context.go('/foodLog');
        },
        child: const Icon(Icons.add),
      ),
      body: Consumer<CaloriesProvider>(
        builder: (context, value, child) {
          double totalCalories = value.totalCalories!.toDouble();
          double consumedCalories = value.totalCalories?.toDouble() ?? 0;
          double remainingCalories = value.remainingCalories?.toDouble() ?? 0;

          final List<ChartData> chartData = [
            ChartData('Consumed', consumedCalories),
            ChartData('Remaining', remainingCalories),
          ];

          return Padding(
            padding: const EdgeInsets.all(16.0),
            child: RefreshIndicator.adaptive(
              onRefresh: () async {
                provider.getTodaysCaloricIntake();
                foodProvider.getMealTimes();
              },
              child: ListView(
                children: [
                  const SizedBox(height: 20),
                  const Text(
                    'Caloric Goals for Today',
                    style: TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                      color: Colors.black87,
                    ),
                  ),
                  const SizedBox(height: 10),
                  // Doughnut Chart
                  Card(
                    elevation: 4,
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12)),
                    child: SizedBox(
                      height: MediaQuery.of(context).size.height * 0.4,
                      child: SfCircularChart(
                        legend: const Legend(
                            isVisible: true, position: LegendPosition.bottom),
                        title: const ChartTitle(
                            text: 'Caloric Intake Report for Today',
                            textStyle: TextStyle(fontSize: 18)),
                        series: <CircularSeries>[
                          DoughnutSeries<ChartData, String>(
                            dataSource: chartData,
                            xValueMapper: (ChartData data, _) => data.x,
                            yValueMapper: (ChartData data, _) => data.y,
                            dataLabelSettings:
                                const DataLabelSettings(isVisible: true),
                            radius: '90%',
                            enableTooltip: true,
                            explode: true,
                            explodeIndex: 0,
                          ),
                        ],
                        tooltipBehavior: TooltipBehavior(enable: true),
                      ),
                    ),
                  ),
                  const SizedBox(height: 20),
                  _buildCaloriesSummary(value),
                  const SizedBox(height: 20),
                  // Display the meal times
                  Consumer<FoodProvider>(
                    builder: (context, foodProvider, child) {
                      return returnMealTimes(foodProvider);
                    },
                  ),

                  Row(
                    children: [
                      TextButton(
                          onPressed: () {},
                          child: const Text("View Weekly Reports")),
                      const Spacer(),
                      TextButton(
                          onPressed: () {
                            context.goNamed("macroGoalsGraphPage", extra: {
                              "userAchievedMap": userAcheivedMap,
                              "userGoalsMap": userGoalsMap
                            });
                          },
                          child: const Text("View Macro Goals")),
                    ],
                  ),
                  // Display the meals based on the selected meal time
                  Consumer<CaloriesProvider>(
                    builder: (context, value, child) {
                      return returnMealsBasedonSelectedIndex(provider);
                    },
                  )
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildCaloriesSummary(CaloriesProvider value) {
    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            Text(
              'Caloric Target: ${value.totalCaloriesForTheDay}',
              style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
            ),
            const SizedBox(height: 8),
            Text(
              'Calories Consumed: ${value.totalCalories}',
              style: const TextStyle(fontSize: 16, color: Colors.black54),
            ),
            const SizedBox(height: 8),
            Text(
              'Remaining Calories: ${value.remainingCalories}',
              style: const TextStyle(fontSize: 16, color: Colors.redAccent),
            ),
          ],
        ),
      ),
    );
  }

  Widget returnMealsBasedonSelectedIndex(CaloriesProvider caloriesProvider) {
    return ValueListenableBuilder<int>(
      valueListenable: selectedMealId,
      builder: (context, selectedMealIdValue, child) {
        var filteredMeals = caloriesProvider.caloricIntakeData?.details
                ?.where((element) => element.mealTimeId == selectedMealIdValue)
                .toList() ??
            [];

        if (filteredMeals.isEmpty) {
          return const Center(
            child: Text(
              'No meals found for this meal time',
              style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w500,
                  color: Colors.grey),
            ),
          );
        }

        return ListView.builder(
          physics: const NeverScrollableScrollPhysics(),
          shrinkWrap: true,
          itemCount: filteredMeals.length,
          itemBuilder: (context, index) {
            var mealDetail = filteredMeals[index];
            double mealCalories = mealDetail.totalCalories?.toDouble() ?? 0;

            return GestureDetector(
              onTap: () {
                context.goNamed("individualIntakeData", extra: mealDetail);
              },
              child: Card(
                elevation: 5,
                margin:
                    const EdgeInsets.symmetric(vertical: 8.0, horizontal: 10.0),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(15.0),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Row(
                    children: [
                      // Circular icon with background color
                      CircleAvatar(
                        radius: 30,
                        backgroundColor: Colors.green.shade100,
                        child: Icon(
                          Icons.fastfood,
                          color: Colors.green.shade700,
                          size: 30,
                        ),
                      ),
                      const SizedBox(width: 15),
                      // Meal details
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              mealDetail.foodItem?.foodName ?? 'Unknown Meal',
                              style: const TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                                color: Colors.black87,
                              ),
                            ),
                            const SizedBox(height: 8),
                            Text(
                              'Calories: ${mealCalories.toStringAsFixed(0)}',
                              style: TextStyle(
                                fontSize: 16,
                                color: Colors.orange.shade700,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ],
                        ),
                      ),
                      const Icon(Icons.arrow_forward_ios,
                          color: Colors.grey, size: 16),
                    ],
                  ),
                ),
              ),
            );
          },
        );
      },
    );
  }

  Widget returnMealTimes(FoodProvider foodProvider) {
    return ValueListenableBuilder<int>(
      valueListenable: selectedIndex,
      builder: (context, selectedIndexValue, child) {
        return SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: Row(
            children: foodProvider.mealTimes.asMap().entries.map((entry) {
              int index = entry.key;
              var mealTime = entry.value;
              bool isSelected = selectedIndexValue == index;

              return Padding(
                padding: const EdgeInsets.symmetric(horizontal: 8.0),
                child: GestureDetector(
                  onTap: () {
                    selectedIndex.value = index;
                    selectedMealId.value = mealTime.id;
                  },
                  child: Card(
                    elevation: 2,
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12)),
                    color: isSelected ? appMainColor : Colors.white,
                    child: Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Text(
                        mealTime.mealTimeName,
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: isSelected ? 16 : 14,
                          color: isSelected ? Colors.white : Colors.black,
                        ),
                      ),
                    ),
                  ),
                ),
              );
            }).toList(),
          ),
        );
      },
    );
  }
}

class ChartData {
  ChartData(this.x, this.y);
  final String x;
  final double y;
}
