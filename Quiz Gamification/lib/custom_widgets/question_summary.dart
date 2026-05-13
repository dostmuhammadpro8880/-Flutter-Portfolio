// import 'package:flutter/material.dart';
// import 'package:google_fonts/google_fonts.dart';

// class QuestionSummary extends StatelessWidget {
//   const QuestionSummary({super.key, required this.summaryData, required List<Map<String, Object>> SummaryData});

//   final List<Map<String, Object>> summaryData;

//   @override
//   Widget build(BuildContext context) {
//     return SizedBox(
//       height: 300,
//       child: SingleChildScrollView(
//         child: Column(
//           children: summaryData.map((data) {
//             return Row(
//               crossAxisAlignment: CrossAxisAlignment.start,
//               children: [
//                 Text(
//                   "${(data['question_index'] as int) + 1}",
//                   style: GoogleFonts.lato(color: Colors.white),
//                 ),
//                 Expanded(
//                   child: Column(
//                     children: [
//                       Text(
//                         "${data['Question']}",
//                         style: GoogleFonts.lato(color: Colors.white),
//                       ),
//                       const SizedBox(height: 5),
//                       Row(
//                         children: [
//                           const Text("You Selected: "),
//                           Text(
//                             "${data['user_answer']}",
//                             style: GoogleFonts.lato(color: Colors.white),
//                           ),
//                         ],
//                       ),
//                       Row(
//                         children: [
//                           const Text("Correct Answer: "),
//                           Text(
//                             "${data['correct_answer']}",
//                             style: GoogleFonts.lato(color: Colors.green),
//                           ),
//                         ],
//                       ),
//                     ],
//                   ),
//                 ),
//               ],
//             );
//           }).toList(),
//         ),
//       ),
//     );
//   }
// }



import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class QuestionSummary extends StatelessWidget {
  const QuestionSummary({super.key, required this.summaryData});

  final List<Map<String, Object>> summaryData;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 400,
      child: SingleChildScrollView(
        child: Column(
          children: summaryData.map((data) {
            return Padding(
              padding: const EdgeInsets.symmetric(vertical: 8.0),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "${(data['question_index'] as int)}. ",
                    style: GoogleFonts.lato(
                      color: Colors.green,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(width: 5),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "${data['Question']}",
                          style: GoogleFonts.lato(
                            color: Colors.black,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 5),
                        Text(
                          "You Selected: ${data['user_answer']}",
                          style: GoogleFonts.lato(color: Colors.red),
                        ),
                        Text(
                          "Correct Answer: ${data['correct_answer']}",
                          style: GoogleFonts.lato(color: Colors.green),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            );
          }).toList(),
        ),
      ),
    );
  }
}
