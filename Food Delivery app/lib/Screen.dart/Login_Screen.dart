
// import 'package:final_exam_project/Screen.dart/HomeScreen.dart';
// import 'package:final_exam_project/Screen.dart/SignUp_Screen.dart';
// import 'package:final_exam_project/Screen.dart/SplashScreen.dart';
// import 'package:flutter/material.dart';
// import 'package:supabase_flutter/supabase_flutter.dart';

// /// ===============================
// /// LOGIN PAGE
// /// ===============================
// class LoginPage extends StatefulWidget {
//   const LoginPage({super.key});

//   @override
//   State<LoginPage> createState() => _LoginPageState();
// }

// class _LoginPageState extends State<LoginPage> {
//   final _emailController = TextEditingController();
//   final _passwordController = TextEditingController();

//   bool _isLoading = false;

//   Future<void> _login() async {
//     final email = _emailController.text.trim();
//     final password = _passwordController.text.trim();

//     if (email.isEmpty || password.isEmpty) {
//       _showMsg("Please fill all fields", isError: true);
//       return;
//     }

//     setState(() => _isLoading = true);

//     try {
//       await Supabase.instance.client.auth.signInWithPassword(
//         email: email,
//         password: password,
//       );

//       if (mounted) {
//         _showMsg("Login Successful");

//         Navigator.pushReplacement(
//           context,
//           MaterialPageRoute(builder: (_) => const HomePage()),
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
//                       "Welcome Back",
//                       style: TextStyle(
//                         fontSize: 28,
//                         fontWeight: FontWeight.bold,
//                       ),
//                     ),

//                     const SizedBox(height: 8),

//                     Text(
//                       "Login to your account",
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
//                         onPressed: _isLoading ? null : _login,
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
//                                 "LOGIN",
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
//                         Navigator.push(
//                           context,
//                           MaterialPageRoute(
//                             builder: (_) => const SignupPage(),
//                           ),
//                         );
//                       },
//                       child: const Text.rich(
//                         TextSpan(
//                           text: "Don't have an account? ",
//                           style: TextStyle(color: Colors.black54),
//                           children: [
//                             TextSpan(
//                               text: "Sign Up",
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
// //


// // Future<void> login() async {
// //   final email = emailController.text.trim();
// //   final password = passwordController.text.trim();

// //   try {

// //     /// LOGIN
// //     final response =
// //         await Supabase.instance.client.auth.signInWithPassword(
// //       email: email,
// //       password: password,
// //     );

// //     final user = response.user;

// //     /// GET SAME USER DATA
// //     if (user != null) {

// //       final data = await Supabase.instance.client
// //           .from('users')
// //           .select()
// //           .eq('id', user.id)
// //           .single();

// //       print("Login Success");

// //       /// SAME ID RETURNS
// //       print("User ID: ${data['custom_id']}");
// //     }

// //   } catch (e) {
// //     print(e.toString());
// //   }
// // }


import 'package:final_exam_project/Screen.dart/HomeScreen.dart';
import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'Signup_Screen.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  bool _isLoading = false;

  Future<void> _login() async {
    final email = _emailController.text.trim();
    final password = _passwordController.text.trim();

    if (email.isEmpty || password.isEmpty) {
      _showMsg("Please fill all fields", isError: true);
      return;
    }

    setState(() => _isLoading = true);

    try {
      await Supabase.instance.client.auth.signInWithPassword(
        email: email,
        password: password,
      );

      if (!mounted) return;

      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (_) => const HomePage()),
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
                      "Welcome Back",
                      style: TextStyle(
                        fontSize: 28,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      "Login to your account",
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
                        onPressed: _isLoading ? null : _login,
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
                                "LOGIN",
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
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) => const SignupPage(),
                          ),
                        );
                      },
                      child: const Text.rich(
                        TextSpan(
                          text: "Don't have an account? ",
                          style: TextStyle(color: Colors.black54),
                          children: [
                            TextSpan(
                              text: "Sign Up",
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