// import 'package:flutter/material.dart';
// import 'package:google_fonts/google_fonts.dart';

// class Start_screen extends StatefulWidget {
//   const Start_screen({super.key, required this.startQuiz, required Null Function() starQuiz});
//   final void Function() startQuiz;

//   @override
//   State<Start_screen> createState() => _Start_screenState();
// }

// class _Start_screenState extends State<Start_screen> {
//   int counter = 0;

//   // void increment() {
//   //   setState(() {
//   //     counter++;
//   //   });
//   // }

//   @override
//   Widget build(BuildContext context) {

//     // return Scaffold(
//     //   appBar: AppBar(title: Text("data")),
//     //   backgroundColor: Colors.transparent,
//     //   body: SafeArea(

//     //     child: Column(
//     //       mainAxisAlignment: MainAxisAlignment.center,

//     //       children: [

//     //         Text(
//     //           "You have Pressed many Times",
//     //           style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
//     //         ),
//     //         Text(
//     //           counter.toString(),
//     //           style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
//     //         ),
//     //         ElevatedButton(onPressed: increment, child: Text("Goooo")),
//     //       ],
//     //     ),
//     //   ),
//     // );

//     return Scaffold(
//       body: Container(
//         decoration: const BoxDecoration(
//           gradient: LinearGradient(
//             begin: Alignment.topLeft,
//             end: Alignment.bottomRight,
//             colors: [Colors.green, Colors.yellowAccent],
//           ),
//         ),
//         child: Center(
//           child: Column(
//             mainAxisSize: MainAxisSize.min,
//             children: [
//               Image.asset("assets/images/quiz_logo.png"),
//               Text(
//                 "Guess th Animal by Voice",
//                 style: GoogleFonts.lato(
//                   color: Colors.white,
//                   fontSize: 24,
//                   decoration: TextDecoration.none,
//                 ),
//               ),

//               const SizedBox(height: 20),
//               InkWell(
//                 onTap: () {
//                   print("Submit");
//                 },
//                 child: Container(
//                   height: 50,
//                   width: 150,
//                   decoration: BoxDecoration(
//                     color: Colors.white,
//                     borderRadius: BorderRadius.circular(50),
//                   ),
//                   child: const Center(
//                     child: Text(
//                       "Submit",
//                       style: TextStyle(fontSize: 20, color: Colors.green),
//                     ),
//                   ),
//                 ),
//               ),
//               const SizedBox(height: 20),
//               OutlinedButton.icon(
//                 style: OutlinedButton.styleFrom(
//                   foregroundColor: Colors.white,
//                   side: const BorderSide(color: Colors.white),
//                 ),
//                 onPressed: widget.startQuiz,
//                 icon: const Icon(Icons.arrow_right_alt),
//                 label: Text("Start Quiz", style: GoogleFonts.lato()),
//               ),
//             ],
//           ),
//         ),
//       ),
//     );
//   }
// }

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class Start_screen extends StatefulWidget {
  const Start_screen({super.key,required this.startQuiz, required Null Function() starQuiz});
 final void Function() startQuiz;
  @override
  State<Start_screen> createState() => _Start_screenState();
}

class _Start_screenState extends State<Start_screen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [Colors.green, Colors.yellowAccent],
          ),
        ),
        child: Center(
          child: Column(
            children: [
              Image.asset("assets/images/quiz_logo copy.png"),
              Text(
                "Guess the Animal Game",
                style: GoogleFonts.lato(
                  fontSize: 20,
                  color: Colors.white,
                  decoration: TextDecoration.none,
                ),
              ),
              const SizedBox(height: 20),
              InkWell(
                onTap: () {
                  print("SubMit");
                },
                child: Container(
                  height: 50,
                  width: 150,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(50),
                  ),
                  child: Center(
                    child: Text(
                      "Submit",
                      style: TextStyle(fontSize: 20, color: Colors.green),
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 20),
              OutlinedButton.icon(
                style: OutlinedButton.styleFrom(
                  foregroundColor: Colors.white,
                  side: BorderSide(color: Colors.white),
                ),
                onPressed: widget.startQuiz,
                icon: Icon(Icons.arrow_forward),
                label: Text("start Quiz", style: GoogleFonts.lato()),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
