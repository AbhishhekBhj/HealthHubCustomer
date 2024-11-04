import 'package:flutter/material.dart';
import 'package:healthhubcustomer/Model/data/caloric_intake.dart';
import 'package:healthhubcustomer/View/widgets/custom_appbar.dart';

class IndividaulIntake extends StatelessWidget {
  const IndividaulIntake({super.key, required this.caloricIntakeData});

  final CaloricIntakeDetail caloricIntakeData;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: customAppBar(title: "Intake Report", context: context),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildHeader(),
            const SizedBox(height: 20),
            _buildIntakeDetails(),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return Center(
      child: Column(
        children: [
          Text(
            "Calories Consumed",
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
              color: Colors.blueAccent,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            "${caloricIntakeData.totalCalories ?? 'N/A'} kcal",
            style: TextStyle(
              fontSize: 32,
              fontWeight: FontWeight.bold,
              color: Colors.orangeAccent,
            ),
          ),
          const SizedBox(height: 16),
          Text(
            "Meal Time: ${caloricIntakeData.mealTimeId ?? 'N/A'}",
            style: TextStyle(fontSize: 18, color: Colors.grey[700]),
          ),
          const SizedBox(height: 8),
          Text(
            "Date: ${caloricIntakeData.createdAt != null ? _formatDate(caloricIntakeData.createdAt!) : 'N/A'}",
            style: TextStyle(fontSize: 16, color: Colors.grey[600]),
          ),
        ],
      ),
    );
  }

  Widget _buildIntakeDetails() {
    return Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      elevation: 4,
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "Food Item",
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.blueAccent),
            ),
            const SizedBox(height: 8),
            Text(
              caloricIntakeData.foodItem?.foodName ?? "N/A",
              style: TextStyle(fontSize: 16, color: Colors.black87),
            ),
            const Divider(thickness: 1, color: Colors.grey),
            _buildDetailRow("Is From Meal:", caloricIntakeData.isFromMeal == true ? "Yes" : "No"),
            _buildDetailRow("Calories:", "${caloricIntakeData.totalCalories ?? 'N/A'} kcal"),
          
          ],
        ),
      ),
    );
  }

  Widget _buildDetailRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500, color: Colors.grey[800]),
          ),
          Text(
            value,
            style: TextStyle(fontSize: 16, color: Colors.black),
          ),
        ],
      ),
    );
  }

  String _formatDate(DateTime date) {
    return "${date.day}/${date.month}/${date.year}";
  }
}
