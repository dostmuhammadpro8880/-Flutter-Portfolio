// import 'package:flutter/material.dart';

// class SignupScreen extends StatelessWidget {
//   const SignupScreen({super.key});

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
//               child: Image.asset("assets/cb.jpg", fit: BoxFit.cover),
//             ),
//           ),

//           // Chessboard Floor
//           Positioned(
//             bottom: 0,
//             left: 0,
//             right: 0,
//             child: Opacity(
//               opacity: 0.65,
//               child: Image.asset(
//                 "assets/cb.jpg",
//                 fit: BoxFit.cover,
//                 height: 220,
//               ),
//             ),
//           ),

//           // Overlay Dark Tint
//           Positioned.fill(
//             child: Container(color: Colors.black.withOpacity(0.35)),
//           ),

//           SafeArea(
//             child: SingleChildScrollView(
//               child: Padding(
//                 padding: const EdgeInsets.symmetric(horizontal: 25),
//                 child: Column(
//                   children: [
//                     const SizedBox(height: 150),

//                     // const SizedBox(height: 20),

//                     // Title
//                     const Text(
//                       "CHESS ARENA",
//                       style: TextStyle(
//                         fontSize: 34,
//                         fontWeight: FontWeight.w900,
//                         color: Colors.white,
//                         letterSpacing: 6,
//                       ),
//                     ),

//                     const Text(
//                       "CREATE YOUR ACCOUNT",
//                       style: TextStyle(
//                         fontSize: 14,
//                         color: Colors.white70,
//                         letterSpacing: 4,
//                       ),
//                     ),

//                     const SizedBox(height: 50),

//                     // Full Name
//                     _glassTextField(
//                       hint: "Full Name",
//                       icon: Icons.person_outline,
//                     ),

//                     const SizedBox(height: 18),

//                     // Email
//                     _glassTextField(
//                       hint: "Email Address",
//                       icon: Icons.email_outlined,
//                     ),

//                     const SizedBox(height: 18),

//                     // Password
//                     _glassTextField(
//                       hint: "Password",
//                       icon: Icons.lock_outline,
//                       isPassword: true,
//                     ),

//                     const SizedBox(height: 18),

//                     // Confirm Password
//                     _glassTextField(
//                       hint: "Confirm Password",
//                       icon: Icons.lock_outline,
//                       isPassword: true,
//                     ),

//                     const SizedBox(height: 35),

//                     // Sign Up Button
//                     Container(
//                       width: double.infinity,
//                       height: 60,
//                       decoration: BoxDecoration(
//                         borderRadius: BorderRadius.circular(16),
//                         boxShadow: [
//                           BoxShadow(
//                             color: Colors.white.withOpacity(0.3),
//                             blurRadius: 25,
//                             spreadRadius: 2,
//                           ),
//                         ],
//                       ),
//                       child: ElevatedButton(
//                         onPressed: () {},
//                         style: ElevatedButton.styleFrom(
//                           backgroundColor: Colors.white,
//                           foregroundColor: Colors.black87,
//                           elevation: 0,
//                           shape: RoundedRectangleBorder(
//                             borderRadius: BorderRadius.circular(16),
//                           ),
//                         ),
//                         child: const Text(
//                           "CREATE ACCOUNT",
//                           style: TextStyle(
//                             fontSize: 18,
//                             fontWeight: FontWeight.bold,
//                             letterSpacing: 1.5,
//                           ),
//                         ),
//                       ),
//                     ),

//                     const SizedBox(height: 30),

//                     // OR Divider
//                     Row(
//                       children: [
//                         const Expanded(child: Divider(color: Colors.white24)),
//                         const Padding(
//                           padding: EdgeInsets.symmetric(horizontal: 16),
//                           child: Text(
//                             "OR",
//                             style: TextStyle(color: Colors.white70),
//                           ),
//                         ),
//                         const Expanded(child: Divider(color: Colors.white24)),
//                       ],
//                     ),

//                     const SizedBox(height: 25),

//                     // Social Buttons
//                     Row(
//                       mainAxisAlignment: MainAxisAlignment.center,
//                       children: [
//                         _socialButton(Icons.g_mobiledata, Colors.red),
//                         const SizedBox(width: 22),
//                         _socialButton(Icons.apple, Colors.white),
//                         const SizedBox(width: 22),
//                         _socialButton(Icons.facebook, const Color(0xFF1877F2)),
//                       ],
//                     ),

//                     const SizedBox(height: 40),

//                     // Already have account
//                     Row(
//                       mainAxisAlignment: MainAxisAlignment.center,
//                       children: [
//                         const Text(
//                           "Already have an account? ",
//                           style: TextStyle(color: Colors.white70),
//                         ),
//                         GestureDetector(
//                           onTap: () {
//                             Navigator.pop(context); // Go back to Login
//                           },
//                           child: const Text(
//                             "LOGIN",
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

//   Widget _glassTextField({
//     required String hint,
//     required IconData icon,
//     bool isPassword = false,
//   }) {
//     return TextField(
//       obscureText: isPassword,
//       style: const TextStyle(color: Colors.white),
//       decoration: InputDecoration(
//         hintText: hint,
//         hintStyle: TextStyle(color: Colors.white.withOpacity(0.6)),
//         prefixIcon: Icon(icon, color: Colors.white70),
//         suffixIcon: isPassword
//             ? const Icon(Icons.visibility_off, color: Colors.white70)
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
//       ),
//     );
//   }

//   Widget _socialButton(IconData icon, Color color) {
//     return Container(
//       width: 58,
//       height: 58,
//       decoration: BoxDecoration(
//         shape: BoxShape.circle,
//         color: Colors.white.withOpacity(0.1),
//         border: Border.all(color: Colors.white24, width: 1),
//       ),
//       child: Icon(icon, color: color, size: 32),
//     );
//   }
// }


















import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class SignupScreen extends StatefulWidget {
  const SignupScreen({super.key});

  @override
  State<SignupScreen> createState() => _SignupScreenState();
}

class _SignupScreenState extends State<SignupScreen> {
  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();

  bool _obscurePassword = true;
  bool _obscureConfirm = true;
  bool _isLoading = false;

  final _supabase = Supabase.instance.client;

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  // ─── Helpers ──────────────────────────────────────────────────────────────

  void _showSnack(String message, {bool isError = true}) {
    if (!mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: isError ? Colors.redAccent : Colors.green,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      ),
    );
  }

  bool _validate() {
    final name = _nameController.text.trim();
    final email = _emailController.text.trim();
    final password = _passwordController.text;
    final confirm = _confirmPasswordController.text;

    if (name.isEmpty) {
      _showSnack('Please enter your full name.');
      return false;
    }
    if (email.isEmpty || !email.contains('@')) {
      _showSnack('Please enter a valid email address.');
      return false;
    }
    if (password.length < 6) {
      _showSnack('Password must be at least 6 characters.');
      return false;
    }
    if (password != confirm) {
      _showSnack('Passwords do not match.');
      return false;
    }
    return true;
  }

  // ─── Supabase Auth ────────────────────────────────────────────────────────

  Future<void> _signup() async {
    if (!_validate()) return;
    setState(() => _isLoading = true);

    try {
      final response = await _supabase.auth.signUp(
        email: _emailController.text.trim(),
        password: _passwordController.text,
        data: {
          'full_name': _nameController.text.trim(),
        },
      );

      if (response.user != null && mounted) {
        // If email confirmation is OFF in Supabase, the user is instantly active.
        // If email confirmation is ON, instruct the user to check their inbox.
        final needsConfirmation =
            response.session == null && response.user!.confirmedAt == null;

        if (needsConfirmation) {
          _showSnack(
            'Account created! Check your email to confirm your account.',
            isError: false,
          );
          await Future.delayed(const Duration(seconds: 2));
          if (mounted) Navigator.pop(context); // back to login
        } else {
          _showSnack('Account created! You are now logged in.', isError: false);
          // TODO: Navigate to your home screen, e.g.:
          // Navigator.pushReplacement(context, MaterialPageRoute(builder: (_) => const HomeScreen()));
        }
      }
    } on AuthException catch (e) {
      _showSnack(e.message);
    } catch (e) {
      _showSnack('An unexpected error occurred. Please try again.');
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  // ─── UI ───────────────────────────────────────────────────────────────────

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
              child: Image.asset('assets/cb.jpg', fit: BoxFit.cover),
            ),
          ),

          // Chessboard Floor
          Positioned(
            bottom: 0,
            left: 0,
            right: 0,
            child: Opacity(
              opacity: 0.65,
              child: Image.asset('assets/cb.jpg', fit: BoxFit.cover, height: 220),
            ),
          ),

          // Dark Tint
          Positioned.fill(
            child: Container(color: Colors.black.withOpacity(0.35)),
          ),

          SafeArea(
            child: SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 25),
                child: Column(
                  children: [
                    const SizedBox(height: 100),

                    const Text(
                      'CHESS ARENA',
                      style: TextStyle(
                        fontSize: 34,
                        fontWeight: FontWeight.w900,
                        color: Colors.white,
                        letterSpacing: 6,
                      ),
                    ),

                    const Text(
                      'CREATE YOUR ACCOUNT',
                      style: TextStyle(
                        fontSize: 14,
                        color: Colors.white70,
                        letterSpacing: 4,
                      ),
                    ),

                    const SizedBox(height: 45),

                    // Full Name
                    _glassTextField(
                      controller: _nameController,
                      hint: 'Full Name',
                      icon: Icons.person_outline,
                    ),

                    const SizedBox(height: 18),

                    // Email
                    _glassTextField(
                      controller: _emailController,
                      hint: 'Email Address',
                      icon: Icons.email_outlined,
                      keyboardType: TextInputType.emailAddress,
                    ),

                    const SizedBox(height: 18),

                    // Password
                    _glassTextField(
                      controller: _passwordController,
                      hint: 'Password',
                      icon: Icons.lock_outline,
                      isPassword: true,
                      obscure: _obscurePassword,
                      onToggleObscure: () =>
                          setState(() => _obscurePassword = !_obscurePassword),
                    ),

                    const SizedBox(height: 18),

                    // Confirm Password
                    _glassTextField(
                      controller: _confirmPasswordController,
                      hint: 'Confirm Password',
                      icon: Icons.lock_outline,
                      isPassword: true,
                      obscure: _obscureConfirm,
                      onToggleObscure: () =>
                          setState(() => _obscureConfirm = !_obscureConfirm),
                    ),

                    const SizedBox(height: 35),

                    // Sign Up Button
                    _primaryButton(
                      label: 'CREATE ACCOUNT',
                      isLoading: _isLoading,
                      onPressed: _signup,
                    ),

                    const SizedBox(height: 30),

                    _orDivider(),

                    const SizedBox(height: 25),

                    _socialRow(),

                    const SizedBox(height: 40),

                    // Already have account
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Text(
                          'Already have an account? ',
                          style: TextStyle(color: Colors.white70),
                        ),
                        GestureDetector(
                          onTap: _isLoading ? null : () => Navigator.pop(context),
                          child: const Text(
                            'LOGIN',
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

  // ─── Reusable Widgets ─────────────────────────────────────────────────────

  Widget _glassTextField({
    required TextEditingController controller,
    required String hint,
    required IconData icon,
    bool isPassword = false,
    bool obscure = false,
    VoidCallback? onToggleObscure,
    TextInputType keyboardType = TextInputType.text,
  }) {
    return TextField(
      controller: controller,
      obscureText: isPassword ? obscure : false,
      keyboardType: keyboardType,
      style: const TextStyle(color: Colors.white),
      enabled: !_isLoading,
      decoration: InputDecoration(
        hintText: hint,
        hintStyle: TextStyle(color: Colors.white.withOpacity(0.6)),
        prefixIcon: Icon(icon, color: Colors.white70),
        suffixIcon: isPassword
            ? IconButton(
                icon: Icon(
                  obscure ? Icons.visibility_off : Icons.visibility,
                  color: Colors.white70,
                ),
                onPressed: onToggleObscure,
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
        disabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16),
          borderSide: BorderSide(color: Colors.white.withOpacity(0.08)),
        ),
      ),
    );
  }

  Widget _primaryButton({
    required String label,
    required bool isLoading,
    required VoidCallback onPressed,
  }) {
    return Container(
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
        onPressed: isLoading ? null : onPressed,
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.white,
          foregroundColor: Colors.black87,
          disabledBackgroundColor: Colors.white60,
          elevation: 0,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
        ),
        child: isLoading
            ? const SizedBox(
                width: 24,
                height: 24,
                child: CircularProgressIndicator(
                  strokeWidth: 2.5,
                  color: Colors.black54,
                ),
              )
            : Text(
                label,
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  letterSpacing: 1.5,
                ),
              ),
      ),
    );
  }

  Widget _orDivider() {
    return const Row(
      children: [
        Expanded(child: Divider(color: Colors.white24)),
        Padding(
          padding: EdgeInsets.symmetric(horizontal: 16),
          child: Text('OR', style: TextStyle(color: Colors.white70)),
        ),
        Expanded(child: Divider(color: Colors.white24)),
      ],
    );
  }

  Widget _socialRow() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        _socialButton(Icons.g_mobiledata, Colors.red),
        const SizedBox(width: 22),
        _socialButton(Icons.apple, Colors.white),
        const SizedBox(width: 22),
        _socialButton(Icons.facebook, const Color(0xFF1877F2)),
      ],
    );
  }

  Widget _socialButton(IconData icon, Color color) {
    return Container(
      width: 58,
      height: 58,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: Colors.white.withOpacity(0.1),
        border: Border.all(color: Colors.white24),
      ),
      child: Icon(icon, color: color, size: 32),
    );
  }
}