import 'package:flutter/material.dart';

class MealCard extends StatelessWidget {
  final String imagePath;
  final String mealName;
  final List<dynamic> ingredients;
  final Map<String, double> ingredientPrices;

  MealCard({
    required this.imagePath,
    required this.mealName,
    required this.ingredients,
    required this.ingredientPrices,
  });

  @override
  Widget build(BuildContext context) {
    double totalCost = ingredientPrices.values.reduce((a, b) => a + b);

    return Card(
      margin: EdgeInsets.only(bottom: 20.0),
      elevation: 5,
      child: Column(
        children: [
          // Meal image
          Image.asset(
            imagePath,
            height: 150,
            width: double.infinity,
            fit: BoxFit.cover,
          ),
          // Meal name
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Text(
              mealName,
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
          ),
          // Dropdown
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8.0),
            child: Row(
              children: [
                // Dropdown
                Expanded(
                  flex: 2,
                  child: DropdownButton<String>(
                    hint: Text('Ingredients'),
                    isExpanded: true,
                    items: ingredientPrices.keys.map((String ingredient) {
                      return DropdownMenuItem<String>(
                        value: ingredient,
                        child: Text(
                          '$ingredient (\$${ingredientPrices[ingredient]?.toStringAsFixed(2)})',
                          overflow: TextOverflow.ellipsis,
                        ),
                      );
                    }).toList(),
                    onChanged: (String? newValue) {
                    },
                  ),
                ),
                SizedBox(width: 8),
                // Show Cost button
                ElevatedButton(
                  onPressed: () {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text('Total Meal Cost: \$${totalCost.toStringAsFixed(2)}')),
                    );
                  },
                  child: Text('Show Cost'),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
