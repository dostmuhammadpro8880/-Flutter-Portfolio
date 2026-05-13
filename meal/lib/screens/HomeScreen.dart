import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart' show Get;
import 'package:get/get_state_manager/get_state_manager.dart';
import 'package:meal/common_widgets/main_drawer.dart';
import 'package:meal/controllers/home_screen_controller.dart';
import 'package:meal/screens/Categories_Screen%20.dart';
import 'package:meal/screens/Favourite_Screen.dart';

class Homescreen extends StatelessWidget {
  Homescreen({super.key});
  final HomeScreenController controller = Get.put(HomeScreenController());
  @override
  Widget build(BuildContext context) {
    return Obx(() {

      Widget activeScreen = CategoriesScreen( availableMeals: controller.availableMeal,);
      var activePageTitle = "Categories";
      if (controller.selectedPageIndex.value == 1) {
        activeScreen = FavouriteScreen();
        activePageTitle = "Favorites";
      }

      return Scaffold(
        appBar: AppBar(title: Text(activePageTitle), ),
        // body: SafeArea(child: child),
        backgroundColor: Colors.black87,
        drawer: MainDrawer(),
        body: activeScreen,
        bottomNavigationBar: BottomNavigationBar(
          currentIndex: controller.selectedPageIndex.value,
          onTap: controller.selectPage,
          items: [
            BottomNavigationBarItem(
              icon: Icon(Icons.set_meal),
              label: "Categories",
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.star),
              label: "Favourites",
            ),

          ],
        ),
      );
    });
  }
}

// import 'package:flutter/material.dart';
// import 'package:get/get.dart';
// import 'package:meal/common_widgets/main_drawer.dart';
// import 'package:meal/controllers/home_screen_controller.dart';
// import 'package:meal/screens/Categories_Screen%20.dart';
// // import 'package:meal/screens/Categories_Screen.dart';
// import 'package:meal/screens/Favourite_Screen.dart';

// class Homescreen extends StatelessWidget {
//   Homescreen({super.key});

//   final HomeScreenController controller = Get.put(HomeScreenController());

//   @override
//   Widget build(BuildContext context) {
//     return Obx(() {
//       Widget activeScreen = CategoriesScreen(
//         availableMeals: controller.availableMeal,
//       );

//       String activePageTitle = "Categories";

//       if (controller.selectedPageIndex.value == 1) {
//         activeScreen = FavouriteScreen();
//         activePageTitle = "Favourites";
//       }

//       return Scaffold(
//         appBar: AppBar(
//           title: Text(activePageTitle),
//         ),

//         drawer: MainDrawer(),
//         body: activeScreen,

//         bottomNavigationBar: BottomNavigationBar(
//           currentIndex: controller.selectedPageIndex.value,
//           onTap: controller.selectPage,
//           items: const [
//             BottomNavigationBarItem(
//               icon: Icon(Icons.shop),
//               label: "Categories",
//             ),
//             BottomNavigationBarItem(
//               icon: Icon(Icons.favorite),
//               label: "Favourite",
//             ),
//           ],
//         ),
//       );
//     });
//   }
// }
