// import 'package:final_exam_project/Screen.dart/HomeScreen.dart';
// import 'package:final_exam_project/Screen.dart/Login_Screen.dart';
// import 'package:flutter/material.dart';
// import 'package:supabase_flutter/supabase_flutter.dart';

// /// ===============================
// /// SPLASH SCREEN
// /// ===============================
// class SplashScreen extends StatefulWidget {
//   const SplashScreen({super.key});

//   @override
//   State<SplashScreen> createState() => _SplashScreenState();
// }

// class _SplashScreenState extends State<SplashScreen> {
//   @override
//   void initState() {
//     super.initState();
//     _navigate();
//   }

//   Future<void> _navigate() async {
//     await Future.delayed(const Duration(seconds: 3));

//     final session = Supabase.instance.client.auth.currentSession;

//     if (!mounted) return;

//     if (session != null) {
//       Navigator.pushReplacement(
//         context,
//         MaterialPageRoute(builder: (_) => const HomePage()),
//       );
//     } else {
//       Navigator.pushReplacement(
//         context,
//         MaterialPageRoute(builder: (_) => const LoginPage()),
//       );
//     }
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       body: Stack(
//         children: [
//           Positioned.fill(
//             child: Image.network(
//               'https://images.unsplash.com/photo-1607082348824-0a96f2a4b9da?q=80&w=2070',
//               fit: BoxFit.cover,
//             ),
//           ),

//           Positioned.fill(
//             child: Container(
//               color: Colors.black.withOpacity(0.55),
//             ),
//           ),

//           const Center(
//             child: Column(
//               mainAxisSize: MainAxisSize.min,
//               children: [
//                 Icon(
//                   Icons.shopping_bag_outlined,
//                   size: 80,
//                   color: Colors.white,
//                 ),
//                 SizedBox(height: 20),
//                 Text(
//                   "Emcome",
//                   style: TextStyle(
//                     color: Colors.white,
//                     fontSize: 34,
//                     fontWeight: FontWeight.bold,
//                     letterSpacing: 1.5,
//                   ),
//                 ),
//                 SizedBox(height: 15),
//                 CircularProgressIndicator(
//                   color: Colors.white,
//                 ),
//               ],
//             ),
//           ),
//         ],
//       ),
//     );
//   }
// }

// /// ===============================
// /// HOME PAGE
// /// ===============================
// /// 
// Future<void> logout(BuildContext context) async {
//   await Supabase.instance.client.auth.signOut();

//   Navigator.pushAndRemoveUntil(
//     context,
//     MaterialPageRoute(builder: (_) => const LoginPage()),
//     (route) => false,
//   );
// }




import 'package:final_exam_project/Screen.dart/HomeScreen.dart';
import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'Login_Screen.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    _goNext();
  }

  Future<void> _goNext() async {
    await Future.delayed(const Duration(seconds: 3));

    final session = Supabase.instance.client.auth.currentSession;

    if (!mounted) return;

    Navigator.pushReplacement(
      context,
      MaterialPageRoute(
        builder: (_) => session != null ? const HomePage() : const LoginPage(),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          Positioned.fill(
            child: Image.network(
              'https://images.unsplash.com/photo-1498837167922-ddd27525d352',
              fit: BoxFit.cover,
            ),
          ),
          Positioned.fill(
            child: Container(
              color: Colors.black.withOpacity(0.6),
            ),
          ),
          const Center(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(
                  Icons.shopping_bag_outlined,
                  size: 80,
                  color: Colors.white,
                ),
                SizedBox(height: 20),
                Text(
                  "Emcome",
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 34,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                SizedBox(height: 20),
                CircularProgressIndicator(color: Colors.white),
              ],
            ),
          ),
        ],
      ),
    );
  }
}