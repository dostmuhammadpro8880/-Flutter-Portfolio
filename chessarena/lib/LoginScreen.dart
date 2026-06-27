// import 'package:chessarena/HomeScreen.dart';
// import 'package:chessarena/signup_Scsreen.dart';
// import 'package:flutter/material.dart';
// import 'package:supabase_flutter/supabase_flutter.dart';


// class LoginScreen extends StatefulWidget {
//   const LoginScreen({super.key});

//   @override
//   State<LoginScreen> createState() => _LoginScreenState();
// }

// class _LoginScreenState extends State<LoginScreen> {
//   final _emailController = TextEditingController();
//   final _passwordController = TextEditingController();
//   bool _obscurePassword = true;
//   bool _isLoading = false;

//   final _supabase = Supabase.instance.client;

//   @override
//   void dispose() {
//     _emailController.dispose();
//     _passwordController.dispose();
//     super.dispose();
//   }

//   // ─── Helpers ──────────────────────────────────────────────────────────────

//   void _showSnack(String message, {bool isError = true}) {
//     if (!mounted) return;
//     ScaffoldMessenger.of(context).showSnackBar(
//       SnackBar(
//         content: Text(message),
//         backgroundColor: isError ? Colors.redAccent : Colors.green,
//         behavior: SnackBarBehavior.floating,
//         shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
//       ),
//     );
//   }

//   bool _validate() {
//     final email = _emailController.text.trim();
//     final password = _passwordController.text;

//     if (email.isEmpty || !email.contains('@')) {
//       _showSnack('Please enter a valid email address.');
//       return false;
//     }
//     if (password.isEmpty || password.length < 6) {
//       _showSnack('Password must be at least 6 characters.');
//       return false;
//     }
//     return true;
//   }

//   // ─── Supabase Auth ────────────────────────────────────────────────────────

// Future<void> _login() async {
//   if (!_validate()) return;
//   setState(() => _isLoading = true);

//   try {
//     final response = await _supabase.auth.signInWithPassword(
//       email: _emailController.text.trim(),
//       password: _passwordController.text,
//     );

//     if (response.user != null && mounted) {
//       Navigator.pushReplacement(
//         context,
//         MaterialPageRoute(builder: (_) => const HomeScreen()),
//       );
//     }
//   } on AuthException catch (e) {
//     _showSnack(e.message);
//   } catch (e) {
//     _showSnack('An unexpected error occurred. Please try again.');
//   } finally {
//     if (mounted) setState(() => _isLoading = false);
//   }
// }
//   // ─── UI ───────────────────────────────────────────────────────────────────

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       body: Stack(
//         children: [
//           // Deep Space Gradient Background
//           Container(
//             decoration: const BoxDecoration(
//               gradient: LinearGradient(
//                 begin: Alignment.topCenter,
//                 end: Alignment.bottomCenter,
//                 colors: [
//                   Color(0xFF0A0E2E),
//                   Color(0xFF1A1F4D),
//                   Color(0xFF0F1329),
//                 ],
//               ),
//             ),
//           ),

//           // Smoke / Nebula Overlay
//           Positioned.fill(
//             child: Opacity(
//               opacity: 0.75,
//               child: Image.asset('assets/cb.jpg', fit: BoxFit.cover),
//             ),
//           ),

//           // Chessboard Floor
//           Positioned(
//             bottom: 0,
//             left: 0,
//             right: 0,
//             child: Opacity(
//               opacity: 0.65,
//               child: Image.asset('assets/cb.jpg', fit: BoxFit.cover, height: 220),
//             ),
//           ),

//           // Dark Tint
//           Positioned.fill(
//             child: Container(color: Colors.black.withOpacity(0.35)),
//           ),

//           SafeArea(
//             child: SingleChildScrollView(
//               child: Padding(
//                 padding: const EdgeInsets.symmetric(horizontal: 25),
//                 child: Column(
//                   children: [
//                     const SizedBox(height: 130),

//                     const Text(
//                       'CHESS ARENA',
//                       style: TextStyle(
//                         fontSize: 34,
//                         fontWeight: FontWeight.w900,
//                         color: Colors.white,
//                         letterSpacing: 6,
//                       ),
//                     ),

//                     const Text(
//                       'MASTER EVERY MOVE',
//                       style: TextStyle(
//                         fontSize: 14,
//                         color: Colors.white70,
//                         letterSpacing: 4,
//                       ),
//                     ),

//                     const SizedBox(height: 55),

//                     // Email
//                     _glassTextField(
//                       controller: _emailController,
//                       hint: 'Email Address',
//                       icon: Icons.email_outlined,
//                       keyboardType: TextInputType.emailAddress,
//                     ),

//                     const SizedBox(height: 18),

//                     // Password
//                     _glassTextField(
//                       controller: _passwordController,
//                       hint: 'Password',
//                       icon: Icons.lock_outline,
//                       isPassword: true,
//                       obscure: _obscurePassword,
//                       onToggleObscure: () =>
//                           setState(() => _obscurePassword = !_obscurePassword),
//                     ),

//                     const SizedBox(height: 10),

//                     Align(
//                       alignment: Alignment.centerRight,
//                       child: TextButton(
//                         onPressed: _isLoading ? null : _forgotPassword,
//                         child: const Text(
//                           'Forgot Password?',
//                           style: TextStyle(color: Colors.white70),
//                         ),
//                       ),
//                     ),

//                     const SizedBox(height: 28),

//                     // Login Button
//                     _primaryButton(
//                       label: 'LOGIN',
//                       isLoading: _isLoading,
//                       onPressed: _login,
//                     ),

//                     const SizedBox(height: 35),

//                     _orDivider(),

//                     const SizedBox(height: 30),

//                     _socialRow(),

//                     const SizedBox(height: 45),

//                     // Sign Up link
//                     Row(
//                       mainAxisAlignment: MainAxisAlignment.center,
//                       children: [
//                         const Text(
//                           "Don't have an account? ",
//                           style: TextStyle(color: Colors.white70),
//                         ),
//                         GestureDetector(
//                           onTap: _isLoading
//                               ? null
//                               : () => Navigator.push(
//                                     context,
//                                     MaterialPageRoute(
//                                       builder: (_) => const SignupScreen(),
//                                     ),
//                                   ),
//                           child: const Text(
//                             'Sign Up',
//                             style: TextStyle(
//                               color: Colors.white,
//                               fontWeight: FontWeight.bold,
//                             ),
//                           ),
//                         ),
//                       ],
//                     ),

//                     const SizedBox(height: 30),
//                   ],
//                 ),
//               ),
//             ),
//           ),
//         ],
//       ),
//     );
//   }

//   // ─── Forgot Password ──────────────────────────────────────────────────────

//   Future<void> _forgotPassword() async {
//     final email = _emailController.text.trim();
//     if (email.isEmpty || !email.contains('@')) {
//       _showSnack('Enter your email above first, then tap Forgot Password.');
//       return;
//     }
//     try {
//       await _supabase.auth.resetPasswordForEmail(email);
//       _showSnack('Password reset email sent! Check your inbox.', isError: false);
//     } on AuthException catch (e) {
//       _showSnack(e.message);
//     } catch (_) {
//       _showSnack('Failed to send reset email. Try again.');
//     }
//   }

//   // ─── Reusable Widgets ─────────────────────────────────────────────────────

//   Widget _glassTextField({
//     required TextEditingController controller,
//     required String hint,
//     required IconData icon,
//     bool isPassword = false,
//     bool obscure = false,
//     VoidCallback? onToggleObscure,
//     TextInputType keyboardType = TextInputType.text,
//   }) {
//     return TextField(
//       controller: controller,
//       obscureText: isPassword ? obscure : false,
//       keyboardType: keyboardType,
//       style: const TextStyle(color: Colors.white),
//       enabled: !_isLoading,
//       decoration: InputDecoration(
//         hintText: hint,
//         hintStyle: TextStyle(color: Colors.white.withOpacity(0.6)),
//         prefixIcon: Icon(icon, color: Colors.white70),
//         suffixIcon: isPassword
//             ? IconButton(
//                 icon: Icon(
//                   obscure ? Icons.visibility_off : Icons.visibility,
//                   color: Colors.white70,
//                 ),
//                 onPressed: onToggleObscure,
//               )
//             : null,
//         filled: true,
//         fillColor: Colors.white.withOpacity(0.09),
//         border: OutlineInputBorder(
//           borderRadius: BorderRadius.circular(16),
//           borderSide: BorderSide.none,
//         ),
//         enabledBorder: OutlineInputBorder(
//           borderRadius: BorderRadius.circular(16),
//           borderSide: BorderSide(color: Colors.white.withOpacity(0.15)),
//         ),
//         focusedBorder: OutlineInputBorder(
//           borderRadius: BorderRadius.circular(16),
//           borderSide: const BorderSide(color: Colors.white, width: 1.2),
//         ),
//         disabledBorder: OutlineInputBorder(
//           borderRadius: BorderRadius.circular(16),
//           borderSide: BorderSide(color: Colors.white.withOpacity(0.08)),
//         ),
//       ),
//     );
//   }

//   Widget _primaryButton({
//     required String label,
//     required bool isLoading,
//     required VoidCallback onPressed,
//   }) {
//     return Container(
//       width: double.infinity,
//       height: 60,
//       decoration: BoxDecoration(
//         borderRadius: BorderRadius.circular(16),
//         boxShadow: [
//           BoxShadow(
//             color: Colors.white.withOpacity(0.3),
//             blurRadius: 25,
//             spreadRadius: 2,
//           ),
//         ],
//       ),
//       child: ElevatedButton(
//         onPressed: isLoading ? null : onPressed,
//         style: ElevatedButton.styleFrom(
//           backgroundColor: Colors.white,
//           foregroundColor: Colors.black87,
//           disabledBackgroundColor: Colors.white60,
//           elevation: 0,
//           shape: RoundedRectangleBorder(
//             borderRadius: BorderRadius.circular(16),
//           ),
//         ),
//         child: isLoading
//             ? const SizedBox(
//                 width: 24,
//                 height: 24,
//                 child: CircularProgressIndicator(
//                   strokeWidth: 2.5,
//                   color: Colors.black54,
//                 ),
//               )
//             : Text(
//                 label,
//                 style: const TextStyle(
//                   fontSize: 18,
//                   fontWeight: FontWeight.bold,
//                   letterSpacing: 1.5,
//                 ),
//               ),
//       ),
//     );
//   }

//   Widget _orDivider() {
//     return const Row(
//       children: [
//         Expanded(child: Divider(color: Colors.white24)),
//         Padding(
//           padding: EdgeInsets.symmetric(horizontal: 16),
//           child: Text('OR', style: TextStyle(color: Colors.white70)),
//         ),
//         Expanded(child: Divider(color: Colors.white24)),
//       ],
//     );
//   }

//   Widget _socialRow() {
//     return Row(
//       mainAxisAlignment: MainAxisAlignment.center,
//       children: [
//         _socialButton(Icons.g_mobiledata, Colors.red),
//         const SizedBox(width: 22),
//         _socialButton(Icons.apple, Colors.white),
//         const SizedBox(width: 22),
//         _socialButton(Icons.facebook, const Color(0xFF1877F2)),
//       ],
//     );
//   }

//   Widget _socialButton(IconData icon, Color color) {
//     return Container(
//       width: 58,
//       height: 58,
//       decoration: BoxDecoration(
//         shape: BoxShape.circle,
//         color: Colors.white.withOpacity(0.1),
//         border: Border.all(color: Colors.white24),
//       ),
//       child: Icon(icon, color: color, size: 32),
//     );
//   }
// }






import 'dart:io' show Platform;
import 'package:chessarena/HomeScreen.dart';
import 'package:chessarena/signup_Scsreen.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:flutter/material.dart';

final supabase = Supabase.instance.client;
final navigatorKey = GlobalKey<NavigatorState>();

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  bool _obscurePassword = true;
  bool _isLoading = false;

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  // Future<void> _continueWithGoogle() async {
  //   setState(() => _isLoading = true);
  //   try {
  //     final GoogleSignIn googleSignIn = GoogleSignIn.instance;
  //     await googleSignIn.initialize(
  //       serverClientId:
  //           '584909765812-e9rf1ianbs2osvbi2aprban0i83ceecf.apps.googleusercontent.com',
  //       clientId: Platform.isAndroid
  //           ? '584909765812-fnaon6lirabpe4k7mr90dcgelhv5eoaa.apps.googleusercontent.com'
  //           : '584909765812-c5begu829jhgme6h2hd951olns04mh3r.apps.googleusercontent.com',
  //     );

  //     final GoogleSignInAccount? account = await googleSignIn.signIn();
  //     if (account == null) return;

  //     final GoogleSignInAuthentication auth = await account.authentication;
  //     final String? idToken = auth.idToken;
  //     final String? accessToken = auth.accessToken;

  //     if (idToken == null || accessToken == null) {
  //       _showError('Failed to get authentication tokens');
  //       return;
  //     }

  //     final AuthResponse result = await supabase.auth.signInWithIdToken(
  //       provider: OAuthProvider.google,
  //       idToken: idToken,
  //       accessToken: accessToken,
  //     );

  //     if (result.user != null && result.session != null) {
  //       if (!mounted) return;
  //       Navigator.pushAndRemoveUntil(
  //         context,
  //         MaterialPageRoute(builder: (context) => const HomeScreen()),
  //         (route) => false,
  //       );
  //     }
  //   } catch (e) {
  //     _showError('Google Sign-In failed: $e');
  //   } finally {
  //     if (mounted) setState(() => _isLoading = false);
  //   }
  // }


// Future<void> _continueWithGoogle() async {
//   setState(() => _isLoading = true);
//   try {
//     await supabase.auth.signInWithOAuth(
//       OAuthProvider.google,
//       redirectTo: 'io.supabase.chessarena://login-callback',
//     );

//     // Listen for auth state change after OAuth redirect
//     supabase.auth.onAuthStateChange.listen((data) {
//       final AuthChangeEvent event = data.event;
//       if (event == AuthChangeEvent.signedIn) {
//         if (!mounted) return;
//         Navigator.pushAndRemoveUntil(
//           context,
//           MaterialPageRoute(builder: (context) => const HomeScreen()),
//           (route) => false,
//         );
//       }
//     });
//   } on AuthException catch (e) {
//     _showError(e.message);
//   } catch (e) {
//     _showError('Google Sign-In failed: $e');
//   } finally {
//     if (mounted) setState(() => _isLoading = false);
//   }
// }

Future<void> _continueWithGoogle() async {
  setState(() => _isLoading = true);
  try {
    await supabase.auth.signInWithOAuth(
      OAuthProvider.google,
      redirectTo: 'io.supabase.chessarena://login-callback',
      authScreenLaunchMode: LaunchMode.externalApplication,
    );

    supabase.auth.onAuthStateChange.listen((data) {
      if (data.event == AuthChangeEvent.signedIn) {
        if (!mounted) return;
        Navigator.pushAndRemoveUntil(
          context,
          MaterialPageRoute(builder: (context) => const HomeScreen()),
          (route) => false,
        );
      }
    });
  } on AuthException catch (e) {
    _showError(e.message);
  } catch (e) {
    _showError('Google Sign-In failed: $e');
  } finally {
    if (mounted) setState(() => _isLoading = false);
  }
}

  Future<void> _login() async {
    final email = _emailController.text.trim();
    final password = _passwordController.text.trim();

    if (email.isEmpty || password.isEmpty) {
      _showError('Please enter email and password');
      return;
    }

    setState(() => _isLoading = true);
    try {
      final AuthResponse result = await supabase.auth.signInWithPassword(
        email: email,
        password: password,
      );

      if (result.user != null && result.session != null) {
        if (!mounted) return;
        Navigator.pushAndRemoveUntil(
          context,
          MaterialPageRoute(builder: (context) => const HomeScreen()),
          (route) => false,
        );
      }
    } on AuthException catch (e) {
      _showError(e.message);
    } catch (e) {
      _showError('Login failed: $e');
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  void _showError(String message) {
    if (!mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: Colors.redAccent,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          // Deep Space Gradient Background
          Container(
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [
                  Color(0xFF0A0E2E),
                  Color(0xFF1A1F4D),
                  Color(0xFF0F1329),
                ],
              ),
            ),
          ),

          // Smoke / Nebula Overlay
          Positioned.fill(
            child: Opacity(
              opacity: 0.75,
              child: Image.asset("assets/cb.jpg", fit: BoxFit.cover),
            ),
          ),

          // Chessboard Floor
          Positioned(
            bottom: 0,
            left: 0,
            right: 0,
            child: Opacity(
              opacity: 0.65,
              child: Image.asset(
                "assets/cb.jpg",
                fit: BoxFit.cover,
                height: 220,
              ),
            ),
          ),

          // Overlay Dark Tint
          Positioned.fill(
            child: Container(color: Colors.black.withOpacity(0.35)),
          ),

          // Loading overlay
          if (_isLoading)
            Positioned.fill(
              child: Container(
                color: Colors.black.withOpacity(0.5),
                child: const Center(
                  child: CircularProgressIndicator(color: Colors.white),
                ),
              ),
            ),

          SafeArea(
            child: SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 25),
                child: Column(
                  children: [
                    const SizedBox(height: 130),
                    const SizedBox(height: 20),

                    // Title
                    const Text(
                      "CHESS ARENA",
                      style: TextStyle(
                        fontSize: 34,
                        fontWeight: FontWeight.w900,
                        color: Colors.white,
                        letterSpacing: 6,
                      ),
                    ),
                    const Text(
                      "MASTER EVERY MOVE",
                      style: TextStyle(
                        fontSize: 14,
                        color: Colors.white70,
                        letterSpacing: 4,
                      ),
                    ),

                    const SizedBox(height: 55),

                    // Email Field
                    _glassTextField(
                      hint: "Email Address",
                      icon: Icons.email_outlined,
                      controller: _emailController,
                    ),

                    const SizedBox(height: 18),

                    // Password Field
                    _glassTextField(
                      hint: "Password",
                      icon: Icons.lock_outline,
                      isPassword: true,
                      controller: _passwordController,
                    ),

                    const SizedBox(height: 10),

                    Align(
                      alignment: Alignment.centerRight,
                      child: TextButton(
                        onPressed: () {},
                        child: const Text(
                          "Forgot Password?",
                          style: TextStyle(color: Colors.white70),
                        ),
                      ),
                    ),

                    const SizedBox(height: 28),

                    // Login Button
                    Container(
                      width: double.infinity,
                      height: 60,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(16),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.white.withOpacity(0.3),
                            blurRadius: 25,
                            spreadRadius: 2,
                          ),
                        ],
                      ),
                      child: ElevatedButton(
                        onPressed: _isLoading ? null : _login,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.white,
                          foregroundColor: Colors.black87,
                          elevation: 0,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(16),
                          ),
                        ),
                        child: const Text(
                          "LOGIN",
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            letterSpacing: 1.5,
                          ),
                        ),
                      ),
                    ),

                    const SizedBox(height: 35),

                    // OR Divider
                    Row(
                      children: const [
                        Expanded(child: Divider(color: Colors.white24)),
                        Padding(
                          padding: EdgeInsets.symmetric(horizontal: 16),
                          child: Text(
                            "OR",
                            style: TextStyle(color: Colors.white70),
                          ),
                        ),
                        Expanded(child: Divider(color: Colors.white24)),
                      ],
                    ),

                    const SizedBox(height: 30),

                    // Social Buttons
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        // Google — wired up
                        GestureDetector(
                          onTap: _isLoading ? null : _continueWithGoogle,
                          child: _socialButton(Icons.g_mobiledata, Colors.red),
                        ),
                        const SizedBox(width: 22),
                        _socialButton(Icons.apple, Colors.white),
                        const SizedBox(width: 22),
                        _socialButton(
                            Icons.facebook, const Color(0xFF1877F2)),
                      ],
                    ),

                    const SizedBox(height: 45),

                    // Sign Up
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Text(
                          "Don't have an account? ",
                          style: TextStyle(color: Colors.white70),
                        ),
                        GestureDetector(
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => SignupScreen(),
                              ),
                            );
                          },
                          child: const Text(
                            "Sign Up",
                            style: TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ],
                    ),

                    const SizedBox(height: 30),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _glassTextField({
    required String hint,
    required IconData icon,
    required TextEditingController controller,
    bool isPassword = false,
  }) {
    return TextField(
      controller: controller,
      obscureText: isPassword ? _obscurePassword : false,
      style: const TextStyle(color: Colors.white),
      decoration: InputDecoration(
        hintText: hint,
        hintStyle: TextStyle(color: Colors.white.withOpacity(0.6)),
        prefixIcon: Icon(icon, color: Colors.white70),
        suffixIcon: isPassword
            ? IconButton(
                icon: Icon(
                  _obscurePassword
                      ? Icons.visibility_off
                      : Icons.visibility,
                  color: Colors.white70,
                ),
                onPressed: () =>
                    setState(() => _obscurePassword = !_obscurePassword),
              )
            : null,
        filled: true,
        fillColor: Colors.white.withOpacity(0.09),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16),
          borderSide: BorderSide.none,
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16),
          borderSide: BorderSide(color: Colors.white.withOpacity(0.15)),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16),
          borderSide: const BorderSide(color: Colors.white, width: 1.2),
        ),
      ),
    );
  }

  Widget _socialButton(IconData icon, Color color) {
    return Container(
      width: 58,
      height: 58,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: Colors.white.withOpacity(0.1),
        border: Border.all(color: Colors.white24, width: 1),
      ),
      child: Icon(icon, color: color, size: 32),
    );
  }
}