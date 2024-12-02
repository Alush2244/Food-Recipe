import 'package:flutter/material.dart';
/*Made By Ali Hamad 12132013 & Majed Deeb 12131613 */
void main() {
  runApp(FoodRecipeApp());
}

class FoodRecipeApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: FoodRecipePage(),
    );
  }
}

class FoodRecipePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Food Recipe',
          style: TextStyle(color: Colors.white),
        ),
        backgroundColor: Colors.red,
        centerTitle: true,
      ),
      body: ListView(
        padding: EdgeInsets.all(10.0),
        children: [
          MealCard(
            imagePath: 'assets/lasagna.jpg',
            mealName: 'Lasagna',
            ingredients: {
              'Pasta': 2.5,
              'Cheese': 3.0,
              'Tomato Sauce': 1.5,
              'Beef': 6.0,
            },
          ),
          MealCard(
            imagePath: 'assets/fettuccine_alfredo.jpg',
            mealName: 'Fettuccine Alfredo',
            ingredients: {
              'Fettuccine': 3.0,
              'Cream': 2.5,
              'Parmesan Cheese': 4.0,
            },
          ),
          MealCard(
            imagePath: 'assets/tabbouleh.jpg',
            mealName: 'Tabbouleh',
            ingredients: {
              'Parsley': 1.0,
              'Tomato': 0.5,
              'Lemon': 0.5,
              'Bulgur': 1.5,
            },
          ),
          MealCard(
            imagePath: 'assets/falafel_wrap.jpg',
            mealName: 'Falafel Wrap',
            ingredients: {
              'Falafel': 2.0,
              'Wrap Bread': 1.5,
              'Hummus': 1.0,
              'Tomato': 0.5,
              'Lettuce': 0.5,
              'Pickles': 0.5,
              'Tahini Sauce': 0.5,
            },
          ),
          MealCard(
            imagePath: 'assets/pizza.jpg',
            mealName: 'Pizza',
            ingredients: {
              'Pizza Dough': 3.0,
              'Tomato Sauce': 1.5,
              'Cheese': 4.0,
              'Pepperoni': 2.0,
              'Olives': 1.0,
              'Bell Peppers': 0.5,
              'Oregano': 0.5,
            },
          ),
        ],
      ),
    );
  }
}

class MealCard extends StatelessWidget {
  String imagePath;
  String mealName;
  Map<String, double> ingredients;

  MealCard({
    required this.imagePath,
    required this.mealName,
    required this.ingredients,
  });

  @override
  Widget build(BuildContext context) {
    double totalCost = ingredients.values.reduce((a, b) => a + b); // Sum the ingredient costs.

    return Card(
      margin: EdgeInsets.only(bottom: 20.0),
      elevation: 5,
      child: Column(
        children: [
          Image.asset(
            imagePath,
            height: 150,
            width: double.infinity,
            fit: BoxFit.cover,
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Text(
              mealName,
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              DropdownButton<String>(
                hint: Text('Ingredients'),
                items: ingredients.keys.map((String ingredient) {
                  return DropdownMenuItem<String>(
                    value: ingredient,
                    child: Text('$ingredient (\$${ingredients[ingredient]})'),
                  );
                }).toList(),
                onChanged: (String? value) {},
              ),
              ElevatedButton(
                onPressed: () {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text('Total Meal Cost: \$${totalCost.toStringAsFixed(2)}')),
                  );
                },
                child: Text('Show Meal Cost'),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
