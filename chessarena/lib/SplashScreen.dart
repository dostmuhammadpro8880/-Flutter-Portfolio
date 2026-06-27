



import 'package:chessarena/HomeScreen.dart';
import 'package:chessarena/LoginScreen.dart';
import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _animController;
  late Animation<double> _fadeAnim;
  late Animation<double> _scaleAnim;
  late Animation<double> _subtitleFade;

  final _supabase = Supabase.instance.client;

  @override
  void initState() {
    super.initState();
    _setupAnimations();
    _navigate();
  }

  void _setupAnimations() {
    _animController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1800),
    );

    _fadeAnim = Tween<double>(begin: 0, end: 1).animate(
      CurvedAnimation(
        parent: _animController,
        curve: const Interval(0.0, 0.6, curve: Curves.easeOut),
      ),
    );

    _scaleAnim = Tween<double>(begin: 0.75, end: 1.0).animate(
      CurvedAnimation(
        parent: _animController,
        curve: const Interval(0.0, 0.6, curve: Curves.easeOutBack),
      ),
    );

    _subtitleFade = Tween<double>(begin: 0, end: 1).animate(
      CurvedAnimation(
        parent: _animController,
        curve: const Interval(0.45, 1.0, curve: Curves.easeIn),
      ),
    );

    _animController.forward();
  }

  // ── Wait for Supabase to restore session from local storage ──────────────
  Future<Session?> _waitForSession() async {
    // If session already loaded, return immediately
    if (_supabase.auth.currentSession != null) {
      return _supabase.auth.currentSession;
    }

    // Otherwise wait for the first auth state change event (max 3 seconds)
    try {
      final authState = await _supabase.auth.onAuthStateChange.first
          .timeout(const Duration(seconds: 3));
      return authState.session;
    } catch (_) {
      // Timeout or error — treat as logged out
      return null;
    }
  }

  Future<void> _navigate() async {
    // Run animation delay and session check in parallel
    final results = await Future.wait([
      Future.delayed(const Duration(milliseconds: 2800)),
      _waitForSession(),
    ]);

    if (!mounted) return;

    final session = results[1] as Session?;

    if (session != null) {
      // Already logged in → go to Home
      Navigator.pushReplacement(
        context,
        _fadeRoute(const HomeScreen()),
      );
    } else {
      // Not logged in → go to Login
      Navigator.pushReplacement(
        context,
        _fadeRoute(const LoginScreen()),
      );
    }
  }

  PageRoute _fadeRoute(Widget page) {
    return PageRouteBuilder(
      pageBuilder: (_, __, ___) => page,
      transitionsBuilder: (_, animation, __, child) {
        return FadeTransition(opacity: animation, child: child);
      },
      transitionDuration: const Duration(milliseconds: 600),
    );
  }

  @override
  void dispose() {
    _animController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          // ── Deep Space Gradient ──────────────────────────────────────────
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

          // ── Nebula / Background Image ────────────────────────────────────
          Positioned.fill(
            child: Opacity(
              opacity: 0.55,
              child: Image.asset('assets/cb.jpg', fit: BoxFit.cover),
            ),
          ),

          // ── Chessboard Floor ─────────────────────────────────────────────
          Positioned(
            bottom: 0,
            left: 0,
            right: 0,
            child: Opacity(
              opacity: 0.45,
              child: Image.asset(
                'assets/cb.jpg',
                fit: BoxFit.cover,
                height: 220,
              ),
            ),
          ),

          // ── Dark Tint ────────────────────────────────────────────────────
          Positioned.fill(
            child: Container(color: Colors.black.withOpacity(0.45)),
          ),

          // ── Animated Content ─────────────────────────────────────────────
          Center(
            child: AnimatedBuilder(
              animation: _animController,
              builder: (context, _) {
                return Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [

                    const SizedBox(height: 36),

                    // App Title
                    FadeTransition(
                      opacity: _fadeAnim,
                      child: ScaleTransition(
                        scale: _scaleAnim,
                        child: const Text(
                          'CHESS ARENA',
                          style: TextStyle(
                            fontSize: 36,
                            fontWeight: FontWeight.w900,
                            color: Colors.white,
                            letterSpacing: 7,
                          ),
                        ),
                      ),
                    ),

                    const SizedBox(height: 10),

                    // Subtitle
                    FadeTransition(
                      opacity: _subtitleFade,
                      child: const Text(
                        'MASTER EVERY MOVE',
                        style: TextStyle(
                          fontSize: 13,
                          color: Colors.white60,
                          letterSpacing: 5,
                          fontWeight: FontWeight.w400,
                        ),
                      ),
                    ),

                    const SizedBox(height: 80),

                    // Loading dots
                    FadeTransition(
                      opacity: _subtitleFade,
                      child: const _PulsingDots(),
                    ),
                  ],
                );
              },
            ),
          ),

          // ── Version tag bottom ───────────────────────────────────────────
          Positioned(
            bottom: 32,
            left: 0,
            right: 0,
            child: AnimatedBuilder(
              animation: _subtitleFade,
              builder: (_, __) => Opacity(
                opacity: _subtitleFade.value,
                child: const Text(
                  'v1.0.0',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: Colors.white30,
                    fontSize: 12,
                    letterSpacing: 2,
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// ── Pulsing Loading Dots ───────────────────────────────────────────────────────

class _PulsingDots extends StatefulWidget {
  const _PulsingDots();

  @override
  State<_PulsingDots> createState() => _PulsingDotsState();
}

class _PulsingDotsState extends State<_PulsingDots>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 900),
    )..repeat();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: List.generate(3, (i) {
        final delay = i * 0.25;
        return AnimatedBuilder(
          animation: _controller,
          builder: (_, __) {
            final t = ((_controller.value - delay) % 1.0 + 1.0) % 1.0;
            final opacity = (t < 0.5 ? t * 2 : (1 - t) * 2).clamp(0.2, 1.0);
            return Container(
              margin: const EdgeInsets.symmetric(horizontal: 5),
              width: 8,
              height: 8,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: Colors.white.withOpacity(opacity),
              ),
            );
          },
        );
      }),
    );
  }
}