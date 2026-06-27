// import 'package:flutter/material.dart';

// class HomeScreen extends StatelessWidget {
//   const HomeScreen({super.key});

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       backgroundColor: const Color.fromARGB(255, 126, 136, 210),
//       body: const Center(
//         child: Text(
//           'Welcome to Chess Arena!',
//           style: TextStyle(color: Colors.white, fontSize: 22),
//         ),
//       ),
//     );
//   }
// }


// import 'dart:ui';
// import 'package:flutter/material.dart';



// class HomeScreen extends StatelessWidget {
//   const HomeScreen({super.key});

//   static const Color prussianBlue = Color(0xFF121F3B);
//   static const Color darkNavy = Color(0xFF141B2E);
//   static const Color inkBlue = Color(0xFF0A0F1E);
//   static const Color midnightBlue = Color(0xFF030E21);
//   static const Color deepBlackBlue = Color(0xFF020814);
//   static const Color richBlack = Color(0xFF020816);
//   static const Color ultraDarkNavy = Color(0xFF010613);
//   static const Color accentNavy = Color(0xFF050814);
//   static const Color pureBlack = Color(0xFF010208);
//   static const Color powderBlue = Color(0xFFA3B1CA);

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       body: Stack(
//         children: [
//           Container(
//             decoration: const BoxDecoration(
//               gradient: LinearGradient(
//                 begin: Alignment.topCenter,
//                 end: Alignment.bottomCenter,
//                 colors: [
//                   prussianBlue,
//                   darkNavy,
//                   inkBlue,
//                   midnightBlue,
//                   pureBlack,
//                 ],
//               ),
//             ),
//           ),

//           Positioned(
//             top: -120,
//             right: -80,
//             child: Container(
//               width: 280,
//               height: 280,
//               decoration: BoxDecoration(
//                 shape: BoxShape.circle,
//                 color: powderBlue.withOpacity(0.08),
//               ),
//             ),
//           ),

//           Positioned(
//             bottom: -100,
//             left: -80,
//             child: Container(
//               width: 250,
//               height: 250,
//               decoration: BoxDecoration(
//                 shape: BoxShape.circle,
//                 color: powderBlue.withOpacity(0.05),
//               ),
//             ),
//           ),

//           Positioned(
//             top: 140,
//             left: 0,
//             right: 0,
//             child: Center(
//               child: Text(
//                 "♔",
//                 style: TextStyle(
//                   fontSize: 250,
//                   color: Colors.white.withOpacity(.04),
//                   fontWeight: FontWeight.bold,
//                 ),
//               ),
//             ),
//           ),

//           SafeArea(
//             child: Padding(
//               padding: const EdgeInsets.symmetric(horizontal: 24),
//               child: Column(
//                 children: [
//                   const SizedBox(height: 15),

//                   Row(
//                     children: [
//                       Container(
//                         padding: const EdgeInsets.all(3),
//                         decoration: BoxDecoration(
//                           shape: BoxShape.circle,
//                           border: Border.all(
//                             color: powderBlue,
//                             width: 2,
//                           ),
//                         ),
//                         child: const CircleAvatar(
//                           radius: 32,
//                           backgroundImage:
//                               NetworkImage("https://i.pravatar.cc/300"),
//                         ),
//                       ),

//                       const SizedBox(width: 15),

//                       Expanded(
//                         child: Column(
//                           crossAxisAlignment:
//                               CrossAxisAlignment.start,
//                           children: const [
//                             Text(
//                               "DOST MUHAMMAD",
//                               style: TextStyle(
//                                 color: Colors.white,
//                                 fontSize: 18,
//                                 fontWeight: FontWeight.w700,
//                               ),
//                             ),
//                             SizedBox(height: 4),
//                             Text(
//                               "Rating • 1450",
//                               style: TextStyle(
//                                 color: powderBlue,
//                                 fontSize: 14,
//                               ),
//                             ),
//                           ],
//                         ),
//                       ),

//                       Container(
//                         width: 14,
//                         height: 14,
//                         decoration: const BoxDecoration(
//                           color: Colors.greenAccent,
//                           shape: BoxShape.circle,
//                         ),
//                       )
//                     ],
//                   ),

//                   const SizedBox(height: 45),

//                   GameButton(
//                     title: "Player vs Player",
//                     subtitle: "Challenge local opponent",
//                     icon: Icons.people_alt_rounded,
//                     onTap: () {},
//                   ),

//                   const SizedBox(height: 18),

//                   GameButton(
//                     title: "Player vs Computer",
//                     subtitle: "Play against AI",
//                     icon: Icons.smart_toy_rounded,
//                     onTap: () {},
//                   ),

//                   const SizedBox(height: 18),

//                   GameButton(
//                     title: "Play With Friends",
//                     subtitle: "Invite your friends",
//                     icon: Icons.group_rounded,
//                     onTap: () {},
//                   ),

//                   const SizedBox(height: 18),

//                   Container(
//                     decoration: BoxDecoration(
//                       borderRadius: BorderRadius.circular(24),
//                       boxShadow: [
//                         BoxShadow(
//                           color: powderBlue.withOpacity(.25),
//                           blurRadius: 20,
//                           spreadRadius: 2,
//                         ),
//                       ],
//                     ),
//                     child: GameButton(
//                       title: "Play Online",
//                       subtitle: "Compete worldwide",
//                       icon: Icons.public_rounded,
//                       onTap: () {},
//                     ),
//                   ),

//                   const Spacer(),

//                   Row(
//                     children: const [
//                       Expanded(
//                         child: StatsCard(
//                           value: "324",
//                           title: "Games",
//                         ),
//                       ),
//                       SizedBox(width: 12),
//                       Expanded(
//                         child: StatsCard(
//                           value: "218",
//                           title: "Wins",
//                         ),
//                       ),
//                       SizedBox(width: 12),
//                       Expanded(
//                         child: StatsCard(
//                           value: "#52",
//                           title: "Rank",
//                         ),
//                       ),
//                     ],
//                   ),

//                   const SizedBox(height: 25),
//                 ],
//               ),
//             ),
//           ),
//         ],
//       ),
//     );
//   }
// }

// class GameButton extends StatelessWidget {
//   final String title;
//   final String subtitle;
//   final IconData icon;
//   final VoidCallback onTap;

//   const GameButton({
//     super.key,
//     required this.title,
//     required this.subtitle,
//     required this.icon,
//     required this.onTap,
//   });

//   @override
//   Widget build(BuildContext context) {
//     return ClipRRect(
//       borderRadius: BorderRadius.circular(24),
//       child: BackdropFilter(
//         filter: ImageFilter.blur(
//           sigmaX: 15,
//           sigmaY: 15,
//         ),
//         child: InkWell(
//           borderRadius: BorderRadius.circular(24),
//           onTap: onTap,
//           child: Container(
//             height: 90,
//             padding: const EdgeInsets.symmetric(horizontal: 20),
//             decoration: BoxDecoration(
//               borderRadius: BorderRadius.circular(24),
//               border: Border.all(
//                 color: Colors.white.withOpacity(.12),
//               ),
//               color: Colors.white.withOpacity(.06),
//             ),
//             child: Row(
//               children: [
//                 Container(
//                   width: 55,
//                   height: 55,
//                   decoration: BoxDecoration(
//                     shape: BoxShape.circle,
//                     color: const Color(0xFFA3B1CA)
//                         .withOpacity(.15),
//                   ),
//                   child: Icon(
//                     icon,
//                     color: const Color(0xFFA3B1CA),
//                     size: 28,
//                   ),
//                 ),
//                 const SizedBox(width: 18),
//                 Expanded(
//                   child: Column(
//                     mainAxisAlignment:
//                         MainAxisAlignment.center,
//                     crossAxisAlignment:
//                         CrossAxisAlignment.start,
//                     children: [
//                       Text(
//                         title,
//                         style: const TextStyle(
//                           color: Colors.white,
//                           fontSize: 17,
//                           fontWeight: FontWeight.w700,
//                         ),
//                       ),
//                       const SizedBox(height: 4),
//                       Text(
//                         subtitle,
//                         style: TextStyle(
//                           color:
//                               Colors.white.withOpacity(.65),
//                           fontSize: 13,
//                         ),
//                       ),
//                     ],
//                   ),
//                 ),
//                 const Icon(
//                   Icons.arrow_forward_ios_rounded,
//                   color: Color(0xFFA3B1CA),
//                   size: 18,
//                 )
//               ],
//             ),
//           ),
//         ),
//       ),
//     );
//   }
// }

// class StatsCard extends StatelessWidget {
//   final String value;
//   final String title;

//   const StatsCard({
//     super.key,
//     required this.value,
//     required this.title,
//   });

//   @override
//   Widget build(BuildContext context) {
//     return ClipRRect(
//       borderRadius: BorderRadius.circular(22),
//       child: BackdropFilter(
//         filter: ImageFilter.blur(
//           sigmaX: 12,
//           sigmaY: 12,
//         ),
//         child: Container(
//           padding: const EdgeInsets.symmetric(
//             vertical: 18,
//           ),
//           decoration: BoxDecoration(
//             borderRadius: BorderRadius.circular(22),
//             border: Border.all(
//               color: Colors.white.withOpacity(.1),
//             ),
//             color: Colors.white.withOpacity(.05),
//           ),
//           child: Column(
//             children: [
//               Text(
//                 value,
//                 style: const TextStyle(
//                   color: Colors.white,
//                   fontSize: 22,
//                   fontWeight: FontWeight.bold,
//                 ),
//               ),
//               const SizedBox(height: 6),
//               Text(
//                 title,
//                 style: const TextStyle(
//                   color: Color(0xFFA3B1CA),
//                   fontSize: 13,
//                 ),
//               ),
//             ],
//           ),
//         ),
//       ),
//     );
//   }
// }


import 'dart:math' as math;
import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import 'LoginScreen.dart';

// ── Color Palette ─────────────────────────────────────────────────────────────
const _bgDeep       = Color(0xFF020814);
const _bgCard       = Color(0xFF0D1528);
const _bgMid        = Color(0xFF121F3B);
const _powder       = Color(0xFFA3B1CA);
const _glowBlue     = Color(0xFF2A4A8A);

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _pulseController;
  late Animation<double> _pulseAnim;

  final _supabase = Supabase.instance.client;

  // Placeholder stats — replace with real Supabase queries
  final int _gamesPlayed = 42;
  final int _wins        = 27;
  final int _ranking     = 314;
  final String _rating   = '1450';

  @override
  void initState() {
    super.initState();
    _pulseController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1600),
    )..repeat(reverse: true);

    _pulseAnim = Tween<double>(begin: 0.85, end: 1.05).animate(
      CurvedAnimation(parent: _pulseController, curve: Curves.easeInOut),
    );
  }

  @override
  void dispose() {
    _pulseController.dispose();
    super.dispose();
  }

  Future<void> _logout() async {
    await _supabase.auth.signOut();
    if (!mounted) return;
    Navigator.pushReplacement(
      context,
      PageRouteBuilder(
        pageBuilder: (_, __, ___) => const LoginScreen(),
        transitionsBuilder: (_, anim, __, child) =>
            FadeTransition(opacity: anim, child: child),
        transitionDuration: const Duration(milliseconds: 500),
      ),
    );
  }

  // ── User info from Supabase ───────────────────────────────────────────────
  String get _userName {
    final meta = _supabase.auth.currentUser?.userMetadata;
    if (meta != null && meta['full_name'] != null) {
      return meta['full_name'] as String;
    }
    return _supabase.auth.currentUser?.email?.split('@').first ?? 'Player';
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: _bgDeep,
      body: Stack(
        children: [
          // ── Multi-layer gradient background ────────────────────────────
          Container(
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [
                  Color(0xFF030E21),
                  Color(0xFF0A0F1E),
                  Color(0xFF020814),
                  Color(0xFF010208),
                ],
                stops: [0.0, 0.35, 0.7, 1.0],
              ),
            ),
          ),

          // ── Faint chess king silhouette ────────────────────────────────
          Positioned(
            right: -30,
            top: 60,
            child: Opacity(
              opacity: 0.04,
              child: Text(
                '♔',
                style: TextStyle(
                  fontSize: 280,
                  color: Colors.white,
                  fontFamily: 'serif',
                ),
              ),
            ),
          ),

          // ── Smoke glow bottom-left ──────────────────────────────────────
          Positioned(
            bottom: -60,
            left: -60,
            child: Container(
              width: 260,
              height: 260,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                gradient: RadialGradient(
                  colors: [
                    _glowBlue.withOpacity(0.18),
                    Colors.transparent,
                  ],
                ),
              ),
            ),
          ),

          // ── Smoke glow bottom-right ─────────────────────────────────────
          Positioned(
            bottom: -40,
            right: -40,
            child: Container(
              width: 200,
              height: 200,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                gradient: RadialGradient(
                  colors: [
                    _powder.withOpacity(0.06),
                    Colors.transparent,
                  ],
                ),
              ),
            ),
          ),

          // ── Floating particles ──────────────────────────────────────────
          const _FloatingParticles(),

          // ── Main content ────────────────────────────────────────────────
          SafeArea(
            child: SingleChildScrollView(
              physics: const BouncingScrollPhysics(),
              padding: const EdgeInsets.symmetric(horizontal: 22),
              child: Column(
                children: [
                  const SizedBox(height: 18),

                  // ── Top bar: logout ──────────────────────────────────
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      // App tag
                      Text(
                        'CHESS ARENA',
                        style: TextStyle(
                          color: _powder.withOpacity(0.5),
                          fontSize: 11,
                          letterSpacing: 3,
                          fontWeight: FontWeight.w600,
                        ),
                      ),

                    ],
                  ),

                  const SizedBox(height: 30),

                  // ── Profile Section ─────────────────────────────────
                  _ProfileSection(
                    name: _userName,
                    rating: _rating,
                  ),

                  const SizedBox(height: 40),

                  // ── Section label ────────────────────────────────────
                  Align(
                    alignment: Alignment.centerLeft,
                    child: Text(
                      'SELECT MODE',
                      style: TextStyle(
                        color: _powder.withOpacity(0.45),
                        fontSize: 11,
                        letterSpacing: 3,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),

                  const SizedBox(height: 14),

                  // ── Game Mode Buttons ────────────────────────────────
                  _GameModeButton(
                    icon: '♟',
                    title: 'Player vs Player',
                    subtitle: 'Challenge a friend locally',
                    glowColor: const Color(0xFF1E3A6E),
                    onTap: () {},
                  ),
                  const SizedBox(height: 14),
                  _GameModeButton(
                    icon: '🤖',
                    title: 'Player vs Computer',
                    subtitle: 'Test your skills against AI',
                    glowColor: const Color(0xFF0E2040),
                    onTap: () {},
                  ),
                  const SizedBox(height: 14),
                  _GameModeButton(
                    icon: '👥',
                    title: 'Play With Friends',
                    subtitle: 'Invite & challenge anyone',
                    glowColor: const Color(0xFF152B52),
                    onTap: () {},
                  ),
                  const SizedBox(height: 14),

                  // ── Play Online — most prominent ─────────────────────
                  _PlayOnlineButton(
                    pulseAnim: _pulseAnim,
                    onTap: () {},
                  ),

                  const SizedBox(height: 36),

              
                  const SizedBox(height: 32),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// ── Profile Section ───────────────────────────────────────────────────────────
class _ProfileSection extends StatelessWidget {
  final String name;
  final String rating;

  const _ProfileSection({required this.name, required this.rating});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        // Avatar with glowing border
        Stack(
          alignment: Alignment.center,
          children: [
            // Outer glow ring
            Container(
              width: 96,
              height: 96,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                gradient: SweepGradient(
                  colors: [
                    _glowBlue,
                    _powder.withOpacity(0.6),
                    _glowBlue,
                  ],
                ),
              ),
            ),
            // Glass avatar circle
            Container(
              width: 88,
              height: 88,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: _bgCard,
                border: Border.all(color: _bgDeep, width: 2),
              ),
              child: const Center(
                child: Text('♔', style: TextStyle(fontSize: 42, color: Colors.white)),
              ),
            ),
            // Online indicator
            Positioned(
              bottom: 4,
              right: 4,
              child: Container(
                width: 14,
                height: 14,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: const Color(0xFF2ECC71),
                  border: Border.all(color: _bgDeep, width: 2),
                ),
              ),
            ),
          ],
        ),

        const SizedBox(height: 14),

        // Player name
        Text(
          name,
          style: const TextStyle(
            fontSize: 22,
            fontWeight: FontWeight.w800,
            color: Colors.white,
            letterSpacing: 0.5,
          ),
        ),

        const SizedBox(height: 6),

        // Rating badge
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 5),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(20),
            color: Colors.white.withOpacity(0.07),
            border: Border.all(color: Colors.white.withOpacity(0.12)),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Text('⭐', style: TextStyle(fontSize: 13)),
              const SizedBox(width: 5),
              Text(
                rating,
                style: const TextStyle(
                  color: _powder,
                  fontSize: 13,
                  fontWeight: FontWeight.w600,
                  letterSpacing: 1,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

// ── Game Mode Button ──────────────────────────────────────────────────────────
class _GameModeButton extends StatefulWidget {
  final String icon;
  final String title;
  final String subtitle;
  final Color glowColor;
  final VoidCallback onTap;

  const _GameModeButton({
    required this.icon,
    required this.title,
    required this.subtitle,
    required this.glowColor,
    required this.onTap,
  });

  @override
  State<_GameModeButton> createState() => _GameModeButtonState();
}

class _GameModeButtonState extends State<_GameModeButton>
    with SingleTickerProviderStateMixin {
  late AnimationController _tapController;
  late Animation<double> _scaleAnim;

  @override
  void initState() {
    super.initState();
    _tapController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 120),
      lowerBound: 0.0,
      upperBound: 0.03,
    );
    _scaleAnim = Tween<double>(begin: 1.0, end: 0.97).animate(
      CurvedAnimation(parent: _tapController, curve: Curves.easeOut),
    );
  }

  @override
  void dispose() {
    _tapController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTapDown: (_) => _tapController.forward(),
      onTapUp: (_) {
        _tapController.reverse();
        widget.onTap();
      },
      onTapCancel: () => _tapController.reverse(),
      child: AnimatedBuilder(
        animation: _scaleAnim,
        builder: (_, child) => Transform.scale(scale: _scaleAnim.value, child: child),
        child: Container(
          width: double.infinity,
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 18),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(22),
            color: _bgCard.withOpacity(0.85),
            border: Border.all(color: Colors.white.withOpacity(0.08)),
            boxShadow: [
              BoxShadow(
                color: widget.glowColor.withOpacity(0.5),
                blurRadius: 20,
                spreadRadius: -4,
                offset: const Offset(0, 6),
              ),
            ],
          ),
          child: Row(
            children: [
              // Icon bubble
              Container(
                width: 52,
                height: 52,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(14),
                  color: Colors.white.withOpacity(0.06),
                  border: Border.all(color: Colors.white.withOpacity(0.1)),
                ),
                child: Center(
                  child: Text(
                    widget.icon,
                    style: const TextStyle(fontSize: 26),
                  ),
                ),
              ),
              const SizedBox(width: 16),
              // Text
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      widget.title,
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 16,
                        fontWeight: FontWeight.w700,
                        letterSpacing: 0.2,
                      ),
                    ),
                    const SizedBox(height: 3),
                    Text(
                      widget.subtitle,
                      style: TextStyle(
                        color: _powder.withOpacity(0.65),
                        fontSize: 12,
                      ),
                    ),
                  ],
                ),
              ),
              Icon(
                Icons.arrow_forward_ios_rounded,
                color: _powder.withOpacity(0.35),
                size: 16,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// ── Play Online Button (most prominent) ───────────────────────────────────────
class _PlayOnlineButton extends StatelessWidget {
  final Animation<double> pulseAnim;
  final VoidCallback onTap;

  const _PlayOnlineButton({required this.pulseAnim, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: AnimatedBuilder(
        animation: pulseAnim,
        builder: (_, child) {
          return Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(22),
              boxShadow: [
                BoxShadow(
                  color: _glowBlue.withOpacity(0.55 * pulseAnim.value),
                  blurRadius: 32 * pulseAnim.value,
                  spreadRadius: 2,
                ),
                BoxShadow(
                  color: _powder.withOpacity(0.10 * pulseAnim.value),
                  blurRadius: 20,
                  spreadRadius: -2,
                ),
              ],
            ),
            child: child,
          );
        },
        child: Container(
          width: double.infinity,
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(22),
            gradient: const LinearGradient(
              colors: [Color(0xFF1A3060), Color(0xFF0D1F45)],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
            border: Border.all(color: _powder.withOpacity(0.25), width: 1.2),
          ),
          child: Row(
            children: [
              Container(
                width: 52,
                height: 52,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(14),
                  color: Colors.white.withOpacity(0.1),
                  border: Border.all(color: _powder.withOpacity(0.2)),
                ),
                child: const Center(
                  child: Text('🌐', style: TextStyle(fontSize: 26)),
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Play Online',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 17,
                        fontWeight: FontWeight.w800,
                        letterSpacing: 0.3,
                      ),
                    ),
                    const SizedBox(height: 3),
                    Text(
                      'Compete with players worldwide',
                      style: TextStyle(
                        color: _powder.withOpacity(0.75),
                        fontSize: 12,
                      ),
                    ),
                  ],
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(12),
                  color: Colors.white.withOpacity(0.12),
                ),
                child: const Text(
                  'LIVE',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 11,
                    fontWeight: FontWeight.w800,
                    letterSpacing: 1.5,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// ── Stat Card ─────────────────────────────────────────────────────────────────
class _StatCard extends StatelessWidget {
  final String label;
  final String value;
  final IconData icon;

  const _StatCard({
    required this.label,
    required this.value,
    required this.icon,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 12),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(18),
        color: _bgCard.withOpacity(0.75),
        border: Border.all(color: Colors.white.withOpacity(0.07)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.3),
            blurRadius: 12,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        children: [
          Icon(icon, color: _powder.withOpacity(0.6), size: 20),
          const SizedBox(height: 8),
          Text(
            value,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 20,
              fontWeight: FontWeight.w800,
            ),
          ),
          const SizedBox(height: 3),
          Text(
            label,
            style: TextStyle(
              color: _powder.withOpacity(0.5),
              fontSize: 11,
              letterSpacing: 0.5,
            ),
          ),
        ],
      ),
    );
  }
}

// ── Floating Particles ────────────────────────────────────────────────────────
class _FloatingParticles extends StatefulWidget {
  const _FloatingParticles();

  @override
  State<_FloatingParticles> createState() => _FloatingParticlesState();
}

class _FloatingParticlesState extends State<_FloatingParticles>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  final _rng = math.Random(42);
  late List<_Particle> _particles;

  @override
  void initState() {
    super.initState();
    _particles = List.generate(
      18,
      (i) => _Particle(
        x: _rng.nextDouble(),
        y: _rng.nextDouble(),
        size: _rng.nextDouble() * 2.5 + 1,
        speed: _rng.nextDouble() * 0.3 + 0.1,
        opacity: _rng.nextDouble() * 0.25 + 0.05,
      ),
    );
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 12),
    )..repeat();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _controller,
      builder: (context, _) {
        return CustomPaint(
          painter: _ParticlePainter(_particles, _controller.value),
          child: const SizedBox.expand(),
        );
      },
    );
  }
}

class _Particle {
  final double x, y, size, speed, opacity;
  _Particle({
    required this.x,
    required this.y,
    required this.size,
    required this.speed,
    required this.opacity,
  });
}

class _ParticlePainter extends CustomPainter {
  final List<_Particle> particles;
  final double t;

  _ParticlePainter(this.particles, this.t);

  @override
  void paint(Canvas canvas, Size size) {
    for (final p in particles) {
      final dy = (t * p.speed) % 1.0;
      final y = (p.y - dy + 1.0) % 1.0;
      final paint = Paint()
        ..color = const Color(0xFFA3B1CA).withOpacity(p.opacity)
        ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 1.5);
      canvas.drawCircle(
        Offset(p.x * size.width, y * size.height),
        p.size,
        paint,
      );
    }
  }

  @override
  bool shouldRepaint(_ParticlePainter old) => old.t != t;
}