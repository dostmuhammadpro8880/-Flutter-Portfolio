import 'package:flutter/material.dart';

class ListViewSeparated extends StatefulWidget {
  const ListViewSeparated({super.key});

  @override
  State<ListViewSeparated> createState() => _ListViewSeparatedState();
}

class _ListViewSeparatedState extends State<ListViewSeparated> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ListView.separated(
        itemBuilder: (context, index) {
          return Container(
            margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
            height: 200,
            width: MediaQuery.of(context).size.width,
            decoration: BoxDecoration(
              color: index.isEven
                  ? Colors.green.shade200
                  : Colors.orange.shade200,
              borderRadius: const BorderRadius.only(
                topRight: Radius.circular(71),
                topLeft: Radius.circular(20),
                bottomLeft: Radius.circular(20),
                bottomRight: Radius.circular(20),
              ),
            ),
          );
        },
        separatorBuilder: (context, index) {
          return Divider();
        },
        itemCount: 20,
      ),
    );
  }
}
