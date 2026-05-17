// import 'package:final_exam_project/Screen.dart/Container_HomeScreen.dart';
// import 'package:final_exam_project/Screen.dart/HomeScreen.dart';
// import 'package:final_exam_project/Screen.dart/classListWidget.dart' hide ClassContainer;
// import 'package:flutter/material.dart';
// import 'package:supabase_flutter/supabase_flutter.dart';

// void main() async {
//   WidgetsFlutterBinding.ensureInitialized();

//   await Supabase.initialize(
//     url: 'https://byqfjiuwtgzoaznwormj.supabase.co',
//     anonKey:
//         'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6ImJ5cWZqaXV3dGd6b2F6bndvcm1qIiwicm9sZSI6ImFub24iLCJpYXQiOjE3NzgxMzgwNDUsImV4cCI6MjA5MzcxNDA0NX0.7ChKomzgPQwuCwhDObV4OZhp8tezKP0LYa1IUGjfsz0',
//   );
//   runApp(const MyApp());
// }

// class MyApp extends StatelessWidget {
//   const MyApp({super.key});

//   @override
//   Widget build(BuildContext context) {
//     return MaterialApp(
//       debugShowCheckedModeBanner: false,
//       home: const HomePage(),
//     );
//   }
// }


import 'package:final_exam_project/Screen.dart/HomeScreen.dart';
import 'package:final_exam_project/Screen.dart/SplashScreen.dart';
import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Supabase.initialize(
    url: 'https://byqfjiuwtgzoaznwormj.supabase.co',
    anonKey:
        'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6ImJ5cWZqaXV3dGd6b2F6bndvcm1qIiwicm9sZSI6ImFub24iLCJpYXQiOjE3NzgxMzgwNDUsImV4cCI6MjA5MzcxNDA0NX0.7ChKomzgPQwuCwhDObV4OZhp8tezKP0LYa1IUGjfsz0',
  );
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      // home: const HomePage(),
      home: SplashScreen()
    );
  }
}

// ─────────────────────────────────────────────────────────────
// HOME PAGE
// ─────────────────────────────────────────────────────────────

// class HomePage extends StatefulWidget {
//   const HomePage({super.key});

//   @override
//   State<HomePage> createState() => _HomePageState();
// }

// class _HomePageState extends State<HomePage> {
//   late Future<List<Map<String, dynamic>>> _classesFuture;

//   @override
//   void initState() {
//     super.initState();
//     _classesFuture = _fetchClasses();
//     _subscribeToChanges();
//   }

//   Future<List<Map<String, dynamic>>> _fetchClasses() async {
//     try {
//       final response = await Supabase.instance.client
//           .from('classes')
//           .select();

//       return List<Map<String, dynamic>>.from(response);
//     } catch (e) {
//       debugPrint("Error: $e");
//       return [];
//     }
//   }

//   void _subscribeToChanges() {
//     Supabase.instance.client
//         .channel('classes-channel')
//         .onPostgresChanges(
//           event: PostgresChangeEvent.all,
//           schema: 'public',
//           table: 'classes',
//           callback: (payload) {
//             setState(() {
//               _classesFuture = _fetchClasses();
//             });
//           },
//         )
//         .subscribe();
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       backgroundColor: Colors.white,

//       appBar: AppBar(
//         title: const Text("Restaurant App"),
//         centerTitle: true,
//       ),

//       body: Padding(
//         padding: const EdgeInsets.all(16),
//         child: Column(
//           crossAxisAlignment: CrossAxisAlignment.start,
//           children: [
//             const Text(
//               "Popular Restaurants",
//               style: TextStyle(
//                 fontSize: 22,
//                 fontWeight: FontWeight.bold,
//               ),
//             ),

//             const SizedBox(height: 20),

//             Expanded(
//               child: FutureBuilder<List<Map<String, dynamic>>>(
//                 future: _classesFuture,
//                 builder: (context, snapshot) {
//                   if (snapshot.connectionState ==
//                       ConnectionState.waiting) {
//                     return const Center(
//                       child: CircularProgressIndicator(),
//                     );
//                   }

//                   if (snapshot.hasError) {
//                     return Center(
//                       child: Text("Error: ${snapshot.error}"),
//                     );
//                   }

//                   final classes = snapshot.data ?? [];

//                   if (classes.isEmpty) {
//                     return const Center(
//                       child: Text("No Data Found"),
//                     );
//                   }

//                   return ListView.builder(
//                     itemCount: classes.length,
//                     itemBuilder: (context, index) {
//                       final classData = classes[index];

//                       return GestureDetector(
//                         onTap: () {
//                           Navigator.push(
//                             context,
//                             MaterialPageRoute(
//                               builder: (_) => ClassDetailScreen(
//                                 classData: classData,
//                               ),
//                             ),
//                           );
//                         },

//                         child: Padding(
//                           padding: const EdgeInsets.only(bottom: 20),

//                           child: Hero(
//                             tag: 'class-image-${classData['id']}',

//                             child: ClassContainer(
//                               name: classData['name'] ?? 'Unknown',
//                               imageUrl:
//                                   classData['image_url'] ??
//                                   'https://via.placeholder.com/400x300',
//                               location:
//                                   classData['location'] ??
//                                   'Unknown Location',
//                             ),
//                           ),
//                         ),
//                       );
//                     },
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

// // ─────────────────────────────────────────────────────────────
// // CLASS CONTAINER
// // ─────────────────────────────────────────────────────────────

// class ClassContainer extends StatelessWidget {
//   final String name;
//   final String imageUrl;
//   final String location;

//   const ClassContainer({
//     super.key,
//     required this.name,
//     required this.imageUrl,
//     required this.location,
//   });

//   @override
//   Widget build(BuildContext context) {
//     return Container(
//       height: 250,
//       width: double.infinity,

//       decoration: BoxDecoration(
//         borderRadius: BorderRadius.circular(20),

//         image: DecorationImage(
//           image: NetworkImage(imageUrl),
//           fit: BoxFit.cover,
//         ),
//       ),

//       child: Container(
//         decoration: BoxDecoration(
//           borderRadius: BorderRadius.circular(20),

//           gradient: LinearGradient(
//             begin: Alignment.topCenter,
//             end: Alignment.bottomCenter,

//             colors: [
//               Colors.transparent,
//               Colors.black.withOpacity(0.8),
//             ],
//           ),
//         ),

//         child: Padding(
//           padding: const EdgeInsets.all(16),

//           child: Column(
//             mainAxisAlignment: MainAxisAlignment.end,
//             crossAxisAlignment: CrossAxisAlignment.start,

//             children: [
//               Text(
//                 name,
//                 style: const TextStyle(
//                   color: Colors.white,
//                   fontSize: 24,
//                   fontWeight: FontWeight.bold,
//                 ),
//               ),

//               const SizedBox(height: 6),

//               Row(
//                 children: [
//                   const Icon(
//                     Icons.location_on,
//                     color: Colors.white,
//                     size: 18,
//                   ),

//                   const SizedBox(width: 5),

//                   Text(
//                     location,
//                     style: const TextStyle(
//                       color: Colors.white70,
//                       fontSize: 14,
//                     ),
//                   ),
//                 ],
//               ),
//             ],
//           ),
//         ),
//       ),
//     );
//   }
// }

// // ─────────────────────────────────────────────────────────────
// // DETAIL SCREEN
// // ─────────────────────────────────────────────────────────────

// class ClassDetailScreen extends StatelessWidget {
//   final Map<String, dynamic> classData;

//   const ClassDetailScreen({
//     super.key,
//     required this.classData,
//   });

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       backgroundColor: Colors.white,

//       body: CustomScrollView(
//         slivers: [
//           // APP BAR IMAGE
//           SliverAppBar(
//             expandedHeight: 320,
//             pinned: true,
//             backgroundColor: Colors.white,

//             leading: Padding(
//               padding: const EdgeInsets.all(8),

//               child: GestureDetector(
//                 onTap: () {
//                   Navigator.pop(context);
//                 },

//                 child: Container(
//                   decoration: BoxDecoration(
//                     color: Colors.white,
//                     borderRadius: BorderRadius.circular(12),
//                   ),

//                   child: const Icon(
//                     Icons.arrow_back,
//                     color: Colors.black,
//                   ),
//                 ),
//               ),
//             ),

//             flexibleSpace: FlexibleSpaceBar(
//               background: Hero(
//                 tag: 'class-image-${classData['id']}',

//                 child: Image.network(
//                   classData['image_url'] ??
//                       'https://via.placeholder.com/400x300',

//                   fit: BoxFit.cover,

//                   errorBuilder:
//                       (context, error, stackTrace) {
//                         return Container(
//                           color: Colors.grey[300],

//                           child: const Icon(
//                             Icons.broken_image,
//                             size: 80,
//                           ),
//                         );
//                       },
//                 ),
//               ),
//             ),
//           ),

//           // BODY
//           SliverToBoxAdapter(
//             child: Padding(
//               padding: const EdgeInsets.all(20),

//               child: Column(
//                 crossAxisAlignment:
//                     CrossAxisAlignment.start,

//                 children: [
//                   Text(
//                     classData['name'] ?? 'Unknown',
//                     style: const TextStyle(
//                       fontSize: 28,
//                       fontWeight: FontWeight.bold,
//                     ),
//                   ),

//                   const SizedBox(height: 12),

//                   Row(
//                     children: [
//                       const Icon(
//                         Icons.location_on,
//                         color: Colors.red,
//                       ),

//                       const SizedBox(width: 6),

//                       Text(
//                         classData['location'] ??
//                             'Unknown Location',

//                         style: TextStyle(
//                           color: Colors.grey[700],
//                           fontSize: 16,
//                         ),
//                       ),
//                     ],
//                   ),

//                   const SizedBox(height: 20),

//                   if (classData['price'] != null)
//                     Text(
//                       "Price: ${classData['price']}",
//                       style: const TextStyle(
//                         fontSize: 20,
//                         color: Colors.green,
//                         fontWeight: FontWeight.bold,
//                       ),
//                     ),

//                   const SizedBox(height: 20),

//                   const Text(
//                     "About",
//                     style: TextStyle(
//                       fontSize: 22,
//                       fontWeight: FontWeight.bold,
//                     ),
//                   ),

//                   const SizedBox(height: 10),

//                   Text(
//                     classData['description'] ??
//                         'No description available.',

//                     style: TextStyle(
//                       fontSize: 16,
//                       height: 1.6,
//                       color: Colors.grey[700],
//                     ),
//                   ),

//                   const SizedBox(height: 30),

//                   SizedBox(
//                     width: double.infinity,
//                     height: 55,

//                     child: ElevatedButton(
//                       onPressed: () {
//                         ScaffoldMessenger.of(context)
//                             .showSnackBar(
//                               const SnackBar(
//                                 content: Text(
//                                   "Booking Coming Soon",
//                                 ),
//                               ),
//                             );
//                       },

//                       style: ElevatedButton.styleFrom(
//                         backgroundColor: Colors.orange,

//                         shape: RoundedRectangleBorder(
//                           borderRadius:
//                               BorderRadius.circular(14),
//                         ),
//                       ),

//                       child: const Text(
//                         "Book Now",
//                         style: TextStyle(
//                           fontSize: 18,
//                           color: Colors.white,
//                           fontWeight: FontWeight.bold,
//                         ),
//                       ),
//                     ),
//                   ),

//                   const SizedBox(height: 30),
//                 ],
//               ),
//             ),
//           ),
//         ],
//       ),
//     );
//   }
// }



// import 'package:flutter/material.dart';
// import 'package:supabase_flutter/supabase_flutter.dart';

// ─────────────────────────────────────────────
// HORIZONTAL CARD
// ─────────────────────────────────────────────



