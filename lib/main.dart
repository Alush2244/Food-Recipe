import 'package:flutter/material.dart';
import 'recipe_page.dart';

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
