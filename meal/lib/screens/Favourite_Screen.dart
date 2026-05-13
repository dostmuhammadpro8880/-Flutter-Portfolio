import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:meal/MealItem.dart';
import 'package:meal/controllers/home_screen_controller.dart';
import 'package:meal/models/meal_model.dart';
// import 'package:meal/common_widgets/meal_item.dart';
import 'package:meal/screens/meal_detail_screen.dart'; // Assuming you have a MealItem widget

class FavouriteScreen extends StatelessWidget {
  FavouriteScreen({super.key});

  final HomeScreenController homeScreenController =
      Get.find<HomeScreenController>();

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      final favouriteMeals = homeScreenController.favouriteMeals;

      if (favouriteMeals.isEmpty) {
        return Scaffold(
          appBar: AppBar(title: const Text("Favorites")),
          body: Center(
            child: Text(
              "Not Added Yet",
              style: Theme.of(context).textTheme.titleLarge!.copyWith(
                    color: const Color.fromARGB(255, 219, 35, 35),
                  ),
            ),
          ),
        );
      }

      return Scaffold(
        appBar: AppBar(title: const Text("Favorites")),
        body: ListView.builder(
          itemCount: favouriteMeals.length,
          itemBuilder: (context, index) {
            final meal = favouriteMeals[index];
            return Mealitem(
              meal: meal,
              onSelectMeal: (selectedMeal) {
                // Navigate to MealDetailScreen
                Get.to(() => MealDetailScreen(meal: selectedMeal));
              },
            );
          },
        ),
      );
    });
  }
}
