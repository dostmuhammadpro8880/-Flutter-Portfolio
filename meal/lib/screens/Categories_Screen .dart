// import 'package:flutter/material.dart';
// import 'package:get/get.dart';
// import 'package:meal/controllers/home_screen_controller.dart';
// import 'package:meal/models/meal_model.dart';

// class CategoriesScreen extends StatefulWidget {
//   const CategoriesScreen({super.key, required this.availableMeals});
//   final RxList<Meal> availableMeals;
//   @override
//   State<CategoriesScreen> createState() => _CategoriesScreenState();
// }

// class _CategoriesScreenState extends State<CategoriesScreen>
//     with SingleTickerProviderStateMixin {
//   final HomeScreenController homeScreenController =
//       Get.find<HomeScreenController>();
//   late AnimationController _animationController;

//   @override
//   void initState() {
//     super.initState();
//     _animationController = AnimationController(
//       vsync: this,
//       duration: const Duration(milliseconds: 300),
//     );
//     _animationController.forward();
//   }

//   @override
//   void dispose() {
//     _animationController.dispose();
//     super.dispose();
//   }

//   @override
//   Widget build(BuildContext context) {
//     return AnimatedBuilder(animation: _animationController, builder:
//     builder:(context,child)=> SlideTransition()
//     )
//   }
// }

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:meal/common_widgets/category_grid_item.dart';
import 'package:meal/controllers/home_screen_controller.dart';
import 'package:meal/models/category_model.dart';
import 'package:meal/models/meal_model.dart';
import 'package:meal/screens/meals_screen.dart';

class CategoriesScreen extends StatefulWidget {
  const CategoriesScreen({super.key, required this.availableMeals});
  final RxList<Meal> availableMeals;

  @override
  State<CategoriesScreen> createState() => _CategoriesScreenState();
}

class _CategoriesScreenState extends State<CategoriesScreen>
    with SingleTickerProviderStateMixin {
  final HomeScreenController homeScreenController =
      Get.find<HomeScreenController>();

  late AnimationController _animationController;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      vsync: this,
      duration: Duration(milliseconds: 300),
    );
    _animationController.forward();
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  void _selectCategories(Category category) {
    final filteredMeals = widget.availableMeals
        .where((meal) => meal.categories.contains(category.id))
        .toList();

    Get.to(() => MealsScreen(meals: filteredMeals, title: "${category.title}'s Meals"));
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _animationController,
      child: GridView(
        padding: EdgeInsets.all(24),
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          childAspectRatio: 3 / 2,
          crossAxisSpacing: 20,
          mainAxisSpacing: 20,
        ),
        children: homeScreenController.availableCategories
            .map(
              (category) => CategoryGridItem(
                category: category,
                onSelectCategory: () {
                  _selectCategories(category);
                },
              ),
            )
            .toList(),
      ),
      builder: (context, child) => SlideTransition(
        position: Tween<Offset>(begin: Offset(0, -0.2), end: Offset.zero)
            .animate(
              CurvedAnimation(
                parent: _animationController,
                curve: Curves.easeOut,
              ),
            ),
        child: child,
      ),
    );
  }
}
