import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_charts/charts.dart';
import '../../widgets/custom_appbar.dart';
import 'caloric_summary.dart';

class MacroGoals extends StatelessWidget {
  MacroGoals({
    super.key,
    required this.macroGoals,
    required this.macroAchieved,
  })  : caloriesGoals = [
          ChartData("Goals", double.tryParse(macroGoals["caloriesGoals"].toString()) ?? 0.0),
          ChartData("Achieved", double.tryParse(macroAchieved["caloriesAcheived"].toString()) ?? 0.0),
        ],
        proteinGoals = [
          ChartData("Goals", double.tryParse(macroGoals["proteinGoals"].toString()) ?? 0.0),
          ChartData("Achieved", double.tryParse(macroAchieved["proteinAcheived"].toString()) ?? 0.0),
        ],
        carbsGoals = [
          ChartData("Goals", double.tryParse(macroGoals["carbsGoals"].toString()) ?? 0.0),
          ChartData("Achieved", double.tryParse(macroAchieved["carbsAcheived"].toString()) ?? 0.0),
        ],
        fatsGoals = [
          ChartData("Goals", double.tryParse(macroGoals["fatGoals"].toString()) ?? 0.0),
          ChartData("Achieved", double.tryParse(macroAchieved["fatAcheived"].toString()) ?? 0.0),
        ],
        sugarGoals = [
          ChartData("Goals", double.tryParse(macroGoals["sugarGoals"].toString()) ?? 0.0),
          ChartData("Achieved", double.tryParse(macroAchieved["sugarAcheived"].toString()) ?? 0.0),
        ],
        cholesterolGoals = [
          ChartData("Goals", double.tryParse(macroGoals["cholesterolGoals"].toString()) ?? 0.0),
          ChartData("Achieved", double.tryParse(macroAchieved["cholesterolAcheived"].toString()) ?? 0.0),
        ];

  final Map<String, dynamic> macroGoals;
  final Map<String, dynamic> macroAchieved;

  final List<ChartData> caloriesGoals;
  final List<ChartData> proteinGoals;
  final List<ChartData> carbsGoals;
  final List<ChartData> fatsGoals;
  final List<ChartData> sugarGoals;
  final List<ChartData> cholesterolGoals;

  final List<String> titles = [
    "Calories",
    "Protein",
    "Carbs",
    "Fats",
    "Sugar",
    "Cholesterol"
  ];

  // Define colors for each macro type
  final List<List<Color>> chartColors = [
    [const Color(0xFF6C63FF), const Color(0xFF8F8AFF)], // Calories
    [const Color(0xFF4CAF50), const Color(0xFF81C784)], // Protein
    [const Color(0xFFFFA726), const Color(0xFFFFB74D)], // Carbs
    [const Color(0xFFEF5350), const Color(0xFFE57373)], // Fats
    [const Color(0xFF26C6DA), const Color(0xFF4DD0E1)], // Sugar
    [const Color(0xFFAB47BC), const Color(0xFFBA68C8)], // Cholesterol
  ];

  @override
  Widget build(BuildContext context) {
    log("Macro Goals: $macroGoals");
    log("Macro Achieved: $macroAchieved");
    final List<List<ChartData>> goalsList = [
      caloriesGoals,
      proteinGoals,
      carbsGoals,
      fatsGoals,
      sugarGoals,
      cholesterolGoals,
    ];

    return Scaffold(
      backgroundColor: Colors.grey[100],
      appBar: customAppBar(
        title: "Nutrition Dashboard",
        context: context,
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Daily Macro Tracking',
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: Colors.black87,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                'Monitor your nutritional goals and achievements',
                style: TextStyle(
                  fontSize: 16,
                  color: Colors.grey[600],
                ),
              ),
              const SizedBox(height: 16),
              Expanded(
                child: GridView.builder(
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    crossAxisSpacing: 16.0,
                    mainAxisSpacing: 16.0,
                    childAspectRatio: 0.85,
                  ),
                  itemCount: goalsList.length,
                  itemBuilder: (context, index) {
                    return buildDoughnutGraph(
                      goalsList[index],
                      titles[index],
                      chartColors[index],
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

  Widget buildDoughnutGraph(List<ChartData> chartData, String title, List<Color> colors) {
    // Calculate percentage achieved
    double goalValue = chartData[0].y;
    double achievedValue = chartData[1].y;
    double percentage = goalValue > 0 ? (achievedValue / goalValue * 100).clamp(0, 100) : 0;

    return Card(
      elevation: 8,
      shadowColor: Colors.black26,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
      child: Padding(
        padding: const EdgeInsets.all(12.0),
        child: Column(
          children: [
            Text(
              title,
              style: const TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Colors.black87,
              ),
            ),
            const SizedBox(height: 4),
            Expanded(
              child: SfCircularChart(
                margin: EdgeInsets.zero,
                legend: const Legend(
                  isVisible: true,
                  position: LegendPosition.bottom,
                  textStyle: TextStyle(fontSize: 12),
                  overflowMode: LegendItemOverflowMode.wrap,
                ),
                series: <CircularSeries>[
                  DoughnutSeries<ChartData, String>(
                    dataSource: chartData,
                    xValueMapper: (ChartData data, _) => data.x,
                    yValueMapper: (ChartData data, _) => data.y,
                    pointColorMapper: (ChartData data, index) => colors[index ?? 0],
                    dataLabelSettings: const DataLabelSettings(
                      isVisible: true,
                      labelPosition: ChartDataLabelPosition.outside,
                      textStyle: TextStyle(fontSize: 12),
                    ),
                    radius: '80%',
                    innerRadius: '60%',
                    enableTooltip: true,
                  ),
                ],
                annotations: [
                  CircularChartAnnotation(
                    widget: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(
                          '${percentage.toStringAsFixed(1)}%',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            color: percentage >= 100 ? Colors.green : Colors.black87,
                          ),
                        ),
                        Text(
                          'Complete',
                          style: TextStyle(
                            fontSize: 10,
                            color: Colors.grey[600],
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}