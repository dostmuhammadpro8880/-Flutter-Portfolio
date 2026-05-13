// import 'package:audioplayers/audioplayers.dart';
// import 'package:flutter/material.dart';
// import 'package:gamification/data/questions.dart';
// import 'package:google_fonts/google_fonts.dart';

// class Questionscreen extends StatefulWidget {
//   const Questionscreen({Key? key}) : super(key: key);

//   @override
//   State<Questionscreen> createState() => _QuestionscreenState();
// }

// class _QuestionscreenState extends State<Questionscreen>
//     with SingleTickerProviderStateMixin {
//   int currentQuestionIndex = 0;
//   bool isPlaying = false;
//   bool isExpanded = true;
//   final AudioPlayer _audioPlayer = AudioPlayer();
//   double opacity = 1.0;
//   late AnimationController _controller;
//   late Animation<double> _scaleanimation;

//   @override
//   void initState() {
//     super.initState();
//     _controller = AnimationController(
//       duration: const Duration(seconds: 1),
//       vsync: this,
//     )..addListener(() {
//         setState(() {});
//       });

//   _scaleanimation = Tween(
//     begin: 0.3,
//     end: 1.2,
//   ).animate(CurvedAnimation(parent: _controller, curve: Curves.easeInOut));
// }

//   @override
//   void dispose() {
//     _controller.dispose();
//     _audioPlayer.dispose();
//     super.dispose();
//   }

//   void playAudio(String audiopath) async {
//     if (isPlaying) {
//       await _audioPlayer.stop();
//       setState(() {
//         isPlaying = false;
//       });
//     } else {
//       try {
//         await _audioPlayer.setSource(AssetSource(audiopath));
//         await _audioPlayer.resume();
//         _controller.repeat();
//         setState(() {
//           isPlaying = true;
//         });

//           _audioPlayer.onPlayerComplete.listen((event){
//           _controller.stop();
//           if(mounted){
//             setState(() {
//               isPlaying=false;
//             });
//           }
//         });

//       } catch (e) {
//         if(mounted){
//           ScaffoldMessenger.of(context).showSnackBar(
//             SnackBar(content: Text("Error Playing audio : ${e.toString()}")),
//           );
//         }
//       }
//     }
//   }

//   @override
//   Widget build(BuildContext context) {
//     final currentQuestion = questions[currentQuestionIndex];
//     return Scaffold(
//       body: Container(
//         width: MediaQuery.sizeOf(context).width,
//         decoration: const BoxDecoration(
// gradient: LinearGradient(
//   begin: Alignment.topLeft,
//   end: Alignment.topRight,
//   colors: [Colors.green, Colors.yellow],
// ),
//         ),
//         child: Center(
//           child: Column(
//             mainAxisAlignment: MainAxisAlignment.center,
//             children: [
//               Text(
//                 currentQuestion.question,
//                 textAlign: TextAlign.center,
//                 style: GoogleFonts.lato(
//                   color: Colors.white,
//                   fontWeight: FontWeight.bold,
//                   fontSize: 20,
//                 ),
//               ),
//               const SizedBox(height: 16),
//               GestureDetector(
//                 onTap: () {
//                   playAudio('audio/correct.mp3');
//                   setState(() {
//                     isPlaying = !isPlaying;
//                   });
//                 },
//                 child: CircleAvatar(
//                   radius: 50,
//                   backgroundColor: Colors.green,
//                   child:
//                       Icon(isPlaying ? Icons.pause : Icons.play_arrow),
//                 ),
//               ),
//               AnimatedContainer(
//                 duration: const Duration(seconds: 3),
//                 height: isExpanded ? 300 : 100,
//                 width: isExpanded ? 150 : 250,
//                 curve: Curves.linear,
//                 decoration: BoxDecoration(
//                   color: Colors.green.shade900,
//                   borderRadius: BorderRadius.circular(36),
//                 ),
//               ),
//               ElevatedButton(
//                 onPressed: () {
//                   setState(() {
//                     isExpanded = !isExpanded;
//                   });
//                 },
//                 child: const Text("data"),
//               ),
//               AnimatedOpacity(
//                 opacity: opacity,
//                 duration: const Duration(seconds: 4),
//                 child: Container(
//                   height: 300,
//                   width: 150,
//                   decoration: BoxDecoration(
//                     color: Colors.green.shade900,
//                     borderRadiFaus: BorderRadius.circular(36),
//                   ),
//                 ),
//               ),
//               ElevatedButton(
//                 onPressed: () {
//                   setState(() {
//                     opacity = opacity == 1.0 ? 0.0 : 1.0;
//                   });
//                 },
//                 child: const Text("data"),
//               ),
//               GestureDetector(
//                 onTap: () => playAudio(currentQuestion.audioPath),
//                 child: Stack(
//                   children: [
//                     if (isPlaying)
//                       ScaleTransition(
//                         scale: _scaleanimation,
//                           height: 150,
//                           decoration: BoxDecoration(
//                             shape: BoxShape.circle,
//                             color: Colors.green.withValues(alpha: 0.3),
//                           ),
//                         ),
//                       ),

//                     CircleAvatar(
//                       ),
//                     CircleAvatar(
//                       radius: 58,
//                       backgroundColor: Colors.green,
//                       child: Icon(
//                         isPlaying ? Icons.pause : Icons.play_arrow,
//                         size: 48,
//                         color: Colors.white,
//                       ),
//                     ),
//                   ],
//                 ),
//               ),
//             ],
//           ),
//         ),
//       ),
//     );
//   }
// }

// import 'package:audioplayers/audioplayers.dart';
// import 'package:flutter/material.dart';
// import 'package:gamification/data/questions.dart';
// import 'package:google_fonts/google_fonts.dart';

// class Questionscreen extends StatefulWidget {
//   const Questionscreen({super.key});

//   @override
//   State<Questionscreen> createState() => _QuestionscreenState();
// }

// class _QuestionscreenState extends State<Questionscreen>
//     with SingleTickerProviderStateMixin {
//   int currentQuestionIndex = 0;
//   bool isPlaying = false;
//   bool isExpanded = true;
//   final AudioPlayer _audioPlayer = AudioPlayer();
//   double opacity = 1.0;
//   late AnimationController _controller;
//   late Animation<double> _scaleanimation;

//   @override
//   void initState() {
//     super.initState();
//     _controller =
//         AnimationController(duration: const Duration(seconds: 1), vsync: this)
//           ..addListener(() {
//             setState(() {});
//           });

//     _scaleanimation = Tween(
//       begin: 0.3,
//       end: 1.2,
//     ).animate(CurvedAnimation(parent: _controller, curve: Curves.easeInOut));
//   }

//   @override
//   void dispose() {
//     _controller.dispose();
//     _audioPlayer.dispose();
//     super.dispose();
//   }

//   void playAudio(String audiopath) async {
//     if (isPlaying) {
//       await _audioPlayer.stop();
//       setState(() {
//         isPlaying = false;
//       });
//     } else {
//       try {
//         await _audioPlayer.setSource(AssetSource(audiopath));
//         await _audioPlayer.resume();
//         _controller.repeat();
//         setState(() {
//           isPlaying = true;
//         });

//         _audioPlayer.onPlayerComplete.listen((event) {
//           _controller.stop();
//           if (mounted) {
//             setState(() {
//               isPlaying = false;
//             });
//           }
//         });
//       } catch (e) {
//         if (mounted) {
//           ScaffoldMessenger.of(context).showSnackBar(
//             SnackBar(content: Text("Error Playing audio : ${e.toString()}")),
//           );
//         }
//       }
//     }
//   }

// void answerQuestion(String selectedAnswer) {
//   print(selectedAnswer);
//   final currentQuestion = questions[currentQuestionIndex];
//   if (currentQuestionIndex < questions.length - 1) {
//     setState(() {
//       currentQuestionIndex--;
//     });
//   }
// }

//   @override
//   Widget build(BuildContext context) {
//     final currentQuestion = questions[currentQuestionIndex];
//     return Scaffold(
//       body: Container(
//         width: MediaQuery.sizeOf(context).width,
//         decoration: const BoxDecoration(
//           gradient: LinearGradient(
//             begin: Alignment.topLeft,
//             end: Alignment.topRight,
//             colors: [Colors.green, Colors.yellow],
//           ),
//         ),
//         child: Center(
//           child: SingleChildScrollView(
//             child: Column(
//               mainAxisAlignment: MainAxisAlignment.center,
//               children: [
//                 Text(
//                   currentQuestion.question,
//                   textAlign: TextAlign.center,
//                   style: GoogleFonts.lato(
//                     color: Colors.white,
//                     fontWeight: FontWeight.bold,
//                     fontSize: 20,
//                   ),
//                 ),
//                 const SizedBox(height: 16),
//                 GestureDetector(
//                   onTap: () {
//                     playAudio('audio/correct.mp3');
//                     setState(() {
//                       isPlaying = !isPlaying;
//                     });
//                   },
//                   child: CircleAvatar(
//                     radius: 50,
//                     backgroundColor: Colors.green,
//                     child: Icon(isPlaying ? Icons.pause : Icons.play_arrow),
//                   ),
//                 ),
                // AnimatedContainer(
                //   duration: const Duration(seconds: 3),
                //   height: isExpanded ? 300 : 100,
                //   width: isExpanded ? 150 : 250,
                //   curve: Curves.linear,
                //   decoration: BoxDecoration(
                //     color: Colors.green.shade900,
                //     borderRadius: BorderRadius.circular(36),
                //   ),
                // ),
//                 // ElevatedButton(
//                 //   onPressed: () {
//                 //     setState(() {
//                 //       isExpanded = !isExpanded;
//                 //     });
//                 //   },
//                 //   child: const Text("data"),
//                 // ),
//                 // AnimatedOpacity(
//                 //   opacity: opacity,
//                 //   duration: const Duration(seconds: 4),
// child: Container(
//   height: 300,
//   width: 150,
//   decoration: BoxDecoration(
//     color: Colors.green.shade900,
//     borderRadius: BorderRadius.circular(36),
//   ),
// ),
//                 // ),
//                 // ElevatedButton(
//                 //   onPressed: () {
//                 //     setState(() {
//                 //       opacity = opacity == 1.0 ? 0.0 : 1.0;
//                 //     });
//                 //   },
//                 //   child: const Text("data"),
//                 // ),
//                 GestureDetector(
//                   onTap: () => playAudio(currentQuestion.audioPath),
//                   child: Stack(
//                     alignment: Alignment.center,
//                     children: [
//                       if (isPlaying)
//                         ScaleTransition(
//                           scale: _scaleanimation,
//                           child: Container(
//                             height: 150,
//                             width: 150,
//                             decoration: BoxDecoration(
//                               shape: BoxShape.circle,
//                               color: Colors.green.withValues(alpha: 0.3),
//                             ),
//                           ),
//                         ),
//                       CircleAvatar(
//                         radius: 58,
//                         backgroundColor: Colors.green,
//                         child: Icon(
//                           isPlaying ? Icons.pause : Icons.play_arrow,
//                           size: 48,
//                           color: Colors.white,
//                         ),
//                       ),
//                     ],
//                   ),
//                 ),
//                 SizedBox(height: 26),
//                 Text(
//                   "Tap to Hear the Second",
//                   style: TextStyle(fontSize: 14, color: Colors.white),
//                 ),
//                 SizedBox(
//                   height: 400,
//                   child: GridView.builder(
//                     gridDelegate:
//                         const SliverGridDelegateWithFixedCrossAxisCount(
//                           crossAxisCount: 2,
//                           crossAxisSpacing: 16,
//                           mainAxisSpacing: 26,
//                         ),
//                     itemCount: currentQuestion.options.length,
//                     itemBuilder: (context, index) {
//                       return GestureDetector(
//                         onTap: () => answerQuestion(
//                           currentQuestion.correctAnswer[index],
//                         ),
//                         child: Container(
// decoration: BoxDecoration(
//   borderRadius: BorderRadius.circular(16.0),
//   gradient: const LinearGradient(
//     begin: Alignment.topLeft,
//     end: Alignment.topRight,
//     colors: [Colors.green, Colors.yellow],
//   ),
// ),
//                           child: Column(
//                             children: [
// CircleAvatar(
//   radius: 50,

//   // backgroundImage: AssetImage(
//   //   currentQuestion.images[index],
//   // ),
//   backgroundImage: AssetImage(
//     currentQuestion.images[index],
//   ),
// ),
// const SizedBox(height: 8),
// Text(
//   currentQuestion.options[index],
//   style: GoogleFonts.monofett(
//     fontWeight: FontWeight.bold,
//     color: Colors.white,
//   ),
// ),
//                             ],
//                           ),
//                         ),
//                       );
//                     },
//                   ),
//                 ),
//               ],
//             ),
//           ),
//         ),
//       ),
//     );
//   }
// }

// import 'package:audioplayers/audioplayers.dart';
// import 'package:flutter/material.dart';
// import 'package:gamification/data/questions.dart';
// import 'package:google_fonts/google_fonts.dart';

// class Questionscreen extends StatefulWidget {
//   const Questionscreen({super.key, required this.onSelectAnswer});

//   final void Function(String answer) onSelectAnswer;
//   @override
//   State<Questionscreen> createState() => _QuestionscreenState();
// }

// class _QuestionscreenState extends State<Questionscreen>
//     with SingleTickerProviderStateMixin {
//   int currentQuestionIndex = 0;
//   bool isPlaying = false;
//   final AudioPlayer _audioPlayer = AudioPlayer();
//   late AnimationController _controller;
//   late Animation<double> _scaleAnimation;

//   @override
//   void initState() {
//     super.initState();
//     _controller =
//         AnimationController(duration: const Duration(seconds: 1), vsync: this)
//           ..addListener(() {
//             setState(() {});
//           });

//     _scaleAnimation = Tween(
//       begin: 0.3,
//       end: 1.2,
//     ).animate(CurvedAnimation(parent: _controller, curve: Curves.easeInOut));
//   }

//   @override
//   void dispose() {
//     _controller.dispose();
//     _audioPlayer.dispose();
//     super.dispose();
//   }

// void playAudio(String audioPath) async {
//   if (isPlaying) {
//     await _audioPlayer.stop();
//     _controller.stop();
//     setState(() {
//       isPlaying = false;
//     });
//   } else {
//     try {
//       await _audioPlayer.play(AssetSource(audioPath));
//       _controller.repeat();
//       setState(() {
//         isPlaying = true;
//       });

//       _audioPlayer.onPlayerComplete.listen((event) {
//         _controller.stop();
//         if (mounted) {
//           setState(() {
//             isPlaying = false;
//           });
//         }
//       });
//     } catch (e) {
//       if (mounted) {
//         ScaffoldMessenger.of(context).showSnackBar(
//           SnackBar(content: Text("Error playing audio: ${e.toString()}")),
//         );
//       }
//     }
//   }
// }

  // void answerQuestion(String selectedAnswer) {
  //   print(selectedAnswer);
  //   widget.onSelectAnswer(selectedAnswer);
  //   final currentQuestion = questions[currentQuestionIndex];
  //   if (selectedAnswer == currentQuestion.correctAnswer) {
  //     ScaffoldMessenger.of(
  //       context,
  //     ).showSnackBar(const SnackBar(content: Text('Correct! 🎉')));
  //   } else {
  //     ScaffoldMessenger.of(
  //       context,
  //     ).showSnackBar(const SnackBar(content: Text('Wrong! ❌')));
  //   }

  //   if (currentQuestionIndex < questions.length - 1) {
  //     setState(() {
  //       currentQuestionIndex++;
  //     });
  //   } else {
  //     ScaffoldMessenger.of(
  //       context,
  //     ).showSnackBar(const SnackBar(content: Text('Quiz Finished!')));
  //   }
  // }

//   @override
//   Widget build(BuildContext context) {
//     final currentQuestion = questions[currentQuestionIndex];

//     return Scaffold(
//       body: Container(
//         width: MediaQuery.sizeOf(context).width,
//         decoration: const BoxDecoration(
//           gradient: LinearGradient(
//             begin: Alignment.topLeft,
//             end: Alignment.topRight,
//             colors: [Colors.green, Colors.yellow],
//           ),
//         ),
//         child: Center(
//           child: SingleChildScrollView(
//             child: Column(
//               mainAxisAlignment: MainAxisAlignment.center,
//               children: [
//                 Text(
//                   currentQuestion.question,
//                   textAlign: TextAlign.center,
//                   style: GoogleFonts.lato(
//                     color: Colors.white,
//                     fontWeight: FontWeight.bold,
//                     fontSize: 20,
//                   ),
//                 ),
//                 const SizedBox(height: 20),

//                 // 🔊 Sound button
//                 GestureDetector(
//                   onTap: () => playAudio(currentQuestion.audioPath),
//                   child: Stack(
//                     alignment: Alignment.center,
//                     children: [
//                       if (isPlaying)
//                         ScaleTransition(
//                           scale: _scaleAnimation,
//                           child: Container(
//                             height: 150,
//                             width: 150,
//                             decoration: BoxDecoration(
//                               shape: BoxShape.circle,
//                               color: Colors.green.withOpacity(0.3),
//                             ),
//                           ),
//                         ),
//                       CircleAvatar(
//                         radius: 58,
//                         backgroundColor: Colors.green,
//                         child: Icon(
//                           isPlaying ? Icons.pause : Icons.play_arrow,
//                           size: 48,
//                           color: Colors.white,
//                         ),
//                       ),
//                     ],
//                   ),
//                 ),

//                 const SizedBox(height: 16),
//                 const Text(
//                   "Tap to hear the sound",
//                   style: TextStyle(fontSize: 14, color: Colors.white),
//                 ),

//                 const SizedBox(height: 24),

//                 // 🐬 Options Grid
//                 SizedBox(
//                   height: 400,
//                   child: GridView.builder(
//                     physics: const NeverScrollableScrollPhysics(),
//                     gridDelegate:
//                         const SliverGridDelegateWithFixedCrossAxisCount(
//                           crossAxisCount: 2,
//                           crossAxisSpacing: 16,
//                           mainAxisSpacing: 26,
//                         ),
//                     itemCount: currentQuestion.options.length,
//                     itemBuilder: (context, index) {
//                       return GestureDetector(
//                         onTap: () =>
//                             answerQuestion(currentQuestion.options[index]),
//                         child: Container(
//                           decoration: BoxDecoration(
//                             borderRadius: BorderRadius.circular(16.0),
//                             gradient: const LinearGradient(
//                               begin: Alignment.topLeft,
//                               end: Alignment.topRight,
//                               colors: [Colors.green, Colors.yellow],
//                             ),
//                           ),
//                           child: Column(
//                             mainAxisAlignment: MainAxisAlignment.center,
//                             children: [
//                               CircleAvatar(
//                                 radius: 50,
//                                 backgroundImage: AssetImage(
//                                   currentQuestion.images[index],
//                                 ),
//                               ),
//                               const SizedBox(height: 8),
//                               Text(
//                                 currentQuestion.options[index],

//                                 //             style: GoogleFonts.monofett(
//                                 //   fontWeight: FontWeight.bold,
//                                 //   color: Colors.white,
//                                 //   fontSize: 18,
//                                 //   letterSpacing: 1.2,
//                                 // ),
//                               ),
//                             ],
//                           ),
//                         ),
//                       );
//                     },
//                   ),
//                 ),
//               ],
//             ),
//           ),
//         ),
//       ),
//     );
//   }
// }

import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/material.dart';
import 'package:gamification/data/questions.dart';
import 'package:google_fonts/google_fonts.dart';

class Questionscreen extends StatefulWidget {
  const Questionscreen({super.key, required void Function(String answer) onSelectAnswer});

  @override
  State<Questionscreen> createState() => _QuestionscreenState();
}

class _QuestionscreenState extends State<Questionscreen>
    with SingleTickerProviderStateMixin {
  int currentQuestionIndex = 0;
  bool isPlaying = false;
  bool isExpanded = false;
  double opacity = 1.0;

  late AnimationController _controller;
  late Animation<double> _scaleAnimation;
  final AudioPlayer _audioPlayer = AudioPlayer();
  @override
  void initState() {
    _controller = AnimationController(
      duration: Duration(seconds: 1),
      vsync: this,
    );
    _scaleAnimation = Tween(
      begin: 0.3,
      end: 1.2,
    ).animate(CurvedAnimation(parent: _controller, curve: Curves.easeInOut));

    super.initState();
  }

  void playAudio(String audioPath) async {
    if (isPlaying) {
      await _audioPlayer.stop();
      _controller.stop();
      setState(() {
        isPlaying = false;
      });
    } else {
      try {
        await _audioPlayer.play(AssetSource(audioPath));
        _controller.repeat();
        setState(() {
          isPlaying = true;
        });

        _audioPlayer.onPlayerComplete.listen((event) {
          _controller.stop();
          if (mounted) {
            setState(() {
              isPlaying = false;
            });
          }
        });
      } catch (e) {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text("Error playing audio: ${e.toString()}")),
          );
        }
      }
    }
  }

  void answerQuestion(String selectedAnswer) {
    print(selectedAnswer);
    final currentQuestion = questions[currentQuestionIndex];
    if (currentQuestionIndex < questions.length - 1) {
      setState(() {
        // currentQuestionIndex--;
        currentQuestionIndex++;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final currentQuestion = questions[currentQuestionIndex];
    return Scaffold(
      body: Container(
        width: MediaQuery.of(context).size.width,
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [Colors.green, Colors.yellowAccent],
          ),
        ),
        child: Center(
          child: SingleChildScrollView(
            child: Column(
              children: [
                Text(
                  currentQuestion.question,
                  textAlign: TextAlign.center,
                  style: GoogleFonts.lato(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                    fontSize: 20,
                  ),
                ),

                GestureDetector(
                  onTap: () => playAudio(currentQuestion.audioPath),
                  child: Stack(
                    alignment: Alignment.center,
                    children: [
                      if (isPlaying)
                        ScaleTransition(
                          scale: _scaleAnimation,
                          child: Container(
                            width: 150,
                            height: 150,
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              color: Colors.green.withOpacity(0.3),
                            ),
                          ),
                        ),
                      CircleAvatar(
                        radius: 50,
                        backgroundColor: Colors.green,
                        child: Icon(
                          isPlaying ? Icons.pause : Icons.play_arrow,
                          size: 48,
                          color: Colors.white,
                        ),
                      ),
                    ],
                  ),
                ),

                SizedBox(height: 24),
                SizedBox(
                  height: 400,
                  child: GridView.builder(
                    physics: const NeverScrollableScrollPhysics(),
                    gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 2,
                      crossAxisSpacing: 16,
                      mainAxisSpacing: 26,
                    ),
                    itemCount: currentQuestion.options.length,
                    itemBuilder: (context, index) {
                      return GestureDetector(
                        onTap: () =>
                            answerQuestion(currentQuestion.options[index]),
                        child: Container(
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(16.0),
                            gradient: const LinearGradient(
                              begin: Alignment.topLeft,
                              end: Alignment.topRight,
                              colors: [Colors.green, Colors.yellow],
                            ),
                          ),

                          child: Column(
                            
                            children: [
                              CircleAvatar(
                                radius: 50,

                                // backgroundImage: AssetImage(
                                //   currentQuestion.images[index],
                                // ),
                                backgroundImage: AssetImage(
                                  currentQuestion.images[index],
                                ),
                              ),
                              const SizedBox(height: 8),
                              Text(
                                currentQuestion.options[index],
                                style: GoogleFonts.monofett(
                                  fontWeight: FontWeight.bold,
                                  color: Colors.white,
                                ),
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
