// import 'package:final_exam_project/Screen.dart/Login_Screen.dart';
// import 'package:final_exam_project/Screen.dart/SplashScreen.dart';
// import 'package:flutter/material.dart';
// import 'package:supabase_flutter/supabase_flutter.dart';

// /// ===============================
// /// SIGNUP PAGE
// /// ===============================
// class SignupPage extends StatefulWidget {
//   const SignupPage({super.key});

//   @override
//   State<SignupPage> createState() => _SignupPageState();
// }

// class _SignupPageState extends State<SignupPage> {
//   final _emailController = TextEditingController();
//   final _passwordController = TextEditingController();

//   bool _isLoading = false;

//   Future<void> _signup() async {
//     final email = _emailController.text.trim();
//     final password = _passwordController.text.trim();

//     if (email.isEmpty || password.isEmpty) {
//       _showMsg("Please fill all fields", isError: true);
//       return;
//     }

//     setState(() => _isLoading = true);

//     try {
//       await Supabase.instance.client.auth.signUp(
//         email: email,
//         password: password,
//       );

//       if (mounted) {
//         _showMsg("Registration successful!");

//         Navigator.pushReplacement(
//           context,
//           MaterialPageRoute(builder: (_) => const LoginPage()),
//         );
//       }
//     } on AuthException catch (e) {
//       _showMsg(e.message, isError: true);
//     } catch (e) {
//       _showMsg("Something went wrong", isError: true);
//     }

//     if (mounted) {
//       setState(() => _isLoading = false);
//     }
//   }

//   void _showMsg(String msg, {bool isError = false}) {
//     ScaffoldMessenger.of(context).showSnackBar(
//       SnackBar(
//         content: Text(msg),
//         backgroundColor: isError ? Colors.red : Colors.green,
//       ),
//     );
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       resizeToAvoidBottomInset: false,
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
//               decoration: BoxDecoration(
//                 gradient: LinearGradient(
//                   colors: [
//                     Colors.black.withOpacity(0.3),
//                     Colors.black.withOpacity(0.7),
//                   ],
//                   begin: Alignment.topCenter,
//                   end: Alignment.bottomCenter,
//                 ),
//               ),
//             ),
//           ),

//           Center(
//             child: SingleChildScrollView(
//               padding: const EdgeInsets.symmetric(horizontal: 24),
//               child: Container(
//                 padding: const EdgeInsets.all(28),
//                 decoration: BoxDecoration(
//                   color: Colors.white.withOpacity(0.92),
//                   borderRadius: BorderRadius.circular(30),
//                 ),
//                 child: Column(
//                   mainAxisSize: MainAxisSize.min,
//                   children: [
//                     const Icon(
//                       Icons.shopping_bag_outlined,
//                       size: 55,
//                       color: Colors.blueAccent,
//                     ),

//                     const SizedBox(height: 10),

//                     const Text(
//                       "Join Emcome",
//                       style: TextStyle(
//                         fontSize: 28,
//                         fontWeight: FontWeight.bold,
//                       ),
//                     ),

//                     const SizedBox(height: 8),

//                     Text(
//                       "Create your new account",
//                       style: TextStyle(
//                         color: Colors.grey[600],
//                       ),
//                     ),

//                     const SizedBox(height: 30),

//                     TextField(
//                       controller: _emailController,
//                       decoration: InputDecoration(
//                         labelText: "Email",
//                         prefixIcon: const Icon(Icons.email_outlined),
//                         filled: true,
//                         fillColor: Colors.grey[100],
//                         border: OutlineInputBorder(
//                           borderRadius: BorderRadius.circular(15),
//                         ),
//                       ),
//                     ),

//                     const SizedBox(height: 18),

//                     TextField(
//                       controller: _passwordController,
//                       obscureText: true,
//                       decoration: InputDecoration(
//                         labelText: "Password",
//                         prefixIcon: const Icon(Icons.lock_outline),
//                         filled: true,
//                         fillColor: Colors.grey[100],
//                         border: OutlineInputBorder(
//                           borderRadius: BorderRadius.circular(15),
//                         ),
//                       ),
//                     ),

//                     const SizedBox(height: 30),

//                     SizedBox(
//                       width: double.infinity,
//                       height: 55,
//                       child: ElevatedButton(
//                         onPressed: _isLoading ? null : _signup,
//                         style: ElevatedButton.styleFrom(
//                           backgroundColor: Colors.blueAccent,
//                           shape: RoundedRectangleBorder(
//                             borderRadius: BorderRadius.circular(15),
//                           ),
//                         ),
//                         child: _isLoading
//                             ? const CircularProgressIndicator(
//                                 color: Colors.white,
//                               )
//                             : const Text(
//                                 "SIGN UP",
//                                 style: TextStyle(
//                                   color: Colors.white,
//                                   fontSize: 16,
//                                   fontWeight: FontWeight.bold,
//                                 ),
//                               ),
//                       ),
//                     ),

//                     const SizedBox(height: 15),

//                     TextButton(
//                       onPressed: () {
//                         Navigator.pop(context);
//                       },
//                       child: const Text.rich(
//                         TextSpan(
//                           text: "Already have an account? ",
//                           style: TextStyle(color: Colors.black54),
//                           children: [
//                             TextSpan(
//                               text: "Login",
//                               style: TextStyle(
//                                 color: Colors.blueAccent,
//                                 fontWeight: FontWeight.bold,
//                               ),
//                             ),
//                           ],
//                         ),
//                       ),
//                     ),
//                   ],
//                 ),
//               ),
//             ),
//           ),
//         ],
//       ),
//     );
//   }
// }




// import 'package:final_exam_project/Screen.dart/Login_Screen.dart';
// import 'package:flutter/material.dart';
// import 'package:supabase_flutter/supabase_flutter.dart';
// import 'package:uuid/uuid.dart';

// class SignupPage extends StatefulWidget {
//   const SignupPage({super.key});

//   @override
//   State<SignupPage> createState() => _SignupPageState();
// }

// class _SignupPageState extends State<SignupPage> {
//   final _emailController = TextEditingController();
//   final _passwordController = TextEditingController();

//   bool _isLoading = false;

//   /// SIGNUP FUNCTION
//   // Future<void> _signup() async {
//   //   final email = _emailController.text.trim();
//   //   final password = _passwordController.text.trim();

//   //   if (email.isEmpty || password.isEmpty) {
//   //     _showMsg("Please fill all fields", isError: true);
//   //     return;
//   //   }

//   //   setState(() => _isLoading = true);

//   //   try {
//   //     /// Generate unique custom ID
//   //     final userUniqueId = const Uuid().v4();

//   //     /// Create account in Supabase Auth
//   //     final response = await Supabase.instance.client.auth.signUp(
//   //       email: email,
//   //       password: password,

//   //       /// Save extra auth metadata
//   //       data: {
//   //         'custom_user_id': userUniqueId,
//   //       },
//   //     );

//   //     final user = response.user;

//   //     /// Save user data into users table
//   //     if (user != null) {
//   //       await Supabase.instance.client.from('users').insert({
//   //         'id': user.id,
//   //         'custom_id': userUniqueId,
//   //         'email': email,
//   //         'created_at': DateTime.now().toIso8601String(),
//   //       });
//   //     }

//   //     if (mounted) {
//   //       _showMsg("Registration Successful");

//   //       Navigator.pushReplacement(
//   //         context,
//   //         MaterialPageRoute(
//   //           builder: (_) => const LoginPage(),
//   //         ),
//   //       );
//   //     }
//   //   } on AuthException catch (e) {
//   //     _showMsg(e.message, isError: true);
//   //   } catch (e) {
//   //     _showMsg(e.toString(), isError: true);
//   //   }

//   //   if (mounted) {
//   //     setState(() => _isLoading = false);
//   //   }
//   // }

// Future<void> signup() async {
//   final email = emailController.text.trim();
//   final password = passwordController.text.trim();

//   try {
//     /// CREATE UNIQUE ID ONLY ONCE
//     final customId = const Uuid().v4();

//     /// CREATE AUTH ACCOUNT
//     final response = await Supabase.instance.client.auth.signUp(
//       email: email,
//       password: password,
//     );

//     final user = response.user;

//     /// SAVE USER DATA
//     if (user != null) {
//       await Supabase.instance.client.from('users').insert({
//         'id': user.id,
//         'email': email,
//         'custom_id': customId,
//       });
//     }

//     print("Signup Success");
//     print("Allocated ID: $customId");

//   } catch (e) {
//     print(e.toString());
//   }
// }

//   void _showMsg(String msg, {bool isError = false}) {
//     ScaffoldMessenger.of(context).showSnackBar(
//       SnackBar(
//         content: Text(msg),
//         backgroundColor: isError ? Colors.red : Colors.green,
//       ),
//     );
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       resizeToAvoidBottomInset: false,
//       body: Stack(
//         children: [
//           /// Background Image
//           Positioned.fill(
//             child: Image.network(
//               'https://images.unsplash.com/photo-1607082348824-0a96f2a4b9da?q=80&w=2070',
//               fit: BoxFit.cover,
//             ),
//           ),

//           /// Dark Overlay
//           Positioned.fill(
//             child: Container(
//               decoration: BoxDecoration(
//                 gradient: LinearGradient(
//                   colors: [
//                     Colors.black.withOpacity(0.3),
//                     Colors.black.withOpacity(0.7),
//                   ],
//                   begin: Alignment.topCenter,
//                   end: Alignment.bottomCenter,
//                 ),
//               ),
//             ),
//           ),

//           /// Main Card
//           Center(
//             child: SingleChildScrollView(
//               padding: const EdgeInsets.symmetric(horizontal: 24),
//               child: Container(
//                 padding: const EdgeInsets.all(28),
//                 decoration: BoxDecoration(
//                   color: Colors.white.withOpacity(0.92),
//                   borderRadius: BorderRadius.circular(30),
//                   boxShadow: [
//                     BoxShadow(
//                       color: Colors.black.withOpacity(0.2),
//                       blurRadius: 15,
//                       offset: const Offset(0, 10),
//                     ),
//                   ],
//                 ),
//                 child: Column(
//                   mainAxisSize: MainAxisSize.min,
//                   children: [
//                     const Icon(
//                       Icons.shopping_bag_outlined,
//                       size: 55,
//                       color: Colors.blueAccent,
//                     ),

//                     const SizedBox(height: 10),

//                     const Text(
//                       "Join Emcome",
//                       style: TextStyle(
//                         fontSize: 28,
//                         fontWeight: FontWeight.bold,
//                       ),
//                     ),

//                     const SizedBox(height: 8),

//                     Text(
//                       "Create your new account",
//                       style: TextStyle(
//                         color: Colors.grey[600],
//                       ),
//                     ),

//                     const SizedBox(height: 30),

//                     /// Email Field
//                     TextField(
//                       controller: _emailController,
//                       decoration: InputDecoration(
//                         labelText: "Email",
//                         prefixIcon: const Icon(Icons.email_outlined),
//                         filled: true,
//                         fillColor: Colors.grey[100],
//                         border: OutlineInputBorder(
//                           borderRadius: BorderRadius.circular(15),
//                         ),
//                       ),
//                     ),

//                     const SizedBox(height: 18),

//                     /// Password Field
//                     TextField(
//                       controller: _passwordController,
//                       obscureText: true,
//                       decoration: InputDecoration(
//                         labelText: "Password",
//                         prefixIcon: const Icon(Icons.lock_outline),
//                         filled: true,
//                         fillColor: Colors.grey[100],
//                         border: OutlineInputBorder(
//                           borderRadius: BorderRadius.circular(15),
//                         ),
//                       ),
//                     ),

//                     const SizedBox(height: 30),

//                     /// Signup Button
//                     SizedBox(
//                       width: double.infinity,
//                       height: 55,
//                       child: ElevatedButton(
//                         onPressed: _isLoading ? null : _signup,
//                         style: ElevatedButton.styleFrom(
//                           backgroundColor: Colors.blueAccent,
//                           shape: RoundedRectangleBorder(
//                             borderRadius: BorderRadius.circular(15),
//                           ),
//                         ),
//                         child: _isLoading
//                             ? const CircularProgressIndicator(
//                                 color: Colors.white,
//                               )
//                             : const Text(
//                                 "SIGN UP",
//                                 style: TextStyle(
//                                   color: Colors.white,
//                                   fontSize: 16,
//                                   fontWeight: FontWeight.bold,
//                                 ),
//                               ),
//                       ),
//                     ),

//                     const SizedBox(height: 15),

//                     /// Login Redirect
//                     TextButton(
//                       onPressed: () {
//                         Navigator.pop(context);
//                       },
//                       child: const Text.rich(
//                         TextSpan(
//                           text: "Already have an account? ",
//                           style: TextStyle(color: Colors.black54),
//                           children: [
//                             TextSpan(
//                               text: "Login",
//                               style: TextStyle(
//                                 color: Colors.blueAccent,
//                                 fontWeight: FontWeight.bold,
//                               ),
//                             ),
//                           ],
//                         ),
//                       ),
//                     ),
//                   ],
//                 ),
//               ),
//             ),
//           ),
//         ],
//       ),
//     );
//   }
// }



import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'Login_Screen.dart';

class SignupPage extends StatefulWidget {
  const SignupPage({super.key});

  @override
  State<SignupPage> createState() => _SignupPageState();
}

class _SignupPageState extends State<SignupPage> {
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  bool _isLoading = false;

  Future<void> _signup() async {
    final email = _emailController.text.trim();
    final password = _passwordController.text.trim();

    if (email.isEmpty || password.isEmpty) {
      _showMsg("Please fill all fields", isError: true);
      return;
    }

    setState(() => _isLoading = true);

    try {
      await Supabase.instance.client.auth.signUp(
        email: email,
        password: password,
      );

      if (!mounted) return;

      _showMsg("Registration successful. Now login with same email.");

      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (_) => const LoginPage()),
      );
    } on AuthException catch (e) {
      _showMsg(e.message, isError: true);
    } catch (_) {
      _showMsg("Something went wrong", isError: true);
    }

    if (mounted) {
      setState(() => _isLoading = false);
    }
  }

  void _showMsg(String msg, {bool isError = false}) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(msg),
        backgroundColor: isError ? Colors.red : Colors.green,
      ),
    );
  }

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
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
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [
                    Colors.black.withOpacity(0.3),
                    Colors.black.withOpacity(0.7),
                  ],
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                ),
              ),
            ),
          ),
          Center(
            child: SingleChildScrollView(
              padding: const EdgeInsets.symmetric(horizontal: 24),
              child: Container(
                padding: const EdgeInsets.all(28),
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.92),
                  borderRadius: BorderRadius.circular(30),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.2),
                      blurRadius: 15,
                      offset: const Offset(0, 10),
                    ),
                  ],
                ),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Icon(
                      Icons.shopping_bag_outlined,
                      size: 55,
                      color: Colors.blueAccent,
                    ),
                    const SizedBox(height: 10),
                    const Text(
                      "Sign_Up",
                      style: TextStyle(
                        fontSize: 28,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      "Create your new account",
                      style: TextStyle(color: Colors.grey[600]),
                    ),
                    const SizedBox(height: 30),
                    TextField(
                      controller: _emailController,
                      keyboardType: TextInputType.emailAddress,
                      decoration: InputDecoration(
                        labelText: "Email",
                        prefixIcon: const Icon(Icons.email_outlined),
                        filled: true,
                        fillColor: Colors.grey[100],
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(15),
                        ),
                      ),
                    ),
                    const SizedBox(height: 18),
                    TextField(
                      controller: _passwordController,
                      obscureText: true,
                      decoration: InputDecoration(
                        labelText: "Password",
                        prefixIcon: const Icon(Icons.lock_outline),
                        filled: true,
                        fillColor: Colors.grey[100],
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(15),
                        ),
                      ),
                    ),
                    const SizedBox(height: 30),
                    SizedBox(
                      width: double.infinity,
                      height: 55,
                      child: ElevatedButton(
                        onPressed: _isLoading ? null : _signup,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.blueAccent,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(15),
                          ),
                        ),
                        child: _isLoading
                            ? const CircularProgressIndicator(
                                color: Colors.white,
                              )
                            : const Text(
                                "SIGN UP",
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                      ),
                    ),
                    const SizedBox(height: 15),
                    TextButton(
                      onPressed: () => Navigator.pop(context),
                      child: const Text.rich(
                        TextSpan(
                          text: "Already have an account? ",
                          style: TextStyle(color: Colors.black54),
                          children: [
                            TextSpan(
                              text: "Login",
                              style: TextStyle(
                                color: Colors.blueAccent,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}