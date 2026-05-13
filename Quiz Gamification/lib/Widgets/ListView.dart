// import 'package:flutter/material.dart';

// class ListViewExample extends StatelessWidget {
//   const ListViewExample({super.key});

//   final List<String> names = const [
//     "Alice", "Bob", "Charlie", "Diana", "Eve", "Frank"
//   ];

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: const Text("ListView Example"),
//         backgroundColor: Colors.cyan,
//       ),
//       body: SafeArea(
//         child: Column(
//           children: [
//             SizedBox(
//               height: 250,
//               child: ListView.builder(
//                 scrollDirection: Axis.horizontal,
//                 itemCount: names.length,
//                 itemBuilder: (context, index) {
//                   return Container(
//                     margin: const EdgeInsets.symmetric(horizontal: 10),
//                     height: 100,
//                     width: 100,
//                     decoration: BoxDecoration(
//                       shape: BoxShape.circle,
//                       color: Colors.orange.shade200,
//                     ),
//                     child: Center(
//                       child: Text(names[index]),
//                     ),
//                   );
//                 },
//               ),
//             ),

//             Expanded(
//               child: ListView.builder(
//                 itemCount: names.length,
//                 itemBuilder: (context, index) {
//                   return Container(
// margin:
//     const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
// height: 200,
// width: MediaQuery.of(context).size.width,
//                     decoration: BoxDecoration(
//                       color: index.isEven
//                           ? Colors.green.shade200
//                           : Colors.orange.shade200,
//                       borderRadius: const BorderRadius.only(
                        // topRight: Radius.circular(71),
                        // topLeft: Radius.circular(20),
                        // bottomLeft: Radius.circular(20),
                        // bottomRight: Radius.circular(20),
//                       ),
//                     ),
//                     child: Center(
//                       child: Text(
//                         names[index],
//                         style: const TextStyle(fontSize: 20),
//                       ),
//                     ),
//                   );
//                 },
//               ),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }

import 'package:flutter/material.dart';

class ListViewExample extends StatelessWidget {
  ListViewExample({super.key});

  final List<String> name = const ["Ali", "AK", "Alio"];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("ListView"), backgroundColor: Colors.amber),
      body: SafeArea(
        child: Column(
          children: [
            SizedBox(
              height: 150,
              child: ListView.builder(
                scrollDirection: Axis.horizontal,
                itemCount: name.length,
                itemBuilder: (context, index) {
                  return Container(
                    margin: const EdgeInsets.symmetric(horizontal: 10),
                    height: 100,
                    width: 100,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: Colors.orange.shade200,
                    ),

                    child: Center(child: Text(name[index])),
                  );
                },
              ),
            ),
            Expanded(
              child: ListView.builder(
                itemCount: name.length,
                itemBuilder: (context, index) {
                  return Container(
                    margin: const EdgeInsets.symmetric(
                      horizontal: 20,
                      vertical: 10,
                    ),
                    height: 200,
                    width: MediaQuery.of(context).size.width,
                    decoration: BoxDecoration(
                      color: index.isEven ? Colors.blue : Colors.blueGrey,
                      borderRadius: BorderRadius.only(
                        topRight: Radius.circular(71),
                        topLeft: Radius.circular(20),
                        bottomLeft: Radius.circular(20),
                        bottomRight: Radius.circular(20),
                      )
                    ),
                    child: Center(
                      child: Text(name[index], style: const TextStyle(fontSize: 20),),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
