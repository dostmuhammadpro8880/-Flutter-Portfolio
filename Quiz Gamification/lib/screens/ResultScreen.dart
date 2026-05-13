// import 'package:flutter/foundation.dart';
// import 'package:flutter/material.dart';
// import 'package:gamification/custom_widgets/question_summary.dart';
// import 'package:gamification/data/questions.dart';
// import 'package:google_fonts/google_fonts.dart';

// class ResultScreen extends StatelessWidget {
//   const ResultScreen({
//     super.key,
//     required this.chooseAnswers,
//     required this.onRestart,
//   });

//   final List<String> chooseAnswers;
//   final void Function() onRestart;

//   List<Map<String, Object>> get SummaryData {
//     final List<Map<String, Object>> summary = [];
// for (int i = 0; i < questions.length; i++) {
//   summary.add({
//     "question_index": i + 1,
//     "Question": questions[i].question,
//     "correct_answer": questions[i].correctAnswer,
//     "user_answer": i < chooseAnswers.length ? chooseAnswers[i] : "Not answered",
//   });
// }

//     return summary;
//   }

  

//   @override
//   Widget build(BuildContext context) {
//     final numTotalQuestion = questions.length;
//     final numCorrectAnswer = SummaryData
//         .where((data) => data["user_answer"] == data["correct_answer"])
//         .length;

//     return SizedBox(
//       width: double.infinity,
//       child: Container(
//         margin: const EdgeInsets.all(40),
//         child: Column(
//           children: [
//             Text(
//               "Your Answer $numCorrectAnswer out of $numTotalQuestion Question Correctly",
//               style: GoogleFonts.lato(
//                 color: Colors.green,
//                 fontWeight: FontWeight.bold,
//               ),
//               textAlign: TextAlign.center,
//             ),
//            QuestionSummary(SummaryData:SummaryData, summaryData: [],),
//            TextButton.icon(onPressed: onRestart, label: Text("Restart Quiz"), icon: Icon(Icons.refresh),)
//           ],
//         ),
//       ),
//     );
//   }
// }



import 'package:flutter/material.dart';
import 'package:gamification/custom_widgets/question_summary.dart';
import 'package:gamification/data/questions.dart';
// import 'package:gamification/screens/question_summary.dart';
import 'package:google_fonts/google_fonts.dart';

class ResultScreen extends StatelessWidget {
  const ResultScreen({
    super.key,
    required this.chooseAnswers,
    required this.onRestart,
  });

  final List<String> chooseAnswers;
  final void Function() onRestart;

  List<Map<String, Object>> get summaryData {
    final List<Map<String, Object>> summary = [];

    for (int i = 0; i < questions.length; i++) {
      summary.add({
        "question_index": i + 1,
        "Question": questions[i].question,
        "correct_answer": questions[i].correctAnswer,
        "user_answer":
            i < chooseAnswers.length ? chooseAnswers[i] : "Not answered",
      });
    }
    return summary;
  }

  @override
  Widget build(BuildContext context) {
    final numTotalQuestion = questions.length;
    final numCorrectAnswer = summaryData
        .where((data) => data["user_answer"] == data["correct_answer"])
        .length;

    return Material(
      child: SizedBox(
        width: double.infinity,
        child: Container(
          margin: const EdgeInsets.all(40),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                "You answered $numCorrectAnswer out of $numTotalQuestion questions correctly!",
                style: GoogleFonts.lato(
                  color: Colors.green,
                  fontWeight: FontWeight.bold,
                  fontSize: 18,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 20),
              QuestionSummary(summaryData: summaryData),
              const SizedBox(height: 20),
              TextButton.icon(
                onPressed: onRestart,
                icon: const Icon(Icons.refresh),
                label: const Text("Restart Quiz"),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
