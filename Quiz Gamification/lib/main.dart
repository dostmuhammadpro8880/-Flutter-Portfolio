import 'package:flutter/material.dart';
import 'package:gamification/Start_screen.dart';
import 'package:gamification/data/questions.dart';
import 'package:gamification/screens/ResultScreen.dart';
import 'package:gamification/screens/questionScreen.dart';

void main() {
  runApp(const MyApp());
  // runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  List<String> selectedanswers = [];
  var activeScreen = "Start-Screen";

  void switchScreen() {
    setState(() {
      activeScreen = "Questions-Screen";
    });
  }

  void chooseAnswer(String answer) {
    selectedanswers.add(answer);
    if (selectedanswers.length == questions.length) {
      setState(() {
        activeScreen = "result-screen";
      });
    }
  }

  void restartQuiz() {
    setState(() {
      selectedanswers = [];
      activeScreen = "start-Screen";
      // activeScreen = "Questions-Screen";
    });
  }

  @override
  Widget build(BuildContext context) {
    // ✅ Corrected: call switchScreen instead of an empty function
    Widget screenWidget = Start_screen(
      startQuiz: switchScreen,
      starQuiz: () {},
    );

    // ✅ Fixed typo and spacing issue in screen name check
    if (activeScreen == "Questions-Screen") {
      screenWidget = Questionscreen(onSelectAnswer: chooseAnswer);
    }

    if (activeScreen == "result-screen") {
      screenWidget = ResultScreen(chooseAnswers:selectedanswers ,onRestart:restartQuiz);
    }

    return MaterialApp(
      title: 'Flutter Demo',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
      ),
      home: screenWidget,
      // home: ListViewExample(),
      // home: ListViewSeparated(),
      // home: MyGridview(),
    );
  }
}

// import 'package:flutter/material.dart';
// import 'package:gamification/Start_screen.dart';
// import 'package:gamification/Widgets/ListView.dart';
// import 'package:gamification/Widgets/my_gridView.dart';
// import 'package:gamification/data/questions.dart';
// import 'package:gamification/screens/ResultScreen.dart';
// import 'package:gamification/screens/questionScreen.dart';

// void main() {
//   runApp(const MyApp());
// }

// class MyApp extends StatefulWidget {
//   const MyApp({super.key});

//   @override
//   State<MyApp> createState() => _MyAppState();
// }

// class _MyAppState extends State<MyApp> {
//   String activeScreen = "Start_screen";
//   List<String> selectedanswers = [];

//   void switchScreen() {
//     setState(() {
//       activeScreen = "Questionscreen";
//     });
//   }

//   void chooseAnswer(String answer) {
//     selectedanswers.add(answer);
//     if (selectedanswers.length == questions.length) {}
//     setState(() {
//       activeScreen = "ResultScreen";
//     });
//   }

//   @override
//   Widget build(BuildContext context) {
//     Widget screenWidget = Start_screen(
//       startQuiz: switchScreen,
//       starQuiz: () {},
//     );

//     if (activeScreen == "Questionscreen") {
//       screenWidget = Questionscreen();
//     }

//     if (activeScreen == "ResultScreen") {
//       screenWidget =const ResultScreen(chooseAnswers: selectedanswers, onRestart: restartQuiz,);
//     }
//     return MaterialApp(
//       title: "Flutter Gamification Practice",
//       debugShowCheckedModeBanner: false,
//       theme: ThemeData(
//         colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
//       ),
//       home: screenWidget,
//       // home: ListViewExample(),
//       //  home: MyGridview(),
//       // home: Questionscreen(),
//     );
//   }
// }
