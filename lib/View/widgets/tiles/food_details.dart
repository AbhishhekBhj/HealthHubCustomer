import 'package:flutter/material.dart';
import 'package:healthhubcustomer/Model/data/food_item.dart';

import '../../../Model/food_category.dart';

class FoodItemDetailsTile extends StatelessWidget {
   FoodItemDetailsTile({super.key, required this.foodItem, });
  final FoodItems foodItem;

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 2,
      margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header with Image and Basic Info
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Food Image
                ClipRRect(
                  borderRadius: BorderRadius.circular(8),
                  child: foodItem.imageUrl != null
                      ? Image.network(
                          foodItem.imageUrl!,
                          width: 100,
                          height: 100,
                          fit: BoxFit.cover,
                          errorBuilder: (_, __, ___) => _buildPlaceholder(),
                        )
                      : _buildPlaceholder(),
                ),
                const SizedBox(width: 16),
                // Basic Info
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        foodItem.foodName ?? 'Unknown Food',
                        style: Theme.of(context).textTheme.titleLarge?.copyWith(
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        foodItem.description ?? 'No description available',
                        style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                          color: Colors.grey[600],
                        ),
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                      const SizedBox(height: 8),
                      Text(
                        'Recommended Serving: ${foodItem.recommendedServingSize ?? 'Not specified'}',
                        style: Theme.of(context).textTheme.bodyMedium,
                      ),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            const Divider(),
            const SizedBox(height: 16),


            Text("This information is based on the serving size of ${foodItem.recommendedServingSize ?? 100}g"),

            const SizedBox(height: 16),

            
            // Nutrition Info Grid
            GridView.count(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              crossAxisCount: 2,
              mainAxisSpacing: 16,
              crossAxisSpacing: 16,
              childAspectRatio: 2.5,
              children: [
                _NutritionTile(
                  icon: Icons.local_fire_department,
                  label: 'Calories',
                  value: '${foodItem.calories ?? 0}',
                  color: Colors.orange,
                ),
                _NutritionTile(
                  icon: Icons.egg_outlined,
                  label: 'Protein',
                  value: '${foodItem.protein ?? 0}g',
                  color: Colors.red,
                ),
                _NutritionTile(
                  icon: Icons.grain,
                  label: 'Carbs',
                  value: '${foodItem.carbohydrates ?? 0}g',
                  color: Colors.brown,
                ),
                _NutritionTile(
                  icon: Icons.water_drop,
                  label: 'Fats',
                  value: '${foodItem.fats ?? 0}g',
                  color: Colors.yellow[700],
                ),
                _NutritionTile(
                  icon: Icons.cookie,
                  label: 'Sugar',
                  value: '${foodItem.sugarContent ?? 0}g',
                  color: Colors.pink,
                ),
                _NutritionTile(
                  icon: Icons.medication,
                  label: 'Cholesterol',
                  value: '${foodItem.cholesterol ?? 0}mg',
                  color: Colors.purple,
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildPlaceholder() {
    return Container(
      width: 100,
      height: 100,
      color: Colors.grey[200],
      child: Icon(
        Icons.restaurant,
        size: 40,
        color: Colors.grey[400],
      ),
    );
  }
}

class _NutritionTile extends StatelessWidget {
  const _NutritionTile({
    required this.icon,
    required this.label,
    required this.value,
    required this.color,
  });

  final IconData icon;
  final String label;
  final String value;
  final Color? color;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(8),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(8),
        color: color?.withOpacity(0.1),
      ),
      child: Row(
        children: [
          Icon(icon, color: color, size: 24),
          const SizedBox(width: 8),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  label,
                  style: Theme.of(context).textTheme.bodySmall?.copyWith(
                    color: Colors.grey[600],
                  ),
                ),
                Text(
                  value,
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

Widget FoodItemCategoryBox(){
  return Container();
}