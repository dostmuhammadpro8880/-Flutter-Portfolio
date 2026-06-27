// import 'dart:ui';

// import 'package:chessp/WalletScreen.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter/services.dart';
// import 'package:image_picker/image_picker.dart';
// import 'package:supabase_flutter/supabase_flutter.dart';

// class ChessappProfile extends StatefulWidget {
//   const ChessappProfile({super.key});

//   @override
//   State<ChessappProfile> createState() => _ChessappProfileState();
// }

// class _ChessappProfileState extends State<ChessappProfile> {
//   final supabase = Supabase.instance.client;
//   final ImagePicker _picker = ImagePicker();

//   String? _profileImageUrl;

//   bool _isUploading = false;
//   bool _isLoading = true;

//   int wallet = 0;
//   int wins = 0;
//   int rank = 0;

//   @override
//   void initState() {
//     super.initState();
//     _loadProfileImage();
//     _loadStats();
//   }

//   Future<void> _loadStats() async {
//     final user = supabase.auth.currentUser;

//     if (user == null) return;

//     try {
//       final data = await supabase
//           .from('player_stats')
//           .select()
//           .eq('id', user.id)
//           .maybeSingle();

//       if (data == null) {
//         await supabase.from('player_stats').insert({
//           'id': user.id,
//           'wallet': 0,
//           'wins': 0,
//           'rank': 0,
//         });

//         setState(() {
//           wallet = 0;
//           wins = 0;
//           rank = 0;
//         });
//       } else {
//         setState(() {
//           wallet = data['wallet'] ?? 0;
//           wins = data['wins'] ?? 0;
//           rank = data['rank'] ?? 0;
//         });
//       }
//     } catch (e) {
//       debugPrint('Stats Error: $e');
//     }
//   }

//   Future<void> updateWallet(int newWallet) async {
//     final user = supabase.auth.currentUser;

//     if (user == null) return;

//     await supabase.from('player_stats').update({
//       'wallet': newWallet,
//     }).eq('id', user.id);

//     setState(() {
//       wallet = newWallet;
//     });
//   }

//   Future<void> updateWins(int newWins) async {
//     final user = supabase.auth.currentUser;

//     if (user == null) return;

//     await supabase.from('player_stats').update({
//       'wins': newWins,
//     }).eq('id', user.id);

//     setState(() {
//       wins = newWins;
//     });
//   }

//   Future<void> updateRank(int newRank) async {
//     final user = supabase.auth.currentUser;

//     if (user == null) return;

//     await supabase.from('player_stats').update({
//       'rank': newRank,
//     }).eq('id', user.id);

//     setState(() {
//       rank = newRank;
//     });
//   }

//   Future<void> _loadProfileImage() async {
//     final user = supabase.auth.currentUser;

//     if (user == null) {
//       setState(() => _isLoading = false);
//       return;
//     }

//     try {
//       final files = await supabase.storage
//           .from('profile-images')
//           .list(path: user.id);

//       if (files.isNotEmpty) {
//         final imageUrl = supabase.storage
//             .from('profile-images')
//             .getPublicUrl('${user.id}/avatar.jpg');

//         if (mounted) {
//           setState(() {
//             _profileImageUrl = imageUrl;
//             _isLoading = false;
//           });
//         }
//       } else {
//         setState(() => _isLoading = false);
//       }
//     } catch (e) {
//       debugPrint('Error loading image: $e');

//       if (mounted) {
//         setState(() => _isLoading = false);
//       }
//     }
//   }

//   Future<void> _pickAndUploadImage() async {
//     final user = supabase.auth.currentUser;

//     if (user == null) return;

//     try {
//       final XFile? pickedImage = await _picker.pickImage(
//         source: ImageSource.gallery,
//         maxWidth: 500,
//         maxHeight: 500,
//         imageQuality: 80,
//       );

//       if (pickedImage == null) return;

//       setState(() => _isUploading = true);

//       final imageBytes = await pickedImage.readAsBytes();

//       await supabase.storage.from('profile-images').uploadBinary(
//             '${user.id}/avatar.jpg',
//             imageBytes,
//             fileOptions: const FileOptions(
//               upsert: true,
//               contentType: 'image/jpeg',
//             ),
//           );

//       final imageUrl = supabase.storage
//           .from('profile-images')
//           .getPublicUrl('${user.id}/avatar.jpg');

//       final imageUrlWithTimestamp =
//           '$imageUrl?t=${DateTime.now().millisecondsSinceEpoch}';

//       if (mounted) {
//         setState(() {
//           _profileImageUrl = imageUrlWithTimestamp;
//           _isUploading = false;
//         });

//         ScaffoldMessenger.of(context).showSnackBar(
//           const SnackBar(
//             content: Text('Profile photo updated successfully!'),
//             backgroundColor: Colors.green,
//           ),
//         );
//       }
//     } catch (e) {
//       debugPrint('Upload error: $e');

//       if (mounted) {
//         setState(() => _isUploading = false);

//         ScaffoldMessenger.of(context).showSnackBar(
//           SnackBar(
//             content: Text('Failed to upload: ${e.toString()}'),
//             backgroundColor: Colors.red,
//           ),
//         );
//       }
//     }
//   }

//   void _copyUserId() {
//     final user = supabase.auth.currentUser;

//     if (user == null) return;

//     Clipboard.setData(ClipboardData(text: user.id));

//     ScaffoldMessenger.of(context).showSnackBar(
//       SnackBar(
//         content: Row(
//           children: [
//             const Icon(Icons.check_circle,
//                 color: Colors.white, size: 18),
//             const SizedBox(width: 8),
//             const Text('User ID copied to clipboard!'),
//           ],
//         ),
//         backgroundColor: Colors.green.shade700,
//         duration: const Duration(seconds: 2),
//         behavior: SnackBarBehavior.floating,
//         shape: RoundedRectangleBorder(
//           borderRadius: BorderRadius.circular(10),
//         ),
//       ),
//     );
//   }

//   @override
//   Widget build(BuildContext context) {
//     final user = supabase.auth.currentUser;

//     if (user == null) {
//       return Scaffold(
//         appBar: AppBar(
//           title: const Text("Profile"),
//           centerTitle: true,
//         ),
//         body: const Center(
//           child: Text("Please login first"),
//         ),
//       );
//     }

//     final userName =
//         user.userMetadata?['username'] ?? 'Chess Player';

//     final email = user.email ?? 'No Email';

//     final userId = user.id;

//     return Scaffold(
//       appBar: AppBar(
//         title: const Text("Profile"),
//         centerTitle: true,
//       ),
//       body: _isLoading
//           ? const Center(
//               child: CircularProgressIndicator(),
//             )
//           : SingleChildScrollView(
//               padding: const EdgeInsets.all(20),
//               child: Column(
//                 children: [
//                   _buildProfileImage(),

//                   const SizedBox(height: 10),

//                   Text(
//                     'Tap photo to change',
//                     style: TextStyle(
//                       color: Colors.grey.shade600,
//                     ),
//                   ),

//                   const SizedBox(height: 20),

//                   Text(
//                     userName,
//                     style: const TextStyle(
//                       fontSize: 28,
//                       fontWeight: FontWeight.bold,
//                     ),
//                   ),

//                   const SizedBox(height: 10),

//                   Text(
//                     email,
//                     style: TextStyle(
//                       color: Colors.grey.shade600,
//                     ),
//                   ),

//                   const SizedBox(height: 25),

//                   _buildUserIdCard(userId),

//                   const SizedBox(height: 25),

//                   _buildStatsSection(),

//                   const SizedBox(height: 30),

//                   _buildSettingsButton(),

//                   const SizedBox(height: 15),

//                   _buildLogoutButton(),
//                 ],
//               ),
//             ),
//     );
//   }

//   Widget _buildProfileImage() {
//     return Stack(
//       alignment: Alignment.center,
//       children: [
//         GestureDetector(
//           onTap: _isUploading ? null : _pickAndUploadImage,
//           child: Container(
//             width: 110,
//             height: 110,
//             decoration: BoxDecoration(
//               shape: BoxShape.circle,
//               border: Border.all(
//                 color: Theme.of(context)
//                     .primaryColor
//                     .withOpacity(0.3),
//                 width: 3,
//               ),
//             ),
//             child: CircleAvatar(
//               radius: 55,
//               backgroundColor: Colors.grey.shade200,
//               backgroundImage: _profileImageUrl != null
//                   ? NetworkImage(_profileImageUrl!)
//                   : null,
//               child: _buildProfilePlaceholder(),
//             ),
//           ),
//         ),
//       ],
//     );
//   }

//   Widget? _buildProfilePlaceholder() {
//     if (_isUploading) {
//       return const CircularProgressIndicator();
//     }

//     if (_profileImageUrl == null) {
//       return Icon(
//         Icons.person,
//         size: 50,
//         color: Colors.grey.shade400,
//       );
//     }

//     return null;
//   }

//   Widget _buildUserIdCard(String userId) {
//     return Card(
//       child: Padding(
//         padding: const EdgeInsets.all(20),
//         child: Column(
//           children: [
//             const Text(
//               "User ID",
//               style: TextStyle(
//                 fontWeight: FontWeight.bold,
//                 fontSize: 18,
//               ),
//             ),
//             const SizedBox(height: 15),
//             SelectableText(userId),
//             const SizedBox(height: 10),
//             ElevatedButton.icon(
//               onPressed: _copyUserId,
//               icon: const Icon(Icons.copy),
//               label: const Text("Copy"),
//             ),
//           ],
//         ),
//       ),
//     );
//   }

//   Widget _buildStatsSection() {
//     return Row(
//       children: [
//         // _buildStatCard(
//         //   title: "Wallet",
//         //   value: "₹$wallet",
//         //   icon: Icons.account_balance_wallet,
//         //   color: Colors.green,
//         // ),
//         _buildStatCard(
//   title: "Wallet",
//   value: "₹$wallet",
//   icon: Icons.account_balance_wallet,
//   color: Colors.green,
//   onTap: () {
//     Navigator.push(
//       context,
//       MaterialPageRoute(
//         builder: (context) => const WalletScreen(),
//       ),
//     );
//   },
// ),
//         _buildStatCard(
//           title: "Wins",
//           value: "$wins",
//           icon: Icons.emoji_events,
//           color: Colors.amber,
//         ),
//         _buildStatCard(
//           title: "Rank",
//           value: "$rank",
//           icon: Icons.leaderboard,
//           color: Colors.blue,
//         ),
//       ],
//     );
//   }

// Widget _buildStatCard({
//   required String title,
//   required String value,
//   required IconData icon,
//   required Color color,
//   VoidCallback? onTap,
// }) {
//   return GestureDetector(
//     onTap: onTap,
//     child: ClipRRect(
//       borderRadius: BorderRadius.circular(20),
//       child: BackdropFilter(
//         filter: ImageFilter.blur(sigmaX: 15, sigmaY: 15),
//         child: Container(
//           padding: const EdgeInsets.all(16),
//           decoration: BoxDecoration(
//             borderRadius: BorderRadius.circular(20),
//             color: Colors.white.withOpacity(0.08),
//             border: Border.all(
//               color: Colors.white.withOpacity(0.15),
//             ),
//           ),
//           child: Column(
//             mainAxisSize: MainAxisSize.min,
//             crossAxisAlignment: CrossAxisAlignment.start,
//             children: [
//               // Icon bubble
//               Container(
//                 padding: const EdgeInsets.all(10),
//                 decoration: BoxDecoration(
//                   color: color.withOpacity(0.2),
//                   borderRadius: BorderRadius.circular(12),
//                 ),
//                 child: Icon(
//                   icon,
//                   color: color,
//                   size: 26,
//                 ),
//               ),

//               const SizedBox(height: 12),

//               // Value
//               Text(
//                 value,
//                 style: const TextStyle(
//                   fontSize: 20,
//                   fontWeight: FontWeight.bold,
//                   color: Colors.white,
//                 ),
//               ),

//               const SizedBox(height: 4),

//               // Title
//               Text(
//                 title,
//                 style: TextStyle(
//                   fontSize: 14,
//                   color: Colors.white.withOpacity(0.7),
//                 ),
//               ),
//             ],
//           ),
//         ),
//       ),
//     ),
//   );
// }
//   Widget _buildSettingsButton() {
//     return SizedBox(
//       width: double.infinity,
//       height: 55,
//       child: ElevatedButton.icon(
//         onPressed: () {
//           Navigator.pushNamed(context, '/settings');
//         },
//         icon: const Icon(Icons.settings),
//         label: const Text("Settings"),
//       ),
//     );
//   }

//   Widget _buildLogoutButton() {
//     return SizedBox(
//       width: double.infinity,
//       height: 55,
//       child: ElevatedButton.icon(
//         style: ElevatedButton.styleFrom(
//           backgroundColor: Colors.red,
//         ),
//         onPressed: () async {
//           await supabase.auth.signOut();

//           if (mounted) {
//             Navigator.pushNamedAndRemoveUntil(
//               context,
//               '/login',
//               (route) => false,
//             );
//           }
//         },
//         icon: const Icon(Icons.logout),
//         label: const Text("Logout"),
//       ),
//     );
//   }
// }


import 'dart:ui';
import 'dart:math' as math;

import 'package:chessp/WalletScreen.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:image_picker/image_picker.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

// ─── Palette ────────────────────────────────────────────────────────────────
const _bgDark = Color(0xFF0A0D14);
const _bgCard = Color(0xFF111827);
const _surface = Color(0xFF1A2236);
const _border = Color(0xFF2A3550);
const _gold = Color(0xFFD4AF37);
const _goldLight = Color(0xFFFFD96A);
const _accent = Color(0xFF4F8EF7);
const _green = Color(0xFF22C55E);
const _textPrimary = Color(0xFFF1F5F9);
const _textSecondary = Color(0xFF94A3B8);

class ChessappProfile extends StatefulWidget {
  const ChessappProfile({super.key});

  @override
  State<ChessappProfile> createState() => _ChessappProfileState();
}

class _ChessappProfileState extends State<ChessappProfile>
    with TickerProviderStateMixin {
  final supabase = Supabase.instance.client;
  final ImagePicker _picker = ImagePicker();

  String? _profileImageUrl;
  bool _isUploading = false;
  bool _isLoading = true;

  int wallet = 0;
  int wins = 0;
  int rank = 0;

  late AnimationController _fadeCtrl;
  late AnimationController _pulseCtrl;
  late Animation<double> _fadeAnim;
  late Animation<double> _pulseAnim;

  @override
  void initState() {
    super.initState();

    _fadeCtrl = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 900),
    );
    _pulseCtrl = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 2200),
    )..repeat(reverse: true);

    _fadeAnim = CurvedAnimation(parent: _fadeCtrl, curve: Curves.easeOut);
    _pulseAnim = Tween<double>(begin: 0.85, end: 1.0).animate(
      CurvedAnimation(parent: _pulseCtrl, curve: Curves.easeInOut),
    );

    _loadProfileImage();
    _loadStats();
  }

  @override
  void dispose() {
    _fadeCtrl.dispose();
    _pulseCtrl.dispose();
    super.dispose();
  }

  // ─── Data ──────────────────────────────────────────────────────────────────

  Future<void> _loadStats() async {
    final user = supabase.auth.currentUser;
    if (user == null) return;

    try {
      final data = await supabase
          .from('player_stats')
          .select()
          .eq('id', user.id)
          .maybeSingle();

      if (data == null) {
        await supabase.from('player_stats').insert({
          'id': user.id,
          'wallet': 0,
          'wins': 0,
          'rank': 0,
        });
        setState(() {
          wallet = 0;
          wins = 0;
          rank = 0;
        });
      } else {
        setState(() {
          wallet = data['wallet'] ?? 0;
          wins = data['wins'] ?? 0;
          rank = data['rank'] ?? 0;
        });
      }
    } catch (e) {
      debugPrint('Stats Error: $e');
    }
  }

  Future<void> updateWallet(int newWallet) async {
    final user = supabase.auth.currentUser;
    if (user == null) return;
    await supabase
        .from('player_stats')
        .update({'wallet': newWallet}).eq('id', user.id);
    setState(() => wallet = newWallet);
  }

  Future<void> updateWins(int newWins) async {
    final user = supabase.auth.currentUser;
    if (user == null) return;
    await supabase
        .from('player_stats')
        .update({'wins': newWins}).eq('id', user.id);
    setState(() => wins = newWins);
  }

  Future<void> updateRank(int newRank) async {
    final user = supabase.auth.currentUser;
    if (user == null) return;
    await supabase
        .from('player_stats')
        .update({'rank': newRank}).eq('id', user.id);
    setState(() => rank = newRank);
  }

  Future<void> _loadProfileImage() async {
    final user = supabase.auth.currentUser;
    if (user == null) {
      setState(() => _isLoading = false);
      return;
    }

    try {
      final files =
          await supabase.storage.from('profile-images').list(path: user.id);

      if (files.isNotEmpty) {
        final imageUrl = supabase.storage
            .from('profile-images')
            .getPublicUrl('${user.id}/avatar.jpg');

        if (mounted) {
          setState(() {
            _profileImageUrl = imageUrl;
            _isLoading = false;
          });
        }
      } else {
        setState(() => _isLoading = false);
      }
    } catch (e) {
      debugPrint('Error loading image: $e');
      if (mounted) setState(() => _isLoading = false);
    }

    _fadeCtrl.forward();
  }

  Future<void> _pickAndUploadImage() async {
    final user = supabase.auth.currentUser;
    if (user == null) return;

    try {
      final XFile? pickedImage = await _picker.pickImage(
        source: ImageSource.gallery,
        maxWidth: 500,
        maxHeight: 500,
        imageQuality: 80,
      );
      if (pickedImage == null) return;

      setState(() => _isUploading = true);

      final imageBytes = await pickedImage.readAsBytes();
      await supabase.storage.from('profile-images').uploadBinary(
            '${user.id}/avatar.jpg',
            imageBytes,
            fileOptions: const FileOptions(
              upsert: true,
              contentType: 'image/jpeg',
            ),
          );

      final imageUrl = supabase.storage
          .from('profile-images')
          .getPublicUrl('${user.id}/avatar.jpg');

      final imageUrlWithTimestamp =
          '$imageUrl?t=${DateTime.now().millisecondsSinceEpoch}';

      if (mounted) {
        setState(() {
          _profileImageUrl = imageUrlWithTimestamp;
          _isUploading = false;
        });
        _showToast('Profile photo updated!', isSuccess: true);
      }
    } catch (e) {
      debugPrint('Upload error: $e');
      if (mounted) {
        setState(() => _isUploading = false);
        _showToast('Upload failed: ${e.toString()}', isSuccess: false);
      }
    }
  }

  void _copyUserId() {
    final user = supabase.auth.currentUser;
    if (user == null) return;
    Clipboard.setData(ClipboardData(text: user.id));
    _showToast('User ID copied!', isSuccess: true);
  }

  void _showToast(String message, {required bool isSuccess}) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Row(
          children: [
            Icon(
              isSuccess ? Icons.check_circle_rounded : Icons.error_rounded,
              color: Colors.white,
              size: 18,
            ),
            const SizedBox(width: 10),
            Expanded(
              child: Text(
                message,
                style: const TextStyle(
                  color: Colors.white,
                  fontFamily: 'Georgia',
                  fontSize: 13,
                ),
              ),
            ),
          ],
        ),
        backgroundColor: isSuccess
            ? const Color(0xFF166534)
            : const Color(0xFF991B1B),
        behavior: SnackBarBehavior.floating,
        margin: const EdgeInsets.all(16),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
          side: BorderSide(
            color: isSuccess
                ? _green.withOpacity(0.4)
                : Colors.red.withOpacity(0.4),
          ),
        ),
        duration: const Duration(seconds: 2),
      ),
    );
  }

  // ─── Build ─────────────────────────────────────────────────────────────────

  @override
  Widget build(BuildContext context) {
    final user = supabase.auth.currentUser;

    if (user == null) {
      return _buildNotLoggedIn();
    }

    final userName = user.userMetadata?['username'] ?? 'Chess Player';
    final email = user.email ?? 'No Email';
    final userId = user.id;

    return Scaffold(
      backgroundColor: _bgDark,
      extendBodyBehindAppBar: true,
      appBar: _buildAppBar(),
      body: _isLoading
          ? _buildLoader()
          : FadeTransition(
              opacity: _fadeAnim,
              child: Stack(
                children: [
                  _buildBackground(),
                  SafeArea(
                    child: SingleChildScrollView(
                      physics: const BouncingScrollPhysics(),
                      padding: const EdgeInsets.symmetric(
                          horizontal: 20, vertical: 8),
                      child: Column(
                        children: [
                          const SizedBox(height: 10),
                          _buildHeroSection(userName, email),
                          const SizedBox(height: 28),
                          _buildUserIdCard(userId),
                          const SizedBox(height: 20),
                          _buildStatsSection(),
                          const SizedBox(height: 28),
                          _buildDivider('Account'),
                          const SizedBox(height: 14),
                          _buildMenuCard(),
                          const SizedBox(height: 24),
                          _buildLogoutButton(),
                          const SizedBox(height: 30),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
    );
  }

  PreferredSizeWidget _buildAppBar() {
    return AppBar(
      backgroundColor: Colors.transparent,
      elevation: 0,
      centerTitle: true,
      title: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Text(
            '♛',
            style: TextStyle(
              fontSize: 18,
              color: _gold,
            ),
          ),
          const SizedBox(width: 8),
          Text(
            'PROFILE',
            style: TextStyle(
              color: _textPrimary,
              fontSize: 13,
              fontWeight: FontWeight.w700,
              letterSpacing: 3.5,
              fontFamily: 'Georgia',
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildBackground() {
    return Positioned.fill(
      child: CustomPaint(
        painter: _ChessBoardBgPainter(),
      ),
    );
  }

  Widget _buildLoader() {
    return Container(
      color: _bgDark,
      child: const Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              '♛',
              style: TextStyle(
                fontSize: 48,
                color: _gold,
              ),
            ),
            SizedBox(height: 16),
            SizedBox(
              width: 24,
              height: 24,
              child: CircularProgressIndicator(
                color: _gold,
                strokeWidth: 2,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildNotLoggedIn() {
    return Scaffold(
      backgroundColor: _bgDark,
      body: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Text('♟', style: TextStyle(fontSize: 52, color: _textSecondary)),
            const SizedBox(height: 16),
            const Text(
              'Not logged in',
              style: TextStyle(color: _textSecondary, fontSize: 18),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: _gold,
                foregroundColor: _bgDark,
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12)),
              ),
              onPressed: () =>
                  Navigator.pushNamedAndRemoveUntil(
                      context, '/login', (r) => false),
              child: const Text('Login'),
            ),
          ],
        ),
      ),
    );
  }

  // ─── Hero ──────────────────────────────────────────────────────────────────

  Widget _buildHeroSection(String userName, String email) {
    return Column(
      children: [
        _buildAvatar(),
        const SizedBox(height: 6),
        GestureDetector(
          onTap: _isUploading ? null : _pickAndUploadImage,
          child: Container(
            padding:
                const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
            decoration: BoxDecoration(
              color: _gold.withOpacity(0.12),
              borderRadius: BorderRadius.circular(20),
              border: Border.all(color: _gold.withOpacity(0.3)),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(Icons.camera_alt_rounded,
                    size: 12, color: _gold.withOpacity(0.8)),
                const SizedBox(width: 5),
                Text(
                  'Change Photo',
                  style: TextStyle(
                    color: _gold.withOpacity(0.8),
                    fontSize: 11,
                    letterSpacing: 0.5,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),
          ),
        ),
        const SizedBox(height: 16),
        Text(
          userName,
          style: const TextStyle(
            fontSize: 26,
            fontWeight: FontWeight.w800,
            color: _textPrimary,
            fontFamily: 'Georgia',
            letterSpacing: 0.5,
          ),
        ),
        const SizedBox(height: 5),
        Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(Icons.mail_outline_rounded,
                size: 13, color: _textSecondary),
            const SizedBox(width: 5),
            Text(
              email,
              style: const TextStyle(
                color: _textSecondary,
                fontSize: 13,
                letterSpacing: 0.2,
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildAvatar() {
    return AnimatedBuilder(
      animation: _pulseAnim,
      builder: (context, child) {
        return GestureDetector(
          onTap: _isUploading ? null : _pickAndUploadImage,
          child: Container(
            width: 110,
            height: 110,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              boxShadow: [
                BoxShadow(
                  color: _gold.withOpacity(0.15 * _pulseAnim.value),
                  blurRadius: 30 * _pulseAnim.value,
                  spreadRadius: 6 * _pulseAnim.value,
                ),
              ],
            ),
            child: Stack(
              alignment: Alignment.center,
              children: [
                // Outer ring
                Container(
                  width: 110,
                  height: 110,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    gradient: SweepGradient(
                      colors: [
                        _gold,
                        _goldLight,
                        _gold.withOpacity(0.4),
                        _gold,
                      ],
                    ),
                  ),
                ),
                // Inner avatar
                Container(
                  width: 104,
                  height: 104,
                  decoration: const BoxDecoration(
                    shape: BoxShape.circle,
                    color: _surface,
                  ),
                  child: ClipOval(
                    child: _isUploading
                        ? const Center(
                            child: SizedBox(
                              width: 26,
                              height: 26,
                              child: CircularProgressIndicator(
                                color: _gold,
                                strokeWidth: 2.5,
                              ),
                            ),
                          )
                        : _profileImageUrl != null
                            ? Image.network(
                                _profileImageUrl!,
                                fit: BoxFit.cover,
                                errorBuilder: (_, __, ___) =>
                                    _defaultAvatar(),
                              )
                            : _defaultAvatar(),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _defaultAvatar() {
    return Container(
      color: _surface,
      child: const Center(
        child: Text(
          '♟',
          style: TextStyle(fontSize: 42, color: _textSecondary),
        ),
      ),
    );
  }

  // ─── User ID card ──────────────────────────────────────────────────────────

  Widget _buildUserIdCard(String userId) {
    return _GlassCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(7),
                decoration: BoxDecoration(
                  color: _accent.withOpacity(0.15),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: const Icon(Icons.fingerprint_rounded,
                    color: _accent, size: 18),
              ),
              const SizedBox(width: 10),
              const Text(
                'USER ID',
                style: TextStyle(
                  color: _textSecondary,
                  fontSize: 11,
                  letterSpacing: 2.5,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ],
          ),
          const SizedBox(height: 14),
          Container(
            padding:
                const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
            decoration: BoxDecoration(
              color: _bgDark.withOpacity(0.6),
              borderRadius: BorderRadius.circular(10),
              border: Border.all(color: _border),
            ),
            child: Row(
              children: [
                Expanded(
                  child: SelectableText(
                    userId,
                    style: const TextStyle(
                      color: _textSecondary,
                      fontSize: 12,
                      fontFamily: 'monospace',
                      letterSpacing: 0.5,
                    ),
                    maxLines: 1,
                  ),
                ),
                const SizedBox(width: 8),
                GestureDetector(
                  onTap: _copyUserId,
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 12, vertical: 6),
                    decoration: BoxDecoration(
                      gradient: const LinearGradient(
                        colors: [_gold, _goldLight],
                      ),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: const Text(
                      'COPY',
                      style: TextStyle(
                        color: _bgDark,
                        fontSize: 10,
                        fontWeight: FontWeight.w800,
                        letterSpacing: 1.2,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // ─── Stats ─────────────────────────────────────────────────────────────────

  Widget _buildStatsSection() {
    return Row(
      children: [
        Expanded(
          child: _buildStatCard(
            title: 'WALLET',
            value: '₹$wallet',
            icon: '💰',
            color: _green,
            onTap: () => Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) => const WalletScreen()),
            ),
          ),
        ),
        const SizedBox(width: 10),
        Expanded(
          child: _buildStatCard(
            title: 'WINS',
            value: '$wins',
            icon: '🏆',
            color: _gold,
          ),
        ),
        const SizedBox(width: 10),
        Expanded(
          child: _buildStatCard(
            title: 'RANK',
            value: '#$rank',
            icon: '⚡',
            color: _accent,
          ),
        ),
      ],
    );
  }

  Widget _buildStatCard({
    required String title,
    required String value,
    required String icon,
    required Color color,
    VoidCallback? onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 16),
        decoration: BoxDecoration(
          color: _bgCard,
          borderRadius: BorderRadius.circular(18),
          border: Border.all(color: _border),
          boxShadow: [
            BoxShadow(
              color: color.withOpacity(0.06),
              blurRadius: 16,
              spreadRadius: 0,
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(icon, style: const TextStyle(fontSize: 20)),
                if (onTap != null)
                  Icon(Icons.arrow_forward_ios_rounded,
                      size: 11, color: _textSecondary),
              ],
            ),
            const SizedBox(height: 12),
            Text(
              value,
              style: TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.w800,
                color: color,
                fontFamily: 'Georgia',
              ),
            ),
            const SizedBox(height: 3),
            Text(
              title,
              style: const TextStyle(
                color: _textSecondary,
                fontSize: 10,
                fontWeight: FontWeight.w600,
                letterSpacing: 1.5,
              ),
            ),
          ],
        ),
      ),
    );
  }

  // ─── Menu ──────────────────────────────────────────────────────────────────

  Widget _buildDivider(String label) {
    return Row(
      children: [
        Expanded(child: Divider(color: _border, thickness: 1)),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 12),
          child: Text(
            label.toUpperCase(),
            style: const TextStyle(
              color: _textSecondary,
              fontSize: 10,
              letterSpacing: 2.5,
              fontWeight: FontWeight.w700,
            ),
          ),
        ),
        Expanded(child: Divider(color: _border, thickness: 1)),
      ],
    );
  }

  Widget _buildMenuCard() {
    return _GlassCard(
      padding: EdgeInsets.zero,
      child: Column(
        children: [
          _buildMenuItem(
            icon: Icons.settings_rounded,
            label: 'Settings',
            subtitle: 'Preferences & notifications',
            iconColor: _textSecondary,
            onTap: () => Navigator.pushNamed(context, '/settings'),
          ),
          Divider(height: 1, color: _border),
          _buildMenuItem(
            icon: Icons.account_balance_wallet_rounded,
            label: 'Wallet',
            subtitle: 'Manage your balance',
            iconColor: _green,
            onTap: () => Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) => const WalletScreen()),
            ),
          ),
          Divider(height: 1, color: _border),
          _buildMenuItem(
            icon: Icons.shield_outlined,
            label: 'Privacy & Security',
            subtitle: 'Manage account security',
            iconColor: _accent,
            onTap: () {},
          ),
          Divider(height: 1, color: _border),
          _buildMenuItem(
            icon: Icons.help_outline_rounded,
            label: 'Help & Support',
            subtitle: 'Get assistance',
            iconColor: _gold,
            onTap: () {},
            isLast: true,
          ),
        ],
      ),
    );
  }

  Widget _buildMenuItem({
    required IconData icon,
    required String label,
    required String subtitle,
    required Color iconColor,
    required VoidCallback onTap,
    bool isLast = false,
  }) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.vertical(
        top: isLast ? Radius.zero : Radius.zero,
        bottom: isLast ? const Radius.circular(16) : Radius.zero,
      ),
      splashColor: _gold.withOpacity(0.06),
      highlightColor: _gold.withOpacity(0.04),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 14),
        child: Row(
          children: [
            Container(
              width: 38,
              height: 38,
              decoration: BoxDecoration(
                color: iconColor.withOpacity(0.12),
                borderRadius: BorderRadius.circular(10),
              ),
              child: Icon(icon, color: iconColor, size: 18),
            ),
            const SizedBox(width: 14),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    label,
                    style: const TextStyle(
                      color: _textPrimary,
                      fontWeight: FontWeight.w600,
                      fontSize: 14,
                    ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    subtitle,
                    style: const TextStyle(
                      color: _textSecondary,
                      fontSize: 12,
                    ),
                  ),
                ],
              ),
            ),
            const Icon(Icons.chevron_right_rounded,
                color: _textSecondary, size: 20),
          ],
        ),
      ),
    );
  }

  // ─── Logout ────────────────────────────────────────────────────────────────

  Widget _buildLogoutButton() {
    return GestureDetector(
      onTap: () async {
        final confirmed = await showDialog<bool>(
          context: context,
          barrierColor: Colors.black.withOpacity(0.7),
          builder: (ctx) => _buildLogoutDialog(ctx),
        );
        if (confirmed == true && mounted) {
          await supabase.auth.signOut();
          if (mounted) {
            Navigator.pushNamedAndRemoveUntil(
                context, '/login', (route) => false);
          }
        }
      },
      child: Container(
        width: double.infinity,
        height: 54,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(14),
          border: Border.all(color: Colors.red.withOpacity(0.4)),
          color: Colors.red.withOpacity(0.08),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.logout_rounded,
                color: Colors.red.shade400, size: 18),
            const SizedBox(width: 10),
            Text(
              'Sign Out',
              style: TextStyle(
                color: Colors.red.shade400,
                fontWeight: FontWeight.w700,
                fontSize: 15,
                letterSpacing: 0.3,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildLogoutDialog(BuildContext ctx) {
    return BackdropFilter(
      filter: ImageFilter.blur(sigmaX: 8, sigmaY: 8),
      child: AlertDialog(
        backgroundColor: _bgCard,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
          side: BorderSide(color: _border),
        ),
        title: const Column(
          children: [
            Text('♚', style: TextStyle(fontSize: 36)),
            SizedBox(height: 8),
            Text(
              'Sign Out?',
              style: TextStyle(
                color: _textPrimary,
                fontWeight: FontWeight.w700,
                fontFamily: 'Georgia',
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
        content: const Text(
          'Are you sure you want to leave the board?',
          style: TextStyle(color: _textSecondary, fontSize: 14),
          textAlign: TextAlign.center,
        ),
        actionsAlignment: MainAxisAlignment.center,
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx, false),
            child: const Text(
              'Stay',
              style: TextStyle(color: _textSecondary, fontSize: 14),
            ),
          ),
          const SizedBox(width: 8),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.red.shade700,
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10)),
              padding: const EdgeInsets.symmetric(
                  horizontal: 24, vertical: 10),
            ),
            onPressed: () => Navigator.pop(ctx, true),
            child: const Text(
              'Sign Out',
              style: TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.w700,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// ─── Glass Card ───────────────────────────────────────────────────────────────

class _GlassCard extends StatelessWidget {
  final Widget child;
  final EdgeInsets? padding;

  const _GlassCard({required this.child, this.padding});

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(18),
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 8, sigmaY: 8),
        child: Container(
          width: double.infinity,
          padding: padding ?? const EdgeInsets.all(18),
          decoration: BoxDecoration(
            color: _bgCard.withOpacity(0.85),
            borderRadius: BorderRadius.circular(18),
            border: Border.all(color: _border),
          ),
          child: child,
        ),
      ),
    );
  }
}

// ─── Background Painter ────────────────────────────────────────────────────────

class _ChessBoardBgPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    const tileSize = 44.0;

    // Very subtle chess pattern
    final paint = Paint()
      ..color = const Color(0xFF1A2236).withOpacity(0.35)
      ..style = PaintingStyle.fill;

    final cols = (size.width / tileSize).ceil() + 1;
    final rows = (size.height / tileSize).ceil() + 1;

    for (int row = 0; row < rows; row++) {
      for (int col = 0; col < cols; col++) {
        if ((row + col) % 2 == 0) {
          canvas.drawRect(
            Rect.fromLTWH(
              col * tileSize,
              row * tileSize,
              tileSize,
              tileSize,
            ),
            paint,
          );
        }
      }
    }

    // Radial gradient overlay to fade out the pattern
    final gradientPaint = Paint()
      ..shader = RadialGradient(
        center: Alignment.topCenter,
        radius: 1.2,
        colors: [
          Colors.transparent,
          _bgDark.withOpacity(0.7),
          _bgDark,
        ],
        stops: const [0.0, 0.6, 1.0],
      ).createShader(Rect.fromLTWH(0, 0, size.width, size.height));

    canvas.drawRect(
        Rect.fromLTWH(0, 0, size.width, size.height), gradientPaint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}