// // import 'dart:ui';

// // import 'package:chessarena/LoginScreen.dart';
// // import 'package:chessarena/signup_Scsreen.dart';
// // import 'package:flutter/material.dart';
// // import 'package:supabase_flutter/supabase_flutter.dart';void main() async{
  // await Supabase.initialize(
  //   url: 'https://iiwsrsdungyeukwhxvwc.supabase.co',
  //   anonKey:
  //       'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6Imlpd3Nyc2R1bmd5ZXVrd2h4dndjIiwicm9sZSI6ImFub24iLCJpYXQiOjE3ODIzNjc2MzQsImV4cCI6MjA5Nzk0MzYzNH0.Bk2x1W2PoYJ_gCiy-pUT4UBnHeUZb34y3_JCn6y-1Eg',
  // );
// //   runApp(const ChessArenaApp());
// // }

// // class ChessArenaApp extends StatelessWidget {
// //   const ChessArenaApp({super.key});

// //   @override
// //   Widget build(BuildContext context) {
// //     return MaterialApp(
// //       debugShowCheckedModeBanner: false,
// //       title: 'Chess Arena',
// //       theme: ThemeData(fontFamily: 'Poppins'),
// //       home: const LoginScreen(),
// //       // home: const SignupScreen(),
// //     );
// //   }
// // }



import 'package:chessarena/SplashScreen.dart';
import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';



Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Supabase.initialize(
    url: 'https://iiwsrsdungyeukwhxvwc.supabase.co',
    anonKey:
        'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6Imlpd3Nyc2R1bmd5ZXVrd2h4dndjIiwicm9sZSI6ImFub24iLCJpYXQiOjE3ODIzNjc2MzQsImV4cCI6MjA5Nzk0MzYzNH0.Bk2x1W2PoYJ_gCiy-pUT4UBnHeUZb34y3_JCn6y-1Eg',
  );



  runApp(const ChessArenaApp());
}

class ChessArenaApp extends StatelessWidget {
  const ChessArenaApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Chess Arena',
      theme: ThemeData(
        fontFamily: 'Poppins',
      ),
      // home: const LoginScreen(),
      // home: const SignupScreen(),
      home: const SplashScreen(),
    );
  }
}




