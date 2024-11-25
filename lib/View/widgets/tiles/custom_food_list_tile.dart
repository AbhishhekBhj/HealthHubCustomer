import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:healthhubcustomer/Model/data/food_item.dart';
import 'package:healthhubcustomer/View/widgets/buttons/healthhub_custom_button.dart';
import 'package:healthhubcustomer/colors/colors.dart';

class CustomFoodListTile extends StatefulWidget {
   CustomFoodListTile({
    super.key,
    required this.foodItem,
    this.isFromFoodItem=false,
    this.callBack,
  });
  
  final FoodItems foodItem;
    bool? isFromFoodItem;
    Function? callBack;
  @override
  State<CustomFoodListTile> createState() => _CustomFoodListTileState();
}

class _CustomFoodListTileState extends State<CustomFoodListTile> {
  bool isExpanded = false;

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.symmetric(
        vertical: 4,
        horizontal: 8,
      ),
      child: ExpansionTile(
        title: Text(
          widget.foodItem.foodName ?? 'Unknown Food',
          style: const TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w500,
          ),
        ),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              '${widget.foodItem.calories ?? 0} calories per ${widget.foodItem.recommendedServingSize ?? 100}g',
              style: TextStyle(
                color: Theme.of(context).colorScheme.secondary,
              ),
            ),
            if (widget.foodItem.description?.isNotEmpty ?? false)
              Text(
                widget.foodItem.description!,
                style: TextStyle(
                  color: Theme.of(context).colorScheme.secondary,
                  fontSize: 12,
                ),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
          ],
        ),
        trailing: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              isExpanded ? Icons.expand_less : Icons.expand_more,
              color: Theme.of(context).colorScheme.primary,
            ),
          ],
        ),
        onExpansionChanged: (expanded) {
          setState(() {
            isExpanded = expanded;
          });
        },
        children: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Divider(),
                if (widget.foodItem.description?.isNotEmpty ?? false) ...[
                  const SizedBox(height: 8),
                  Text(
                    widget.foodItem.description!,
                    style: const TextStyle(
                      fontSize: 14,
                    ),
                  ),
                  const SizedBox(height: 8),
                  const Divider(),
                ],
                const SizedBox(height: 8),
                Text(
                  'Nutrition Information (per ${widget.foodItem.recommendedServingSize ?? 100} Serving Size):',
                  style: const TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 8),
                _buildNutritionRow(
                  'Protein',
                  '${widget.foodItem.protein ?? 0}g',
                  Icons.fitness_center,
                ),
                _buildNutritionRow(
                  'Carbohydrates',
                  '${widget.foodItem.carbohydrates ?? 0}g',
                  Icons.grain,
                ),
                _buildNutritionRow(
                  'Fats',
                  '${widget.foodItem.fats ?? 0}g',
                  Icons.opacity,
                ),
                _buildNutritionRow(
                  'Sugar',
                  '${widget.foodItem.sugarContent ?? 0}g',
                  Icons.icecream,
                ),
                _buildNutritionRow(
                  'Cholesterol',
                  '${widget.foodItem.cholesterol ?? 0}mg',
                  Icons.medical_information,
                ),
                const SizedBox(height: 16),


                HealthhubCustomButton(
                  backgroundColor: appMainColor,
                  textColor: Colors.white,
                  text:

                  widget.isFromFoodItem==true?"Select Food":"Log Calories",
                  
                  
                  
                  onPressed: () {
                    if(widget.isFromFoodItem==true){
                      widget.callBack!(widget.foodItem);
                      context.pop();
                    }
                    else{
                    context.pushNamed("logCalories", extra: widget.foodItem);

                    }

                //  context.goNamed("logCalories",extra: widget.foodItem);
                  },

                )
                
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildNutritionRow(String label, String value, IconData icon) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4.0),
      child: Row(
        children: [
          Icon(
            icon,
            size: 20,
            color: Theme.of(context).colorScheme.primary.withOpacity(0.7),
          ),
          const SizedBox(width: 8),
          Text(
            label,
            style: const TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w500,
            ),
          ),
          const Spacer(),
          Text(
            value,
            style: TextStyle(
              fontSize: 14,
              color: Theme.of(context).colorScheme.secondary,
            ),
          ),
        ],
      ),
    );
  }

  String _formatDate(dynamic date) {

    if (date is String) {
      date = DateTime.parse(date);
    }

    if (date == null) return 'N/A';
    return '${date.day}/${date.month}/${date.year}';
  }
}