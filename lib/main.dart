// Made By Ali Hamad 12132013 & Majed Deeb 12131613

import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart' show rootBundle;

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

class FoodRecipePage extends StatefulWidget {
  @override
  _FoodRecipePageState createState() => _FoodRecipePageState();
}

class _FoodRecipePageState extends State<FoodRecipePage> {
  List<dynamic> meals = [];
  List<dynamic> filteredMeals = [];

  @override
  void initState() {
    super.initState();
    loadMeals();
  }

  Future<void> loadMeals() async {
    final String response = await rootBundle.loadString('assets/meals.json');
    final List<dynamic> data = json.decode(response);
    setState(() {
      meals = data;
      filteredMeals = meals;
    });
  }

  void filterMeals(String query) {
    final results = meals.where((meal) {
      final mealName = meal['mealName'].toLowerCase();
      final ingredients = meal['ingredients'].map((ingredient) => ingredient.toLowerCase()).toList();
      return mealName.contains(query.toLowerCase()) || ingredients.contains(query.toLowerCase());
    }).toList();

    setState(() {
      filteredMeals = results;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.red,
        title: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              'Food Recipe',
              style: TextStyle(color: Colors.white),
            ),
            Container(
              width: 200.0,
              child: TextField(
                decoration: InputDecoration(
                  hintText: 'Search...',
                  hintStyle: TextStyle(color: Colors.white70),
                  filled: true,
                  fillColor: Colors.white24,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(30.0),
                    borderSide: BorderSide.none,
                  ),
                  contentPadding: EdgeInsets.symmetric(horizontal: 20.0),
                ),
                style: TextStyle(color: Colors.white),
                onChanged: (value) {
                  filterMeals(value);
                },
              ),
            ),
          ],
        ),
      ),
      body: ListView.builder(
        padding: EdgeInsets.all(10.0),
        itemCount: filteredMeals.length,
        itemBuilder: (context, index) {
          return MealCard(
            imagePath: filteredMeals[index]['imagePath'],
            mealName: filteredMeals[index]['mealName'],
            ingredients: filteredMeals[index]['ingredients'],
          );
        },
      ),
    );
  }
}

class MealCard extends StatelessWidget {
  final String imagePath;
  final String mealName;
  final List<dynamic> ingredients;

  MealCard({
    required this.imagePath,
    required this.mealName,
    required this.ingredients,
  });

  @override
  Widget build(BuildContext context) {
    // Mock prices for ingredients
    final Map<String, double> ingredientPrices = {
      for (var ingredient in ingredients) ingredient: (ingredients.indexOf(ingredient) + 1) * 1.5,
    };

    double totalCost = ingredientPrices.values.reduce((a, b) => a + b);

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
                items: ingredientPrices.keys.map((String ingredient) {
                  return DropdownMenuItem<String>(
                    value: ingredient,
                    child: Text('$ingredient (\$${ingredientPrices[ingredient]?.toStringAsFixed(2)})'),
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
