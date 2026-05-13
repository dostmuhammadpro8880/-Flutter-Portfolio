import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:meal/controllers/home_screen_controller.dart';
import 'package:meal/models/meal_model.dart';

class MealDetailScreen extends StatelessWidget {
  final Meal meal;

  MealDetailScreen({super.key, required this.meal});

  final HomeScreenController homeScreenController =
      Get.find<HomeScreenController>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(meal.title),
        // actions: [
        //   Obx(() {
        //     final isFavorite = homeScreenController.isFavorite(meal);
        //     return IconButton(
        //       onPressed: () {
        //         print(homeScreenController.favouriteMeals.length);
        //         homeScreenController.toggleMealFavoriteStatus(meal);

        //         ScaffoldMessenger.of(context).showSnackBar(
        //           SnackBar(
        //             backgroundColor: isFavorite ? Colors.red : Colors.green,
        //             behavior: SnackBarBehavior.floating,
        //             content: Text(
        //               isFavorite
        //                   ? "Meal removed from Favorites"
        //                   : "Meal added to Favorites",
        //             ),
        //           ),
        //         );
        //       },
        //       icon: Icon(homeScreenController.favouriteMeals.contains(meal) ? Icons.star : Icons.star_border),
        //       // icon: Icon(isFavorite ? Icons.star : Icons.star_border),
        //     );
        //   }),
        // ],
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Hero(
              tag: meal.id,
              child: Image.network(
                meal.imageUrl,
                height: 300,
                width: double.infinity,
                fit: BoxFit.cover,
              ),
            ),
            const SizedBox(height: 14),
            Text(
              "Ingredients",
              style: Theme.of(context).textTheme.titleLarge!.copyWith(
                color: Theme.of(context).colorScheme.primary,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 14),
            Column(
              children: [
                for (final ingredient in meal.ingredients)
                  Text(
                    ingredient,
                    style: Theme.of(context).textTheme.titleLarge!.copyWith(
                      color: Theme.of(context).colorScheme.onSurface,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
              ],
            ),
            const SizedBox(height: 14),
            Text(
              "Steps",
              style: Theme.of(context).textTheme.titleLarge!.copyWith(
                color: Theme.of(context).colorScheme.primary,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 14),
            Column(
              children: [
                for (final Step in meal.steps)
                  Padding(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 12,
                      vertical: 6,
                    ),
                    child: Text(
                      ". ${meal.steps}",
                      textAlign: TextAlign.center,
                      style: Theme.of(context).textTheme.titleLarge!.copyWith(
                        color: Theme.of(context).colorScheme.onSurface,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
