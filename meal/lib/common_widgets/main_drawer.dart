import 'package:flutter/material.dart';

class MainDrawer extends StatelessWidget {
  const MainDrawer({super.key});

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: Column(
        children: [
          DrawerHeader(
            padding: EdgeInsets.all(20),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  // Colors.green,Colors.red,
                  Theme.of(context).colorScheme.primaryContainer,
                  Theme.of(
                    context,
                  ).colorScheme.primaryContainer.withOpacity(0.8),
                  // ).colorScheme.primaryContainer.withOpacity(1.0),
                ],
              ),
            ),
            child: Row(
              children: [
                Icon(Icons.fastfood),
                Text(
                  "Cooking up!",
                  // style: Theme.of(context).textTheme.titleMedium!.copyWith(
                  style: Theme.of(context).textTheme.titleLarge!.copyWith(
                    color: Theme.of(context).colorScheme.primary,
                  ),
                ),
              ],
            ),
          ),

          ListTile(
            leading: Icon(
              Icons.restaurant,
              size: 26,
              // size: 86,
              color: Theme.of(context).colorScheme.onSurface,
                //  color: Theme.of(context).colorScheme.primaryContainer,

            ),
            title: Text(
              "Meals",
              style: Theme.of(context).textTheme.titleSmall?.copyWith(
                color: Theme.of(context).colorScheme.onSurface,
                fontSize: 24,
              ),
            ),
            onTap: (){
              
            },
          ),
        ],
      ),
    );
  }
}
