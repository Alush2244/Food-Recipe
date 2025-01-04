import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'meal_card.dart';

class FoodRecipePage extends StatefulWidget {
  @override
  _FoodRecipePageState createState() {
    return _FoodRecipePageState();
  }
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
    try {
      print('Fetching data from API...');
      final response = await http.get(Uri.parse('http://foodrecipe.infinityfreeapp.com/get_meals.php'));

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        print('Fetched data: $data');

        // Check if data is in the expected format
        if (data is List) {
          setState(() {
            meals = data.map((meal) {
              try {
                return {
                  'mealName': meal['mealName'],
                  'imagePath': meal['imagePath'],
                  'ingredients': List<String>.from(meal['ingredients']),
                  'ingredientPrices': Map<String, double>.from(meal['ingredientPrices'])
                };
              } catch (e) {
                print('Error parsing meal: $meal, $e');
                return null;
              }
            }).where((meal) => meal != null).toList();
            filteredMeals = meals;
          });
        } else {
          throw Exception('Invalid data format received from API');
        }
      } else {
        throw Exception('Failed to load meals: ${response.statusCode}');
      }
    } catch (e) {
      print('Error: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to load meals. Loading fallback data...')),
      );

      // Fallback to hardcoded data
      setState(() {
        meals = [
          {
            "mealName": "Lasagna",
            "imagePath": "assets/lasagna.jpg",
            "ingredients": ["Pasta", "Cheese", "Tomato Sauce", "Beef"],
            "ingredientPrices": {"Pasta": 1.5, "Cheese": 2.5, "Tomato Sauce": 1.0, "Beef": 3.0}
          },
          {
            "mealName": "Fettuccine Alfredo",
            "imagePath": "assets/fettuccine_alfredo.jpg",
            "ingredients": ["Fettuccine", "Cream", "Parmesan Cheese"],
            "ingredientPrices": {"Fettuccine": 2.0, "Cream": 3.0, "Parmesan Cheese": 4.5}
          },
          {
            "mealName": "Tabbouleh",
            "imagePath": "assets/tabbouleh.jpg",
            "ingredients": ["Parsley", "Tomato", "Lemon", "Bulgur"],
            "ingredientPrices": {"Parsley": 0.8, "Tomato": 1.0, "Lemon": 0.5, "Bulgur": 1.2}
          },
          {
            "mealName": "Falafel Wrap",
            "imagePath": "assets/falafel_wrap.jpg",
            "ingredients": ["Falafel", "Wrap Bread", "Hummus", "Tomato", "Lettuce", "Pickles", "Tahini Sauce"],
            "ingredientPrices": {"Falafel": 1.0, "Wrap Bread": 0.5, "Hummus": 0.5, "Tomato": 0.5, "Lettuce": 0.2, "Pickles": 0.3, "Tahini Sauce": 0.5}
          },
          {
            "mealName": "Pizza",
            "imagePath": "assets/pizza.jpg",
            "ingredients": ["Pizza Dough", "Tomato Sauce", "Cheese", "Pepperoni", "Olives", "Bell Peppers", "Oregano"],
            "ingredientPrices": {"Pizza Dough": 1.2, "Tomato Sauce": 0.4, "Cheese": 2.0, "Pepperoni": 2.0, "Olives": 1.0, "Bell Peppers": 0.4, "Oregano": 0.2}
          }
        ];
        filteredMeals = meals;
      });
    }
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
          final meal = filteredMeals[index];
          final Map<String, double> ingredientPrices = Map<String, double>.from(meal['ingredientPrices']);
          return MealCard(
            imagePath: meal['imagePath'],
            mealName: meal['mealName'],
            ingredients: meal['ingredients'],
            ingredientPrices: ingredientPrices,
          );
        },
      ),
    );
  }
}