// import 'package:flutter/material.dart';
// import 'package:meal/models/meal_model.dart';
// import 'package:transparent_image/transparent_image.dart';

// class Mealitem extends StatelessWidget {
//   final Meal meal;
//   final void Function(Meal meal) onSelectMeal;
//   String get complexityText => meal.complexity.name;
//   String get affordabilityText => meal.affordability.name;

//   const Mealitem({super.key, required this.meal, required this.onSelectMeal});

//   @override
//   Widget build(BuildContext context) {
//     IconData icon = Icons.time_to_leave;
//     String label = "time";
//     return Card(
//       margin: EdgeInsets.all(8),
//       shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
//       clipBehavior: Clip.hardEdge,
//       elevation: 2,
//       child: InkWell(
//         onTap: () {
//           onSelectMeal(meal);
//         },
//         child: Stack(
//           children: [
//             Hero(
//               tag: meal.id,
//               child: FadeInImage(
//                 placeholder: MemoryImage(kTransparentImage),
//                 image: NetworkImage(meal.imageUrl),
//                 fit: BoxFit.cover,
//                 height: 200,
//                 width: double.infinity,
//               ),
//             ),
//             Positioned(
//               bottom: 9,
//               left: 9,
//               right: 9,
//               child: Container(
//                 decoration: BoxDecoration(
//                   color: Colors.black54,
//                   borderRadius: BorderRadius.circular(6),
//                 ),
//                 padding: EdgeInsets.symmetric(vertical: 6, horizontal: 12),
//                 child: Column(
//                   children: [
//                     Text(
//                       meal.title,
//                       maxLines: 2,
//                       textAlign: TextAlign.center,
//                       overflow: TextOverflow.ellipsis,
//                       style: TextStyle(
//                         fontSize: 20,
//                         fontWeight: FontWeight.bold,
//                         color: Colors.white,
//                       ),
//                     ),
//                     SizedBox(height: 12),
//                     Row(
//                       mainAxisAlignment: MainAxisAlignment.center,
//                       children: [
//                         MealsTrait(
//                           icon: Icons.schedule,
//                           label: "${meal.duration} min",
//                         ),
//                         SizedBox(width: 12),
//                         MealsTrait(icon: Icons.work, label: complexityText),
//                         SizedBox(width: 12),
//                         MealsTrait(icon: Icons.attach_money, label: affordabilityText),
//                       ],
//                     ),
//                   ],
//                 ),
//               ),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }

// class MealsTrait extends StatelessWidget {
//   const MealsTrait({super.key, required this.label, required Type icon});

//   final String label;

//   @override
//   Widget build(BuildContext context) {
//     return Row(
//       children: [
//         Icon(Icons.time_to_leave, size: 17, color: Colors.white),
//         SizedBox(height: 10),
//         Text(label, style: TextStyle(color: Colors.white)),
//       ],
//     );
//   }
// }



import 'package:flutter/material.dart';
import 'package:meal/models/meal_model.dart';
import 'package:transparent_image/transparent_image.dart';
// import 'package:transparent_image/transparent_image.dart';

class Mealitem extends StatelessWidget {
  final Meal meal;
  final void Function(Meal meal) onSelectMeal;

  String get complexityText => meal.complexity.name;
  String get affordabilityText => meal.affordability.name;

  const Mealitem({
    super.key,
    required this.meal,
    required this.onSelectMeal,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: EdgeInsets.all(8),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
      clipBehavior: Clip.hardEdge,
      elevation: 2,
      child: InkWell(
        onTap: () {
          onSelectMeal(meal);
        },
        child: Stack(
          children: [
            Hero(
              tag: meal.id,
              child: FadeInImage(
                placeholder: MemoryImage(kTransparentImage),
                image: NetworkImage(meal.imageUrl),
                fit: BoxFit.cover,
                height: 200,
                width: double.infinity,
              ),
            ),
            Positioned(
              bottom: 9,
              left: 9,
              right: 9,
              child: Container(
                decoration: BoxDecoration(
                  color: Colors.black54,
                  borderRadius: BorderRadius.circular(6),
                ),
                padding: EdgeInsets.symmetric(vertical: 6, horizontal: 12),
                child: Column(
                  children: [
                    Text(
                      meal.title,
                      // "Jaguear",
                      maxLines: 2,
                      textAlign: TextAlign.center,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                    SizedBox(height: 12),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        MealsTrait(
                          icon: Icons.schedule,
                          label: "${meal.duration} min",
                        ),
                        SizedBox(width: 12),
                        MealsTrait(
                          icon: Icons.work,
                          label: complexityText,
                        ),
                        SizedBox(width: 12),
                        MealsTrait(
                          icon: Icons.attach_money,
                          label: affordabilityText,
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class MealsTrait extends StatelessWidget {
  final IconData icon;
  final String label;

  const MealsTrait({
    super.key,
    required this.icon,
    required this.label,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Icon(icon, size: 17, color: Colors.white),
        SizedBox(width: 6),
        Text(
          label,
          style: TextStyle(color: Colors.white),
        ),
      ],
    );
  }
}
