import 'package:flutter/material.dart';
import 'package:gamification/models/question_model.dart';

class MyGridview extends StatefulWidget {
  const MyGridview({super.key});

  @override
  State<MyGridview> createState() => _MyGridviewState();
}

class _MyGridviewState extends State<MyGridview> {
  List<Product> products = [
    Product(
      id: 'p1',
      name: 'Laptop',
      price: 899.99,
      imageUrl: 'assets/images/laptop.png',
      description: 'A powerful laptop for developers.',
    ),
    Product(
      id: 'p2',
      name: 'PC',
      price: 800.99,
      imageUrl: 'assets/images/laptop.png',
      description: 'A powerful PC for work.',
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("GridView"),
        backgroundColor: Colors.purple.shade200,
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            const SizedBox(height: 10),
            Text(
              "GridView.builder",
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
            ),
            GridView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: products.length,
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 4,
                mainAxisSpacing: 5,
                crossAxisSpacing: 5,
                childAspectRatio: 1 / 1.5,
              ),
              itemBuilder: (context, index) {
                final product = products[index];
                return Container(
                  padding: const EdgeInsets.all(8),
                  color: Colors.purple.shade100,
                  child: Column(
                    children: [
                      Image.asset(
                        product.imageUrl,
                        height: 80,
                        width: 80,
                      ),
                      const SizedBox(height: 5),
                      Text(product.name),
                      Text("\$${product.price}"),
                    ],
                  ),
                );
              },
            ),

            const SizedBox(height: 20),
            Text(
              "GridView.count",
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
            ),
            GridView.count(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              crossAxisCount: 3,
              mainAxisSpacing: 5,
              crossAxisSpacing: 5,
              childAspectRatio: 1 / 1.5,
              children: [
                Container(color: Colors.red),
                Container(color: Colors.blue),
                Container(color: Colors.green),
                Container(color: Colors.yellow),
              ],
            ),

            const SizedBox(height: 20),
            Text(
              "GridView.extent",
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
            ),
            GridView.extent(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              maxCrossAxisExtent: 150,
              mainAxisSpacing: 5,
              crossAxisSpacing: 5,
              children: [
                Container(color: Colors.red),
                Container(color: Colors.blue),
                Container(color: Colors.green),
                Container(color: Colors.yellow),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
