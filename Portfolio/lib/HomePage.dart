// import 'package:flutter/material.dart';

// class HomeScreen extends StatefulWidget {
//   const HomeScreen({super.key});

//   @override
//   State<HomeScreen> createState() => _HomeScreenState();
// }

// class _HomeScreenState extends State<HomeScreen> {
//   @override
//   Widget build(BuildContext context) {
//     return Container(
//       width: MediaQuery.of(context).size.width,
//       decoration: BoxDecoration(
//         borderRadius: BorderRadius.circular(20),
//         boxShadow: const [
//           BoxShadow(color: Colors.black12, blurRadius: 10.0, spreadRadius: 5.0),
//         ],
//       ),
//       child: SingleChildScrollView(
//         child: Column(
//           mainAxisSize: MainAxisSize.min,
//           children: [
//             //  Container(
//             //   height: 200,
//             //   decoration: BoxDecoration(
//             //     borderRadius: BorderRadius.vertical(bottom: Radius.circular(60)),
//             //     // color: const Color.fromARGB(181, 233, 1763, 42)
//             //     gradient: LinearGradient(
//             //       begin:Alignment.topCenter,
//             //       end:Alignment.bottomCenter,
//             //       colors: [
//             //       Colors.red,Colors.blue,
//             //     ])
//             //   ),
//             //  )
//             Stack(
//               alignment: Alignment.center,
//               clipBehavior: Clip.none,
//               children: [
//                 Container(
//                   height: 200,
//                   decoration: const BoxDecoration(
//                     borderRadius: BorderRadius.vertical(
//                       bottom: Radius.circular(65),
//                     ),
//                     gradient: LinearGradient(
//                       begin: Alignment.topCenter,
//                       end: Alignment.bottomCenter,
//                       colors: [Colors.red, Color(0xFFC1222C)],
//                     ),
//                   ),
//                 ),
//                 Positioned(
//                   top: 150,
//                   // bottom: 150,
//                   // left: 150,
//                   // right: 150,
//                   child: const CircleAvatar(
//                     radius: 56,
//                     // backgroundColor: Color.fromARGB(255, 240, 231, 231),
//                     child: CircleAvatar(
//                       radius: 50,
//                       backgroundColor: Colors.black,
//                       // backgroundImage: NetworkImage(''), // Uncomment and provide a valid URL if needed
//                       backgroundImage: AssetImage("assets/images/project1.png"),
//                     ),
//                   ),
//                 ),

//                 // CircleAvatar(
//                 //   radius: 50,
//                 //   backgroundColor: Colors.black,
//                 //   // backgroundImage: ,
//                 // )
//                 // Stack(
//                 //   // alignment: Alignment.center,
//                 //   clipBehavior: Clip.none,
//                 //   children: [
//                 //     Container(height: 100, width: 200, color: Colors.red),
//                 //     Positioned(
//                 //       left: 10,
//                 //       right: 10,
//                 //       child: Container(height: 100, width: 200, color: Colors.black)),
//                 //     Positioned(
//                 //       left: 20,
//                 //       right: 20,
//                 //       child: Container(height: 100, width: 200, color: Colors.blue)),
//                 //   ],
//                 // ),
//               ],
//             ),

//             SizedBox(height: 60),
//             Text(
//               "Dost Muhammad",
//               style: TextStyle(
//                 fontSize: 20,
//                 fontWeight: FontWeight.bold,
//                 color: Colors.black,
//                 decoration: TextDecoration.none,
//               ),
//             ),
//             SizedBox(height: 5),

//             Text(
//               "Flutter Developer",
//               style: TextStyle(
//                 fontSize: 10,
//                 fontWeight: FontWeight.bold,
//                 color: const Color.fromARGB(255, 138, 133, 133),
//                 decoration: TextDecoration.none,
//               ),
//             ),
//             SizedBox(height: 5),

//             Row(
//               mainAxisAlignment: MainAxisAlignment.spaceEvenly,
//               children: [
//                 Column(
//                   children: [
//                     Text(
//                       "Projects",
//                       style: TextStyle(
//                         fontSize: 14,
//                         color: Colors.black54,
//                         decoration: TextDecoration.none,
//                       ),
//                     ),
//                     Text(
//                       "17",
//                       style: TextStyle(
//                         fontSize: 14,
//                         color: Colors.black87,
//                         decoration: TextDecoration.none,
//                       ),
//                     ),
//                   ],
//                 ),
//                 // SizedBox(width: 10,),
//                 Column(
//                   children: [
//                     Text(
//                       "Following",
//                       style: TextStyle(
//                         fontSize: 14,
//                         color: Colors.black54,
//                         decoration: TextDecoration.none,
//                       ),
//                     ),
//                     Text(
//                       "159",
//                       style: TextStyle(
//                         fontSize: 14,
//                         color: Colors.black87,
//                         decoration: TextDecoration.none,
//                       ),
//                     ),
//                   ],
//                 ),
//                 // SizedBox(width: 10,),
//                 Column(
//                   children: [
//                     Text(
//                       "Followers",
//                       style: TextStyle(
//                         fontSize: 14,
//                         color: Colors.black54,
//                         decoration: TextDecoration.none,
//                       ),
//                     ),
//                     Text(
//                       "datea",
//                       style: TextStyle(
//                         fontSize: 14,
//                         color: Colors.black87,
//                         decoration: TextDecoration.none,
//                       ),
//                     ),
//                   ],
//                 ),
//               ],
//             ),

//             SizedBox(height: 16),

//             Divider(
//               color: Color(0xFFC1222C),
//               thickness: 3,
//               indent: 30,
//               endIndent: 30,
//             ),
//             SizedBox(height: 16),

//             Padding(
//               padding: EdgeInsets.symmetric(horizontal: 8.0),
//               child: Text(
//                 "I Am Professional MMA Fighter Have",
//                 textAlign: TextAlign.center,
//                 style: TextStyle(
//                   fontSize: 16,
//                   color: Colors.black54,
//                   decoration: TextDecoration.none,
//                 ),
//               ),
//             ),
//             SizedBox(height: 16),
//             Row(
//               mainAxisAlignment: MainAxisAlignment.center,
//               children: [
//                 IconButton(
//                   onPressed: () {
//                     print("Instagram");
//                   },
//                   icon: Image.asset("assets/icons/instagram.png"),
//                 ),
//                 IconButton(
//                   onPressed: () {
//                     print("Instagram");
//                   },
//                   icon: Image.asset("assets/icons/twitter.png"),
//                 ),
//                 IconButton(
//                   onPressed: () {
//                     print("Instagram");
//                   },
//                   icon: Image.asset("assets/icons/FaceBook.png"),
//                 ),
//               ],
//             ),

//             Padding(
//               padding: EdgeInsets.only(left: 16.6),

//               child: Row(
//                 children: [
//                   Text(
//                     "Skills",
//                     style: TextStyle(
//                       fontSize: 18,
//                       color: Colors.black87,
//                       decoration: TextDecoration.none,
//                     ),
//                   ),
//                 ],
//               ),
//             ),

//             SingleChildScrollView(
//               scrollDirection: Axis.horizontal,
//               child: Row(
//                 children: [
//                   // AppSkillContainer(imagePath: "assets/images/skills_img1.png",),
//                   AppSkillContainer(
//                     imagePath: "assets/images/skills_img1.png",
//                     texts: "Ali",
//                   ),
//                   AppSkillContainer(
//                     imagePath: "assets/images/skills_img1.png",
//                     texts: "",
//                   ),
//                   AppSkillContainer(
//                     imagePath: "assets/images/skills_img1.png",
//                     texts: "Ali",
//                   ),
//                 ],
//               ),
//             ),

//             Padding(
//               padding: EdgeInsets.only(left: 16.6),

//               child: Row(
//                 children: [
//                   Text(
//                     "Projects",
//                     style: TextStyle(
//                       fontSize: 18,
//                       color: Colors.black87,
//                       decoration: TextDecoration.none,
//                     ),
//                   ),
//                 ],
//               ),
//             ),

//             SingleChildScrollView(
//               scrollDirection: Axis.horizontal,
//               child: Row(
//                 children: [
//                   Container(
//                     height: MediaQuery.sizeOf(context).width / 1.7,
//                     width: MediaQuery.sizeOf(context).width / 1.7,
//                     padding: EdgeInsets.all(10.0),
//                     margin: EdgeInsets.all(10.0),
//                     decoration: BoxDecoration(
//                       borderRadius: BorderRadius.circular(10),
//                     ),
//                     child: Column(
//                       children: [
//                         Expanded(
//                           child: ClipRRect(
//                             borderRadius: BorderRadius.circular(10),
//                             child: Image.asset("assets/images/project1.png"),
//                           ),
//                         ),
//                         Row(
//                           children: [
//                             Expanded(child: TitleWidget( imagePath:"assets/images/project2.png" ,texts: "Project")),
//                             Expanded(child: TitleWidget( imagePath:"assets/images/project1.png" ,texts: "Project")),
//                             Container(
//                               height: 30,
//                               width: 30,
//                               decoration: BoxDecoration(
//                                 color: Colors.pinkAccent,
//                                 borderRadius: BorderRadius.circular(30),
//                               ),
//                               child: Icon(
//                                 Icons.arrow_forward,
//                                 color: Colors.white,
//                               ),
//                             ),
//                           ],
//                         ),
//                       ],
//                     ),
//                   ),
//                 ],
//               ),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }

// class AppSkillContainer extends StatelessWidget {
//   const AppSkillContainer({
//     super.key,
//     required this.imagePath,
//     required this.texts,
//   });
//   final String imagePath;
//   final String texts;
//   @override
//   Widget build(BuildContext context) {
//     return Container(
//       padding: EdgeInsets.only(left: 16.6),
//       margin: EdgeInsets.all(10.0),
//       height: 120,
//       width: MediaQuery.sizeOf(context).width / 2,
//       decoration: BoxDecoration(
//         color: Colors.pink.withOpacity(0.2),
//         borderRadius: BorderRadius.circular(16.0),
//       ),
//       // child: Image.asset(imagePath),
//       child: Row(
//         children: [
//           Image.asset(imagePath),
//           Text(
//             texts,
//             style: TextStyle(
//               fontSize: 16,
//               color: Colors.black54,
//               decoration: TextDecoration.none,
//             ),
//           ),
//         ],
//       ),
//     );
//   }
// }

// class TitleWidget extends StatelessWidget {
//   const TitleWidget({super.key, required this.texts, required this.imagePath});
//   final String texts;
//   final String imagePath;

//   @override
//   Widget build(BuildContext context) {
//     return Container(
//       child: Column(
//         children: [
//           // Add your image here
//           Image.asset(imagePath), // or NetworkImage if using URL
//           Text(
//             texts,
//             style: TextStyle(
//               fontSize: 15,
//               fontWeight: FontWeight.w600,
//               color: Colors.blue,
//             ),
//           ),
//         ],
//       ),
//     );
//   }
// }

import 'package:flutter/material.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // Added Scaffold for proper app structure
      body: Container(
        width: MediaQuery.of(context).size.width,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(20),

          boxShadow: const [
            BoxShadow(
              color: Colors.black12,
              blurRadius: 10.0,
              spreadRadius: 5.0,
            ),
          ],
        ),

        child: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Stack(
                alignment: Alignment.center,
                clipBehavior: Clip.none,

                children: [
                  Container(
                    height: 200,
                    decoration: const BoxDecoration(
                      borderRadius: BorderRadius.vertical(
                        bottom: Radius.circular(65),
                        // bottom: Radius.circular(15),
                      ),
                      gradient: LinearGradient(
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                        colors: [Colors.red, Color(0xFFC1222C)],
                      ),
                    ),
                  ),
                  Positioned(
                    top: 150,
                    child: CircleAvatar(
                      radius: 56,
                      backgroundColor: Colors.white,
                      child: CircleAvatar(
                        radius: 50,
                        backgroundColor: Colors.grey[300],
                        backgroundImage: AssetImage(
                          "assets/images/project1.png",
                        ),
                      ),
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 60),
              Text(
                "Dost Muhammad",
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: Colors.black,
                ),
              ),
              const SizedBox(height: 5),

              Text(
                "Flutter Developer",
                style: TextStyle(
                  fontSize: 14, // Increased from 10 for better readability
                  fontWeight: FontWeight.bold,
                  color: const Color.fromARGB(255, 138, 133, 133),
                ),
              ),
              const SizedBox(height: 5),

              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  _buildStatItem("Projects", "17"),
                  _buildStatItem("Following", "159"),
                  _buildStatItem("Followers", "205"), // Fixed the text
                ],
              ),

              const SizedBox(height: 16),
              Divider(
                color: const Color(0xFFC1222C),
                thickness: 3,
                indent: 30,
                endIndent: 30,
              ),
              const SizedBox(height: 16),

              const Padding(
                padding: EdgeInsets.symmetric(horizontal: 8.0),
                child: Text(
                  "I Am Professional Flutter Developer",
                  textAlign: TextAlign.center,
                  style: TextStyle(fontSize: 16, color: Colors.black54),
                ),
              ),
              const SizedBox(height: 16),

              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  IconButton(
                    onPressed: () => print("Instagram"),
                    icon: Image.asset("assets/icons/instagram.png"),
                  ),
                  IconButton(
                    onPressed: () => print("Twitter"),
                    icon: Image.asset("assets/icons/twitter.png"),
                  ),
                  IconButton(
                    onPressed: () => print("Facebook"),
                    icon: Image.asset("assets/icons/FaceBook.png"),
                  ),
                ],
              ),

              const Padding(
                padding: EdgeInsets.only(left: 16.6, top: 16),
                child: Align(
                  alignment: Alignment.centerLeft,
                  child: Text(
                    "Skills",
                    style: TextStyle(
                      fontSize: 18,
                      color: Colors.black87,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),

              SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: Row(
                  children: [
                    AppSkillContainer(
                      imagePath: "assets/images/skills_img1.png",
                      texts: "Flutter",
                    ),
                    AppSkillContainer(
                      imagePath: "assets/images/skills_img1.png",
                      texts: "Dart",
                    ),
                    AppSkillContainer(
                      imagePath: "assets/images/skills_img1.png",
                      texts: "UI/UX",
                    ),
                  ],
                ),
              ),

              const Padding(
                padding: EdgeInsets.only(left: 16.6, top: 16),
                child: Align(
                  alignment: Alignment.centerLeft,
                  child: Text(
                    "Projects",
                    style: TextStyle(
                      fontSize: 18,
                      color: Colors.black87,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),

              SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: Row(
                  children: [
                    _buildProjectItem(
                      "Project 1",
                      "assets/images/project1.png",
                    ),
                    _buildProjectItem(
                      "Project 2",
                      "assets/images/project2.png",
                    ),
                    _buildProjectItem(
                      "Project 3",
                      "assets/images/project3.png",
                    ),
                    _buildProjectItem(
                      "Project 4",
                      "assets/images/project4.png",
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 20), // Added bottom padding
            ],
          ),
        ),
      ),
    );
  }

  // Helper method for stats
  Widget _buildStatItem(String title, String value) {
    return Column(
      children: [
        Text(
          title,
          style: const TextStyle(fontSize: 14, color: Colors.black54),
        ),
        const SizedBox(height: 4),
        Text(
          value,
          style: const TextStyle(
            fontSize: 16,
            color: Colors.black87,
            fontWeight: FontWeight.bold,
          ),
        ),
      ],
    );
  }

  // Helper method for project items
  Widget _buildProjectItem(String title, String imagePath) {
    return Container(
      height: MediaQuery.of(context).size.width / 1.7,
      width: MediaQuery.of(context).size.width / 1.7,
      padding: const EdgeInsets.all(10.0),
      margin: const EdgeInsets.all(10.0),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10),
        color: Colors.white,
        boxShadow: [
          BoxShadow(color: Colors.black12, blurRadius: 5.0, spreadRadius: 2.0),
        ],
      ),

      child: Column(
        children: [
          Expanded(
            child: ClipRRect(
              borderRadius: BorderRadius.circular(10),
              child: Image.asset(
                imagePath,
                fit: BoxFit.cover,
                width: double.infinity,
              ),
            ),
          ),

          const SizedBox(height: 10),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8.0),
            child: Row(
              children: [
                Expanded(
                  child: Text(
                    title,
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: Colors.black87,
                    ),
                  ),
                ),

                Container(
                  height: 30,
                  width: 30,
                  decoration: BoxDecoration(
                    color: Colors.pinkAccent,
                    borderRadius: BorderRadius.circular(30),
                  ),
                  child: const Icon(
                    Icons.arrow_forward,
                    color: Colors.white,
                    size: 16,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class AppSkillContainer extends StatelessWidget {
  const AppSkillContainer({
    super.key,
    required this.imagePath,
    required this.texts,
  });
  final String imagePath;
  final String texts;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      margin: const EdgeInsets.all(10.0),
      height: 120,
      width: MediaQuery.of(context).size.width / 2,
      decoration: BoxDecoration(
        color: Colors.pink.withOpacity(0.2),
        borderRadius: BorderRadius.circular(16.0),
      ),
      child: Row(
        children: [
          Image.asset(imagePath, width: 50, height: 50),
          const SizedBox(width: 10),
          Expanded(
            child: Text(
              texts,
              style: const TextStyle(
                fontSize: 16,
                color: Colors.black87,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// Simplified TitleWidget - You can remove this if not needed elsewhere
class TitleWidget extends StatelessWidget {
  const TitleWidget({super.key, required this.texts, required this.imagePath});
  final String texts;
  final String imagePath;

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Column(
        children: [
          Image.asset(imagePath, width: 40, height: 40),
          const SizedBox(height: 5),
          Text(
            texts,
            style: const TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.w600,
              color: Colors.blue,
            ),
          ),
        ],
      ),
    );
  }
}
