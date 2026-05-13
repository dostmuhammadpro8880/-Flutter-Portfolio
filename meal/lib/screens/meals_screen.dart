import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/instance_manager.dart';
import 'package:meal/MealItem.dart';
import 'package:meal/models/meal_model.dart';
import 'package:meal/screens/meal_detail_screen.dart';

class MealsScreen extends StatelessWidget {
  const MealsScreen({super.key, this.title, required this.meals});
  final String? title;
  final List<Meal> meals;

  void selectMeal(Meal meal) {
    Get.to(MealDetailScreen(meal: meal));
  }

  @override
  Widget build(BuildContext context) {
    Widget content = Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Text(
            "uh oh ..nothing here",
            style: Theme.of(context).textTheme.headlineLarge!.copyWith(
              color: Theme.of(context).colorScheme.onSurface,
            ),
          ),
          SizedBox(height: 16),
          Text(
            "Try Selecting a different Category!",
            style: Theme.of(context).textTheme.headlineLarge!.copyWith(
              color: Theme.of(context).colorScheme.onSurface,
            ),
          ),
        ],
      ),
    );
    
    if (meals.isNotEmpty) {
      itemCount: meals.length;
      content = ListView.builder(
        itemBuilder: (context, index) => Mealitem(
          meal: meals[index],
          onSelectMeal: (meal) {
            selectMeal(meal);
          },
        ),
      );
    }
    // if (title == null) {
    //   return content;
    // }
    return Scaffold(
      appBar: AppBar(
        title: Text(title!),
      ),
      body: content,
    );
  }
}
