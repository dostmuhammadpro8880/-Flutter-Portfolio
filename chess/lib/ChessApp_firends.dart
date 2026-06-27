// // // ```dart
// // // // ```dart
// // // // import 'package:flutter/material.dart';

// // // // class ChessappFirends extends StatelessWidget {
// // // //   const ChessappFirends({super.key});

// // // //   @override
// // // //   Widget build(BuildContext context) {
// // // //     return Scaffold(
// // // //       appBar: AppBar(title: Text("Friends")),
// // // //       body: Column(children: [
        
// // // //       ],),
// // // //     );
// // // //   }
// // // // }
// // // i want code each Friend send request to other friend make friend with others using uiud search friends using uiud  give me complete working code   uisng backend supabase
// // // ```

// // // 1. Friend System

// // // * Search users using UUID
// // // * Send friend request
// // // * Accept/reject request
// // // * Cancel request
// // // * Remove friend
// // // * Show pending requests
// // // * Show sent requests
// // // * Show friends list 

// // // * Suggested friends


// // // * “People you may know”
// // // * Show Add Friend buttonPlay Features Each friend card should include:

// // // * Play button
// // // * Invite to match
 
// // // * Show online/offline
// // // * Show currently playingUI Design Modern dark chess theme. Use:




// // // * avatar
// // // * username
// // // * uuid

// // // * add friend button
// // // * play button




// // // * users
// // // * friends
// // // * friend_requests
// // // * matches
// // // * notifications

// // // 1. Notifications

// // // * Friend request received
// // // * Request accepted
// // // * Match invite
// // // * Friend online  
// // // //  i am using 
// // // // ```

// // // // supabase







// // -- Friend requests table
// // CREATE TABLE friend_requests (
// //   id UUID DEFAULT gen_random_uuid() PRIMARY KEY,
// //   sender_id UUID REFERENCES users(auth_user_id) ON DELETE CASCADE,
// //   receiver_id UUID REFERENCES users(auth_user_id) ON DELETE CASCADE,
// //   status TEXT DEFAULT 'pending' CHECK (status IN ('pending', 'accepted', 'rejected')),
// //   created_at TIMESTAMPTZ DEFAULT NOW(),
// //   UNIQUE(sender_id, receiver_id)
// // );

// // -- Friends table (mutual friendship)
// // CREATE TABLE friends (
// //   id UUID DEFAULT gen_random_uuid() PRIMARY KEY,
// //   user_id UUID REFERENCES users(auth_user_id) ON DELETE CASCADE,
// //   friend_id UUID REFERENCES users(auth_user_id) ON DELETE CASCADE,
// //   created_at TIMESTAMPTZ DEFAULT NOW(),
// //   UNIQUE(user_id, friend_id)
// // );

// // -- Notifications table
// // CREATE TABLE notifications (
// //   id UUID DEFAULT gen_random_uuid() PRIMARY KEY,
// //   user_id UUID REFERENCES users(auth_user_id) ON DELETE CASCADE,
// //   type TEXT NOT NULL,
// //   message TEXT NOT NULL,
// //   from_user_id UUID REFERENCES users(auth_user_id) ON DELETE CASCADE,
// //   is_read BOOLEAN DEFAULT FALSE,
// //   created_at TIMESTAMPTZ DEFAULT NOW()
// // );

// // -- Online status (add to users table or separate)
// // ALTER TABLE users ADD COLUMN IF NOT EXISTS is_online BOOLEAN DEFAULT FALSE;
// // ALTER TABLE users ADD COLUMN IF NOT EXISTS username TEXT;
// // ALTER TABLE users ADD COLUMN IF NOT EXISTS last_seen TIMESTAMPTZ DEFAULT NOW();

// // -- Enable realtime on these tables
// // ALTER PUBLICATION supabase_realtime ADD TABLE friend_requests;
// // ALTER PUBLICATION supabase_realtime ADD TABLE notifications;
// // ALTER PUBLICATION supabase_realtime ADD TABLE users;




// import 'dart:math' as math;

// import 'package:flutter/material.dart';
// import 'package:flutter/services.dart';
// import 'package:supabase_flutter/supabase_flutter.dart';
// import 'dart:async';

// // ─────────────────────────────────────────────
// // MODELS
// // ─────────────────────────────────────────────

// class AppUser {
//   final String authUserId;
//   final String customId;
//   final String email;
//   final String? imageUrl;
//   final String? username;
//   final bool isOnline;

//   AppUser({
//     required this.authUserId,
//     required this.customId,
//     required this.email,
//     this.imageUrl,
//     this.username,
//     this.isOnline = false,
//   });

//   factory AppUser.fromMap(Map<String, dynamic> map) {
//     return AppUser(
//       authUserId: map['auth_user_id'] ?? '',
//       customId: map['custom_id'] ?? '',
//       email: map['email'] ?? '',
//       imageUrl: map['image_url'],
//       username: map['username'],
//       isOnline: map['is_online'] ?? false,
//     );
//   }

//   String get displayName => username ?? email.split('@').first;
//   String get shortId => customId.length > 8 ? customId.substring(0, 8) : customId;
// }

// class FriendRequest {
//   final String id;
//   final String senderId;
//   final String receiverId;
//   final String status;
//   final DateTime createdAt;
//   AppUser? senderUser;
//   AppUser? receiverUser;

//   FriendRequest({
//     required this.id,
//     required this.senderId,
//     required this.receiverId,
//     required this.status,
//     required this.createdAt,
//     this.senderUser,
//     this.receiverUser,
//   });

//   factory FriendRequest.fromMap(Map<String, dynamic> map) {
//     return FriendRequest(
//       id: map['id'] ?? '',
//       senderId: map['sender_id'] ?? '',
//       receiverId: map['receiver_id'] ?? '',
//       status: map['status'] ?? 'pending',
//       createdAt: DateTime.tryParse(map['created_at'] ?? '') ?? DateTime.now(),
//     );
//   }
// }

// class AppNotification {
//   final String id;
//   final String userId;
//   final String type;
//   final String message;
//   final String? fromUserId;
//   final bool isRead;
//   final DateTime createdAt;

//   AppNotification({
//     required this.id,
//     required this.userId,
//     required this.type,
//     required this.message,
//     this.fromUserId,
//     required this.isRead,
//     required this.createdAt,
//   });

//   factory AppNotification.fromMap(Map<String, dynamic> map) {
//     return AppNotification(
//       id: map['id'] ?? '',
//       userId: map['user_id'] ?? '',
//       type: map['type'] ?? '',
//       message: map['message'] ?? '',
//       fromUserId: map['from_user_id'],
//       isRead: map['is_read'] ?? false,
//       createdAt: DateTime.tryParse(map['created_at'] ?? '') ?? DateTime.now(),
//     );
//   }
// }

// // ─────────────────────────────────────────────
// // SUPABASE SERVICE
// // ─────────────────────────────────────────────

// class FriendService {
//   final _supabase = Supabase.instance.client;

//   String get currentUserId => _supabase.auth.currentUser!.id;

//   // Search user by custom_id or UUID
//   Future<AppUser?> searchUser(String query) async {
//     try {
//       final res = await _supabase
//           .from('users')
//           .select()
//           .or('custom_id.eq.$query,auth_user_id.eq.$query,email.ilike.%$query%')
//           .neq('auth_user_id', currentUserId)
//           .limit(1)
//           .maybeSingle();
//       if (res == null) return null;
//       return AppUser.fromMap(res);
//     } catch (e) {
//       return null;
//     }
//   }

//   // Get all friends
//   Future<List<AppUser>> getFriends() async {
//     final res = await _supabase
//         .from('friends')
//         .select('friend_id')
//         .eq('user_id', currentUserId);

//     if (res.isEmpty) return [];

//     final ids = res.map((e) => e['friend_id'] as String).toList();
//     final users = await _supabase.from('users').select().inFilter('auth_user_id', ids);
//     return users.map((e) => AppUser.fromMap(e)).toList();
//   }

//   // Get pending incoming requests
//   Future<List<FriendRequest>> getIncomingRequests() async {
//     final res = await _supabase
//         .from('friend_requests')
//         .select()
//         .eq('receiver_id', currentUserId)
//         .eq('status', 'pending');

//     final requests = res.map((e) => FriendRequest.fromMap(e)).toList();
//     for (final req in requests) {
//       final user = await _supabase
//           .from('users')
//           .select()
//           .eq('auth_user_id', req.senderId)
//           .maybeSingle();
//       if (user != null) req.senderUser = AppUser.fromMap(user);
//     }
//     return requests;
//   }

//   // Get sent requests
//   Future<List<FriendRequest>> getSentRequests() async {
//     final res = await _supabase
//         .from('friend_requests')
//         .select()
//         .eq('sender_id', currentUserId)
//         .eq('status', 'pending');

//     final requests = res.map((e) => FriendRequest.fromMap(e)).toList();
//     for (final req in requests) {
//       final user = await _supabase
//           .from('users')
//           .select()
//           .eq('auth_user_id', req.receiverId)
//           .maybeSingle();
//       if (user != null) req.receiverUser = AppUser.fromMap(user);
//     }
//     return requests;
//   }

//   // Send friend request
//   Future<String?> sendFriendRequest(String receiverId) async {
//     // Check existing
//     final existing = await _supabase
//         .from('friend_requests')
//         .select()
//         .or('and(sender_id.eq.$currentUserId,receiver_id.eq.$receiverId),and(sender_id.eq.$receiverId,receiver_id.eq.$currentUserId)')
//         .maybeSingle();

//     if (existing != null) return 'Request already exists';

//     // Check already friends
//     final alreadyFriend = await _supabase
//         .from('friends')
//         .select()
//         .eq('user_id', currentUserId)
//         .eq('friend_id', receiverId)
//         .maybeSingle();

//     if (alreadyFriend != null) return 'Already friends';

//     await _supabase.from('friend_requests').insert({
//       'sender_id': currentUserId,
//       'receiver_id': receiverId,
//       'status': 'pending',
//     });

//     // Send notification
//     await _supabase.from('notifications').insert({
//       'user_id': receiverId,
//       'type': 'friend_request',
//       'message': 'You have a new friend request',
//       'from_user_id': currentUserId,
//       'is_read': false,
//     });

//     return null;
//   }

//   // Accept request
//   Future<void> acceptRequest(String requestId, String senderId) async {
//     await _supabase
//         .from('friend_requests')
//         .update({'status': 'accepted'})
//         .eq('id', requestId);

//     // Create mutual friendship
//     await _supabase.from('friends').upsert([
//       {'user_id': currentUserId, 'friend_id': senderId},
//       {'user_id': senderId, 'friend_id': currentUserId},
//     ]);

//     // Notify sender
//     await _supabase.from('notifications').insert({
//       'user_id': senderId,
//       'type': 'request_accepted',
//       'message': 'Your friend request was accepted!',
//       'from_user_id': currentUserId,
//       'is_read': false,
//     });
//   }

//   // Reject request
//   Future<void> rejectRequest(String requestId) async {
//     await _supabase
//         .from('friend_requests')
//         .update({'status': 'rejected'})
//         .eq('id', requestId);
//   }

//   // Cancel sent request
//   Future<void> cancelRequest(String requestId) async {
//     await _supabase.from('friend_requests').delete().eq('id', requestId);
//   }

//   // Remove friend
//   Future<void> removeFriend(String friendId) async {
//     await _supabase
//         .from('friends')
//         .delete()
//         .eq('user_id', currentUserId)
//         .eq('friend_id', friendId);
//     await _supabase
//         .from('friends')
//         .delete()
//         .eq('user_id', friendId)
//         .eq('friend_id', currentUserId);
//   }

//   // Get notifications
//   Future<List<AppNotification>> getNotifications() async {
//     final res = await _supabase
//         .from('notifications')
//         .select()
//         .eq('user_id', currentUserId)
//         .order('created_at', ascending: false)
//         .limit(20);
//     return res.map((e) => AppNotification.fromMap(e)).toList();
//   }

//   // Mark notification read
//   Future<void> markNotificationRead(String notifId) async {
//     await _supabase.from('notifications').update({'is_read': true}).eq('id', notifId);
//   }

//   // Suggested friends (not friends, not pending)
//   Future<List<AppUser>> getSuggestedFriends() async {
//     final friendsRes = await _supabase
//         .from('friends')
//         .select('friend_id')
//         .eq('user_id', currentUserId);
//     final friendIds = friendsRes.map((e) => e['friend_id'] as String).toList();

//     final sentRes = await _supabase
//         .from('friend_requests')
//         .select('receiver_id')
//         .eq('sender_id', currentUserId)
//         .eq('status', 'pending');
//     final sentIds = sentRes.map((e) => e['receiver_id'] as String).toList();

//     final excludeIds = [...friendIds, ...sentIds, currentUserId];

//     final res = await _supabase
//         .from('users')
//         .select()
//         .not('auth_user_id', 'in', '(${excludeIds.map((e) => '"$e"').join(',')})')
//         .limit(10);

//     return res.map((e) => AppUser.fromMap(e)).toList();
//   }

//   // Realtime subscriptions
//   RealtimeChannel subscribeToNotifications(Function(AppNotification) onNew) {
//     return _supabase
//         .channel('notifications_$currentUserId')
//         .onPostgresChanges(
//           event: PostgresChangeEvent.insert,
//           schema: 'public',
//           table: 'notifications',
//           filter: PostgresChangeFilter(
//             type: PostgresChangeFilterType.eq,
//             column: 'user_id',
//             value: currentUserId,
//           ),
//           callback: (payload) {
//             final notif = AppNotification.fromMap(payload.newRecord);
//             onNew(notif);
//           },
//         )
//         .subscribe();
//   }

//   RealtimeChannel subscribeToFriendRequests(Function() onChange) {
//     return _supabase
//         .channel('friend_requests_$currentUserId')
//         .onPostgresChanges(
//           event: PostgresChangeEvent.all,
//           schema: 'public',
//           table: 'friend_requests',
//           callback: (payload) => onChange(),
//         )
//         .subscribe();
//   }
// }

// // ─────────────────────────────────────────────
// // THEME
// // ─────────────────────────────────────────────

// class ChessTheme {
//   static const bg = Color(0xFF0D0F14);
//   static const surface = Color(0xFF161B25);
//   static const card = Color(0xFF1E2535);
//   static const accent = Color(0xFFE8C96D); // gold
//   static const accentDark = Color(0xFF9E7F2F);
//   static const green = Color(0xFF4ADE80);
//   static const red = Color(0xFFFF5757);
//   static const blue = Color(0xFF60A5FA);
//   static const textPrimary = Color(0xFFEEEEEE);
//   static const textSecondary = Color(0xFF8A94A8);
//   static const border = Color(0xFF2A3347);

//   static ThemeData theme = ThemeData(
//     brightness: Brightness.dark,
//     scaffoldBackgroundColor: bg,
//     colorScheme: const ColorScheme.dark(
//       primary: accent,
//       surface: surface,
//     ),
//     fontFamily: 'Roboto',
//     appBarTheme: const AppBarTheme(
//       backgroundColor: bg,
//       elevation: 0,
//       titleTextStyle: TextStyle(
//         color: textPrimary,
//         fontSize: 20,
//         fontWeight: FontWeight.w700,
//         letterSpacing: 0.5,
//       ),
//       iconTheme: IconThemeData(color: textPrimary),
//     ),
//     tabBarTheme: TabBarThemeData(
//       labelColor: accent,
//       unselectedLabelColor: textSecondary,
//       indicatorColor: accent 
//     )
// // tabBarTheme:  TabBarTheme(
// //   labelColor: accent,
// //   unselectedLabelColor: textSecondary,
// //   indicatorColor: accent,
// // ),
//   );
// }

// // ─────────────────────────────────────────────
// // MAIN PAGE
// // ─────────────────────────────────────────────

// class ChessAppFriends extends StatefulWidget {
//   const ChessAppFriends({super.key});

//   @override
//   State<ChessAppFriends> createState() => _ChessAppFriendsState();
// }

// class _ChessAppFriendsState extends State<ChessAppFriends>
//     with SingleTickerProviderStateMixin {
//   late TabController _tabs;
//   final _service = FriendService();
//   int _unreadNotifs = 0;
//   late RealtimeChannel _notifChannel;
//   late RealtimeChannel _reqChannel;

//   @override
//   void initState() {
//     super.initState();
//     _tabs = TabController(length: 4, vsync: this);
//     _loadUnread();
//     _notifChannel = _service.subscribeToNotifications((notif) {
//       setState(() => _unreadNotifs++);
//       _showSnackBar(notif.message);
//     });
//     _reqChannel = _service.subscribeToFriendRequests(() {
//       if (mounted) setState(() {});
//     });
//   }

//   Future<void> _loadUnread() async {
//     final notifs = await _service.getNotifications();
//     if (mounted) {
//       setState(() => _unreadNotifs = notifs.where((n) => !n.isRead).length);
//     }
//   }

//   void _showSnackBar(String msg) {
//     if (!mounted) return;
//     ScaffoldMessenger.of(context).showSnackBar(SnackBar(
//       content: Text(msg, style: const TextStyle(color: ChessTheme.textPrimary)),
//       backgroundColor: ChessTheme.card,
//       behavior: SnackBarBehavior.floating,
//       shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
//     ));
//   }

//   @override
//   void dispose() {
//     _notifChannel.unsubscribe();
//     _reqChannel.unsubscribe();
//     _tabs.dispose();
//     super.dispose();
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Theme(
//       data: ChessTheme.theme,
//       child: Scaffold(
//         backgroundColor: ChessTheme.bg,
//         appBar: AppBar(
//           backgroundColor: ChessTheme.bg,
//           title: Row(children: [
//             const Text('♟', style: TextStyle(fontSize: 22, color: ChessTheme.accent)),
//             const SizedBox(width: 8),
//             const Text('Friends',
//                 style: TextStyle(color: ChessTheme.textPrimary, fontWeight: FontWeight.w700)),
//           ]),
//           actions: [
//             Stack(
//               children: [
//                 IconButton(
//                   icon: const Icon(Icons.notifications_outlined, color: ChessTheme.textPrimary),
//                   onPressed: () => _showNotificationsSheet(),
//                 ),
//                 if (_unreadNotifs > 0)
//                   Positioned(
//                     right: 8,
//                     top: 8,
//                     child: Container(
//                       width: 16,
//                       height: 16,
//                       decoration: const BoxDecoration(
//                         color: ChessTheme.red,
//                         shape: BoxShape.circle,
//                       ),
//                       child: Center(
//                         child: Text(
//                           _unreadNotifs > 9 ? '9+' : '$_unreadNotifs',
//                           style: const TextStyle(fontSize: 9, color: Colors.white, fontWeight: FontWeight.bold),
//                         ),
//                       ),
//                     ),
//                   ),
//               ],
//             ),
//           ],
//           bottom: TabBar(
//             controller: _tabs,
//             labelColor: ChessTheme.accent,
//             unselectedLabelColor: ChessTheme.textSecondary,
//             indicatorColor: ChessTheme.accent,
//             indicatorWeight: 2,
//             labelStyle: const TextStyle(fontSize: 12, fontWeight: FontWeight.w600),
//             tabs: const [
//               Tab(text: 'FRIENDS'),
//               Tab(text: 'REQUESTS'),
//               Tab(text: 'SENT'),
//               Tab(text: 'DISCOVER'),
//             ],
//           ),
//         ),
//         body: Column(
//           children: [
//             _SearchBar(service: _service, onRefresh: () => setState(() {})),
//             Expanded(
//               child: TabBarView(
//                 controller: _tabs,
//                 children: [
//                   _FriendsList(service: _service),
//                   _IncomingRequests(service: _service),
//                   _SentRequests(service: _service),
//                   _SuggestedFriends(service: _service),
//                 ],
//               ),
//             ),
//           ],
//         ),
//       ),
//     );
//   }

//   void _showNotificationsSheet() {
//     showModalBottomSheet(
//       context: context,
//       backgroundColor: ChessTheme.surface,
//       shape: const RoundedRectangleBorder(
//           borderRadius: BorderRadius.vertical(top: Radius.circular(20))),
//       builder: (_) => _NotificationsSheet(service: _service, onRead: () {
//         setState(() => _unreadNotifs = 0);
//       }),
//     );
//   }
// }

// // ─────────────────────────────────────────────
// // SEARCH BAR
// // ─────────────────────────────────────────────

// class _SearchBar extends StatefulWidget {
//   final FriendService service;
//   final VoidCallback onRefresh;
//   const _SearchBar({required this.service, required this.onRefresh});

//   @override
//   State<_SearchBar> createState() => _SearchBarState();
// }

// class _SearchBarState extends State<_SearchBar> {
//   final _ctrl = TextEditingController();
//   AppUser? _result;
//   bool _loading = false;
//   String? _error;

//   Future<void> _search() async {
//     final q = _ctrl.text.trim();
//     if (q.isEmpty) return;
//     setState(() { _loading = true; _error = null; _result = null; });
//     final user = await widget.service.searchUser(q);
//     setState(() {
//       _loading = false;
//       _result = user;
//       if (user == null) _error = 'No user found';
//     });
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Container(
//       color: ChessTheme.bg,
//       padding: const EdgeInsets.fromLTRB(16, 12, 16, 4),
//       child: Column(
//         children: [
//           Row(
//             children: [
//               Expanded(
//                 child: Container(
//                   decoration: BoxDecoration(
//                     color: ChessTheme.card,
//                     borderRadius: BorderRadius.circular(12),
//                     border: Border.all(color: ChessTheme.border),
//                   ),
//                   child: TextField(
//                     controller: _ctrl,
//                     style: const TextStyle(color: ChessTheme.textPrimary, fontSize: 14),
//                     decoration: const InputDecoration(
//                       hintText: 'Search by UUID, custom ID or email...',
//                       hintStyle: TextStyle(color: ChessTheme.textSecondary, fontSize: 13),
//                       prefixIcon: Icon(Icons.search, color: ChessTheme.textSecondary, size: 20),
//                       border: InputBorder.none,
//                       contentPadding: EdgeInsets.symmetric(vertical: 12),
//                     ),
//                     onSubmitted: (_) => _search(),
//                   ),
//                 ),
//               ),
//               const SizedBox(width: 8),
//               GestureDetector(
//                 onTap: _search,
//                 child: Container(
//                   padding: const EdgeInsets.all(12),
//                   decoration: BoxDecoration(
//                     color: ChessTheme.accent,
//                     borderRadius: BorderRadius.circular(12),
//                   ),
//                   child: _loading
//                       ? const SizedBox(width: 20, height: 20,
//                           child: CircularProgressIndicator(strokeWidth: 2, color: Colors.black))
//                       : const Icon(Icons.search, color: Colors.black, size: 20),
//                 ),
//               ),
//             ],
//           ),
//           if (_error != null)
//             Padding(
//               padding: const EdgeInsets.only(top: 8),
//               child: Text(_error!, style: const TextStyle(color: ChessTheme.red, fontSize: 13)),
//             ),
//           if (_result != null) ...[
//             const SizedBox(height: 8),
//             _UserSearchResult(user: _result!, service: widget.service, onAction: () {
//               setState(() => _result = null);
//               _ctrl.clear();
//               widget.onRefresh();
//             }),
//           ],
//         ],
//       ),
//     );
//   }
// }

// // ─────────────────────────────────────────────
// // SEARCH RESULT CARD
// // ─────────────────────────────────────────────

// class _UserSearchResult extends StatefulWidget {
//   final AppUser user;
//   final FriendService service;
//   final VoidCallback onAction;
//   const _UserSearchResult({required this.user, required this.service, required this.onAction});

//   @override
//   State<_UserSearchResult> createState() => _UserSearchResultState();
// }

// class _UserSearchResultState extends State<_UserSearchResult> {
//   bool _loading = false;

//   Future<void> _sendRequest() async {
//     setState(() => _loading = true);
//     final err = await widget.service.sendFriendRequest(widget.user.authUserId);
//     setState(() => _loading = false);
//     if (!mounted) return;
//     if (err != null) {
//       ScaffoldMessenger.of(context).showSnackBar(
//           SnackBar(content: Text(err), backgroundColor: ChessTheme.red));
//     } else {
//       ScaffoldMessenger.of(context).showSnackBar(
//           const SnackBar(content: Text('Friend request sent!'), backgroundColor: ChessTheme.green));
//       widget.onAction();
//     }
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Container(
//       padding: const EdgeInsets.all(12),
//       decoration: BoxDecoration(
//         color: ChessTheme.card,
//         borderRadius: BorderRadius.circular(12),
//         border: Border.all(color: ChessTheme.accent.withOpacity(0.3)),
//       ),
//       child: Row(
//         children: [
//           _Avatar(user: widget.user, size: 44),
//           const SizedBox(width: 12),
//           Expanded(
//             child: Column(
//               crossAxisAlignment: CrossAxisAlignment.start,
//               children: [
//                 Text(widget.user.displayName,
//                     style: const TextStyle(color: ChessTheme.textPrimary, fontWeight: FontWeight.w600)),
//                 Text(widget.user.shortId,
//                     style: const TextStyle(color: ChessTheme.textSecondary, fontSize: 12)),
//               ],
//             ),
//           ),
//           _ActionButton(
//             label: 'Add Friend',
//             icon: Icons.person_add_outlined,
//             color: ChessTheme.accent,
//             textColor: Colors.black,
//             loading: _loading,
//             onTap: _sendRequest,
//           ),
//         ],
//       ),
//     );
//   }
// }

// // ─────────────────────────────────────────────
// // FRIENDS LIST TAB
// // ─────────────────────────────────────────────

// class _FriendsList extends StatefulWidget {
//   final FriendService service;
//   const _FriendsList({required this.service});

//   @override
//   State<_FriendsList> createState() => _FriendsListState();
// }

// class _FriendsListState extends State<_FriendsList> {
//   List<AppUser> _friends = [];
//   bool _loading = true;

//   @override
//   void initState() {
//     super.initState();
//     _load();
//   }

//   Future<void> _load() async {
//     setState(() => _loading = true);
//     final f = await widget.service.getFriends();
//     if (mounted) setState(() { _friends = f; _loading = false; });
//   }

//   @override
//   Widget build(BuildContext context) {
//     if (_loading) return const _LoadingIndicator();
//     if (_friends.isEmpty) return _EmptyState(icon: '♟', message: 'No friends yet.\nSearch by UUID to add friends!');

//     return RefreshIndicator(
//       onRefresh: _load,
//       color: ChessTheme.accent,
//       child: ListView.builder(
//         padding: const EdgeInsets.all(16),
//         itemCount: _friends.length,
//         itemBuilder: (_, i) => _FriendCard(
//           user: _friends[i],
//           service: widget.service,
//           onRemove: _load,
//         ),
//       ),
//     );
//   }
// }

// class _FriendCard extends StatelessWidget {
//   final AppUser user;
//   final FriendService service;
//   final VoidCallback onRemove;
//   const _FriendCard({required this.user, required this.service, required this.onRemove});

//   @override
//   Widget build(BuildContext context) {
//     return Container(
//       margin: const EdgeInsets.only(bottom: 10),
//       padding: const EdgeInsets.all(14),
//       decoration: BoxDecoration(
//         color: ChessTheme.card,
//         borderRadius: BorderRadius.circular(14),
//         border: Border.all(color: ChessTheme.border),
//       ),
//       child: Row(
//         children: [
//           Stack(
//             children: [
//               _Avatar(user: user, size: 48),

//               if (user.isOnline)
//                 Positioned(
//                   right: 0,
//                   bottom: 0,
//                   child: Container(
//                     width: 12,
//                     height: 12,
//                     decoration: BoxDecoration(
//                       color: ChessTheme.green,
//                       shape: BoxShape.circle,
//                       border: Border.all(color: ChessTheme.card, width: 2),
//                     ),
//                   ),
//                 ),
//             ],
//           ),
//           const SizedBox(width: 12),
//           Expanded(
//             child: Column(
//               crossAxisAlignment: CrossAxisAlignment.start,
//               children: [
//                 Text(user.displayName,
//                     style: const TextStyle(
//                         color: ChessTheme.textPrimary,
//                         fontWeight: FontWeight.w600,
//                         fontSize: 15)),
//                 const SizedBox(height: 2),
//                 Row(children: [
//                   const Icon(Icons.tag, size: 12, color: ChessTheme.textSecondary),
//                   const SizedBox(width: 2),
//                   Text(user.shortId,
//                       style: const TextStyle(color: ChessTheme.textSecondary, fontSize: 12)),
//                   const SizedBox(width: 8),
//                   Container(
//                     padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
//                     decoration: BoxDecoration(
//                       color: user.isOnline
//                           ? ChessTheme.green.withOpacity(0.15)
//                           : ChessTheme.border,
//                       borderRadius: BorderRadius.circular(4),
//                     ),
//                     child: Text(
//                       user.isOnline ? 'Online' : 'Offline',
//                       style: TextStyle(
//                         color: user.isOnline ? ChessTheme.green : ChessTheme.textSecondary,
//                         fontSize: 10,
//                         fontWeight: FontWeight.w600,
//                       ),
//                     ),
//                   ),
//                 ]),
//               ],
//             ),
//           ),
//           Row(
//             children: [
//               _IconBtn(
//                 icon: Icons.sports_esports_outlined,
//                 color: ChessTheme.accent,
//                 tooltip: 'Invite to Match',
//                 onTap: () => _inviteToMatch(context, user),
//               ),
//               const SizedBox(width: 6),
//               _IconBtn(
//                 icon: Icons.person_remove_outlined,
//                 color: ChessTheme.red,
//                 tooltip: 'Remove Friend',
//                 onTap: () => _confirmRemove(context),
//               ),
//             ],
//           ),
//         ],
//       ),
//     );
//   }

//   void _inviteToMatch(BuildContext context, AppUser user) {
//     ScaffoldMessenger.of(context).showSnackBar(
//       SnackBar(
//         content: Text('Match invite sent to ${user.displayName}!'),
//         backgroundColor: ChessTheme.green,
//         behavior: SnackBarBehavior.floating,
//       ),
//     );
//   }

//   void _confirmRemove(BuildContext context) {
//     showDialog(
//       context: context,
//       builder: (_) => AlertDialog(
//         backgroundColor: ChessTheme.surface,
//         shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
//         title: const Text('Remove Friend', style: TextStyle(color: ChessTheme.textPrimary)),
//         content: Text('Remove ${user.displayName} from friends?',
//             style: const TextStyle(color: ChessTheme.textSecondary)),
//         actions: [
//           TextButton(
//             onPressed: () => Navigator.pop(context),
//             child: const Text('Cancel', style: TextStyle(color: ChessTheme.textSecondary)),
//           ),
//           TextButton(
//             onPressed: () async {
//               Navigator.pop(context);
//               await service.removeFriend(user.authUserId);
//               onRemove();
//             },
//             child: const Text('Remove', style: TextStyle(color: ChessTheme.red)),
//           ),
//         ],
//       ),
//     );
//   }
// }

// // ─────────────────────────────────────────────
// // INCOMING REQUESTS TAB
// // ─────────────────────────────────────────────

// class _IncomingRequests extends StatefulWidget {
//   final FriendService service;
//   const _IncomingRequests({required this.service});

//   @override
//   State<_IncomingRequests> createState() => _IncomingRequestsState();
// }

// class _IncomingRequestsState extends State<_IncomingRequests> {
//   List<FriendRequest> _requests = [];
//   bool _loading = true;

//   @override
//   void initState() { super.initState(); _load(); }

//   Future<void> _load() async {
//     setState(() => _loading = true);
//     final r = await widget.service.getIncomingRequests();
//     if (mounted) setState(() { _requests = r; _loading = false; });
//   }

//   @override
//   Widget build(BuildContext context) {
//     if (_loading) return const _LoadingIndicator();
//     if (_requests.isEmpty) return _EmptyState(icon: '📬', message: 'No pending requests');

//     return RefreshIndicator(
//       onRefresh: _load,
//       color: ChessTheme.accent,
//       child: ListView.builder(
//         padding: const EdgeInsets.all(16),
//         itemCount: _requests.length,
//         itemBuilder: (_, i) {
//           final req = _requests[i];
//           final user = req.senderUser;
//           if (user == null) return const SizedBox();
//           return _RequestCard(
//             user: user,
//             trailing: Row(
//               mainAxisSize: MainAxisSize.min,
//               children: [
//                 _ActionButton(
//                   label: 'Accept',
//                   icon: Icons.check,
//                   color: ChessTheme.green,
//                   textColor: Colors.black,
//                   onTap: () async {
//                     await widget.service.acceptRequest(req.id, req.senderId);
//                     _load();
//                   },
//                 ),
//                 const SizedBox(width: 6),
//                 _ActionButton(
//                   label: 'Decline',
//                   icon: Icons.close,
//                   color: ChessTheme.border,
//                   textColor: ChessTheme.textSecondary,
//                   onTap: () async {
//                     await widget.service.rejectRequest(req.id);
//                     _load();
//                   },
//                 ),
//               ],
//             ),
//           );
//         },
//       ),
//     );
//   }
// }

// // ─────────────────────────────────────────────
// // SENT REQUESTS TAB
// // ─────────────────────────────────────────────

// class _SentRequests extends StatefulWidget {
//   final FriendService service;
//   const _SentRequests({required this.service});

//   @override
//   State<_SentRequests> createState() => _SentRequestsState();
// }

// class _SentRequestsState extends State<_SentRequests> {
//   List<FriendRequest> _requests = [];
//   bool _loading = true;

//   @override
//   void initState() { super.initState(); _load(); }

//   Future<void> _load() async {
//     setState(() => _loading = true);
//     final r = await widget.service.getSentRequests();
//     if (mounted) setState(() { _requests = r; _loading = false; });
//   }

//   @override
//   Widget build(BuildContext context) {
//     if (_loading) return const _LoadingIndicator();
//     if (_requests.isEmpty) return _EmptyState(icon: '📤', message: 'No sent requests');

//     return RefreshIndicator(
//       onRefresh: _load,
//       color: ChessTheme.accent,
//       child: ListView.builder(
//         padding: const EdgeInsets.all(16),
//         itemCount: _requests.length,
//         itemBuilder: (_, i) {
//           final req = _requests[i];
//           final user = req.receiverUser;
//           if (user == null) return const SizedBox();
//           return _RequestCard(
//             user: user,
//             label: 'Pending',
//             labelColor: ChessTheme.accent,
//             trailing: _ActionButton(
//               label: 'Cancel',
//               icon: Icons.cancel_outlined,
//               color: ChessTheme.border,
//               textColor: ChessTheme.textSecondary,
//               onTap: () async {
//                 await widget.service.cancelRequest(req.id);
//                 _load();
//               },
//             ),
//           );
//         },
//       ),
//     );
//   }
// }

// // ─────────────────────────────────────────────
// // SUGGESTED FRIENDS TAB
// // ─────────────────────────────────────────────

// class _SuggestedFriends extends StatefulWidget {
//   final FriendService service;
//   const _SuggestedFriends({required this.service});

//   @override
//   State<_SuggestedFriends> createState() => _SuggestedFriendsState();
// }

// class _SuggestedFriendsState extends State<_SuggestedFriends> {
//   List<AppUser> _users = [];
//   bool _loading = true;
//   final Set<String> _sent = {};

//   @override
//   void initState() { super.initState(); _load(); }

//   Future<void> _load() async {
//     setState(() => _loading = true);
//     final u = await widget.service.getSuggestedFriends();
//     if (mounted) setState(() { _users = u; _loading = false; });
//   }

//   @override
//   Widget build(BuildContext context) {
//     if (_loading) return const _LoadingIndicator();
//     if (_users.isEmpty) return _EmptyState(icon: '🌐', message: 'No suggestions available');

//     return RefreshIndicator(
//       onRefresh: _load,
//       color: ChessTheme.accent,
//       child: Column(
//         children: [
//           Padding(
//             padding: const EdgeInsets.fromLTRB(16, 16, 16, 4),
//             child: Row(
//               children: [
//                 const Icon(Icons.people_outline, color: ChessTheme.accent, size: 16),
//                 const SizedBox(width: 6),
//                 const Text('People you may know',
//                     style: TextStyle(color: ChessTheme.textSecondary, fontSize: 13,
//                         fontWeight: FontWeight.w600)),
//               ],
//             ),
//           ),
//           Expanded(
//             child: ListView.builder(
//               padding: const EdgeInsets.all(16),
//               itemCount: _users.length,
//               itemBuilder: (_, i) {
//                 final user = _users[i];
//                 final sent = _sent.contains(user.authUserId);
//                 return _RequestCard(
//                   user: user,
//                   trailing: _ActionButton(
//                     label: sent ? 'Sent' : 'Add Friend',
//                     icon: sent ? Icons.check : Icons.person_add_outlined,
//                     color: sent ? ChessTheme.border : ChessTheme.accent,
//                     textColor: sent ? ChessTheme.textSecondary : Colors.black,
//                     onTap: sent ? null : () async {
//                       await widget.service.sendFriendRequest(user.authUserId);
//                       setState(() => _sent.add(user.authUserId));
//                     },
//                   ),
//                 );
//               },
//             ),
//           ),
//         ],
//       ),
//     );
//   }
// }

// // ─────────────────────────────────────────────
// // NOTIFICATIONS SHEET
// // ─────────────────────────────────────────────

// class _NotificationsSheet extends StatefulWidget {
//   final FriendService service;
//   final VoidCallback onRead;
//   const _NotificationsSheet({required this.service, required this.onRead});

//   @override
//   State<_NotificationsSheet> createState() => _NotificationsSheetState();
// }

// class _NotificationsSheetState extends State<_NotificationsSheet> {
//   List<AppNotification> _notifs = [];
//   bool _loading = true;

//   @override
//   void initState() { super.initState(); _load(); }

//   Future<void> _load() async {
//     final n = await widget.service.getNotifications();
//     if (mounted) setState(() { _notifs = n; _loading = false; });
//   }

//   IconData _iconFor(String type) {
//     switch (type) {
//       case 'friend_request': return Icons.person_add_outlined;
//       case 'request_accepted': return Icons.people;
//       case 'match_invite': return Icons.sports_esports_outlined;
//       case 'friend_online': return Icons.circle;
//       default: return Icons.notifications_outlined;
//     }
//   }

//   Color _colorFor(String type) {
//     switch (type) {
//       case 'friend_request': return ChessTheme.accent;
//       case 'request_accepted': return ChessTheme.green;
//       case 'match_invite': return ChessTheme.blue;
//       default: return ChessTheme.textSecondary;
//     }
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Container(
//       height: MediaQuery.of(context).size.height * 0.6,
//       padding: const EdgeInsets.all(16),
//       child: Column(
//         children: [
//           Container(
//             width: 40, height: 4,
//             decoration: BoxDecoration(
//               color: ChessTheme.border,
//               borderRadius: BorderRadius.circular(2),
//             ),
//           ),
//           const SizedBox(height: 16),
//           Row(
//             mainAxisAlignment: MainAxisAlignment.spaceBetween,
//             children: [
//               const Text('Notifications',
//                   style: TextStyle(color: ChessTheme.textPrimary,
//                       fontWeight: FontWeight.w700, fontSize: 18)),
//               TextButton(
//                 onPressed: () async {
//                   for (final n in _notifs.where((n) => !n.isRead)) {
//                     await widget.service.markNotificationRead(n.id);
//                   }
//                   widget.onRead();
//                   await _load();
//                 },
//                 child: const Text('Mark all read',
//                     style: TextStyle(color: ChessTheme.accent, fontSize: 12)),
//               ),
//             ],
//           ),
//           const SizedBox(height: 8),
//           if (_loading)
//             const Expanded(child: Center(child: CircularProgressIndicator(color: ChessTheme.accent)))
//           else if (_notifs.isEmpty)
//             Expanded(child: _EmptyState(icon: '🔔', message: 'No notifications'))
//           else
//             Expanded(
//               child: ListView.builder(
//                 itemCount: _notifs.length,
//                 itemBuilder: (_, i) {
//                   final n = _notifs[i];
//                   return ListTile(
//                     contentPadding: const EdgeInsets.symmetric(vertical: 4),
//                     leading: Container(
//                       width: 40, height: 40,
//                       decoration: BoxDecoration(
//                         color: _colorFor(n.type).withOpacity(0.15),
//                         shape: BoxShape.circle,
//                       ),
//                       child: Icon(_iconFor(n.type), color: _colorFor(n.type), size: 20),
//                     ),
//                     title: Text(n.message,
//                         style: TextStyle(
//                           color: n.isRead ? ChessTheme.textSecondary : ChessTheme.textPrimary,
//                           fontSize: 14,
//                         )),
//                     subtitle: Text(
//                       _timeAgo(n.createdAt),
//                       style: const TextStyle(color: ChessTheme.textSecondary, fontSize: 12),
//                     ),
//                     trailing: !n.isRead
//                         ? Container(
//                             width: 8, height: 8,
//                             decoration: const BoxDecoration(
//                               color: ChessTheme.accent, shape: BoxShape.circle))
//                         : null,
//                     onTap: () => widget.service.markNotificationRead(n.id),
//                   );
//                 },
//               ),
//             ),
//         ],
//       ),
//     );
//   }

//   String _timeAgo(DateTime dt) {
//     final diff = DateTime.now().difference(dt);
//     if (diff.inMinutes < 1) return 'Just now';
//     if (diff.inHours < 1) return '${diff.inMinutes}m ago';
//     if (diff.inDays < 1) return '${diff.inHours}h ago';
//     return '${diff.inDays}d ago';
//   }
// }

// // ─────────────────────────────────────────────
// // SHARED WIDGETS
// // ─────────────────────────────────────────────
// class _Avatar extends StatelessWidget {
//   final AppUser user;
//   final double size;

//   const _Avatar({
//     required this.user,
//     required this.size,
//   });

//   @override
//   Widget build(BuildContext context) {
//     final hasImage =
//         user.imageUrl != null && user.imageUrl!.trim().isNotEmpty;

//     return Container(
//       width: size,
//       height: size,
//       decoration: BoxDecoration(
//         shape: BoxShape.circle,
//         color: ChessTheme.border,
//         border: Border.all(
//           color: ChessTheme.border,
//           width: 1.5,
//         ),
//       ),
//       child: ClipOval(
//         child: hasImage
//             ? Image.network(
//                 user.imageUrl!,
//                 fit: BoxFit.cover,
//                 errorBuilder: (_, __, ___) {
//                   return _fallbackAvatar();
//                 },
//                 loadingBuilder: (context, child, progress) {
//                   if (progress == null) return child;

//                   return const Center(
//                     child: CircularProgressIndicator(
//                       strokeWidth: 2,
//                       color: ChessTheme.accent,
//                     ),
//                   );
//                 },
//               )
//             : _fallbackAvatar(),
//       ),
//     );
//   }

//   Widget _fallbackAvatar() {
//     return Container(
//       color: ChessTheme.border,
//       alignment: Alignment.center,
//       child: Text(
//         user.displayName.isNotEmpty
//             ? user.displayName[0].toUpperCase()
//             : '?',
//         style: TextStyle(
//           color: ChessTheme.accent,
//           fontSize: size * 0.4,
//           fontWeight: FontWeight.w700,
//         ),
//       ),
//     );
//   }
// }
// class _RequestCard extends StatelessWidget {
//   final AppUser user;
//   final Widget trailing;
//   final String? label;
//   final Color? labelColor;
//   const _RequestCard({
//     required this.user,
//     required this.trailing,
//     this.label,
//     this.labelColor,
//   });

//   @override
//   Widget build(BuildContext context) {
//     return Container(
//       margin: const EdgeInsets.only(bottom: 10),
//       padding: const EdgeInsets.all(14),
//       decoration: BoxDecoration(
//         color: ChessTheme.card,
//         borderRadius: BorderRadius.circular(14),
//         border: Border.all(color: ChessTheme.border),
//       ),
//       child: Row(
//         children: [
//           _Avatar(user: user, size: 46),
//           const SizedBox(width: 12),
//           Expanded(
//             child: Column(
//               crossAxisAlignment: CrossAxisAlignment.start,
//               children: [
//                 Row(children: [
//                   Text(user.displayName,
//                       style: const TextStyle(
//                           color: ChessTheme.textPrimary,
//                           fontWeight: FontWeight.w600,
//                           fontSize: 14)),
//                   if (label != null) ...[
//                     const SizedBox(width: 6),
//                     Container(
//                       padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
//                       decoration: BoxDecoration(
//                         color: (labelColor ?? ChessTheme.accent).withOpacity(0.15),
//                         borderRadius: BorderRadius.circular(4),
//                       ),
//                       child: Text(label!,
//                           style: TextStyle(
//                               color: labelColor ?? ChessTheme.accent,
//                               fontSize: 10,
//                               fontWeight: FontWeight.w600)),
//                     ),
//                   ],
//                 ]),
//                 const SizedBox(height: 3),
//                 GestureDetector(
//                   onTap: () {
//                     Clipboard.setData(ClipboardData(text: user.customId));
//                     ScaffoldMessenger.of(context).showSnackBar(
//                       const SnackBar(content: Text('UUID copied!'),
//                           backgroundColor: ChessTheme.card,
//                           behavior: SnackBarBehavior.floating));
//                   },
//                   child: Row(children: [
//                     const Icon(Icons.copy, size: 10, color: ChessTheme.textSecondary),
//                     const SizedBox(width: 3),
//                     Text(user.shortId,
//                         style: const TextStyle(color: ChessTheme.textSecondary, fontSize: 11)),
//                   ]),
//                 ),
//               ],
//             ),
//           ),
//           trailing,
//         ],
//       ),
//     );
//   }
// }

// class _ActionButton extends StatefulWidget {
//   final String label;
//   final IconData icon;
//   final Color color;
//   final Color textColor;
//   final VoidCallback? onTap;
//   final bool loading;
//   const _ActionButton({
//     required this.label,
//     required this.icon,
//     required this.color,
//     required this.textColor,
//     this.onTap,
//     this.loading = false,
//   });

//   @override
//   State<_ActionButton> createState() => _ActionButtonState();
// }

// class _ActionButtonState extends State<_ActionButton> {
//   bool _busy = false;

//   @override
//   Widget build(BuildContext context) {
//     return GestureDetector(
//       onTap: widget.onTap == null || _busy ? null : () async {
//         setState(() => _busy = true);
//         await Future.microtask(widget.onTap!);
//         if (mounted) setState(() => _busy = false);
//       },
//       child: AnimatedContainer(
//         duration: const Duration(milliseconds: 150),
//         padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
//         decoration: BoxDecoration(
//           color: widget.color,
//           borderRadius: BorderRadius.circular(8),
//         ),
//         child: _busy || widget.loading
//             ? SizedBox(
//                 width: 14, height: 14,
//                 child: CircularProgressIndicator(strokeWidth: 2, color: widget.textColor))
//             : Row(
//                 mainAxisSize: MainAxisSize.min,
//                 children: [
//                   Icon(widget.icon, size: 13, color: widget.textColor),
//                   const SizedBox(width: 4),
//                   Text(widget.label,
//                       style: TextStyle(
//                           color: widget.textColor,
//                           fontSize: 12,
//                           fontWeight: FontWeight.w600)),
//                 ],
//               ),
//       ),
//     );
//   }
// }

// class _IconBtn extends StatelessWidget {
//   final IconData icon;
//   final Color color;
//   final String tooltip;
//   final VoidCallback onTap;
//   const _IconBtn({required this.icon, required this.color, required this.tooltip, required this.onTap});

//   @override
//   Widget build(BuildContext context) {
//     return Tooltip(
//       message: tooltip,
//       child: GestureDetector(
//         onTap: onTap,
//         child: Container(
//           width: 34, height: 34,
//           decoration: BoxDecoration(
//             color: color.withOpacity(0.12),
//             borderRadius: BorderRadius.circular(8),
//           ),
//           child: Icon(icon, size: 17, color: color),
//         ),
//       ),
//     );
//   }
// }

// class _LoadingIndicator extends StatelessWidget {
//   const _LoadingIndicator();
//   @override
//   Widget build(BuildContext context) {
//     return const Center(
//         child: CircularProgressIndicator(color: ChessTheme.accent, strokeWidth: 2));
//   }
// }

// class _EmptyState extends StatelessWidget {
//   final String icon;
//   final String message;
//   const _EmptyState({required this.icon, required this.message});

//   @override
//   Widget build(BuildContext context) {
//     return Center(
//       child: Column(
//         mainAxisAlignment: MainAxisAlignment.center,
//         children: [
//           Text(icon, style: const TextStyle(fontSize: 48)),
//           const SizedBox(height: 16),
//           Text(
//             message,
//             textAlign: TextAlign.center,
//             style: const TextStyle(color: ChessTheme.textSecondary, fontSize: 15, height: 1.6),
//           ),
//         ],
//       ),
//     );
//   }
// }





































































// import 'dart:math' as math;
// import 'package:flutter/material.dart';
// import 'package:flutter/services.dart';
// import 'package:supabase_flutter/supabase_flutter.dart';
// import 'dart:async';
// import 'package:intl/intl.dart';

// // ─────────────────────────────────────────────
// // MODELS
// // ─────────────────────────────────────────────

// class AppUser {
//   final String authUserId;
//   final String customId;
//   final String email;
//   final String? imageUrl;
//   final String? username;
//   final bool isOnline;
//   final DateTime? lastSeen;

//   AppUser({
//     required this.authUserId,
//     required this.customId,
//     required this.email,
//     this.imageUrl,
//     this.username,
//     this.isOnline = false,
//     this.lastSeen,
//   });

//   factory AppUser.fromMap(Map<String, dynamic> map) {
//     return AppUser(
//       authUserId: map['auth_user_id'] ?? '',
//       customId: map['custom_id'] ?? '',
//       email: map['email'] ?? '',
//       imageUrl: map['image_url'],
//       username: map['username'],
//       isOnline: map['is_online'] ?? false,
//       lastSeen: map['last_seen'] != null ? DateTime.tryParse(map['last_seen']) : null,
//     );
//   }

//   String get displayName => username ?? email.split('@').first;
//   String get shortId => customId.length > 8 ? customId.substring(0, 8) : customId;
// }

// class FriendRequest {
//   final String id;
//   final String senderId;
//   final String receiverId;
//   final String status;
//   final DateTime createdAt;
//   AppUser? senderUser;
//   AppUser? receiverUser;

//   FriendRequest({
//     required this.id,
//     required this.senderId,
//     required this.receiverId,
//     required this.status,
//     required this.createdAt,
//     this.senderUser,
//     this.receiverUser,
//   });

//   factory FriendRequest.fromMap(Map<String, dynamic> map) {
//     return FriendRequest(
//       id: map['id'] ?? '',
//       senderId: map['sender_id'] ?? '',
//       receiverId: map['receiver_id'] ?? '',
//       status: map['status'] ?? 'pending',
//       createdAt: DateTime.tryParse(map['created_at'] ?? '') ?? DateTime.now(),
//     );
//   }
// }

// class Message {
//   final String id;
//   final String senderId;
//   final String receiverId;
//   final String content;
//   final DateTime createdAt;
//   final bool isRead;

//   Message({
//     required this.id,
//     required this.senderId,
//     required this.receiverId,
//     required this.content,
//     required this.createdAt,
//     this.isRead = false,
//   });

//   factory Message.fromMap(Map<String, dynamic> map) {
//     return Message(
//       id: map['id'] ?? '',
//       senderId: map['sender_id'] ?? '',
//       receiverId: map['receiver_id'] ?? '',
//       content: map['content'] ?? '',
//       createdAt: DateTime.tryParse(map['created_at'] ?? '') ?? DateTime.now(),
//       isRead: map['is_read'] ?? false,
//     );
//   }
// }

// class AppNotification {
//   final String id;
//   final String userId;
//   final String type;
//   final String message;
//   final String? fromUserId;
//   final bool isRead;
//   final DateTime createdAt;

//   AppNotification({
//     required this.id,
//     required this.userId,
//     required this.type,
//     required this.message,
//     this.fromUserId,
//     required this.isRead,
//     required this.createdAt,
//   });

//   factory AppNotification.fromMap(Map<String, dynamic> map) {
//     return AppNotification(
//       id: map['id'] ?? '',
//       userId: map['user_id'] ?? '',
//       type: map['type'] ?? '',
//       message: map['message'] ?? '',
//       fromUserId: map['from_user_id'],
//       isRead: map['is_read'] ?? false,
//       createdAt: DateTime.tryParse(map['created_at'] ?? '') ?? DateTime.now(),
//     );
//   }
// }

// // ─────────────────────────────────────────────
// // SUPABASE SERVICE
// // ─────────────────────────────────────────────

// class FriendService {
//   final _supabase = Supabase.instance.client;

//   String get currentUserId => _supabase.auth.currentUser!.id;

//   // Search user by custom_id or UUID
//   Future<AppUser?> searchUser(String query) async {
//     try {
//       final res = await _supabase
//           .from('users')
//           .select()
//           .or('custom_id.eq.$query,auth_user_id.eq.$query,email.ilike.%$query%')
//           .neq('auth_user_id', currentUserId)
//           .limit(1)
//           .maybeSingle();
//       if (res == null) return null;
//       return AppUser.fromMap(res);
//     } catch (e) {
//       return null;
//     }
//   }

//   // Get all friends
//   Future<List<AppUser>> getFriends() async {
//     final res = await _supabase
//         .from('friends')
//         .select('friend_id')
//         .eq('user_id', currentUserId);

//     if (res.isEmpty) return [];

//     final ids = res.map((e) => e['friend_id'] as String).toList();
//     final users = await _supabase.from('users').select().inFilter('auth_user_id', ids);
//     return users.map((e) => AppUser.fromMap(e)).toList();
//   }

//   // Get pending incoming requests
//   Future<List<FriendRequest>> getIncomingRequests() async {
//     final res = await _supabase
//         .from('friend_requests')
//         .select()
//         .eq('receiver_id', currentUserId)
//         .eq('status', 'pending');

//     final requests = res.map((e) => FriendRequest.fromMap(e)).toList();
//     for (final req in requests) {
//       final user = await _supabase
//           .from('users')
//           .select()
//           .eq('auth_user_id', req.senderId)
//           .maybeSingle();
//       if (user != null) req.senderUser = AppUser.fromMap(user);
//     }
//     return requests;
//   }

//   // Get sent requests
//   Future<List<FriendRequest>> getSentRequests() async {
//     final res = await _supabase
//         .from('friend_requests')
//         .select()
//         .eq('sender_id', currentUserId)
//         .eq('status', 'pending');

//     final requests = res.map((e) => FriendRequest.fromMap(e)).toList();
//     for (final req in requests) {
//       final user = await _supabase
//           .from('users')
//           .select()
//           .eq('auth_user_id', req.receiverId)
//           .maybeSingle();
//       if (user != null) req.receiverUser = AppUser.fromMap(user);
//     }
//     return requests;
//   }

//   // Send friend request
//   Future<String?> sendFriendRequest(String receiverId) async {
//     final existing = await _supabase
//         .from('friend_requests')
//         .select()
//         .or('and(sender_id.eq.$currentUserId,receiver_id.eq.$receiverId),and(sender_id.eq.$receiverId,receiver_id.eq.$currentUserId)')
//         .maybeSingle();

//     if (existing != null) return 'Request already exists';

//     final alreadyFriend = await _supabase
//         .from('friends')
//         .select()
//         .eq('user_id', currentUserId)
//         .eq('friend_id', receiverId)
//         .maybeSingle();

//     if (alreadyFriend != null) return 'Already friends';

//     await _supabase.from('friend_requests').insert({
//       'sender_id': currentUserId,
//       'receiver_id': receiverId,
//       'status': 'pending',
//     });

//     await _supabase.from('notifications').insert({
//       'user_id': receiverId,
//       'type': 'friend_request',
//       'message': 'You have a new friend request',
//       'from_user_id': currentUserId,
//       'is_read': false,
//     });

//     return null;
//   }

//   // Accept request
//   Future<void> acceptRequest(String requestId, String senderId) async {
//     await _supabase
//         .from('friend_requests')
//         .update({'status': 'accepted'})
//         .eq('id', requestId);

//     await _supabase.from('friends').upsert([
//       {'user_id': currentUserId, 'friend_id': senderId},
//       {'user_id': senderId, 'friend_id': currentUserId},
//     ]);

//     await _supabase.from('notifications').insert({
//       'user_id': senderId,
//       'type': 'request_accepted',
//       'message': 'Your friend request was accepted!',
//       'from_user_id': currentUserId,
//       'is_read': false,
//     });
//   }

//   // Reject request
//   Future<void> rejectRequest(String requestId) async {
//     await _supabase
//         .from('friend_requests')
//         .update({'status': 'rejected'})
//         .eq('id', requestId);
//   }

//   // Cancel sent request
//   Future<void> cancelRequest(String requestId) async {
//     await _supabase.from('friend_requests').delete().eq('id', requestId);
//   }

//   // Remove friend
//   Future<void> removeFriend(String friendId) async {
//     await _supabase
//         .from('friends')
//         .delete()
//         .eq('user_id', currentUserId)
//         .eq('friend_id', friendId);
//     await _supabase
//         .from('friends')
//         .delete()
//         .eq('user_id', friendId)
//         .eq('friend_id', currentUserId);
//   }

//   // Get notifications
//   Future<List<AppNotification>> getNotifications() async {
//     final res = await _supabase
//         .from('notifications')
//         .select()
//         .eq('user_id', currentUserId)
//         .order('created_at', ascending: false)
//         .limit(20);
//     return res.map((e) => AppNotification.fromMap(e)).toList();
//   }

//   // Mark notification read
//   Future<void> markNotificationRead(String notifId) async {
//     await _supabase.from('notifications').update({'is_read': true}).eq('id', notifId);
//   }

//   // Get messages between two users
//   Future<List<Message>> getMessages(String otherUserId) async {
//     final res = await _supabase
//         .from('messages')
//         .select()
//         .or('and(sender_id.eq.$currentUserId,receiver_id.eq.$otherUserId),and(sender_id.eq.$otherUserId,receiver_id.eq.$currentUserId)')
//         .order('created_at', ascending: true)
//         .limit(50);
//     return res.map((e) => Message.fromMap(e)).toList();
//   }

//   // Send message
//   Future<void> sendMessage(String receiverId, String content) async {
//     await _supabase.from('messages').insert({
//       'sender_id': currentUserId,
//       'receiver_id': receiverId,
//       'content': content,
//       'is_read': false,
//     });
//   }

//   // Get suggested friends
//   Future<List<AppUser>> getSuggestedFriends() async {
//     final friendsRes = await _supabase
//         .from('friends')
//         .select('friend_id')
//         .eq('user_id', currentUserId);
//     final friendIds = friendsRes.map((e) => e['friend_id'] as String).toList();

//     final sentRes = await _supabase
//         .from('friend_requests')
//         .select('receiver_id')
//         .eq('sender_id', currentUserId)
//         .eq('status', 'pending');
//     final sentIds = sentRes.map((e) => e['receiver_id'] as String).toList();

//     final excludeIds = [...friendIds, ...sentIds, currentUserId];

//     final res = await _supabase
//         .from('users')
//         .select()
//         .not('auth_user_id', 'in', '(${excludeIds.map((e) => '"$e"').join(',')})')
//         .limit(10);

//     return res.map((e) => AppUser.fromMap(e)).toList();
//   }

//   // Realtime subscriptions
//   RealtimeChannel subscribeToNotifications(Function(AppNotification) onNew) {
//     return _supabase
//         .channel('notifications_$currentUserId')
//         .onPostgresChanges(
//           event: PostgresChangeEvent.insert,
//           schema: 'public',
//           table: 'notifications',
//           filter: PostgresChangeFilter(
//             type: PostgresChangeFilterType.eq,
//             column: 'user_id',
//             value: currentUserId,
//           ),
//           callback: (payload) {
//             final notif = AppNotification.fromMap(payload.newRecord);
//             onNew(notif);
//           },
//         )
//         .subscribe();
//   }

//   RealtimeChannel subscribeToMessages(String otherUserId, Function(Message) onNew) {
//     return _supabase
//         .channel('messages_${currentUserId}_$otherUserId')
//         .onPostgresChanges(
//           event: PostgresChangeEvent.insert,
//           schema: 'public',
//           table: 'messages',
//           callback: (payload) {
//             final msg = Message.fromMap(payload.newRecord);
//             if ((msg.senderId == currentUserId && msg.receiverId == otherUserId) ||
//                 (msg.senderId == otherUserId && msg.receiverId == currentUserId)) {
//               onNew(msg);
//             }
//           },
//         )
//         .subscribe();
//   }
// }

// // ─────────────────────────────────────────────
// // THEME
// // ─────────────────────────────────────────────

// class GameTheme {
//   static const bg = Color(0xFF0A0E17);
//   static const surface = Color(0xFF141B26);
//   static const card = Color(0xFF1A2235);
//   static const cardLight = Color(0xFF1F2840);
//   static const gold = Color(0xFFFFD700);
//   static const goldDark = Color(0xFFB8960F);
//   static const green = Color(0xFF00E676);
//   static const red = Color(0xFFFF1744);
//   static const blue = Color(0xFF448AFF);
//   static const purple = Color(0xFF7C4DFF);
//   static const textPrimary = Color(0xFFF5F5F5);
//   static const textSecondary = Color(0xFF8A94A8);
//   static const border = Color(0xFF2A3347);

//   static final gradientGold = LinearGradient(
//     colors: [const Color(0xFFFFD700), const Color(0xFFFFA000)],
//     begin: Alignment.topLeft,
//     end: Alignment.bottomRight,
//   );

//   static final gradientBlue = LinearGradient(
//     colors: [const Color(0xFF448AFF), const Color(0xFF2962FF)],
//     begin: Alignment.topLeft,
//     end: Alignment.bottomRight,
//   );

//   static final gradientPurple = LinearGradient(
//     colors: [const Color(0xFF7C4DFF), const Color(0xFF651FFF)],
//     begin: Alignment.topLeft,
//     end: Alignment.bottomRight,
//   );

//   static final gradientBg = LinearGradient(
//     colors: [const Color(0xFF0A0E17), const Color(0xFF141B26)],
//     begin: Alignment.topCenter,
//     end: Alignment.bottomCenter,
//   );

//   static BoxDecoration cardDecoration = BoxDecoration(
//     gradient: LinearGradient(
//       colors: [cardLight, card],
//       begin: Alignment.topLeft,
//       end: Alignment.bottomRight,
//     ),
//     borderRadius: BorderRadius.circular(16),
//     border: Border.all(color: border.withOpacity(0.5), width: 1),
//     boxShadow: [
//       BoxShadow(
//         color: Colors.black.withOpacity(0.3),
//         blurRadius: 10,
//         offset: const Offset(0, 4),
//       ),
//     ],
//   );
// }

// // ─────────────────────────────────────────────
// // MAIN APP
// // ─────────────────────────────────────────────

// class GameFriendsApp extends StatefulWidget {
//   const GameFriendsApp({super.key});

//   @override
//   State<GameFriendsApp> createState() => _GameFriendsAppState();
// }

// class _GameFriendsAppState extends State<GameFriendsApp> {
//   final _service = FriendService();
//   int _unreadNotifs = 0;
//   int _unreadMessages = 0;
//   late RealtimeChannel _notifChannel;
//   late RealtimeChannel _msgChannel;

//   @override
//   void initState() {
//     super.initState();
//     _loadCounts();
//     _notifChannel = _service.subscribeToNotifications((notif) {
//       if (mounted) {
//         setState(() => _unreadNotifs++);
//         _showNotification(notif.message);
//       }
//     });
//   }

//   Future<void> _loadCounts() async {
//     final notifs = await _service.getNotifications();
//     if (mounted) {
//       setState(() {
//         _unreadNotifs = notifs.where((n) => !n.isRead).length;
//       });
//     }
//   }

//   void _showNotification(String msg) {
//     if (!mounted) return;
//     showDialog(
//       context: context,
//       builder: (_) => AlertDialog(
//         backgroundColor: GameTheme.card,
//         shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
//         content: Row(
//           children: [
//             Container(
//               padding: const EdgeInsets.all(10),
//               decoration: BoxDecoration(
//                 gradient: GameTheme.gradientGold,
//                 shape: BoxShape.circle,
//               ),
//               child: const Icon(Icons.notifications, color: Colors.black, size: 24),
//             ),
//             const SizedBox(width: 16),
//             Expanded(
//               child: Text(
//                 msg,
//                 style: const TextStyle(color: GameTheme.textPrimary, fontSize: 16),
//               ),
//             ),
//           ],
//         ),
//         actions: [
//           TextButton(
//             onPressed: () => Navigator.pop(context),
//             child: const Text('OK', style: TextStyle(color: GameTheme.gold)),
//           ),
//         ],
//       ),
//     );
//   }

//   @override
//   void dispose() {
//     _notifChannel.unsubscribe();
//     super.dispose();
//   }

//   @override
//   Widget build(BuildContext context) {
//     return MaterialApp(
//       debugShowCheckedModeBanner: false,
//       theme: ThemeData(
//         brightness: Brightness.dark,
//         scaffoldBackgroundColor: GameTheme.bg,
//         fontFamily: 'Orbitron',
//         colorScheme: const ColorScheme.dark(
//           primary: GameTheme.gold,
//           surface: GameTheme.surface,
//         ),
//       ),
//       home: Scaffold(
//         body: Container(
//           decoration: BoxDecoration(gradient: GameTheme.gradientBg),
//           child: SafeArea(
//             child: _MainScreen(
//               service: _service,
//               unreadNotifs: _unreadNotifs,
//               unreadMessages: _unreadMessages,
//               onRefresh: () => setState(() {}),
//             ),
//           ),
//         ),
//       ),
//     );
//   }
// }

// // ─────────────────────────────────────────────
// // MAIN SCREEN - SINGLE SCREEN GAMING UI
// // ─────────────────────────────────────────────

// class _MainScreen extends StatefulWidget {
//   final FriendService service;
//   final int unreadNotifs;
//   final int unreadMessages;
//   final VoidCallback onRefresh;

//   const _MainScreen({
//     required this.service,
//     required this.unreadNotifs,
//     required this.unreadMessages,
//     required this.onRefresh,
//   });

//   @override
//   State<_MainScreen> createState() => _MainScreenState();
// }

// class _MainScreenState extends State<_MainScreen> {
//   int _selectedTab = 0;
//   final _searchCtrl = TextEditingController();
//   AppUser? _searchResult;
//   bool _searching = false;

//   @override
//   Widget build(BuildContext context) {
//     return Column(
//       children: [
//         // HEADER
//         _buildHeader(),
        
//         // SEARCH BAR
//         _buildSearchBar(),
        
//         // TAB NAVIGATION
//         _buildTabNav(),
        
//         // CONTENT
//         Expanded(child: _buildContent()),
//       ],
//     );
//   }

//   Widget _buildHeader() {
//     return Container(
//       padding: const EdgeInsets.fromLTRB(20, 16, 20, 12),
//       decoration: BoxDecoration(
//         border: Border(bottom: BorderSide(color: GameTheme.border.withOpacity(0.3))),
//       ),
//       child: Row(
//         children: [
//           // Logo
//           Container(
//             padding: const EdgeInsets.all(10),
//             decoration: BoxDecoration(
//               gradient: GameTheme.gradientGold,
//               borderRadius: BorderRadius.circular(12),
//               boxShadow: [
//                 BoxShadow(
//                   color: GameTheme.gold.withOpacity(0.3),
//                   blurRadius: 15,
//                   spreadRadius: 1,
//                 ),
//               ],
//             ),
//             child: const Text(
//               '♛',
//               style: TextStyle(fontSize: 24, color: Colors.black),
//             ),
//           ),
//           const SizedBox(width: 12),
//           const Expanded(
//             child: Column(
//               crossAxisAlignment: CrossAxisAlignment.start,
//               children: [
//                 Text(
//                   'SOCIAL HUB',
//                   style: TextStyle(
//                     color: GameTheme.textPrimary,
//                     fontSize: 18,
//                     fontWeight: FontWeight.w800,
//                     letterSpacing: 2,
//                   ),
//                 ),
//                 Text(
//                   'Connect & Conquer',
//                   style: TextStyle(
//                     color: GameTheme.gold,
//                     fontSize: 11,
//                     fontWeight: FontWeight.w600,
//                     letterSpacing: 1,
//                   ),
//                 ),
//               ],
//             ),
//           ),
//           // Notifications
//           _buildIconBadge(
//             icon: Icons.notifications_outlined,
//             count: widget.unreadNotifs,
//             onTap: () => _showNotifications(),
//           ),
//           const SizedBox(width: 12),
//           // Messages
//           _buildIconBadge(
//             icon: Icons.messenger_outline,
//             count: widget.unreadMessages,
//             onTap: () => setState(() => _selectedTab = 1),
//           ),
//         ],
//       ),
//     );
//   }

//   Widget _buildIconBadge({required IconData icon, required int count, required VoidCallback onTap}) {
//     return GestureDetector(
//       onTap: onTap,
//       child: Container(
//         width: 44,
//         height: 44,
//         decoration: BoxDecoration(
//           color: GameTheme.card,
//           borderRadius: BorderRadius.circular(12),
//           border: Border.all(color: GameTheme.border.withOpacity(0.5)),
//         ),
//         child: Stack(
//           children: [
//             Center(child: Icon(icon, color: GameTheme.textPrimary, size: 22)),
//             if (count > 0)
//               Positioned(
//                 right: 6,
//                 top: 6,
//                 child: Container(
//                   padding: const EdgeInsets.all(4),
//                   decoration: const BoxDecoration(
//                     color: GameTheme.red,
//                     shape: BoxShape.circle,
//                   ),
//                   child: Text(
//                     count > 99 ? '99+' : '$count',
//                     style: const TextStyle(
//                       color: Colors.white,
//                       fontSize: 8,
//                       fontWeight: FontWeight.w800,
//                     ),
//                   ),
//                 ),
//               ),
//           ],
//         ),
//       ),
//     );
//   }

//   Widget _buildSearchBar() {
//     return Container(
//       margin: const EdgeInsets.fromLTRB(20, 12, 20, 0),
//       decoration: GameTheme.cardDecoration.copyWith(
//         borderRadius: BorderRadius.circular(16),
//       ),
//       child: Row(
//         children: [
//           const SizedBox(width: 16),
//           const Icon(Icons.search, color: GameTheme.gold, size: 22),
//           const SizedBox(width: 12),
//           Expanded(
//             child: TextField(
//               controller: _searchCtrl,
//               style: const TextStyle(color: GameTheme.textPrimary, fontSize: 14),
//               decoration: const InputDecoration(
//                 hintText: 'Search players by ID...',
//                 hintStyle: TextStyle(color: GameTheme.textSecondary, fontSize: 13),
//                 border: InputBorder.none,
//               ),
//               // onSubmitted: _sear,
//               onSubmitted: (_) async => _search(),
//             ),
//           ),
//           if (_searching)
//             const Padding(
//               padding: EdgeInsets.all(12),
//               child: SizedBox(
//                 width: 20,
//                 height: 20,
//                 child: CircularProgressIndicator(
//                   strokeWidth: 2,
//                   color: GameTheme.gold,
//                 ),
//               ),
//             )
//           else
//             Container(
//               margin: const EdgeInsets.all(8),
//               decoration: BoxDecoration(
//                 gradient: GameTheme.gradientGold,
//                 borderRadius: BorderRadius.circular(12),
//               ),
//               child: IconButton(
//                 icon: const Icon(Icons.search, color: Colors.black, size: 20),
//                 onPressed: _search,
//               ),
//             ),
//         ],
//       ),
//     );
//   }

//   Widget _buildTabNav() {
//     final tabs = [
//       _TabData('FRIENDS', Icons.people, 0),
//       _TabData('CHATS', Icons.messenger, 1),
//       _TabData('REQUESTS', Icons.person_add, 2),
//       _TabData('DISCOVER', Icons.explore, 3),
//     ];

//     return Container(
//       margin: const EdgeInsets.fromLTRB(20, 16, 20, 0),
//       height: 50,
//       child: Row(
//         children: tabs.map((tab) {
//           final isSelected = _selectedTab == tab.index;
//           return Expanded(
//             child: GestureDetector(
//               onTap: () => setState(() => _selectedTab = tab.index),
//               child: AnimatedContainer(
//                 duration: const Duration(milliseconds: 200),
//                 margin: const EdgeInsets.symmetric(horizontal: 4),
//                 decoration: BoxDecoration(
//                   gradient: isSelected ? GameTheme.gradientGold : null,
//                   color: isSelected ? null : GameTheme.card,
//                   borderRadius: BorderRadius.circular(12),
//                   border: isSelected ? null : Border.all(color: GameTheme.border.withOpacity(0.5)),
//                   boxShadow: isSelected
//                       ? [BoxShadow(color: GameTheme.gold.withOpacity(0.3), blurRadius: 8, spreadRadius: 0)]
//                       : null,
//                 ),
//                 child: Column(
//                   mainAxisAlignment: MainAxisAlignment.center,
//                   children: [
//                     Icon(
//                       tab.icon,
//                       color: isSelected ? Colors.black : GameTheme.textSecondary,
//                       size: 20,
//                     ),
//                     const SizedBox(height: 2),
//                     Text(
//                       tab.label,
//                       style: TextStyle(
//                         color: isSelected ? Colors.black : GameTheme.textSecondary,
//                         fontSize: 9,
//                         fontWeight: FontWeight.w700,
//                         letterSpacing: 0.5,
//                       ),
//                     ),
//                   ],
//                 ),
//               ),
//             ),
//           );
//         }).toList(),
//       ),
//     );
//   }

//   Widget _buildContent() {
//     // Search result overlay
//     if (_searchResult != null) {
//       return _buildSearchResult();
//     }

//     switch (_selectedTab) {
//       case 0:
//         return _FriendsTab(service: widget.service);
//       case 1:
//         return _ChatsTab(service: widget.service);
//       case 2:
//         return _RequestsTab(service: widget.service, onRefresh: widget.onRefresh);
//       case 3:
//         return _DiscoverTab(service: widget.service);
//       default:
//         return const SizedBox();
//     }
//   }

//   Widget _buildSearchResult() {
//     final user = _searchResult!;
//     return Container(
//       margin: const EdgeInsets.all(20),
//       padding: const EdgeInsets.all(20),
//       decoration: GameTheme.cardDecoration,
//       child: Column(
//         mainAxisSize: MainAxisSize.min,
//         children: [
//           Row(
//             mainAxisAlignment: MainAxisAlignment.spaceBetween,
//             children: [
//               const Text(
//                 'SEARCH RESULT',
//                 style: TextStyle(
//                   color: GameTheme.gold,
//                   fontSize: 12,
//                   fontWeight: FontWeight.w700,
//                   letterSpacing: 2,
//                 ),
//               ),
//               IconButton(
//                 icon: const Icon(Icons.close, color: GameTheme.textSecondary),
//                 onPressed: () {
//                   setState(() {
//                     _searchResult = null;
//                     _searchCtrl.clear();
//                   });
//                 },
//               ),
//             ],
//           ),
//           const SizedBox(height: 20),
//           // Avatar
//           Container(
//             width: 80,
//             height: 80,
//             decoration: BoxDecoration(
//               shape: BoxShape.circle,
//               border: Border.all(color: GameTheme.gold, width: 2),
//               boxShadow: [BoxShadow(color: GameTheme.gold.withOpacity(0.3), blurRadius: 15)],
//             ),
//             child: ClipOval(
//               child: user.imageUrl != null
//                   ? Image.network(user.imageUrl!, fit: BoxFit.cover, errorBuilder: (_, __, ___) => _buildAvatarPlaceholder(user))
//                   : _buildAvatarPlaceholder(user),
//             ),
//           ),
//           const SizedBox(height: 16),
//           Text(
//             user.displayName,
//             style: const TextStyle(
//               color: GameTheme.textPrimary,
//               fontSize: 20,
//               fontWeight: FontWeight.w800,
//             ),
//           ),
//           const SizedBox(height: 4),
//           Container(
//             padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
//             decoration: BoxDecoration(
//               color: GameTheme.border.withOpacity(0.3),
//               borderRadius: BorderRadius.circular(8),
//             ),
//             child: Row(
//               mainAxisSize: MainAxisSize.min,
//               children: [
//                 const Icon(Icons.tag, size: 14, color: GameTheme.gold),
//                 const SizedBox(width: 4),
//                 Text(
//                   user.shortId,
//                   style: const TextStyle(color: GameTheme.gold, fontSize: 13),
//                 ),
//               ],
//             ),
//           ),
//           const SizedBox(height: 20),
//           GestureDetector(
//             onTap: () => _sendRequest(user),
//             child: Container(
//               width: double.infinity,
//               padding: const EdgeInsets.symmetric(vertical: 14),
//               decoration: BoxDecoration(
//                 gradient: GameTheme.gradientGold,
//                 borderRadius: BorderRadius.circular(12),
//                 boxShadow: [BoxShadow(color: GameTheme.gold.withOpacity(0.3), blurRadius: 10)],
//               ),
//               child: const Center(
//                 child: Text(
//                   'SEND FRIEND REQUEST',
//                   style: TextStyle(
//                     color: Colors.black,
//                     fontWeight: FontWeight.w800,
//                     fontSize: 14,
//                     letterSpacing: 1,
//                   ),
//                 ),
//               ),
//             ),
//           ),
//         ],
//       ),
//     );
//   }

//   Widget _buildAvatarPlaceholder(AppUser user) {
//     return Container(
//       color: GameTheme.purple,
//       child: Center(
//         child: Text(
//           user.displayName[0].toUpperCase(),
//           style: const TextStyle(
//             color: Colors.white,
//             fontSize: 32,
//             fontWeight: FontWeight.w800,
//           ),
//         ),
//       ),
//     );
//   }

//   Future<void> _search() async {
//     final q = _searchCtrl.text.trim();
//     if (q.isEmpty) return;
//     setState(() => _searching = true);
//     final user = await widget.service.searchUser(q);
//     setState(() {
//       _searching = false;
//       _searchResult = user;
//     });
//   }

//   Future<void> _sendRequest(AppUser user) async {
//     final err = await widget.service.sendFriendRequest(user.authUserId);
//     if (!mounted) return;
//     ScaffoldMessenger.of(context).showSnackBar(
//       SnackBar(
//         content: Text(
//           err ?? 'Friend request sent! 🎮',
//           style: const TextStyle(color: Colors.white),
//         ),
//         backgroundColor: err != null ? GameTheme.red : GameTheme.green,
//         behavior: SnackBarBehavior.floating,
//         shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
//       ),
//     );
//     if (err == null) {
//       setState(() {
//         _searchResult = null;
//         _searchCtrl.clear();
//       });
//     }
//   }

//   void _showNotifications() {
//     showModalBottomSheet(
//       context: context,
//       backgroundColor: Colors.transparent,
//       builder: (_) => _NotificationsPanel(service: widget.service),
//     );
//   }
// }

// // ─────────────────────────────────────────────
// // FRIENDS TAB
// // ─────────────────────────────────────────────

// class _FriendsTab extends StatefulWidget {
//   final FriendService service;
//   const _FriendsTab({required this.service});

//   @override
//   State<_FriendsTab> createState() => _FriendsTabState();
// }

// class _FriendsTabState extends State<_FriendsTab> {
//   List<AppUser> _friends = [];
//   bool _loading = true;

//   @override
//   void initState() {
//     super.initState();
//     _load();
//   }

//   Future<void> _load() async {
//     setState(() => _loading = true);
//     final f = await widget.service.getFriends();
//     if (mounted) setState(() { _friends = f; _loading = false; });
//   }

//   @override
//   Widget build(BuildContext context) {
//     if (_loading) {
//       return const Center(child: CircularProgressIndicator(color: GameTheme.gold));
//     }

//     if (_friends.isEmpty) {
//       return Center(
//         child: Column(
//           mainAxisAlignment: MainAxisAlignment.center,
//           children: [
//             Container(
//               padding: const EdgeInsets.all(30),
//               decoration: BoxDecoration(
//                 shape: BoxShape.circle,
//                 border: Border.all(color: GameTheme.border, width: 2),
//               ),
//               child: const Icon(Icons.people_outline, size: 60, color: GameTheme.textSecondary),
//             ),
//             const SizedBox(height: 24),
//             const Text(
//               'NO FRIENDS YET',
//               style: TextStyle(
//                 color: GameTheme.textSecondary,
//                 fontSize: 18,
//                 fontWeight: FontWeight.w700,
//                 letterSpacing: 2,
//               ),
//             ),
//             const SizedBox(height: 8),
//             const Text(
//               'Search for players and add them!',
//               style: TextStyle(color: GameTheme.textSecondary, fontSize: 14),
//             ),
//           ],
//         ),
//       );
//     }

//     return RefreshIndicator(
//       onRefresh: _load,
//       color: GameTheme.gold,
//       child: ListView.builder(
//         padding: const EdgeInsets.all(20),
//         itemCount: _friends.length,
//         itemBuilder: (_, i) => _FriendCard(
//           user: _friends[i],
//           service: widget.service,
//           onRemove: _load,
//         ),
//       ),
//     );
//   }
// }

// class _FriendCard extends StatelessWidget {
//   final AppUser user;
//   final FriendService service;
//   final VoidCallback onRemove;

//   const _FriendCard({required this.user, required this.service, required this.onRemove});

//   @override
//   Widget build(BuildContext context) {
//     return Container(
//       margin: const EdgeInsets.only(bottom: 12),
//       decoration: GameTheme.cardDecoration,
//       child: Padding(
//         padding: const EdgeInsets.all(16),
//         child: Row(
//           children: [
//             // Avatar with online indicator
//             Stack(
//               children: [
//                 Container(
//                   width: 52,
//                   height: 52,
//                   decoration: BoxDecoration(
//                     shape: BoxShape.circle,
//                     border: Border.all(
//                       color: user.isOnline ? GameTheme.green : GameTheme.border,
//                       width: 2,
//                     ),
//                     boxShadow: [
//                       if (user.isOnline)
//                         BoxShadow(
//                           color: GameTheme.green.withOpacity(0.3),
//                           blurRadius: 10,
//                           spreadRadius: 1,
//                         ),
//                     ],
//                   ),
//                   child: ClipOval(
//                     child: user.imageUrl != null
//                         ? Image.network(user.imageUrl!, fit: BoxFit.cover)
//                         : Container(
//                             color: GameTheme.purple,
//                             child: Center(
//                               child: Text(
//                                 user.displayName[0].toUpperCase(),
//                                 style: const TextStyle(color: Colors.white, fontSize: 22, fontWeight: FontWeight.w800),
//                               ),
//                             ),
//                           ),
//                   ),
//                 ),
//                 if (user.isOnline)
//                   Positioned(
//                     right: 0,
//                     bottom: 0,
//                     child: Container(
//                       width: 14,
//                       height: 14,
//                       decoration: BoxDecoration(
//                         color: GameTheme.green,
//                         shape: BoxShape.circle,
//                         border: Border.all(color: GameTheme.card, width: 2),
//                       ),
//                     ),
//                   ),
//               ],
//             ),
//             const SizedBox(width: 14),
//             // Info
//             Expanded(
//               child: Column(
//                 crossAxisAlignment: CrossAxisAlignment.start,
//                 children: [
//                   Text(
//                     user.displayName,
//                     style: const TextStyle(
//                       color: GameTheme.textPrimary,
//                       fontSize: 15,
//                       fontWeight: FontWeight.w700,
//                     ),
//                   ),
//                   const SizedBox(height: 4),
//                   Row(
//                     children: [
//                       Container(
//                         padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
//                         decoration: BoxDecoration(
//                           color: user.isOnline
//                               ? GameTheme.green.withOpacity(0.15)
//                               : GameTheme.border.withOpacity(0.5),
//                           borderRadius: BorderRadius.circular(4),
//                         ),
//                         child: Text(
//                           user.isOnline ? 'ONLINE' : 'OFFLINE',
//                           style: TextStyle(
//                             color: user.isOnline ? GameTheme.green : GameTheme.textSecondary,
//                             fontSize: 9,
//                             fontWeight: FontWeight.w700,
//                             letterSpacing: 1,
//                           ),
//                         ),
//                       ),
//                       const SizedBox(width: 8),
//                       Text(
//                         'ID: ${user.shortId}',
//                         style: const TextStyle(color: GameTheme.textSecondary, fontSize: 11),
//                       ),
//                     ],
//                   ),
//                 ],
//               ),
//             ),
//             // Actions
//             Row(
//               children: [
//                 _actionButton(
//                   icon: Icons.sports_esports,
//                   color: GameTheme.gold,
//                   onTap: () {
//                     ScaffoldMessenger.of(context).showSnackBar(
//                       SnackBar(
//                         content: Text('Inviting ${user.displayName} to match...'),
//                         backgroundColor: GameTheme.goldDark,
//                       ),
//                     );
//                   },
//                 ),
//                 const SizedBox(width: 8),
//                 _actionButton(
//                   icon: Icons.message,
//                   color: GameTheme.blue,
//                   onTap: () {
//                     // Navigate to chat
//                     Navigator.push(
//                       context,
//                       MaterialPageRoute(
//                         builder: (_) => _ChatScreen(
//                           service: service,
//                           otherUser: user,
//                         ),
//                       ),
//                     );
//                   },
//                 ),
//                 const SizedBox(width: 8),
//                 _actionButton(
//                   icon: Icons.person_remove,
//                   color: GameTheme.red,
//                   onTap: () => _confirmRemove(context),
//                 ),
//               ],
//             ),
//           ],
//         ),
//       ),
//     );
//   }

//   Widget _actionButton({required IconData icon, required Color color, required VoidCallback onTap}) {
//     return GestureDetector(
//       onTap: onTap,
//       child: Container(
//         width: 36,
//         height: 36,
//         decoration: BoxDecoration(
//           color: color.withOpacity(0.15),
//           borderRadius: BorderRadius.circular(10),
//           border: Border.all(color: color.withOpacity(0.3)),
//         ),
//         child: Icon(icon, color: color, size: 18),
//       ),
//     );
//   }

//   void _confirmRemove(BuildContext context) {
//     showDialog(
//       context: context,
//       builder: (_) => AlertDialog(
//         backgroundColor: GameTheme.card,
//         shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
//         title: const Text('Remove Friend', style: TextStyle(color: GameTheme.textPrimary)),
//         content: Text(
//           'Remove ${user.displayName} from friends?',
//           style: const TextStyle(color: GameTheme.textSecondary),
//         ),
//         actions: [
//           TextButton(
//             onPressed: () => Navigator.pop(context),
//             child: const Text('Cancel', style: TextStyle(color: GameTheme.textSecondary)),
//           ),
//           TextButton(
//             onPressed: () async {
//               Navigator.pop(context);
//               await service.removeFriend(user.authUserId);
//               onRemove();
//             },
//             child: const Text('Remove', style: TextStyle(color: GameTheme.red)),
//           ),
//         ],
//       ),
//     );
//   }
// }

// // ─────────────────────────────────────────────
// // CHATS TAB
// // ─────────────────────────────────────────────

// class _ChatsTab extends StatefulWidget {
//   final FriendService service;
//   const _ChatsTab({required this.service});

//   @override
//   State<_ChatsTab> createState() => _ChatsTabState();
// }

// class _ChatsTabState extends State<_ChatsTab> {
//   List<AppUser> _friends = [];
//   bool _loading = true;

//   @override
//   void initState() {
//     super.initState();
//     _load();
//   }

//   Future<void> _load() async {
//     setState(() => _loading = true);
//     final f = await widget.service.getFriends();
//     if (mounted) setState(() { _friends = f; _loading = false; });
//   }

//   @override
//   Widget build(BuildContext context) {
//     if (_loading) {
//       return const Center(child: CircularProgressIndicator(color: GameTheme.gold));
//     }

//     if (_friends.isEmpty) {
//       return Center(
//         child: Column(
//           mainAxisAlignment: MainAxisAlignment.center,
//           children: [
//             Container(
//               padding: const EdgeInsets.all(30),
//               decoration: BoxDecoration(
//                 shape: BoxShape.circle,
//                 border: Border.all(color: GameTheme.border, width: 2),
//               ),
//               child: const Icon(Icons.messenger_outline, size: 60, color: GameTheme.textSecondary),
//             ),
//             const SizedBox(height: 24),
//             const Text(
//               'NO CONVERSATIONS',
//               style: TextStyle(
//                 color: GameTheme.textSecondary,
//                 fontSize: 18,
//                 fontWeight: FontWeight.w700,
//                 letterSpacing: 2,
//               ),
//             ),
//             const SizedBox(height: 8),
//             const Text(
//               'Add friends to start chatting!',
//               style: TextStyle(color: GameTheme.textSecondary, fontSize: 14),
//             ),
//           ],
//         ),
//       );
//     }

//     return ListView.builder(
//       padding: const EdgeInsets.all(20),
//       itemCount: _friends.length,
//       itemBuilder: (_, i) => _ChatPreviewCard(
//         user: _friends[i],
//         service: widget.service,
//       ),
//     );
//   }
// }

// class _ChatPreviewCard extends StatelessWidget {
//   final AppUser user;
//   final FriendService service;

//   const _ChatPreviewCard({required this.user, required this.service});

//   @override
//   Widget build(BuildContext context) {
//     return GestureDetector(
//       onTap: () {
//         Navigator.push(
//           context,
//           MaterialPageRoute(
//             builder: (_) => _ChatScreen(service: service, otherUser: user),
//           ),
//         );
//       },
//       child: Container(
//         margin: const EdgeInsets.only(bottom: 10),
//         decoration: GameTheme.cardDecoration,
//         child: Padding(
//           padding: const EdgeInsets.all(16),
//           child: Row(
//             children: [
//               Stack(
//                 children: [
//                   Container(
//                     width: 50,
//                     height: 50,
//                     decoration: BoxDecoration(
//                       shape: BoxShape.circle,
//                       border: Border.all(color: GameTheme.gold.withOpacity(0.3)),
//                     ),
//                     child: ClipOval(
//                       child: user.imageUrl != null
//                           ? Image.network(user.imageUrl!, fit: BoxFit.cover)
//                           : Container(
//                               color: GameTheme.purple,
//                               child: Center(
//                                 child: Text(
//                                   user.displayName[0].toUpperCase(),
//                                   style: const TextStyle(color: Colors.white, fontSize: 20, fontWeight: FontWeight.w800),
//                                 ),
//                               ),
//                             ),
//                     ),
//                   ),
//                   if (user.isOnline)
//                     Positioned(
//                       right: 0,
//                       bottom: 0,
//                       child: Container(
//                         width: 14,
//                         height: 14,
//                         decoration: BoxDecoration(
//                           color: GameTheme.green,
//                           shape: BoxShape.circle,
//                           border: Border.all(color: GameTheme.card, width: 2),
//                         ),
//                       ),
//                     ),
//                 ],
//               ),
//               const SizedBox(width: 14),
//               Expanded(
//                 child: Column(
//                   crossAxisAlignment: CrossAxisAlignment.start,
//                   children: [
//                     Text(
//                       user.displayName,
//                       style: const TextStyle(
//                         color: GameTheme.textPrimary,
//                         fontSize: 15,
//                         fontWeight: FontWeight.w700,
//                       ),
//                     ),
//                     const SizedBox(height: 4),
//                     Text(
//                       'Tap to open chat',
//                       style: TextStyle(
//                         color: GameTheme.textSecondary.withOpacity(0.7),
//                         fontSize: 12,
//                       ),
//                     ),
//                   ],
//                 ),
//               ),
//               const Icon(Icons.chevron_right, color: GameTheme.textSecondary),
//             ],
//           ),
//         ),
//       ),
//     );
//   }
// }

// // ─────────────────────────────────────────────
// // CHAT SCREEN - INDIVIDUAL CHAT
// // ─────────────────────────────────────────────

// class _ChatScreen extends StatefulWidget {
//   final FriendService service;
//   final AppUser otherUser;

//   const _ChatScreen({required this.service, required this.otherUser});

//   @override
//   State<_ChatScreen> createState() => _ChatScreenState();
// }

// class _ChatScreenState extends State<_ChatScreen> {
//   final _msgCtrl = TextEditingController();
//   List<Message> _messages = [];
//   bool _loading = true;
//   late RealtimeChannel _msgChannel;
//   final _scrollCtrl = ScrollController();

//   @override
//   void initState() {
//     super.initState();
//     _loadMessages();
//     _msgChannel = widget.service.subscribeToMessages(
//       widget.otherUser.authUserId,
//       (msg) {
//         if (mounted) {
//           setState(() => _messages.add(msg));
//           _scrollToBottom();
//         }
//       },
//     );
//   }

//   Future<void> _loadMessages() async {
//     final msgs = await widget.service.getMessages(widget.otherUser.authUserId);
//     if (mounted) {
//       setState(() {
//         _messages = msgs;
//         _loading = false;
//       });
//       _scrollToBottom();
//     }
//   }

//   void _scrollToBottom() {
//     Future.delayed(const Duration(milliseconds: 100), () {
//       if (_scrollCtrl.hasClients) {
//         _scrollCtrl.animateTo(
//           _scrollCtrl.position.maxScrollExtent,
//           duration: const Duration(milliseconds: 300),
//           curve: Curves.easeOut,
//         );
//       }
//     });
//   }

//   Future<void> _send() async {
//     final text = _msgCtrl.text.trim();
//     if (text.isEmpty) return;
//     await widget.service.sendMessage(widget.otherUser.authUserId, text);
//     _msgCtrl.clear();
//   }

//   @override
//   void dispose() {
//     _msgChannel.unsubscribe();
//     _msgCtrl.dispose();
//     _scrollCtrl.dispose();
//     super.dispose();
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       body: Container(
//         decoration: BoxDecoration(gradient: GameTheme.gradientBg),
//         child: SafeArea(
//           child: Column(
//             children: [
//               // Chat header
//               Container(
//                 padding: const EdgeInsets.all(16),
//                 decoration: BoxDecoration(
//                   color: GameTheme.card,
//                   border: Border(bottom: BorderSide(color: GameTheme.border.withOpacity(0.3))),
//                 ),
//                 child: Row(
//                   children: [
//                     IconButton(
//                       icon: const Icon(Icons.arrow_back, color: GameTheme.textPrimary),
//                       onPressed: () => Navigator.pop(context),
//                     ),
//                     const SizedBox(width: 8),
//                     Container(
//                       width: 42,
//                       height: 42,
//                       decoration: BoxDecoration(
//                         shape: BoxShape.circle,
//                         border: Border.all(
//                           color: widget.otherUser.isOnline ? GameTheme.green : GameTheme.border,
//                           width: 2,
//                         ),
//                       ),
//                       child: ClipOval(
//                         child: widget.otherUser.imageUrl != null
//                             ? Image.network(widget.otherUser.imageUrl!, fit: BoxFit.cover)
//                             : Container(
//                                 color: GameTheme.purple,
//                                 child: Center(
//                                   child: Text(
//                                     widget.otherUser.displayName[0].toUpperCase(),
//                                     style: const TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.w800),
//                                   ),
//                                 ),
//                               ),
//                       ),
//                     ),
//                     const SizedBox(width: 12),
//                     Expanded(
//                       child: Column(
//                         crossAxisAlignment: CrossAxisAlignment.start,
//                         children: [
//                           Text(
//                             widget.otherUser.displayName,
//                             style: const TextStyle(
//                               color: GameTheme.textPrimary,
//                               fontSize: 16,
//                               fontWeight: FontWeight.w700,
//                             ),
//                           ),
//                           Text(
//                             widget.otherUser.isOnline ? 'Online' : 'Offline',
//                             style: TextStyle(
//                               color: widget.otherUser.isOnline ? GameTheme.green : GameTheme.textSecondary,
//                               fontSize: 12,
//                             ),
//                           ),
//                         ],
//                       ),
//                     ),
//                     Container(
//                       padding: const EdgeInsets.all(10),
//                       decoration: BoxDecoration(
//                         gradient: GameTheme.gradientGold,
//                         borderRadius: BorderRadius.circular(12),
//                       ),
//                       child: const Icon(Icons.sports_esports, color: Colors.black, size: 20),
//                     ),
//                   ],
//                 ),
//               ),
//               // Messages
//               Expanded(
//                 child: _loading
//                     ? const Center(child: CircularProgressIndicator(color: GameTheme.gold))
//                     : ListView.builder(
//                         controller: _scrollCtrl,
//                         padding: const EdgeInsets.all(16),
//                         itemCount: _messages.length,
//                         itemBuilder: (_, i) => _MessageBubble(
//                           message: _messages[i],
//                           isMe: _messages[i].senderId == widget.service.currentUserId,
//                         ),
//                       ),
//               ),
//               // Input
//               Container(
//                 padding: const EdgeInsets.all(12),
//                 decoration: BoxDecoration(
//                   color: GameTheme.card,
//                   border: Border(top: BorderSide(color: GameTheme.border.withOpacity(0.3))),
//                 ),
//                 child: Row(
//                   children: [
//                     Expanded(
//                       child: Container(
//                         decoration: BoxDecoration(
//                           color: GameTheme.surface,
//                           borderRadius: BorderRadius.circular(25),
//                           border: Border.all(color: GameTheme.border.withOpacity(0.5)),
//                         ),
//                         child: TextField(
//                           controller: _msgCtrl,
//                           style: const TextStyle(color: GameTheme.textPrimary),
//                           decoration: const InputDecoration(
//                             hintText: 'Type a message...',
//                             hintStyle: TextStyle(color: GameTheme.textSecondary),
//                             border: InputBorder.none,
//                             contentPadding: EdgeInsets.symmetric(horizontal: 20, vertical: 14),
//                           ),
//                           onSubmitted: (_) => _send(),
//                         ),
//                       ),
//                     ),
//                     const SizedBox(width: 8),
//                     GestureDetector(
//                       onTap: _send,
//                       child: Container(
//                         padding: const EdgeInsets.all(14),
//                         decoration: BoxDecoration(
//                           gradient: GameTheme.gradientGold,
//                           shape: BoxShape.circle,
//                           boxShadow: [BoxShadow(color: GameTheme.gold.withOpacity(0.3), blurRadius: 8)],
//                         ),
//                         child: const Icon(Icons.send, color: Colors.black, size: 20),
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

// class _MessageBubble extends StatelessWidget {
//   final Message message;
//   final bool isMe;

//   const _MessageBubble({required this.message, required this.isMe});

//   @override
//   Widget build(BuildContext context) {
//     return Align(
//       alignment: isMe ? Alignment.centerRight : Alignment.centerLeft,
//       child: Container(
//         margin: const EdgeInsets.only(bottom: 8),
//         constraints: BoxConstraints(maxWidth: MediaQuery.of(context).size.width * 0.75),
//         padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
//         decoration: BoxDecoration(
//           gradient: isMe ? GameTheme.gradientGold : null,
//           color: isMe ? null : GameTheme.card,
//           borderRadius: BorderRadius.only(
//             topLeft: const Radius.circular(16),
//             topRight: const Radius.circular(16),
//             bottomLeft: isMe ? const Radius.circular(16) : Radius.zero,
//             bottomRight: isMe ? Radius.zero : const Radius.circular(16),
//           ),
//           border: isMe ? null : Border.all(color: GameTheme.border.withOpacity(0.3)),
//         ),
//         child: Column(
//           crossAxisAlignment: isMe ? CrossAxisAlignment.end : CrossAxisAlignment.start,
//           children: [
//             Text(
//               message.content,
//               style: TextStyle(
//                 color: isMe ? Colors.black : GameTheme.textPrimary,
//                 fontSize: 14,
//               ),
//             ),
//             const SizedBox(height: 4),
//             Text(
//               DateFormat('HH:mm').format(message.createdAt),
//               style: TextStyle(
//                 color: isMe ? Colors.black54 : GameTheme.textSecondary,
//                 fontSize: 10,
//               ),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }

// // ─────────────────────────────────────────────
// // REQUESTS TAB (INCOMING + SENT)
// // ─────────────────────────────────────────────

// class _RequestsTab extends StatefulWidget {
//   final FriendService service;
//   final VoidCallback onRefresh;

//   const _RequestsTab({required this.service, required this.onRefresh});

//   @override
//   State<_RequestsTab> createState() => _RequestsTabState();
// }

// class _RequestsTabState extends State<_RequestsTab> with SingleTickerProviderStateMixin {
//   late TabController _tabs;
//   bool _loading = true;

//   @override
//   void initState() {
//     super.initState();
//     _tabs = TabController(length: 2, vsync: this);
//     Future.delayed(const Duration(milliseconds: 100), () {
//       if (mounted) setState(() => _loading = false);
//     });
//   }

//   @override
//   void dispose() {
//     _tabs.dispose();
//     super.dispose();
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Column(
//       children: [
//         Container(
//           margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
//           height: 40,
//           decoration: BoxDecoration(
//             color: GameTheme.card,
//             borderRadius: BorderRadius.circular(12),
//           ),
//           child: TabBar(
//             controller: _tabs,
//             indicator: BoxDecoration(
//               gradient: GameTheme.gradientGold,
//               borderRadius: BorderRadius.circular(10),
//             ),
//             indicatorSize: TabBarIndicatorSize.tab,
//             labelColor: Colors.black,
//             unselectedLabelColor: GameTheme.textSecondary,
//             labelStyle: const TextStyle(fontWeight: FontWeight.w700, fontSize: 12, letterSpacing: 1),
//             tabs: const [
//               Tab(text: 'RECEIVED'),
//               Tab(text: 'SENT'),
//             ],
//           ),
//         ),
//         Expanded(
//           child: TabBarView(
//             controller: _tabs,
//             children: [
//               _IncomingRequestsList(service: widget.service, onRefresh: widget.onRefresh),
//               _SentRequestsList(service: widget.service, onRefresh: widget.onRefresh),
//             ],
//           ),
//         ),
//       ],
//     );
//   }
// }

// class _IncomingRequestsList extends StatefulWidget {
//   final FriendService service;
//   final VoidCallback onRefresh;

//   const _IncomingRequestsList({required this.service, required this.onRefresh});

//   @override
//   State<_IncomingRequestsList> createState() => _IncomingRequestsListState();
// }

// class _IncomingRequestsListState extends State<_IncomingRequestsList> {
//   List<FriendRequest> _requests = [];
//   bool _loading = true;

//   @override
//   void initState() {
//     super.initState();
//     _load();
//   }

//   Future<void> _load() async {
//     setState(() => _loading = true);
//     final r = await widget.service.getIncomingRequests();
//     if (mounted) setState(() { _requests = r; _loading = false; });
//   }

//   @override
//   Widget build(BuildContext context) {
//     if (_loading) {
//       return const Center(child: CircularProgressIndicator(color: GameTheme.gold));
//     }

//     if (_requests.isEmpty) {
//       return Center(
//         child: Column(
//           mainAxisAlignment: MainAxisAlignment.center,
//           children: [
//             Container(
//               padding: const EdgeInsets.all(24),
//               decoration: BoxDecoration(
//                 shape: BoxShape.circle,
//                 border: Border.all(color: GameTheme.border, width: 2),
//               ),
//               child: const Icon(Icons.inbox, size: 40, color: GameTheme.textSecondary),
//             ),
//             const SizedBox(height: 16),
//             const Text(
//               'NO PENDING REQUESTS',
//               style: TextStyle(
//                 color: GameTheme.textSecondary,
//                 fontSize: 14,
//                 fontWeight: FontWeight.w700,
//                 letterSpacing: 2,
//               ),
//             ),
//           ],
//         ),
//       );
//     }

//     return ListView.builder(
//       padding: const EdgeInsets.all(20),
//       itemCount: _requests.length,
//       itemBuilder: (_, i) {
//         final req = _requests[i];
//         final user = req.senderUser;
//         if (user == null) return const SizedBox();
//         return Container(
//           margin: const EdgeInsets.only(bottom: 10),
//           decoration: GameTheme.cardDecoration,
//           child: Padding(
//             padding: const EdgeInsets.all(16),
//             child: Row(
//               children: [
//                 Container(
//                   width: 48,
//                   height: 48,
//                   decoration: BoxDecoration(
//                     shape: BoxShape.circle,
//                     border: Border.all(color: GameTheme.gold.withOpacity(0.3)),
//                   ),
//                   child: ClipOval(
//                     child: user.imageUrl != null
//                         ? Image.network(user.imageUrl!, fit: BoxFit.cover)
//                         : Container(
//                             color: GameTheme.purple,
//                             child: Center(
//                               child: Text(
//                                 user.displayName[0].toUpperCase(),
//                                 style: const TextStyle(color: Colors.white, fontSize: 20, fontWeight: FontWeight.w800),
//                               ),
//                             ),
//                           ),
//                   ),
//                 ),
//                 const SizedBox(width: 12),
//                 Expanded(
//                   child: Column(
//                     crossAxisAlignment: CrossAxisAlignment.start,
//                     children: [
//                       Text(
//                         user.displayName,
//                         style: const TextStyle(color: GameTheme.textPrimary, fontSize: 15, fontWeight: FontWeight.w700),
//                       ),
//                       const SizedBox(height: 2),
//                       Text(
//                         'ID: ${user.shortId}',
//                         style: const TextStyle(color: GameTheme.textSecondary, fontSize: 11),
//                       ),
//                     ],
//                   ),
//                 ),
//                 Column(
//                   children: [
//                     GestureDetector(
//                       onTap: () async {
//                         await widget.service.acceptRequest(req.id, req.senderId);
//                         widget.onRefresh();
//                         _load();
//                       },
//                       child: Container(
//                         padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
//                         decoration: BoxDecoration(
//                           gradient: GameTheme.gradientGold,
//                           borderRadius: BorderRadius.circular(8),
//                         ),
//                         child: const Text(
//                           'ACCEPT',
//                           style: TextStyle(color: Colors.black, fontSize: 11, fontWeight: FontWeight.w800, letterSpacing: 1),
//                         ),
//                       ),
//                     ),
//                     const SizedBox(height: 6),
//                     GestureDetector(
//                       onTap: () async {
//                         await widget.service.rejectRequest(req.id);
//                         _load();
//                       },
//                       child: Container(
//                         padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
//                         decoration: BoxDecoration(
//                           color: GameTheme.red.withOpacity(0.15),
//                           borderRadius: BorderRadius.circular(8),
//                           border: Border.all(color: GameTheme.red.withOpacity(0.3)),
//                         ),
//                         child: const Text(
//                           'DECLINE',
//                           style: TextStyle(color: GameTheme.red, fontSize: 11, fontWeight: FontWeight.w800, letterSpacing: 1),
//                         ),
//                       ),
//                     ),
//                   ],
//                 ),
//               ],
//             ),
//           ),
//         );
//       },
//     );
//   }
// }

// class _SentRequestsList extends StatefulWidget {
//   final FriendService service;
//   final VoidCallback onRefresh;

//   const _SentRequestsList({required this.service, required this.onRefresh});

//   @override
//   State<_SentRequestsList> createState() => _SentRequestsListState();
// }

// class _SentRequestsListState extends State<_SentRequestsList> {
//   List<FriendRequest> _requests = [];
//   bool _loading = true;

//   @override
//   void initState() {
//     super.initState();
//     _load();
//   }

//   Future<void> _load() async {
//     setState(() => _loading = true);
//     final r = await widget.service.getSentRequests();
//     if (mounted) setState(() { _requests = r; _loading = false; });
//   }

//   @override
//   Widget build(BuildContext context) {
//     if (_loading) {
//       return const Center(child: CircularProgressIndicator(color: GameTheme.gold));
//     }

//     if (_requests.isEmpty) {
//       return Center(
//         child: Column(
//           mainAxisAlignment: MainAxisAlignment.center,
//           children: [
//             Container(
//               padding: const EdgeInsets.all(24),
//               decoration: BoxDecoration(
//                 shape: BoxShape.circle,
//                 border: Border.all(color: GameTheme.border, width: 2),
//               ),
//               child: const Icon(Icons.send, size: 40, color: GameTheme.textSecondary),
//             ),
//             const SizedBox(height: 16),
//             const Text(
//               'NO SENT REQUESTS',
//               style: TextStyle(
//                 color: GameTheme.textSecondary,
//                 fontSize: 14,
//                 fontWeight: FontWeight.w700,
//                 letterSpacing: 2,
//               ),
//             ),
//           ],
//         ),
//       );
//     }

//     return ListView.builder(
//       padding: const EdgeInsets.all(20),
//       itemCount: _requests.length,
//       itemBuilder: (_, i) {
//         final req = _requests[i];
//         final user = req.receiverUser;
//         if (user == null) return const SizedBox();
//         return Container(
//           margin: const EdgeInsets.only(bottom: 10),
//           decoration: GameTheme.cardDecoration,
//           child: Padding(
//             padding: const EdgeInsets.all(16),
//             child: Row(
//               children: [
//                 Container(
//                   width: 48,
//                   height: 48,
//                   decoration: BoxDecoration(
//                     shape: BoxShape.circle,
//                     border: Border.all(color: GameTheme.gold.withOpacity(0.3)),
//                   ),
//                   child: ClipOval(
//                     child: user.imageUrl != null
//                         ? Image.network(user.imageUrl!, fit: BoxFit.cover)
//                         : Container(
//                             color: GameTheme.purple,
//                             child: Center(
//                               child: Text(
//                                 user.displayName[0].toUpperCase(),
//                                 style: const TextStyle(color: Colors.white, fontSize: 20, fontWeight: FontWeight.w800),
//                               ),
//                             ),
//                           ),
//                   ),
//                 ),
//                 const SizedBox(width: 12),
//                 Expanded(
//                   child: Column(
//                     crossAxisAlignment: CrossAxisAlignment.start,
//                     children: [
//                       Text(
//                         user.displayName,
//                         style: const TextStyle(color: GameTheme.textPrimary, fontSize: 15, fontWeight: FontWeight.w700),
//                       ),
//                       const SizedBox(height: 2),
//                       Container(
//                         padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
//                         decoration: BoxDecoration(
//                           color: GameTheme.gold.withOpacity(0.15),
//                           borderRadius: BorderRadius.circular(4),
//                         ),
//                         child: const Text(
//                           'PENDING',
//                           style: TextStyle(color: GameTheme.gold, fontSize: 9, fontWeight: FontWeight.w700, letterSpacing: 1),
//                         ),
//                       ),
//                     ],
//                   ),
//                 ),
//                 GestureDetector(
//                   onTap: () async {
//                     await widget.service.cancelRequest(req.id);
//                     widget.onRefresh();
//                     _load();
//                   },
//                   child: Container(
//                     padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
//                     decoration: BoxDecoration(
//                       color: GameTheme.red.withOpacity(0.15),
//                       borderRadius: BorderRadius.circular(8),
//                       border: Border.all(color: GameTheme.red.withOpacity(0.3)),
//                     ),
//                     child: const Text(
//                       'CANCEL',
//                       style: TextStyle(color: GameTheme.red, fontSize: 11, fontWeight: FontWeight.w800, letterSpacing: 1),
//                     ),
//                   ),
//                 ),
//               ],
//             ),
//           ),
//         );
//       },
//     );
//   }
// }

// // ─────────────────────────────────────────────
// // DISCOVER TAB
// // ─────────────────────────────────────────────

// class _DiscoverTab extends StatefulWidget {
//   final FriendService service;
//   const _DiscoverTab({required this.service});

//   @override
//   State<_DiscoverTab> createState() => _DiscoverTabState();
// }

// class _DiscoverTabState extends State<_DiscoverTab> {
//   List<AppUser> _users = [];
//   bool _loading = true;
//   final Set<String> _sent = {};

//   @override
//   void initState() {
//     super.initState();
//     _load();
//   }

//   Future<void> _load() async {
//     setState(() => _loading = true);
//     final u = await widget.service.getSuggestedFriends();
//     if (mounted) setState(() { _users = u; _loading = false; });
//   }

//   @override
//   Widget build(BuildContext context) {
//     if (_loading) {
//       return const Center(child: CircularProgressIndicator(color: GameTheme.gold));
//     }

//     if (_users.isEmpty) {
//       return Center(
//         child: Column(
//           mainAxisAlignment: MainAxisAlignment.center,
//           children: [
//             Container(
//               padding: const EdgeInsets.all(30),
//               decoration: BoxDecoration(
//                 shape: BoxShape.circle,
//                 border: Border.all(color: GameTheme.border, width: 2),
//               ),
//               child: const Icon(Icons.explore, size: 60, color: GameTheme.textSecondary),
//             ),
//             const SizedBox(height: 24),
//             const Text(
//               'NO SUGGESTIONS',
//               style: TextStyle(
//                 color: GameTheme.textSecondary,
//                 fontSize: 18,
//                 fontWeight: FontWeight.w700,
//                 letterSpacing: 2,
//               ),
//             ),
//             const SizedBox(height: 8),
//             const Text(
//               'Check back later!',
//               style: TextStyle(color: GameTheme.textSecondary, fontSize: 14),
//             ),
//           ],
//         ),
//       );
//     }

//     return RefreshIndicator(
//       onRefresh: _load,
//       color: GameTheme.gold,
//       child: ListView.builder(
//         padding: const EdgeInsets.all(20),
//         itemCount: _users.length,
//         itemBuilder: (_, i) {
//           final user = _users[i];
//           final sent = _sent.contains(user.authUserId);
//           return Container(
//             margin: const EdgeInsets.only(bottom: 10),
//             decoration: GameTheme.cardDecoration,
//             child: Padding(
//               padding: const EdgeInsets.all(16),
//               child: Row(
//                 children: [
//                   Container(
//                     width: 48,
//                     height: 48,
//                     decoration: BoxDecoration(
//                       shape: BoxShape.circle,
//                       gradient: GameTheme.gradientPurple,
//                     ),
//                     child: Center(
//                       child: Text(
//                         user.displayName[0].toUpperCase(),
//                         style: const TextStyle(color: Colors.white, fontSize: 22, fontWeight: FontWeight.w800),
//                       ),
//                     ),
//                   ),
//                   const SizedBox(width: 12),
//                   Expanded(
//                     child: Column(
//                       crossAxisAlignment: CrossAxisAlignment.start,
//                       children: [
//                         Text(
//                           user.displayName,
//                           style: const TextStyle(color: GameTheme.textPrimary, fontSize: 15, fontWeight: FontWeight.w700),
//                         ),
//                         const SizedBox(height: 2),
//                         Text(
//                           'ID: ${user.shortId}',
//                           style: const TextStyle(color: GameTheme.textSecondary, fontSize: 11),
//                         ),
//                       ],
//                     ),
//                   ),
//                   GestureDetector(
//                     onTap: sent ? null : () async {
//                       await widget.service.sendFriendRequest(user.authUserId);
//                       setState(() => _sent.add(user.authUserId));
//                     },
//                     child: Container(
//                       padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
//                       decoration: sent
//                           ? BoxDecoration(
//                               color: GameTheme.card,
//                               borderRadius: BorderRadius.circular(8),
//                               border: Border.all(color: GameTheme.border),
//                             )
//                           : BoxDecoration(
//                               gradient: GameTheme.gradientGold,
//                               borderRadius: BorderRadius.circular(8),
//                               boxShadow: [BoxShadow(color: GameTheme.gold.withOpacity(0.3), blurRadius: 8)],
//                             ),
//                       child: Text(
//                         sent ? 'SENT ✓' : 'ADD',
//                         style: TextStyle(
//                           color: sent ? GameTheme.textSecondary : Colors.black,
//                           fontSize: 11,
//                           fontWeight: FontWeight.w800,
//                           letterSpacing: 1,
//                         ),
//                       ),
//                     ),
//                   ),
//                 ],
//               ),
//             ),
//           );
//         },
//       ),
//     );
//   }
// }

// // ─────────────────────────────────────────────
// // NOTIFICATIONS PANEL
// // ─────────────────────────────────────────────

// class _NotificationsPanel extends StatefulWidget {
//   final FriendService service;
//   const _NotificationsPanel({required this.service});

//   @override
//   State<_NotificationsPanel> createState() => _NotificationsPanelState();
// }

// class _NotificationsPanelState extends State<_NotificationsPanel> {
//   List<AppNotification> _notifs = [];
//   bool _loading = true;

//   @override
//   void initState() {
//     super.initState();
//     _load();
//   }

//   Future<void> _load() async {
//     final n = await widget.service.getNotifications();
//     if (mounted) setState(() { _notifs = n; _loading = false; });
//   }

//   IconData _iconFor(String type) {
//     switch (type) {
//       case 'friend_request': return Icons.person_add;
//       case 'request_accepted': return Icons.people;
//       case 'match_invite': return Icons.sports_esports;
//       default: return Icons.notifications;
//     }
//   }

//   Color _colorFor(String type) {
//     switch (type) {
//       case 'friend_request': return GameTheme.gold;
//       case 'request_accepted': return GameTheme.green;
//       case 'match_invite': return GameTheme.blue;
//       default: return GameTheme.purple;
//     }
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Container(
//       height: MediaQuery.of(context).size.height * 0.7,
//       decoration: const BoxDecoration(
//         color: GameTheme.surface,
//         borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
//       ),
//       child: Column(
//         children: [
//           Container(
//             margin: const EdgeInsets.symmetric(vertical: 12),
//             width: 40,
//             height: 4,
//             decoration: BoxDecoration(
//               color: GameTheme.border,
//               borderRadius: BorderRadius.circular(2),
//             ),
//           ),
//           Padding(
//             padding: const EdgeInsets.symmetric(horizontal: 20),
//             child: Row(
//               mainAxisAlignment: MainAxisAlignment.spaceBetween,
//               children: [
//                 const Text(
//                   'NOTIFICATIONS',
//                   style: TextStyle(
//                     color: GameTheme.textPrimary,
//                     fontSize: 18,
//                     fontWeight: FontWeight.w800,
//                     letterSpacing: 2,
//                   ),
//                 ),
//                 TextButton(
//                   onPressed: () async {
//                     for (final n in _notifs.where((n) => !n.isRead)) {
//                       await widget.service.markNotificationRead(n.id);
//                     }
//                     await _load();
//                   },
//                   child: const Text(
//                     'MARK ALL READ',
//                     style: TextStyle(
//                       color: GameTheme.gold,
//                       fontSize: 11,
//                       fontWeight: FontWeight.w700,
//                       letterSpacing: 1,
//                     ),
//                   ),
//                 ),
//               ],
//             ),
//           ),
//           const SizedBox(height: 12),
//           Expanded(
//             child: _loading
//                 ? const Center(child: CircularProgressIndicator(color: GameTheme.gold))
//                 : _notifs.isEmpty
//                     ? Center(
//                         child: Column(
//                           mainAxisAlignment: MainAxisAlignment.center,
//                           children: [
//                             const Icon(Icons.notifications_off, size: 48, color: GameTheme.textSecondary),
//                             const SizedBox(height: 12),
//                             const Text(
//                               'NO NOTIFICATIONS',
//                               style: TextStyle(
//                                 color: GameTheme.textSecondary,
//                                 fontSize: 14,
//                                 fontWeight: FontWeight.w700,
//                                 letterSpacing: 2,
//                               ),
//                             ),
//                           ],
//                         ),
//                       )
//                     : ListView.builder(
//                         padding: const EdgeInsets.symmetric(horizontal: 20),
//                         itemCount: _notifs.length,
//                         itemBuilder: (_, i) {
//                           final n = _notifs[i];
//                           final color = _colorFor(n.type);
//                           return Container(
//                             margin: const EdgeInsets.only(bottom: 8),
//                             padding: const EdgeInsets.all(14),
//                             decoration: BoxDecoration(
//                               color: GameTheme.card,
//                               borderRadius: BorderRadius.circular(12),
//                               border: Border.all(
//                                 color: n.isRead
//                                     ? GameTheme.border.withOpacity(0.3)
//                                     : color.withOpacity(0.5),
//                               ),
//                             ),
//                             child: Row(
//                               children: [
//                                 Container(
//                                   padding: const EdgeInsets.all(10),
//                                   decoration: BoxDecoration(
//                                     color: color.withOpacity(0.15),
//                                     shape: BoxShape.circle,
//                                   ),
//                                   child: Icon(_iconFor(n.type), color: color, size: 20),
//                                 ),
//                                 const SizedBox(width: 12),
//                                 Expanded(
//                                   child: Column(
//                                     crossAxisAlignment: CrossAxisAlignment.start,
//                                     children: [
//                                       Text(
//                                         n.message,
//                                         style: TextStyle(
//                                           color: n.isRead ? GameTheme.textSecondary : GameTheme.textPrimary,
//                                           fontSize: 13,
//                                           fontWeight: FontWeight.w600,
//                                         ),
//                                       ),
//                                       const SizedBox(height: 4),
//                                       Text(
//                                         _timeAgo(n.createdAt),
//                                         style: const TextStyle(
//                                           color: GameTheme.textSecondary,
//                                           fontSize: 11,
//                                         ),
//                                       ),
//                                     ],
//                                   ),
//                                 ),
//                                 if (!n.isRead)
//                                   Container(
//                                     width: 8,
//                                     height: 8,
//                                     decoration: const BoxDecoration(
//                                       color: GameTheme.gold,
//                                       shape: BoxShape.circle,
//                                     ),
//                                   ),
//                               ],
//                             ),
//                           );
//                         },
//                       ),
//           ),
//         ],
//       ),
//     );
//   }

//   String _timeAgo(DateTime dt) {
//     final diff = DateTime.now().difference(dt);
//     if (diff.inMinutes < 1) return 'Just now';
//     if (diff.inHours < 1) return '${diff.inMinutes}m ago';
//     if (diff.inDays < 1) return '${diff.inHours}h ago';
//     return '${diff.inDays}d ago';
//   }
// }

// // ─────────────────────────────────────────────
// // TAB DATA HELPER
// // ─────────────────────────────────────────────

// class _TabData {
//   final String label;
//   final IconData icon;
//   final int index;

//   _TabData(this.label, this.icon, this.index);
// }






























































































































// import 'dart:math' as math;
// import 'package:flutter/material.dart';
// import 'package:flutter/services.dart';
// import 'package:supabase_flutter/supabase_flutter.dart';
// import 'dart:async';
// import 'package:intl/intl.dart';


// // ─────────────────────────────────────────────
// // MODELS
// // ─────────────────────────────────────────────

// class AppUser {
//   final String authUserId;
//   final String customId;
//   final String email;
//   final String? imageUrl;
//   final String? username;
//   final bool isOnline;
//   final DateTime? lastSeen;

//   AppUser({
//     required this.authUserId,
//     required this.customId,
//     required this.email,
//     this.imageUrl,
//     this.username,
//     this.isOnline = false,
//     this.lastSeen,
//   });

//   factory AppUser.fromMap(Map<String, dynamic> map) {
//     return AppUser(
//       authUserId: map['auth_user_id'] ?? '',
//       customId: map['custom_id'] ?? '',
//       email: map['email'] ?? '',
//       imageUrl: map['image_url'],
//       username: map['username'],
//       isOnline: map['is_online'] ?? false,
//       lastSeen: map['last_seen'] != null ? DateTime.tryParse(map['last_seen']) : null,
//     );
//   }

//   String get displayName => username ?? email.split('@').first;
//   String get shortId => customId.length > 8 ? customId.substring(0, 8) : customId;
// }

// class FriendRequest {
//   final String id;
//   final String senderId;
//   final String receiverId;
//   final String status;
//   final DateTime createdAt;
//   AppUser? senderUser;
//   AppUser? receiverUser;

//   FriendRequest({
//     required this.id,
//     required this.senderId,
//     required this.receiverId,
//     required this.status,
//     required this.createdAt,
//     this.senderUser,
//     this.receiverUser,
//   });

//   factory FriendRequest.fromMap(Map<String, dynamic> map) {
//     return FriendRequest(
//       id: map['id'] ?? '',
//       senderId: map['sender_id'] ?? '',
//       receiverId: map['receiver_id'] ?? '',
//       status: map['status'] ?? 'pending',
//       createdAt: DateTime.tryParse(map['created_at'] ?? '') ?? DateTime.now(),
//     );
//   }
// }

// class Message {
//   final String id;
//   final String senderId;
//   final String receiverId;
//   final String content;
//   final DateTime createdAt;
//   final bool isRead;

//   Message({
//     required this.id,
//     required this.senderId,
//     required this.receiverId,
//     required this.content,
//     required this.createdAt,
//     this.isRead = false,
//   });

//   factory Message.fromMap(Map<String, dynamic> map) {
//     return Message(
//       id: map['id'] ?? '',
//       senderId: map['sender_id'] ?? '',
//       receiverId: map['receiver_id'] ?? '',
//       content: map['content'] ?? '',
//       createdAt: DateTime.tryParse(map['created_at'] ?? '') ?? DateTime.now(),
//       isRead: map['is_read'] ?? false,
//     );
//   }
// }

// class AppNotification {
//   final String id;
//   final String userId;
//   final String type;
//   final String message;
//   final String? fromUserId;
//   final bool isRead;
//   final DateTime createdAt;

//   AppNotification({
//     required this.id,
//     required this.userId,
//     required this.type,
//     required this.message,
//     this.fromUserId,
//     required this.isRead,
//     required this.createdAt,
//   });

//   factory AppNotification.fromMap(Map<String, dynamic> map) {
//     return AppNotification(
//       id: map['id'] ?? '',
//       userId: map['user_id'] ?? '',
//       type: map['type'] ?? '',
//       message: map['message'] ?? '',
//       fromUserId: map['from_user_id'],
//       isRead: map['is_read'] ?? false,
//       createdAt: DateTime.tryParse(map['created_at'] ?? '') ?? DateTime.now(),
//     );
//   }
// }

// // ─────────────────────────────────────────────
// // SUPABASE SERVICE
// // ─────────────────────────────────────────────

// class FriendService {
//   final _supabase = Supabase.instance.client;

//   String get currentUserId => _supabase.auth.currentUser!.id;

//   // Search user by custom_id or UUID
//   Future<AppUser?> searchUser(String query) async {
//     try {
//       // Fix: Use proper OR syntax for Supabase
//       final res = await _supabase
//           .from('users')
//           .select()
//           .or('custom_id.eq.$query,auth_user_id.eq.$query')
//           .neq('auth_user_id', currentUserId)
//           .limit(1)
//           .maybeSingle();
      
//       if (res == null) {
//         // Try email search separately
//         final emailRes = await _supabase
//             .from('users')
//             .select()
//             .ilike('email', '%$query%')
//             .neq('auth_user_id', currentUserId)
//             .limit(1)
//             .maybeSingle();
        
//         if (emailRes == null) return null;
//         return AppUser.fromMap(emailRes);
//       }
      
//       return AppUser.fromMap(res);
//     } catch (e) {
//       debugPrint('Search error: $e');
//       return null;
//     }
//   }

//   // Get all friends
//   Future<List<AppUser>> getFriends() async {
//     try {
//       final res = await _supabase
//           .from('friends')
//           .select('friend_id')
//           .eq('user_id', currentUserId);

//       if (res.isEmpty) return [];

//       final ids = res.map((e) => e['friend_id'] as String).toList();
      
//       if (ids.isEmpty) return [];
      
//       // Fix: Use proper filter syntax
//       final users = await _supabase
//           .from('users')
//           .select()
//           .inFilter('auth_user_id', ids);
      
//       return users.map((e) => AppUser.fromMap(e)).toList();
//     } catch (e) {
//       debugPrint('Get friends error: $e');
//       return [];
//     }
//   }

//   // Get pending incoming requests
//   Future<List<FriendRequest>> getIncomingRequests() async {
//     try {
//       final res = await _supabase
//           .from('friend_requests')
//           .select()
//           .eq('receiver_id', currentUserId)
//           .eq('status', 'pending');

//       final requests = res.map((e) => FriendRequest.fromMap(e)).toList();
      
//       // Fetch sender details for each request
//       for (final req in requests) {
//         final user = await _supabase
//             .from('users')
//             .select()
//             .eq('auth_user_id', req.senderId)
//             .maybeSingle();
//         if (user != null) req.senderUser = AppUser.fromMap(user);
//       }
//       return requests;
//     } catch (e) {
//       debugPrint('Get incoming requests error: $e');
//       return [];
//     }
//   }

//   // Get sent requests
//   Future<List<FriendRequest>> getSentRequests() async {
//     try {
//       final res = await _supabase
//           .from('friend_requests')
//           .select()
//           .eq('sender_id', currentUserId)
//           .eq('status', 'pending');

//       final requests = res.map((e) => FriendRequest.fromMap(e)).toList();
      
//       for (final req in requests) {
//         final user = await _supabase
//             .from('users')
//             .select()
//             .eq('auth_user_id', req.receiverId)
//             .maybeSingle();
//         if (user != null) req.receiverUser = AppUser.fromMap(user);
//       }
//       return requests;
//     } catch (e) {
//       debugPrint('Get sent requests error: $e');
//       return [];
//     }
//   }

//   // Send friend request
//   Future<String?> sendFriendRequest(String receiverId) async {
//     try {
//       // Check existing request
//       final existing = await _supabase
//           .from('friend_requests')
//           .select()
//           .or('and(sender_id.eq.$currentUserId,receiver_id.eq.$receiverId),and(sender_id.eq.$receiverId,receiver_id.eq.$currentUserId)')
//           .maybeSingle();

//       if (existing != null) {
//         if (existing['status'] == 'pending') {
//           return 'Request already pending';
//         } else if (existing['status'] == 'accepted') {
//           return 'Already friends';
//         }
//       }

//       // Check if already friends
//       final alreadyFriend = await _supabase
//           .from('friends')
//           .select()
//           .eq('user_id', currentUserId)
//           .eq('friend_id', receiverId)
//           .maybeSingle();

//       if (alreadyFriend != null) return 'Already friends';

//       // Insert friend request
//       await _supabase.from('friend_requests').insert({
//         'sender_id': currentUserId,
//         'receiver_id': receiverId,
//         'status': 'pending',
//       });

//       // Send notification
//       await _supabase.from('notifications').insert({
//         'user_id': receiverId,
//         'type': 'friend_request',
//         'message': 'You have a new friend request',
//         'from_user_id': currentUserId,
//         'is_read': false,
//       });

//       return null; // Success
//     } catch (e) {
//       debugPrint('Send request error: $e');
//       return 'Error sending request: $e';
//     }
//   }

//   // Accept request
//   Future<void> acceptRequest(String requestId, String senderId) async {
//     try {
//       await _supabase
//           .from('friend_requests')
//           .update({'status': 'accepted'})
//           .eq('id', requestId);

//       // Create mutual friendship
//       await _supabase.from('friends').insert([
//         {'user_id': currentUserId, 'friend_id': senderId},
//         {'user_id': senderId, 'friend_id': currentUserId},
//       ]);

//       // Notify sender
//       await _supabase.from('notifications').insert({
//         'user_id': senderId,
//         'type': 'request_accepted',
//         'message': 'Your friend request was accepted!',
//         'from_user_id': currentUserId,
//         'is_read': false,
//       });
//     } catch (e) {
//       debugPrint('Accept request error: $e');
//     }
//   }

//   // Reject request
//   Future<void> rejectRequest(String requestId) async {
//     try {
//       await _supabase
//           .from('friend_requests')
//           .update({'status': 'rejected'})
//           .eq('id', requestId);
//     } catch (e) {
//       debugPrint('Reject request error: $e');
//     }
//   }

//   // Cancel sent request
//   Future<void> cancelRequest(String requestId) async {
//     try {
//       await _supabase.from('friend_requests').delete().eq('id', requestId);
//     } catch (e) {
//       debugPrint('Cancel request error: $e');
//     }
//   }

//   // Remove friend
//   Future<void> removeFriend(String friendId) async {
//     try {
//       // Remove both directions
//       await _supabase
//           .from('friends')
//           .delete()
//           .eq('user_id', currentUserId)
//           .eq('friend_id', friendId);
      
//       await _supabase
//           .from('friends')
//           .delete()
//           .eq('user_id', friendId)
//           .eq('friend_id', currentUserId);
//     } catch (e) {
//       debugPrint('Remove friend error: $e');
//     }
//   }

//   // Get notifications
//   Future<List<AppNotification>> getNotifications() async {
//     try {
//       final res = await _supabase
//           .from('notifications')
//           .select()
//           .eq('user_id', currentUserId)
//           .order('created_at', ascending: false)
//           .limit(20);
//       return res.map((e) => AppNotification.fromMap(e)).toList();
//     } catch (e) {
//       debugPrint('Get notifications error: $e');
//       return [];
//     }
//   }

//   // Mark notification read
//   Future<void> markNotificationRead(String notifId) async {
//     try {
//       await _supabase.from('notifications').update({'is_read': true}).eq('id', notifId);
//     } catch (e) {
//       debugPrint('Mark notification error: $e');
//     }
//   }

//   // Get messages between two users
//   Future<List<Message>> getMessages(String otherUserId) async {
//     try {
//       // Fix: Use proper filter for bidirectional messages
//       final res = await _supabase
//           .from('messages')
//           .select()
//           .or('and(sender_id.eq.$currentUserId,receiver_id.eq.$otherUserId),and(sender_id.eq.$otherUserId,receiver_id.eq.$currentUserId)')
//           .order('created_at', ascending: true)
//           .limit(50);
//       return res.map((e) => Message.fromMap(e)).toList();
//     } catch (e) {
//       debugPrint('Get messages error: $e');
//       return [];
//     }
//   }

//   // Send message
//   Future<void> sendMessage(String receiverId, String content) async {
//     try {
//       await _supabase.from('messages').insert({
//         'sender_id': currentUserId,
//         'receiver_id': receiverId,
//         'content': content,
//         'is_read': false,
//       });
//     } catch (e) {
//       debugPrint('Send message error: $e');
//     }
//   }

//   // Get suggested friends
//   Future<List<AppUser>> getSuggestedFriends() async {
//     try {
//       // Get existing friends
//       final friendsRes = await _supabase
//           .from('friends')
//           .select('friend_id')
//           .eq('user_id', currentUserId);
//       final friendIds = friendsRes.map((e) => e['friend_id'] as String).toList();

//       // Get pending sent requests
//       final sentRes = await _supabase
//           .from('friend_requests')
//           .select('receiver_id')
//           .eq('sender_id', currentUserId)
//           .eq('status', 'pending');
//       final sentIds = sentRes.map((e) => e['receiver_id'] as String).toList();

//       // Fix: Properly handle empty exclude list
//       final excludeIds = [...friendIds, ...sentIds, currentUserId];
      
//       if (excludeIds.isEmpty) {
//         final res = await _supabase
//             .from('users')
//             .select()
//             .limit(10);
//         return res.map((e) => AppUser.fromMap(e)).toList();
//       }

//       // Use not-in filter if we have IDs to exclude
//       final res = await _supabase
//           .from('users')
//           .select()
//           .not('auth_user_id', 'in', '(${excludeIds.join(',')})')
//           .limit(10);

//       return res.map((e) => AppUser.fromMap(e)).toList();
//     } catch (e) {
//       debugPrint('Get suggested friends error: $e');
//       return [];
//     }
//   }

//   // Realtime subscriptions
//   RealtimeChannel subscribeToNotifications(Function(AppNotification) onNew) {
//     return _supabase
//         .channel('notifications_$currentUserId')
//         .onPostgresChanges(
//           event: PostgresChangeEvent.insert,
//           schema: 'public',
//           table: 'notifications',
//           filter: PostgresChangeFilter(
//             type: PostgresChangeFilterType.eq,
//             column: 'user_id',
//             value: currentUserId,
//           ),
//           callback: (payload) {
//             try {
//               final notif = AppNotification.fromMap(payload.newRecord);
//               onNew(notif);
//             } catch (e) {
//               debugPrint('Notification callback error: $e');
//             }
//           },
//         )
//         .subscribe();
//   }

//   RealtimeChannel subscribeToMessages(String otherUserId, Function(Message) onNew) {
//     return _supabase
//         .channel('messages_${currentUserId}_$otherUserId')
//         .onPostgresChanges(
//           event: PostgresChangeEvent.insert,
//           schema: 'public',
//           table: 'messages',
//           callback: (payload) {
//             try {
//               final msg = Message.fromMap(payload.newRecord);
//               if ((msg.senderId == currentUserId && msg.receiverId == otherUserId) ||
//                   (msg.senderId == otherUserId && msg.receiverId == currentUserId)) {
//                 onNew(msg);
//               }
//             } catch (e) {
//               debugPrint('Message callback error: $e');
//             }
//           },
//         )
//         .subscribe();
//   }
// }

// // ─────────────────────────────────────────────
// // THEME - Gaming-Inspired Dark Theme
// // ─────────────────────────────────────────────

// class GameTheme {
//   static const bg = Color(0xFF0A0E17);
//   static const surface = Color(0xFF141B26);
//   static const card = Color(0xFF1A2235);
//   static const cardLight = Color(0xFF1F2840);
//   static const gold = Color(0xFFFFD700);
//   static const goldDark = Color(0xFFB8960F);
//   static const green = Color(0xFF00E676);
//   static const red = Color(0xFFFF1744);
//   static const blue = Color(0xFF448AFF);
//   static const purple = Color(0xFF7C4DFF);
//   static const textPrimary = Color(0xFFF5F5F5);
//   static const textSecondary = Color(0xFF8A94A8);
//   static const border = Color(0xFF2A3347);

//   static final gradientGold = const LinearGradient(
//     colors: [Color(0xFFFFD700), Color(0xFFFFA000)],
//     begin: Alignment.topLeft,
//     end: Alignment.bottomRight,
//   );

//   static final gradientPurple = const LinearGradient(
//     colors: [Color(0xFF7C4DFF), Color(0xFF651FFF)],
//     begin: Alignment.topLeft,
//     end: Alignment.bottomRight,
//   );

//   static final gradientBg = const LinearGradient(
//     colors: [Color(0xFF0A0E17), Color(0xFF141B26)],
//     begin: Alignment.topCenter,
//     end: Alignment.bottomCenter,
//   );

//   static BoxDecoration cardDecoration = BoxDecoration(
//     gradient: LinearGradient(
//       colors: [cardLight, card],
//       begin: Alignment.topLeft,
//       end: Alignment.bottomRight,
//     ),
//     borderRadius: BorderRadius.circular(16),
//     border: Border.all(color: border.withOpacity(0.5), width: 1),
//     boxShadow: [
//       BoxShadow(
//         color: Colors.black.withOpacity(0.3),
//         blurRadius: 10,
//         offset: const Offset(0, 4),
//       ),
//     ],
//   );
// }

// // ─────────────────────────────────────────────
// // MAIN APP WIDGET
// // ─────────────────────────────────────────────

// class GameFriendsApp extends StatelessWidget {
//   const GameFriendsApp({super.key});

//   @override
//   Widget build(BuildContext context) {
//     return MaterialApp(
//       debugShowCheckedModeBanner: false,
//       title: 'Game Friends',
//       theme: ThemeData(
//         brightness: Brightness.dark,
//         scaffoldBackgroundColor: GameTheme.bg,
//         colorScheme: const ColorScheme.dark(
//           primary: GameTheme.gold,
//           surface: GameTheme.surface,
//         ),
//         fontFamily: 'Roboto',
//       ),
//       home: const MainScreen(),
//     );
//   }
// }

// // ─────────────────────────────────────────────
// // MAIN SCREEN
// // ─────────────────────────────────────────────

// class MainScreen extends StatefulWidget {
//   const MainScreen({super.key});

//   @override
//   State<MainScreen> createState() => _MainScreenState();
// }

// class _MainScreenState extends State<MainScreen> {
//   final _service = FriendService();
//   int _unreadNotifs = 0;
//   int _selectedTab = 0;
//   final _searchCtrl = TextEditingController();
//   AppUser? _searchResult;
//   bool _searching = false;
//   late RealtimeChannel _notifChannel;

//   @override
//   void initState() {
//     super.initState();
//     _loadUnreadCount();
//     _notifChannel = _service.subscribeToNotifications((notif) {
//       if (mounted) {
//         setState(() => _unreadNotifs++);
//         _showNotificationPopup(notif.message);
//       }
//     });
//   }

//   Future<void> _loadUnreadCount() async {
//     final notifs = await _service.getNotifications();
//     if (mounted) {
//       setState(() => _unreadNotifs = notifs.where((n) => !n.isRead).length);
//     }
//   }

//   void _showNotificationPopup(String msg) {
//     if (!mounted) return;
//     showDialog(
//       context: context,
//       builder: (_) => AlertDialog(
//         backgroundColor: GameTheme.card,
//         shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
//         content: Row(
//           children: [
//             Container(
//               padding: const EdgeInsets.all(10),
//               decoration: BoxDecoration(
//                 gradient: GameTheme.gradientGold,
//                 shape: BoxShape.circle,
//               ),
//               child: const Icon(Icons.notifications, color: Colors.black, size: 24),
//             ),
//             const SizedBox(width: 16),
//             Expanded(
//               child: Text(
//                 msg,
//                 style: const TextStyle(color: GameTheme.textPrimary, fontSize: 16),
//               ),
//             ),
//           ],
//         ),
//         actions: [
//           TextButton(
//             onPressed: () => Navigator.pop(context),
//             child: const Text('OK', style: TextStyle(color: GameTheme.gold)),
//           ),
//         ],
//       ),
//     );
//   }

//   Future<void> _search() async {
//     final q = _searchCtrl.text.trim();
//     if (q.isEmpty) return;
//     setState(() => _searching = true);
//     final user = await _service.searchUser(q);
//     if (mounted) {
//       setState(() {
//         _searching = false;
//         _searchResult = user;
//       });
//     }
//   }

//   Future<void> _sendRequest(AppUser user) async {
//     final err = await _service.sendFriendRequest(user.authUserId);
//     if (!mounted) return;
//     ScaffoldMessenger.of(context).showSnackBar(
//       SnackBar(
//         content: Text(
//           err ?? 'Friend request sent! 🎮',
//           style: const TextStyle(color: Colors.white),
//         ),
//         backgroundColor: err != null ? GameTheme.red : GameTheme.green,
//         behavior: SnackBarBehavior.floating,
//         shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
//       ),
//     );
//     if (err == null) {
//       setState(() {
//         _searchResult = null;
//         _searchCtrl.clear();
//       });
//     }
//   }

//   @override
//   void dispose() {
//     _notifChannel.unsubscribe();
//     _searchCtrl.dispose();
//     super.dispose();
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       body: Container(
//         decoration: BoxDecoration(gradient: GameTheme.gradientBg),
//         child: SafeArea(
//           child: Column(
//             children: [
//               _buildHeader(),
//               _buildSearchBar(),
//               _buildTabNavigation(),
//               if (_searchResult != null)
//                 _buildSearchResultCard()
//               else
//                 Expanded(child: _buildTabContent()),
//             ],
//           ),
//         ),
//       ),
//     );
//   }

//   Widget _buildHeader() {
//     return Container(
//       padding: const EdgeInsets.fromLTRB(20, 16, 20, 12),
//       decoration: BoxDecoration(
//         border: Border(bottom: BorderSide(color: GameTheme.border.withOpacity(0.3))),
//       ),
//       child: Row(
//         children: [
//           Container(
//             padding: const EdgeInsets.all(10),
//             decoration: BoxDecoration(
//               gradient: GameTheme.gradientGold,
//               borderRadius: BorderRadius.circular(12),
//               boxShadow: [
//                 BoxShadow(
//                   color: GameTheme.gold.withOpacity(0.3),
//                   blurRadius: 15,
//                   spreadRadius: 1,
//                 ),
//               ],
//             ),
//             child: const Text(
//               '♛',
//               style: TextStyle(fontSize: 24, color: Colors.black),
//             ),
//           ),
//           const SizedBox(width: 12),
//           const Expanded(
//             child: Column(
//               crossAxisAlignment: CrossAxisAlignment.start,
//               children: [
//                 Text(
//                   'SOCIAL HUB',
//                   style: TextStyle(
//                     color: GameTheme.textPrimary,
//                     fontSize: 18,
//                     fontWeight: FontWeight.w800,
//                     letterSpacing: 2,
//                   ),
//                 ),
//                 Text(
//                   'Connect & Conquer',
//                   style: TextStyle(
//                     color: GameTheme.gold,
//                     fontSize: 11,
//                     fontWeight: FontWeight.w600,
//                     letterSpacing: 1,
//                   ),
//                 ),
//               ],
//             ),
//           ),
//           GestureDetector(
//             onTap: () => _showNotifications(),
//             child: Container(
//               width: 44,
//               height: 44,
//               decoration: BoxDecoration(
//                 color: GameTheme.card,
//                 borderRadius: BorderRadius.circular(12),
//                 border: Border.all(color: GameTheme.border.withOpacity(0.5)),
//               ),
//               child: Stack(
//                 children: [
//                   const Center(
//                     child: Icon(Icons.notifications_outlined, color: GameTheme.textPrimary, size: 22),
//                   ),
//                   if (_unreadNotifs > 0)
//                     Positioned(
//                       right: 6,
//                       top: 6,
//                       child: Container(
//                         padding: const EdgeInsets.all(4),
//                         decoration: const BoxDecoration(
//                           color: GameTheme.red,
//                           shape: BoxShape.circle,
//                         ),
//                         child: Text(
//                           _unreadNotifs > 99 ? '99+' : '$_unreadNotifs',
//                           style: const TextStyle(
//                             color: Colors.white,
//                             fontSize: 8,
//                             fontWeight: FontWeight.w800,
//                           ),
//                         ),
//                       ),
//                     ),
//                 ],
//               ),
//             ),
//           ),
//         ],
//       ),
//     );
//   }

//   Widget _buildSearchBar() {
//     return Container(
//       margin: const EdgeInsets.fromLTRB(20, 12, 20, 0),
//       padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
//       decoration: GameTheme.cardDecoration.copyWith(
//         borderRadius: BorderRadius.circular(16),
//       ),
//       child: Row(
//         children: [
//           const Icon(Icons.search, color: GameTheme.gold, size: 22),
//           const SizedBox(width: 12),
//           Expanded(
//             child: TextField(
//               controller: _searchCtrl,
//               style: const TextStyle(color: GameTheme.textPrimary, fontSize: 14),
//               decoration: const InputDecoration(
//                 hintText: 'Search players by ID...',
//                 hintStyle: TextStyle(color: GameTheme.textSecondary, fontSize: 13),
//                 border: InputBorder.none,
//                 contentPadding: EdgeInsets.symmetric(vertical: 8),
//               ),
//               onSubmitted: (_) => _search(),
//             ),
//           ),
//           if (_searching)
//             const Padding(
//               padding: EdgeInsets.all(8),
//               child: SizedBox(
//                 width: 20,
//                 height: 20,
//                 child: CircularProgressIndicator(strokeWidth: 2, color: GameTheme.gold),
//               ),
//             )
//           else
//             GestureDetector(
//               onTap: _search,
//               child: Container(
//                 padding: const EdgeInsets.all(10),
//                 decoration: BoxDecoration(
//                   gradient: GameTheme.gradientGold,
//                   borderRadius: BorderRadius.circular(10),
//                 ),
//                 child: const Icon(Icons.search, color: Colors.black, size: 20),
//               ),
//             ),
//         ],
//       ),
//     );
//   }

//   Widget _buildTabNavigation() {
//     final tabs = [
//       _TabData('Friends', Icons.people, 0),
//       _TabData('Chats', Icons.messenger, 1),
//       _TabData('Requests', Icons.person_add, 2),
//       _TabData('Discover', Icons.explore, 3),
//     ];

//     return Container(
//       margin: const EdgeInsets.fromLTRB(20, 16, 20, 8),
//       height: 48,
//       child: Row(
//         children: tabs.map((tab) {
//           final isSelected = _selectedTab == tab.index;
//           return Expanded(
//             child: GestureDetector(
//               onTap: () => setState(() => _selectedTab = tab.index),
//               child: AnimatedContainer(
//                 duration: const Duration(milliseconds: 200),
//                 margin: const EdgeInsets.symmetric(horizontal: 4),
//                 decoration: BoxDecoration(
//                   gradient: isSelected ? GameTheme.gradientGold : null,
//                   color: isSelected ? null : GameTheme.card,
//                   borderRadius: BorderRadius.circular(12),
//                   border: isSelected ? null : Border.all(color: GameTheme.border.withOpacity(0.5)),
//                 ),
//                 child: Column(
//                   mainAxisAlignment: MainAxisAlignment.center,
//                   children: [
//                     Icon(
//                       tab.icon,
//                       color: isSelected ? Colors.black : GameTheme.textSecondary,
//                       size: 18,
//                     ),
//                     const SizedBox(height: 2),
//                     Text(
//                       tab.label,
//                       style: TextStyle(
//                         color: isSelected ? Colors.black : GameTheme.textSecondary,
//                         fontSize: 9,
//                         fontWeight: FontWeight.w700,
//                         letterSpacing: 0.5,
//                       ),
//                     ),
//                   ],
//                 ),
//               ),
//             ),
//           );
//         }).toList(),
//       ),
//     );
//   }

//   Widget _buildSearchResultCard() {
//     final user = _searchResult!;
//     return Container(
//       margin: const EdgeInsets.fromLTRB(20, 16, 20, 0),
//       padding: const EdgeInsets.all(20),
//       decoration: GameTheme.cardDecoration,
//       child: Column(
//         mainAxisSize: MainAxisSize.min,
//         children: [
//           Row(
//             mainAxisAlignment: MainAxisAlignment.spaceBetween,
//             children: [
//               const Text(
//                 'SEARCH RESULT',
//                 style: TextStyle(
//                   color: GameTheme.gold,
//                   fontSize: 12,
//                   fontWeight: FontWeight.w700,
//                   letterSpacing: 2,
//                 ),
//               ),
//               IconButton(
//                 icon: const Icon(Icons.close, color: GameTheme.textSecondary),
//                 onPressed: () {
//                   setState(() {
//                     _searchResult = null;
//                     _searchCtrl.clear();
//                   });
//                 },
//               ),
//             ],
//           ),
//           const SizedBox(height: 16),
//           Container(
//             width: 80,
//             height: 80,
//             decoration: BoxDecoration(
//               shape: BoxShape.circle,
//               border: Border.all(color: GameTheme.gold, width: 2),
//               boxShadow: [BoxShadow(color: GameTheme.gold.withOpacity(0.3), blurRadius: 15)],
//             ),
//             child: ClipOval(
//               child: user.imageUrl != null
//                   ? Image.network(user.imageUrl!, fit: BoxFit.cover, errorBuilder: (_, __, ___) => _buildAvatar(user))
//                   : _buildAvatar(user),
//             ),
//           ),
//           const SizedBox(height: 16),
//           Text(
//             user.displayName,
//             style: const TextStyle(
//               color: GameTheme.textPrimary,
//               fontSize: 20,
//               fontWeight: FontWeight.w800,
//             ),
//           ),
//           const SizedBox(height: 4),
//           Container(
//             padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
//             decoration: BoxDecoration(
//               color: GameTheme.border.withOpacity(0.3),
//               borderRadius: BorderRadius.circular(8),
//             ),
//             child: Row(
//               mainAxisSize: MainAxisSize.min,
//               children: [
//                 const Icon(Icons.tag, size: 14, color: GameTheme.gold),
//                 const SizedBox(width: 4),
//                 Text(
//                   user.shortId,
//                   style: const TextStyle(color: GameTheme.gold, fontSize: 13),
//                 ),
//               ],
//             ),
//           ),
//           const SizedBox(height: 20),
//           GestureDetector(
//             onTap: () => _sendRequest(user),
//             child: Container(
//               width: double.infinity,
//               padding: const EdgeInsets.symmetric(vertical: 14),
//               decoration: BoxDecoration(
//                 gradient: GameTheme.gradientGold,
//                 borderRadius: BorderRadius.circular(12),
//                 boxShadow: [BoxShadow(color: GameTheme.gold.withOpacity(0.3), blurRadius: 10)],
//               ),
//               child: const Center(
//                 child: Text(
//                   'SEND FRIEND REQUEST',
//                   style: TextStyle(
//                     color: Colors.black,
//                     fontWeight: FontWeight.w800,
//                     fontSize: 14,
//                     letterSpacing: 1,
//                   ),
//                 ),
//               ),
//             ),
//           ),
//         ],
//       ),
//     );
//   }

//   Widget _buildAvatar(AppUser user) {
//     return Container(
//       color: GameTheme.purple,
//       child: Center(
//         child: Text(
//           user.displayName[0].toUpperCase(),
//           style: const TextStyle(
//             color: Colors.white,
//             fontSize: 32,
//             fontWeight: FontWeight.w800,
//           ),
//         ),
//       ),
//     );
//   }

//   Widget _buildTabContent() {
//     switch (_selectedTab) {
//       case 0:
//         return _FriendsTab(service: _service);
//       case 1:
//         return _ChatsList(service: _service);
//       case 2:
//         return _RequestsTab(service: _service, onRefresh: () => setState(() {}));
//       case 3:
//         return _DiscoverTab(service: _service);
//       default:
//         return const SizedBox();
//     }
//   }

//   void _showNotifications() {
//     showModalBottomSheet(
//       context: context,
//       backgroundColor: Colors.transparent,
//       isScrollControlled: true,
//       builder: (_) => _NotificationsPanel(service: _service, onRead: () {
//         setState(() => _unreadNotifs = 0);
//       }),
//     );
//   }
// }

// // ─────────────────────────────────────────────
// // FRIENDS TAB
// // ─────────────────────────────────────────────

// class _FriendsTab extends StatefulWidget {
//   final FriendService service;
//   const _FriendsTab({required this.service});

//   @override
//   State<_FriendsTab> createState() => _FriendsTabState();
// }

// class _FriendsTabState extends State<_FriendsTab> {
//   List<AppUser> _friends = [];
//   bool _loading = true;

//   @override
//   void initState() {
//     super.initState();
//     _load();
//   }

//   Future<void> _load() async {
//     setState(() => _loading = true);
//     final f = await widget.service.getFriends();
//     if (mounted) setState(() { _friends = f; _loading = false; });
//   }

//   @override
//   Widget build(BuildContext context) {
//     if (_loading) {
//       return const Center(child: CircularProgressIndicator(color: GameTheme.gold));
//     }

//     if (_friends.isEmpty) {
//       return Center(
//         child: Column(
//           mainAxisAlignment: MainAxisAlignment.center,
//           children: [
//             Container(
//               padding: const EdgeInsets.all(30),
//               decoration: BoxDecoration(
//                 shape: BoxShape.circle,
//                 border: Border.all(color: GameTheme.border, width: 2),
//               ),
//               child: const Icon(Icons.people_outline, size: 60, color: GameTheme.textSecondary),
//             ),
//             const SizedBox(height: 24),
//             const Text(
//               'NO FRIENDS YET',
//               style: TextStyle(
//                 color: GameTheme.textSecondary,
//                 fontSize: 18,
//                 fontWeight: FontWeight.w700,
//                 letterSpacing: 2,
//               ),
//             ),
//             const SizedBox(height: 8),
//             const Text(
//               'Search for players and add them!',
//               style: TextStyle(color: GameTheme.textSecondary, fontSize: 14),
//             ),
//           ],
//         ),
//       );
//     }

//     return RefreshIndicator(
//       onRefresh: _load,
//       color: GameTheme.gold,
//       child: ListView.builder(
//         padding: const EdgeInsets.fromLTRB(20, 12, 20, 20),
//         itemCount: _friends.length,
//         itemBuilder: (_, i) => _FriendCard(
//           user: _friends[i],
//           service: widget.service,
//           onRemove: _load,
//         ),
//       ),
//     );
//   }
// }

// class _FriendCard extends StatelessWidget {
//   final AppUser user;
//   final FriendService service;
//   final VoidCallback onRemove;

//   const _FriendCard({
//     required this.user,
//     required this.service,
//     required this.onRemove,
//   });

//   @override
//   Widget build(BuildContext context) {
//     return Container(
//       margin: const EdgeInsets.only(bottom: 12),
//       decoration: GameTheme.cardDecoration,
//       child: Padding(
//         padding: const EdgeInsets.all(16),
//         child: Row(
//           children: [
//             Stack(
//               children: [
//                 Container(
//                   width: 52,
//                   height: 52,
//                   decoration: BoxDecoration(
//                     shape: BoxShape.circle,
//                     border: Border.all(
//                       color: user.isOnline ? GameTheme.green : GameTheme.border,
//                       width: 2,
//                     ),
//                     boxShadow: [
//                       if (user.isOnline)
//                         BoxShadow(
//                           color: GameTheme.green.withOpacity(0.3),
//                           blurRadius: 10,
//                           spreadRadius: 1,
//                         ),
//                     ],
//                   ),
//                   child: ClipOval(
//                     child: user.imageUrl != null
//                         ? Image.network(user.imageUrl!, fit: BoxFit.cover)
//                         : Container(
//                             color: GameTheme.purple,
//                             child: Center(
//                               child: Text(
//                                 user.displayName[0].toUpperCase(),
//                                 style: const TextStyle(
//                                   color: Colors.white,
//                                   fontSize: 22,
//                                   fontWeight: FontWeight.w800,
//                                 ),
//                               ),
//                             ),
//                           ),
//                   ),
//                 ),
//                 if (user.isOnline)
//                   Positioned(
//                     right: 0,
//                     bottom: 0,
//                     child: Container(
//                       width: 14,
//                       height: 14,
//                       decoration: BoxDecoration(
//                         color: GameTheme.green,
//                         shape: BoxShape.circle,
//                         border: Border.all(color: GameTheme.card, width: 2),
//                       ),
//                     ),
//                   ),
//               ],
//             ),
//             const SizedBox(width: 14),
//             Expanded(
//               child: Column(
//                 crossAxisAlignment: CrossAxisAlignment.start,
//                 children: [
//                   Text(
//                     user.displayName,
//                     style: const TextStyle(
//                       color: GameTheme.textPrimary,
//                       fontSize: 15,
//                       fontWeight: FontWeight.w700,
//                     ),
//                   ),
//                   const SizedBox(height: 4),
//                   Row(
//                     children: [
//                       Container(
//                         padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
//                         decoration: BoxDecoration(
//                           color: user.isOnline
//                               ? GameTheme.green.withOpacity(0.15)
//                               : GameTheme.border.withOpacity(0.5),
//                           borderRadius: BorderRadius.circular(4),
//                         ),
//                         child: Text(
//                           user.isOnline ? 'ONLINE' : 'OFFLINE',
//                           style: TextStyle(
//                             color: user.isOnline ? GameTheme.green : GameTheme.textSecondary,
//                             fontSize: 9,
//                             fontWeight: FontWeight.w700,
//                             letterSpacing: 1,
//                           ),
//                         ),
//                       ),
//                       const SizedBox(width: 8),
//                       Text(
//                         'ID: ${user.shortId}',
//                         style: const TextStyle(color: GameTheme.textSecondary, fontSize: 11),
//                       ),
//                     ],
//                   ),
//                 ],
//               ),
//             ),
//             _ActionIcon(
//               icon: Icons.sports_esports,
//               color: GameTheme.gold,
//               onTap: () {
//                 ScaffoldMessenger.of(context).showSnackBar(
//                   SnackBar(
//                     content: Text('Inviting ${user.displayName} to match...'),
//                     backgroundColor: GameTheme.goldDark,
//                   ),
//                 );
//               },
//             ),
//             const SizedBox(width: 8),
//             _ActionIcon(
//               icon: Icons.message,
//               color: GameTheme.blue,
//               onTap: () {
//                 Navigator.push(
//                   context,
//                   MaterialPageRoute(
//                     builder: (_) => _ChatScreen(service: service, otherUser: user),
//                   ),
//                 );
//               },
//             ),
//             const SizedBox(width: 8),
//             _ActionIcon(
//               icon: Icons.person_remove,
//               color: GameTheme.red,
//               onTap: () => _confirmRemove(context),
//             ),
//           ],
//         ),
//       ),
//     );
//   }

//   void _confirmRemove(BuildContext context) {
//     showDialog(
//       context: context,
//       builder: (_) => AlertDialog(
//         backgroundColor: GameTheme.card,
//         shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
//         title: const Text('Remove Friend', style: TextStyle(color: GameTheme.textPrimary)),
//         content: Text(
//           'Remove ${user.displayName} from friends?',
//           style: const TextStyle(color: GameTheme.textSecondary),
//         ),
//         actions: [
//           TextButton(
//             onPressed: () => Navigator.pop(context),
//             child: const Text('Cancel', style: TextStyle(color: GameTheme.textSecondary)),
//           ),
//           TextButton(
//             onPressed: () async {
//               Navigator.pop(context);
//               await service.removeFriend(user.authUserId);
//               onRemove();
//             },
//             child: const Text('Remove', style: TextStyle(color: GameTheme.red)),
//           ),
//         ],
//       ),
//     );
//   }
// }

// class _ActionIcon extends StatelessWidget {
//   final IconData icon;
//   final Color color;
//   final VoidCallback onTap;

//   const _ActionIcon({
//     required this.icon,
//     required this.color,
//     required this.onTap,
//   });

//   @override
//   Widget build(BuildContext context) {
//     return GestureDetector(
//       onTap: onTap,
//       child: Container(
//         width: 36,
//         height: 36,
//         decoration: BoxDecoration(
//           color: color.withOpacity(0.15),
//           borderRadius: BorderRadius.circular(10),
//           border: Border.all(color: color.withOpacity(0.3)),
//         ),
//         child: Icon(icon, color: color, size: 18),
//       ),
//     );
//   }
// }

// // ─────────────────────────────────────────────
// // CHATS LIST
// // ─────────────────────────────────────────────

// class _ChatsList extends StatefulWidget {
//   final FriendService service;
//   const _ChatsList({required this.service});

//   @override
//   State<_ChatsList> createState() => _ChatsListState();
// }

// class _ChatsListState extends State<_ChatsList> {
//   List<AppUser> _friends = [];
//   bool _loading = true;

//   @override
//   void initState() {
//     super.initState();
//     _load();
//   }

//   Future<void> _load() async {
//     setState(() => _loading = true);
//     final f = await widget.service.getFriends();
//     if (mounted) setState(() { _friends = f; _loading = false; });
//   }

//   @override
//   Widget build(BuildContext context) {
//     if (_loading) {
//       return const Center(child: CircularProgressIndicator(color: GameTheme.gold));
//     }

//     if (_friends.isEmpty) {
//       return Center(
//         child: Column(
//           mainAxisAlignment: MainAxisAlignment.center,
//           children: [
//             Container(
//               padding: const EdgeInsets.all(30),
//               decoration: BoxDecoration(
//                 shape: BoxShape.circle,
//                 border: Border.all(color: GameTheme.border, width: 2),
//               ),
//               child: const Icon(Icons.messenger_outline, size: 60, color: GameTheme.textSecondary),
//             ),
//             const SizedBox(height: 24),
//             const Text(
//               'NO CONVERSATIONS',
//               style: TextStyle(
//                 color: GameTheme.textSecondary,
//                 fontSize: 18,
//                 fontWeight: FontWeight.w700,
//                 letterSpacing: 2,
//               ),
//             ),
//             const SizedBox(height: 8),
//             const Text(
//               'Add friends to start chatting!',
//               style: TextStyle(color: GameTheme.textSecondary, fontSize: 14),
//             ),
//           ],
//         ),
//       );
//     }

//     return ListView.builder(
//       padding: const EdgeInsets.fromLTRB(20, 12, 20, 20),
//       itemCount: _friends.length,
//       itemBuilder: (_, i) => GestureDetector(
//         onTap: () {
//           Navigator.push(
//             context,
//             MaterialPageRoute(
//               builder: (_) => _ChatScreen(service: widget.service, otherUser: _friends[i]),
//             ),
//           );
//         },
//         child: Container(
//           margin: const EdgeInsets.only(bottom: 10),
//           decoration: GameTheme.cardDecoration,
//           child: Padding(
//             padding: const EdgeInsets.all(16),
//             child: Row(
//               children: [
//                 Stack(
//                   children: [
//                     Container(
//                       width: 50,
//                       height: 50,
//                       decoration: BoxDecoration(
//                         shape: BoxShape.circle,
//                         border: Border.all(color: GameTheme.gold.withOpacity(0.3)),
//                       ),
//                       child: ClipOval(
//                         child: _friends[i].imageUrl != null
//                             ? Image.network(_friends[i].imageUrl!, fit: BoxFit.cover)
//                             : Container(
//                                 color: GameTheme.purple,
//                                 child: Center(
//                                   child: Text(
//                                     _friends[i].displayName[0].toUpperCase(),
//                                     style: const TextStyle(
//                                       color: Colors.white,
//                                       fontSize: 20,
//                                       fontWeight: FontWeight.w800,
//                                     ),
//                                   ),
//                                 ),
//                               ),
//                       ),
//                     ),
//                     if (_friends[i].isOnline)
//                       Positioned(
//                         right: 0,
//                         bottom: 0,
//                         child: Container(
//                           width: 14,
//                           height: 14,
//                           decoration: BoxDecoration(
//                             color: GameTheme.green,
//                             shape: BoxShape.circle,
//                             border: Border.all(color: GameTheme.card, width: 2),
//                           ),
//                         ),
//                       ),
//                   ],
//                 ),
//                 const SizedBox(width: 14),
//                 Expanded(
//                   child: Column(
//                     crossAxisAlignment: CrossAxisAlignment.start,
//                     children: [
//                       Text(
//                         _friends[i].displayName,
//                         style: const TextStyle(
//                           color: GameTheme.textPrimary,
//                           fontSize: 15,
//                           fontWeight: FontWeight.w700,
//                         ),
//                       ),
//                       const SizedBox(height: 4),
//                       Text(
//                         'Tap to open chat',
//                         style: TextStyle(
//                           color: GameTheme.textSecondary.withOpacity(0.7),
//                           fontSize: 12,
//                         ),
//                       ),
//                     ],
//                   ),
//                 ),
//                 const Icon(Icons.chevron_right, color: GameTheme.textSecondary),
//               ],
//             ),
//           ),
//         ),
//       ),
//     );
//   }
// }

// // ─────────────────────────────────────────────
// // CHAT SCREEN
// // ─────────────────────────────────────────────

// class _ChatScreen extends StatefulWidget {
//   final FriendService service;
//   final AppUser otherUser;

//   const _ChatScreen({required this.service, required this.otherUser});

//   @override
//   State<_ChatScreen> createState() => _ChatScreenState();
// }

// class _ChatScreenState extends State<_ChatScreen> {
//   final _msgCtrl = TextEditingController();
//   List<Message> _messages = [];
//   bool _loading = true;
//   late RealtimeChannel _msgChannel;
//   final _scrollCtrl = ScrollController();

//   @override
//   void initState() {
//     super.initState();
//     _loadMessages();
//     _msgChannel = widget.service.subscribeToMessages(
//       widget.otherUser.authUserId,
//       (msg) {
//         if (mounted) {
//           setState(() => _messages.add(msg));
//           _scrollToBottom();
//         }
//       },
//     );
//   }

//   Future<void> _loadMessages() async {
//     final msgs = await widget.service.getMessages(widget.otherUser.authUserId);
//     if (mounted) {
//       setState(() {
//         _messages = msgs;
//         _loading = false;
//       });
//       _scrollToBottom();
//     }
//   }

//   void _scrollToBottom() {
//     Future.delayed(const Duration(milliseconds: 100), () {
//       if (_scrollCtrl.hasClients) {
//         _scrollCtrl.animateTo(
//           _scrollCtrl.position.maxScrollExtent,
//           duration: const Duration(milliseconds: 300),
//           curve: Curves.easeOut,
//         );
//       }
//     });
//   }

//   Future<void> _send() async {
//     final text = _msgCtrl.text.trim();
//     if (text.isEmpty) return;
//     await widget.service.sendMessage(widget.otherUser.authUserId, text);
//     _msgCtrl.clear();
//     _scrollToBottom();
//   }

//   @override
//   void dispose() {
//     _msgChannel.unsubscribe();
//     _msgCtrl.dispose();
//     _scrollCtrl.dispose();
//     super.dispose();
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       body: Container(
//         decoration: BoxDecoration(gradient: GameTheme.gradientBg),
//         child: SafeArea(
//           child: Column(
//             children: [
//               // Header
//               Container(
//                 padding: const EdgeInsets.all(16),
//                 decoration: BoxDecoration(
//                   color: GameTheme.card,
//                   border: Border(bottom: BorderSide(color: GameTheme.border.withOpacity(0.3))),
//                 ),
//                 child: Row(
//                   children: [
//                     IconButton(
//                       icon: const Icon(Icons.arrow_back, color: GameTheme.textPrimary),
//                       onPressed: () => Navigator.pop(context),
//                     ),
//                     const SizedBox(width: 8),
//                     Container(
//                       width: 42,
//                       height: 42,
//                       decoration: BoxDecoration(
//                         shape: BoxShape.circle,
//                         border: Border.all(
//                           color: widget.otherUser.isOnline ? GameTheme.green : GameTheme.border,
//                           width: 2,
//                         ),
//                       ),
//                       child: ClipOval(
//                         child: widget.otherUser.imageUrl != null
//                             ? Image.network(widget.otherUser.imageUrl!, fit: BoxFit.cover)
//                             : Container(
//                                 color: GameTheme.purple,
//                                 child: Center(
//                                   child: Text(
//                                     widget.otherUser.displayName[0].toUpperCase(),
//                                     style: const TextStyle(
//                                       color: Colors.white,
//                                       fontSize: 18,
//                                       fontWeight: FontWeight.w800,
//                                     ),
//                                   ),
//                                 ),
//                               ),
//                       ),
//                     ),
//                     const SizedBox(width: 12),
//                     Expanded(
//                       child: Column(
//                         crossAxisAlignment: CrossAxisAlignment.start,
//                         children: [
//                           Text(
//                             widget.otherUser.displayName,
//                             style: const TextStyle(
//                               color: GameTheme.textPrimary,
//                               fontSize: 16,
//                               fontWeight: FontWeight.w700,
//                             ),
//                           ),
//                           Text(
//                             widget.otherUser.isOnline ? 'Online' : 'Offline',
//                             style: TextStyle(
//                               color: widget.otherUser.isOnline ? GameTheme.green : GameTheme.textSecondary,
//                               fontSize: 12,
//                             ),
//                           ),
//                         ],
//                       ),
//                     ),
//                     Container(
//                       padding: const EdgeInsets.all(10),
//                       decoration: BoxDecoration(
//                         gradient: GameTheme.gradientGold,
//                         borderRadius: BorderRadius.circular(12),
//                       ),
//                       child: const Icon(Icons.sports_esports, color: Colors.black, size: 20),
//                     ),
//                   ],
//                 ),
//               ),
//               // Messages
//               Expanded(
//                 child: _loading
//                     ? const Center(child: CircularProgressIndicator(color: GameTheme.gold))
//                     : _messages.isEmpty
//                         ? Center(
//                             child: Column(
//                               mainAxisAlignment: MainAxisAlignment.center,
//                               children: [
//                                 const Icon(Icons.chat_bubble_outline, size: 60, color: GameTheme.textSecondary),
//                                 const SizedBox(height: 16),
//                                 Text(
//                                   'Say hello to ${widget.otherUser.displayName}!',
//                                   style: const TextStyle(color: GameTheme.textSecondary, fontSize: 14),
//                                 ),
//                               ],
//                             ),
//                           )
//                         : ListView.builder(
//                             controller: _scrollCtrl,
//                             padding: const EdgeInsets.all(16),
//                             itemCount: _messages.length,
//                             itemBuilder: (_, i) => _MessageBubble(
//                               message: _messages[i],
//                               isMe: _messages[i].senderId == widget.service.currentUserId,
//                             ),
//                           ),
//               ),
//               // Input
//               Container(
//                 padding: const EdgeInsets.all(12),
//                 decoration: BoxDecoration(
//                   color: GameTheme.card,
//                   border: Border(top: BorderSide(color: GameTheme.border.withOpacity(0.3))),
//                 ),
//                 child: Row(
//                   children: [
//                     Expanded(
//                       child: Container(
//                         decoration: BoxDecoration(
//                           color: GameTheme.surface,
//                           borderRadius: BorderRadius.circular(25),
//                           border: Border.all(color: GameTheme.border.withOpacity(0.5)),
//                         ),
//                         child: TextField(
//                           controller: _msgCtrl,
//                           style: const TextStyle(color: GameTheme.textPrimary),
//                           decoration: const InputDecoration(
//                             hintText: 'Type a message...',
//                             hintStyle: TextStyle(color: GameTheme.textSecondary),
//                             border: InputBorder.none,
//                             contentPadding: EdgeInsets.symmetric(horizontal: 20, vertical: 14),
//                           ),
//                           onSubmitted: (_) => _send(),
//                         ),
//                       ),
//                     ),
//                     const SizedBox(width: 8),
//                     GestureDetector(
//                       onTap: _send,
//                       child: Container(
//                         padding: const EdgeInsets.all(14),
//                         decoration: BoxDecoration(
//                           gradient: GameTheme.gradientGold,
//                           shape: BoxShape.circle,
//                           boxShadow: [
//                             BoxShadow(
//                               color: GameTheme.gold.withOpacity(0.3),
//                               blurRadius: 8,
//                             ),
//                           ],
//                         ),
//                         child: const Icon(Icons.send, color: Colors.black, size: 20),
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

// class _MessageBubble extends StatelessWidget {
//   final Message message;
//   final bool isMe;

//   const _MessageBubble({required this.message, required this.isMe});

//   @override
//   Widget build(BuildContext context) {
//     return Align(
//       alignment: isMe ? Alignment.centerRight : Alignment.centerLeft,
//       child: Container(
//         margin: const EdgeInsets.only(bottom: 8),
//         constraints: BoxConstraints(
//           maxWidth: MediaQuery.of(context).size.width * 0.75,
//         ),
//         padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
//         decoration: BoxDecoration(
//           gradient: isMe ? GameTheme.gradientGold : null,
//           color: isMe ? null : GameTheme.card,
//           borderRadius: BorderRadius.only(
//             topLeft: const Radius.circular(16),
//             topRight: const Radius.circular(16),
//             bottomLeft: isMe ? const Radius.circular(16) : Radius.zero,
//             bottomRight: isMe ? Radius.zero : const Radius.circular(16),
//           ),
//           border: isMe ? null : Border.all(color: GameTheme.border.withOpacity(0.3)),
//         ),
//         child: Column(
//           crossAxisAlignment: isMe ? CrossAxisAlignment.end : CrossAxisAlignment.start,
//           children: [
//             Text(
//               message.content,
//               style: TextStyle(
//                 color: isMe ? Colors.black : GameTheme.textPrimary,
//                 fontSize: 14,
//               ),
//             ),
//             const SizedBox(height: 4),
//             Text(
//               DateFormat('HH:mm').format(message.createdAt),
//               style: TextStyle(
//                 color: isMe ? Colors.black54 : GameTheme.textSecondary,
//                 fontSize: 10,
//               ),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }

// // ─────────────────────────────────────────────
// // REQUESTS TAB (Received + Sent)
// // ─────────────────────────────────────────────

// class _RequestsTab extends StatefulWidget {
//   final FriendService service;
//   final VoidCallback onRefresh;

//   const _RequestsTab({required this.service, required this.onRefresh});

//   @override
//   State<_RequestsTab> createState() => _RequestsTabState();
// }

// class _RequestsTabState extends State<_RequestsTab> with SingleTickerProviderStateMixin {
//   late TabController _tabController;

//   @override
//   void initState() {
//     super.initState();
//     _tabController = TabController(length: 2, vsync: this);
//   }

//   @override
//   void dispose() {
//     _tabController.dispose();
//     super.dispose();
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Column(
//       children: [
//         Container(
//           margin: const EdgeInsets.fromLTRB(20, 12, 20, 8),
//           height: 40,
//           decoration: BoxDecoration(
//             color: GameTheme.card,
//             borderRadius: BorderRadius.circular(12),
//           ),
//           child: TabBar(
//             controller: _tabController,
//             indicator: BoxDecoration(
//               gradient: GameTheme.gradientGold,
//               borderRadius: BorderRadius.circular(10),
//             ),
//             indicatorSize: TabBarIndicatorSize.tab,
//             labelColor: Colors.black,
//             unselectedLabelColor: GameTheme.textSecondary,
//             labelStyle: const TextStyle(
//               fontWeight: FontWeight.w700,
//               fontSize: 11,
//               letterSpacing: 1,
//             ),
//             tabs: const [
//               Tab(text: 'RECEIVED'),
//               Tab(text: 'SENT'),
//             ],
//           ),
//         ),
//         Expanded(
//           child: TabBarView(
//             controller: _tabController,
//             children: [
//               _ReceivedRequests(service: widget.service, onRefresh: widget.onRefresh),
//               _SentRequests(service: widget.service, onRefresh: widget.onRefresh),
//             ],
//           ),
//         ),
//       ],
//     );
//   }
// }

// class _ReceivedRequests extends StatefulWidget {
//   final FriendService service;
//   final VoidCallback onRefresh;

//   const _ReceivedRequests({required this.service, required this.onRefresh});

//   @override
//   State<_ReceivedRequests> createState() => _ReceivedRequestsState();
// }

// class _ReceivedRequestsState extends State<_ReceivedRequests> {
//   List<FriendRequest> _requests = [];
//   bool _loading = true;

//   @override
//   void initState() {
//     super.initState();
//     _load();
//   }

//   Future<void> _load() async {
//     setState(() => _loading = true);
//     final r = await widget.service.getIncomingRequests();
//     if (mounted) setState(() { _requests = r; _loading = false; });
//   }

//   @override
//   Widget build(BuildContext context) {
//     if (_loading) {
//       return const Center(child: CircularProgressIndicator(color: GameTheme.gold));
//     }

//     if (_requests.isEmpty) {
//       return Center(
//         child: Column(
//           mainAxisAlignment: MainAxisAlignment.center,
//           children: [
//             Container(
//               padding: const EdgeInsets.all(24),
//               decoration: BoxDecoration(
//                 shape: BoxShape.circle,
//                 border: Border.all(color: GameTheme.border, width: 2),
//               ),
//               child: const Icon(Icons.inbox, size: 40, color: GameTheme.textSecondary),
//             ),
//             const SizedBox(height: 16),
//             const Text(
//               'NO PENDING REQUESTS',
//               style: TextStyle(
//                 color: GameTheme.textSecondary,
//                 fontSize: 14,
//                 fontWeight: FontWeight.w700,
//                 letterSpacing: 2,
//               ),
//             ),
//           ],
//         ),
//       );
//     }

//     return ListView.builder(
//       padding: const EdgeInsets.fromLTRB(20, 0, 20, 20),
//       itemCount: _requests.length,
//       itemBuilder: (_, i) {
//         final req = _requests[i];
//         final user = req.senderUser;
//         if (user == null) return const SizedBox();
//         return Container(
//           margin: const EdgeInsets.only(bottom: 10),
//           decoration: GameTheme.cardDecoration,
//           child: Padding(
//             padding: const EdgeInsets.all(16),
//             child: Row(
//               children: [
//                 Container(
//                   width: 48,
//                   height: 48,
//                   decoration: BoxDecoration(
//                     shape: BoxShape.circle,
//                     border: Border.all(color: GameTheme.gold.withOpacity(0.3)),
//                   ),
//                   child: ClipOval(
//                     child: user.imageUrl != null
//                         ? Image.network(user.imageUrl!, fit: BoxFit.cover)
//                         : Container(
//                             color: GameTheme.purple,
//                             child: Center(
//                               child: Text(
//                                 user.displayName[0].toUpperCase(),
//                                 style: const TextStyle(
//                                   color: Colors.white,
//                                   fontSize: 20,
//                                   fontWeight: FontWeight.w800,
//                                 ),
//                               ),
//                             ),
//                           ),
//                   ),
//                 ),
//                 const SizedBox(width: 12),
//                 Expanded(
//                   child: Column(
//                     crossAxisAlignment: CrossAxisAlignment.start,
//                     children: [
//                       Text(
//                         user.displayName,
//                         style: const TextStyle(
//                           color: GameTheme.textPrimary,
//                           fontSize: 15,
//                           fontWeight: FontWeight.w700,
//                         ),
//                       ),
//                       const SizedBox(height: 2),
//                       Text(
//                         'ID: ${user.shortId}',
//                         style: const TextStyle(color: GameTheme.textSecondary, fontSize: 11),
//                       ),
//                     ],
//                   ),
//                 ),
//                 Column(
//                   children: [
//                     GestureDetector(
//                       onTap: () async {
//                         await widget.service.acceptRequest(req.id, req.senderId);
//                         widget.onRefresh();
//                         _load();
//                       },
//                       child: Container(
//                         padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
//                         decoration: BoxDecoration(
//                           gradient: GameTheme.gradientGold,
//                           borderRadius: BorderRadius.circular(8),
//                         ),
//                         child: const Text(
//                           'ACCEPT',
//                           style: TextStyle(
//                             color: Colors.black,
//                             fontSize: 11,
//                             fontWeight: FontWeight.w800,
//                             letterSpacing: 1,
//                           ),
//                         ),
//                       ),
//                     ),
//                     const SizedBox(height: 6),
//                     GestureDetector(
//                       onTap: () async {
//                         await widget.service.rejectRequest(req.id);
//                         _load();
//                       },
//                       child: Container(
//                         padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
//                         decoration: BoxDecoration(
//                           color: GameTheme.red.withOpacity(0.15),
//                           borderRadius: BorderRadius.circular(8),
//                           border: Border.all(color: GameTheme.red.withOpacity(0.3)),
//                         ),
//                         child: const Text(
//                           'DECLINE',
//                           style: TextStyle(
//                             color: GameTheme.red,
//                             fontSize: 11,
//                             fontWeight: FontWeight.w800,
//                             letterSpacing: 1,
//                           ),
//                         ),
//                       ),
//                     ),
//                   ],
//                 ),
//               ],
//             ),
//           ),
//         );
//       },
//     );
//   }
// }

// class _SentRequests extends StatefulWidget {
//   final FriendService service;
//   final VoidCallback onRefresh;

//   const _SentRequests({required this.service, required this.onRefresh});

//   @override
//   State<_SentRequests> createState() => _SentRequestsState();
// }

// class _SentRequestsState extends State<_SentRequests> {
//   List<FriendRequest> _requests = [];
//   bool _loading = true;

//   @override
//   void initState() {
//     super.initState();
//     _load();
//   }

//   Future<void> _load() async {
//     setState(() => _loading = true);
//     final r = await widget.service.getSentRequests();
//     if (mounted) setState(() { _requests = r; _loading = false; });
//   }

//   @override
//   Widget build(BuildContext context) {
//     if (_loading) {
//       return const Center(child: CircularProgressIndicator(color: GameTheme.gold));
//     }

//     if (_requests.isEmpty) {
//       return Center(
//         child: Column(
//           mainAxisAlignment: MainAxisAlignment.center,
//           children: [
//             Container(
//               padding: const EdgeInsets.all(24),
//               decoration: BoxDecoration(
//                 shape: BoxShape.circle,
//                 border: Border.all(color: GameTheme.border, width: 2),
//               ),
//               child: const Icon(Icons.send, size: 40, color: GameTheme.textSecondary),
//             ),
//             const SizedBox(height: 16),
//             const Text(
//               'NO SENT REQUESTS',
//               style: TextStyle(
//                 color: GameTheme.textSecondary,
//                 fontSize: 14,
//                 fontWeight: FontWeight.w700,
//                 letterSpacing: 2,
//               ),
//             ),
//           ],
//         ),
//       );
//     }

//     return ListView.builder(
//       padding: const EdgeInsets.fromLTRB(20, 0, 20, 20),
//       itemCount: _requests.length,
//       itemBuilder: (_, i) {
//         final req = _requests[i];
//         final user = req.receiverUser;
//         if (user == null) return const SizedBox();
//         return Container(
//           margin: const EdgeInsets.only(bottom: 10),
//           decoration: GameTheme.cardDecoration,
//           child: Padding(
//             padding: const EdgeInsets.all(16),
//             child: Row(
//               children: [
//                 Container(
//                   width: 48,
//                   height: 48,
//                   decoration: BoxDecoration(
//                     shape: BoxShape.circle,
//                     border: Border.all(color: GameTheme.gold.withOpacity(0.3)),
//                   ),
//                   child: ClipOval(
//                     child: user.imageUrl != null
//                         ? Image.network(user.imageUrl!, fit: BoxFit.cover)
//                         : Container(
//                             color: GameTheme.purple,
//                             child: Center(
//                               child: Text(
//                                 user.displayName[0].toUpperCase(),
//                                 style: const TextStyle(
//                                   color: Colors.white,
//                                   fontSize: 20,
//                                   fontWeight: FontWeight.w800,
//                                 ),
//                               ),
//                             ),
//                           ),
//                   ),
//                 ),
//                 const SizedBox(width: 12),
//                 Expanded(
//                   child: Column(
//                     crossAxisAlignment: CrossAxisAlignment.start,
//                     children: [
//                       Text(
//                         user.displayName,
//                         style: const TextStyle(
//                           color: GameTheme.textPrimary,
//                           fontSize: 15,
//                           fontWeight: FontWeight.w700,
//                         ),
//                       ),
//                       const SizedBox(height: 2),
//                       Container(
//                         padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
//                         decoration: BoxDecoration(
//                           color: GameTheme.gold.withOpacity(0.15),
//                           borderRadius: BorderRadius.circular(4),
//                         ),
//                         child: const Text(
//                           'PENDING',
//                           style: TextStyle(
//                             color: GameTheme.gold,
//                             fontSize: 9,
//                             fontWeight: FontWeight.w700,
//                             letterSpacing: 1,
//                           ),
//                         ),
//                       ),
//                     ],
//                   ),
//                 ),
//                 GestureDetector(
//                   onTap: () async {
//                     await widget.service.cancelRequest(req.id);
//                     widget.onRefresh();
//                     _load();
//                   },
//                   child: Container(
//                     padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
//                     decoration: BoxDecoration(
//                       color: GameTheme.red.withOpacity(0.15),
//                       borderRadius: BorderRadius.circular(8),
//                       border: Border.all(color: GameTheme.red.withOpacity(0.3)),
//                     ),
//                     child: const Text(
//                       'CANCEL',
//                       style: TextStyle(
//                         color: GameTheme.red,
//                         fontSize: 11,
//                         fontWeight: FontWeight.w800,
//                         letterSpacing: 1,
//                       ),
//                     ),
//                   ),
//                 ),
//               ],
//             ),
//           ),
//         );
//       },
//     );
//   }
// }

// // ─────────────────────────────────────────────
// // DISCOVER TAB
// // ─────────────────────────────────────────────

// class _DiscoverTab extends StatefulWidget {
//   final FriendService service;
//   const _DiscoverTab({required this.service});

//   @override
//   State<_DiscoverTab> createState() => _DiscoverTabState();
// }

// class _DiscoverTabState extends State<_DiscoverTab> {
//   List<AppUser> _users = [];
//   bool _loading = true;
//   final Set<String> _sent = {};

//   @override
//   void initState() {
//     super.initState();
//     _load();
//   }

//   Future<void> _load() async {
//     setState(() => _loading = true);
//     final u = await widget.service.getSuggestedFriends();
//     if (mounted) setState(() { _users = u; _loading = false; });
//   }

//   @override
//   Widget build(BuildContext context) {
//     if (_loading) {
//       return const Center(child: CircularProgressIndicator(color: GameTheme.gold));
//     }

//     if (_users.isEmpty) {
//       return Center(
//         child: Column(
//           mainAxisAlignment: MainAxisAlignment.center,
//           children: [
//             Container(
//               padding: const EdgeInsets.all(30),
//               decoration: BoxDecoration(
//                 shape: BoxShape.circle,
//                 border: Border.all(color: GameTheme.border, width: 2),
//               ),
//               child: const Icon(Icons.explore, size: 60, color: GameTheme.textSecondary),
//             ),
//             const SizedBox(height: 24),
//             const Text(
//               'NO SUGGESTIONS',
//               style: TextStyle(
//                 color: GameTheme.textSecondary,
//                 fontSize: 18,
//                 fontWeight: FontWeight.w700,
//                 letterSpacing: 2,
//               ),
//             ),
//             const SizedBox(height: 8),
//             const Text(
//               'Check back later!',
//               style: TextStyle(color: GameTheme.textSecondary, fontSize: 14),
//             ),
//           ],
//         ),
//       );
//     }

//     return RefreshIndicator(
//       onRefresh: _load,
//       color: GameTheme.gold,
//       child: ListView.builder(
//         padding: const EdgeInsets.fromLTRB(20, 12, 20, 20),
//         itemCount: _users.length,
//         itemBuilder: (_, i) {
//           final user = _users[i];
//           final sent = _sent.contains(user.authUserId);
//           return Container(
//             margin: const EdgeInsets.only(bottom: 10),
//             decoration: GameTheme.cardDecoration,
//             child: Padding(
//               padding: const EdgeInsets.all(16),
//               child: Row(
//                 children: [
//                   Container(
//                     width: 48,
//                     height: 48,
//                     decoration: BoxDecoration(
//                       shape: BoxShape.circle,
//                       gradient: GameTheme.gradientPurple,
//                     ),
//                     child: Center(
//                       child: Text(
//                         user.displayName[0].toUpperCase(),
//                         style: const TextStyle(
//                           color: Colors.white,
//                           fontSize: 22,
//                           fontWeight: FontWeight.w800,
//                         ),
//                       ),
//                     ),
//                   ),
//                   const SizedBox(width: 12),
//                   Expanded(
//                     child: Column(
//                       crossAxisAlignment: CrossAxisAlignment.start,
//                       children: [
//                         Text(
//                           user.displayName,
//                           style: const TextStyle(
//                             color: GameTheme.textPrimary,
//                             fontSize: 15,
//                             fontWeight: FontWeight.w700,
//                           ),
//                         ),
//                         const SizedBox(height: 2),
//                         Text(
//                           'ID: ${user.shortId}',
//                           style: const TextStyle(color: GameTheme.textSecondary, fontSize: 11),
//                         ),
//                       ],
//                     ),
//                   ),
//                   GestureDetector(
//                     onTap: sent
//                         ? null
//                         : () async {
//                             await widget.service.sendFriendRequest(user.authUserId);
//                             setState(() => _sent.add(user.authUserId));
//                           },
//                     child: Container(
//                       padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
//                       decoration: sent
//                           ? BoxDecoration(
//                               color: GameTheme.card,
//                               borderRadius: BorderRadius.circular(8),
//                               border: Border.all(color: GameTheme.border),
//                             )
//                           : BoxDecoration(
//                               gradient: GameTheme.gradientGold,
//                               borderRadius: BorderRadius.circular(8),
//                               boxShadow: [
//                                 BoxShadow(
//                                   color: GameTheme.gold.withOpacity(0.3),
//                                   blurRadius: 8,
//                                 ),
//                               ],
//                             ),
//                       child: Text(
//                         sent ? 'SENT ✓' : 'ADD',
//                         style: TextStyle(
//                           color: sent ? GameTheme.textSecondary : Colors.black,
//                           fontSize: 11,
//                           fontWeight: FontWeight.w800,
//                           letterSpacing: 1,
//                         ),
//                       ),
//                     ),
//                   ),
//                 ],
//               ),
//             ),
//           );
//         },
//       ),
//     );
//   }
// }

// // ─────────────────────────────────────────────
// // NOTIFICATIONS PANEL
// // ─────────────────────────────────────────────

// class _NotificationsPanel extends StatefulWidget {
//   final FriendService service;
//   final VoidCallback onRead;

//   const _NotificationsPanel({required this.service, required this.onRead});

//   @override
//   State<_NotificationsPanel> createState() => _NotificationsPanelState();
// }

// class _NotificationsPanelState extends State<_NotificationsPanel> {
//   List<AppNotification> _notifs = [];
//   bool _loading = true;

//   @override
//   void initState() {
//     super.initState();
//     _load();
//   }

//   Future<void> _load() async {
//     final n = await widget.service.getNotifications();
//     if (mounted) setState(() { _notifs = n; _loading = false; });
//   }

//   IconData _iconFor(String type) {
//     switch (type) {
//       case 'friend_request':
//         return Icons.person_add;
//       case 'request_accepted':
//         return Icons.people;
//       case 'match_invite':
//         return Icons.sports_esports;
//       default:
//         return Icons.notifications;
//     }
//   }

//   Color _colorFor(String type) {
//     switch (type) {
//       case 'friend_request':
//         return GameTheme.gold;
//       case 'request_accepted':
//         return GameTheme.green;
//       case 'match_invite':
//         return GameTheme.blue;
//       default:
//         return GameTheme.purple;
//     }
//   }

//   String _timeAgo(DateTime dt) {
//     final diff = DateTime.now().difference(dt);
//     if (diff.inMinutes < 1) return 'Just now';
//     if (diff.inHours < 1) return '${diff.inMinutes}m ago';
//     if (diff.inDays < 1) return '${diff.inHours}h ago';
//     return '${diff.inDays}d ago';
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Container(
//       height: MediaQuery.of(context).size.height * 0.7,
//       decoration: const BoxDecoration(
//         color: GameTheme.surface,
//         borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
//       ),
//       child: Column(
//         children: [
//           Container(
//             margin: const EdgeInsets.symmetric(vertical: 12),
//             width: 40,
//             height: 4,
//             decoration: BoxDecoration(
//               color: GameTheme.border,
//               borderRadius: BorderRadius.circular(2),
//             ),
//           ),
//           Padding(
//             padding: const EdgeInsets.symmetric(horizontal: 20),
//             child: Row(
//               mainAxisAlignment: MainAxisAlignment.spaceBetween,
//               children: [
//                 const Text(
//                   'NOTIFICATIONS',
//                   style: TextStyle(
//                     color: GameTheme.textPrimary,
//                     fontSize: 18,
//                     fontWeight: FontWeight.w800,
//                     letterSpacing: 2,
//                   ),
//                 ),
//                 TextButton(
//                   onPressed: () async {
//                     for (final n in _notifs.where((n) => !n.isRead)) {
//                       await widget.service.markNotificationRead(n.id);
//                     }
//                     widget.onRead();
//                     await _load();
//                   },
//                   child: const Text(
//                     'MARK ALL READ',
//                     style: TextStyle(
//                       color: GameTheme.gold,
//                       fontSize: 11,
//                       fontWeight: FontWeight.w700,
//                       letterSpacing: 1,
//                     ),
//                   ),
//                 ),
//               ],
//             ),
//           ),
//           const SizedBox(height: 12),
//           Expanded(
//             child: _loading
//                 ? const Center(child: CircularProgressIndicator(color: GameTheme.gold))
//                 : _notifs.isEmpty
//                     ? Center(
//                         child: Column(
//                           mainAxisAlignment: MainAxisAlignment.center,
//                           children: [
//                             const Icon(Icons.notifications_off, size: 48, color: GameTheme.textSecondary),
//                             const SizedBox(height: 12),
//                             const Text(
//                               'NO NOTIFICATIONS',
//                               style: TextStyle(
//                                 color: GameTheme.textSecondary,
//                                 fontSize: 14,
//                                 fontWeight: FontWeight.w700,
//                                 letterSpacing: 2,
//                               ),
//                             ),
//                           ],
//                         ),
//                       )
//                     : ListView.builder(
//                         padding: const EdgeInsets.symmetric(horizontal: 20),
//                         itemCount: _notifs.length,
//                         itemBuilder: (_, i) {
//                           final n = _notifs[i];
//                           final color = _colorFor(n.type);
//                           return Container(
//                             margin: const EdgeInsets.only(bottom: 8),
//                             padding: const EdgeInsets.all(14),
//                             decoration: BoxDecoration(
//                               color: GameTheme.card,
//                               borderRadius: BorderRadius.circular(12),
//                               border: Border.all(
//                                 color: n.isRead
//                                     ? GameTheme.border.withOpacity(0.3)
//                                     : color.withOpacity(0.5),
//                               ),
//                             ),
//                             child: Row(
//                               children: [
//                                 Container(
//                                   padding: const EdgeInsets.all(10),
//                                   decoration: BoxDecoration(
//                                     color: color.withOpacity(0.15),
//                                     shape: BoxShape.circle,
//                                   ),
//                                   child: Icon(_iconFor(n.type), color: color, size: 20),
//                                 ),
//                                 const SizedBox(width: 12),
//                                 Expanded(
//                                   child: Column(
//                                     crossAxisAlignment: CrossAxisAlignment.start,
//                                     children: [
//                                       Text(
//                                         n.message,
//                                         style: TextStyle(
//                                           color: n.isRead ? GameTheme.textSecondary : GameTheme.textPrimary,
//                                           fontSize: 13,
//                                           fontWeight: FontWeight.w600,
//                                         ),
//                                       ),
//                                       const SizedBox(height: 4),
//                                       Text(
//                                         _timeAgo(n.createdAt),
//                                         style: const TextStyle(
//                                           color: GameTheme.textSecondary,
//                                           fontSize: 11,
//                                         ),
//                                       ),
//                                     ],
//                                   ),
//                                 ),
//                                 if (!n.isRead)
//                                   Container(
//                                     width: 8,
//                                     height: 8,
//                                     decoration: const BoxDecoration(
//                                       color: GameTheme.gold,
//                                       shape: BoxShape.circle,
//                                     ),
//                                   ),
//                               ],
//                             ),
//                           );
//                         },
//                       ),
//           ),
//         ],
//       ),
//     );
//   }
// }

// // ─────────────────────────────────────────────
// // HELPER CLASSES
// // ─────────────────────────────────────────────

// class _TabData {
//   final String label;
//   final IconData icon;
//   final int index;

//   _TabData(this.label, this.icon, this.index);
// }














import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:intl/intl.dart';

// ═══════════════════════════════════════════
// MODELS
// ═══════════════════════════════════════════

class AppUser {
  final String authUserId;
  final String customId;
  final String email;
  final String? imageUrl;
  final String? username;
  final bool isOnline;
  final DateTime? lastSeen;

  AppUser({
    required this.authUserId,
    required this.customId,
    required this.email,
    this.imageUrl,
    this.username,
    this.isOnline = false,
    this.lastSeen,
  });

  factory AppUser.fromMap(Map<String, dynamic> map) {
    return AppUser(
      authUserId: map['auth_user_id'] ?? '',
      customId: map['custom_id'] ?? '',
      email: map['email'] ?? '',
      imageUrl: map['image_url'],
      username: map['username'],
      isOnline: map['is_online'] ?? false,
      lastSeen: map['last_seen'] != null ? DateTime.tryParse(map['last_seen']) : null,
    );
  }

  String get displayName => username ?? email.split('@').first;
  String get shortId => customId.length > 8 ? customId.substring(0, 8) : customId;
}

class FriendRequest {
  final String id;
  final String senderId;
  final String receiverId;
  final String status;
  final DateTime createdAt;
  AppUser? senderUser;
  AppUser? receiverUser;

  FriendRequest({
    required this.id,
    required this.senderId,
    required this.receiverId,
    required this.status,
    required this.createdAt,
    this.senderUser,
    this.receiverUser,
  });

  factory FriendRequest.fromMap(Map<String, dynamic> map) {
    return FriendRequest(
      id: map['id'] ?? '',
      senderId: map['sender_id'] ?? '',
      receiverId: map['receiver_id'] ?? '',
      status: map['status'] ?? 'pending',
      createdAt: DateTime.tryParse(map['created_at'] ?? '') ?? DateTime.now(),
    );
  }
}

class Message {
  final String id;
  final String senderId;
  final String receiverId;
  final String content;
  final DateTime createdAt;
  final bool isRead;

  Message({
    required this.id,
    required this.senderId,
    required this.receiverId,
    required this.content,
    required this.createdAt,
    this.isRead = false,
  });

  factory Message.fromMap(Map<String, dynamic> map) {
    return Message(
      id: map['id'] ?? '',
      senderId: map['sender_id'] ?? '',
      receiverId: map['receiver_id'] ?? '',
      content: map['content'] ?? '',
      createdAt: DateTime.tryParse(map['created_at'] ?? '') ?? DateTime.now(),
      isRead: map['is_read'] ?? false,
    );
  }
}

class AppNotification {
  final String id;
  final String userId;
  final String type;
  final String message;
  final String? fromUserId;
  final bool isRead;
  final DateTime createdAt;

  AppNotification({
    required this.id,
    required this.userId,
    required this.type,
    required this.message,
    this.fromUserId,
    required this.isRead,
    required this.createdAt,
  });

  factory AppNotification.fromMap(Map<String, dynamic> map) {
    return AppNotification(
      id: map['id'] ?? '',
      userId: map['user_id'] ?? '',
      type: map['type'] ?? '',
      message: map['message'] ?? '',
      fromUserId: map['from_user_id'],
      isRead: map['is_read'] ?? false,
      createdAt: DateTime.tryParse(map['created_at'] ?? '') ?? DateTime.now(),
    );
  }
}

// ═══════════════════════════════════════════
// SUPABASE SERVICE
// ═══════════════════════════════════════════

class FriendService {
  final _supabase = Supabase.instance.client;

  String get currentUserId => _supabase.auth.currentUser!.id;

  // ── Search user ────────────────────────────
  Future<AppUser?> searchUser(String query) async {
    try {
      final res = await _supabase
          .from('users')
          .select()
          .or('custom_id.eq.$query,auth_user_id.eq.$query')
          .neq('auth_user_id', currentUserId)
          .limit(1)
          .maybeSingle();

      if (res != null) return AppUser.fromMap(res);

      // email fallback
      final emailRes = await _supabase
          .from('users')
          .select()
          .ilike('email', '%$query%')
          .neq('auth_user_id', currentUserId)
          .limit(1)
          .maybeSingle();
      if (emailRes != null) return AppUser.fromMap(emailRes);
    } catch (_) {}
    return null;
  }

  // ── Friends list ──────────────────────────
  Future<List<AppUser>> getFriends() async {
    try {
      final res = await _supabase
          .from('friends')
          .select('friend_id')
          .eq('user_id', currentUserId);

      if (res.isEmpty) return [];
      final ids = res.map((e) => e['friend_id'] as String).toList();
      final users = await _supabase.from('users').select().inFilter('auth_user_id', ids);
      return users.map((e) => AppUser.fromMap(e)).toList();
    } catch (_) {
      return [];
    }
  }

  // ── Friend requests (incoming) ────────────
  Future<List<FriendRequest>> getIncomingRequests() async {
    try {
      final res = await _supabase
          .from('friend_requests')
          .select()
          .eq('receiver_id', currentUserId)
          .eq('status', 'pending');

      final requests = res.map((e) => FriendRequest.fromMap(e)).toList();
      for (final req in requests) {
        final user = await _supabase
            .from('users')
            .select()
            .eq('auth_user_id', req.senderId)
            .maybeSingle();
        if (user != null) req.senderUser = AppUser.fromMap(user);
      }
      return requests;
    } catch (_) {
      return [];
    }
  }

  // ── Sent requests ─────────────────────────
  Future<List<FriendRequest>> getSentRequests() async {
    try {
      final res = await _supabase
          .from('friend_requests')
          .select()
          .eq('sender_id', currentUserId)
          .eq('status', 'pending');

      final requests = res.map((e) => FriendRequest.fromMap(e)).toList();
      for (final req in requests) {
        final user = await _supabase
            .from('users')
            .select()
            .eq('auth_user_id', req.receiverId)
            .maybeSingle();
        if (user != null) req.receiverUser = AppUser.fromMap(user);
      }
      return requests;
    } catch (_) {
      return [];
    }
  }

  // ── Send request ──────────────────────────
  Future<String?> sendFriendRequest(String receiverId) async {
    try {
      // Check existing request
      final existing = await _supabase
          .from('friend_requests')
          .select()
          .or('and(sender_id.eq.$currentUserId,receiver_id.eq.$receiverId),and(sender_id.eq.$receiverId,receiver_id.eq.$currentUserId)')
          .maybeSingle();

      if (existing != null) {
        if (existing['status'] == 'pending') return 'Request already pending';
        if (existing['status'] == 'accepted') return 'Already friends';
      }

      final already = await _supabase
          .from('friends')
          .select()
          .eq('user_id', currentUserId)
          .eq('friend_id', receiverId)
          .maybeSingle();
      if (already != null) return 'Already friends';

      await _supabase.from('friend_requests').insert({
        'sender_id': currentUserId,
        'receiver_id': receiverId,
        'status': 'pending',
      });

      await _supabase.from('notifications').insert({
        'user_id': receiverId,
        'type': 'friend_request',
        'message': 'You have a new friend request',
        'from_user_id': currentUserId,
        'is_read': false,
      });
      return null;
    } catch (e) {
      return 'Error: $e';
    }
  }

  // ── Accept / reject / cancel / remove ─────
  Future<void> acceptRequest(String requestId, String senderId) async {
    await _supabase.from('friend_requests').update({'status': 'accepted'}).eq('id', requestId);
    await _supabase.from('friends').insert([
      {'user_id': currentUserId, 'friend_id': senderId},
      {'user_id': senderId, 'friend_id': currentUserId},
    ]);
    await _supabase.from('notifications').insert({
      'user_id': senderId,
      'type': 'request_accepted',
      'message': 'Your friend request was accepted!',
      'from_user_id': currentUserId,
      'is_read': false,
    });
  }

  Future<void> rejectRequest(String requestId) async {
    await _supabase.from('friend_requests').update({'status': 'rejected'}).eq('id', requestId);
  }

  Future<void> cancelRequest(String requestId) async {
    await _supabase.from('friend_requests').delete().eq('id', requestId);
  }

  Future<void> removeFriend(String friendId) async {
    await _supabase.from('friends').delete().eq('user_id', currentUserId).eq('friend_id', friendId);
    await _supabase.from('friends').delete().eq('user_id', friendId).eq('friend_id', currentUserId);
  }

  // ── Notifications ─────────────────────────
  Future<List<AppNotification>> getNotifications() async {
    try {
      final res = await _supabase
          .from('notifications')
          .select()
          .eq('user_id', currentUserId)
          .order('created_at', ascending: false)
          .limit(30);
      return res.map((e) => AppNotification.fromMap(e)).toList();
    } catch (_) {
      return [];
    }
  }

  Future<void> markNotificationRead(String notifId) async {
    await _supabase.from('notifications').update({'is_read': true}).eq('id', notifId);
  }

  // ── Messages ──────────────────────────────
  Future<List<Message>> getMessages(String otherUserId) async {
    try {
      final res = await _supabase
          .from('messages')
          .select()
          .or('and(sender_id.eq.$currentUserId,receiver_id.eq.$otherUserId),and(sender_id.eq.$otherUserId,receiver_id.eq.$currentUserId)')
          .order('created_at', ascending: true)
          .limit(50);
      return res.map((e) => Message.fromMap(e)).toList();
    } catch (_) {
      return [];
    }
  }

  Future<void> sendMessage(String receiverId, String content) async {
    await _supabase.from('messages').insert({
      'sender_id': currentUserId,
      'receiver_id': receiverId,
      'content': content,
      'is_read': false,
    });
  }

  // ── Suggested friends ────────────────────
  Future<List<AppUser>> getSuggestedFriends() async {
    try {
      final friendsRes = await _supabase.from('friends').select('friend_id').eq('user_id', currentUserId);
      final sentRes = await _supabase.from('friend_requests').select('receiver_id').eq('sender_id', currentUserId).eq('status', 'pending');
      final excludeIds = <String>[
        ...friendsRes.map((e) => e['friend_id'] as String),
        ...sentRes.map((e) => e['receiver_id'] as String),
        currentUserId,
      ];

      if (excludeIds.isEmpty) {
        return (await _supabase.from('users').select().limit(10)).map((e) => AppUser.fromMap(e)).toList();
      }
      final res = await _supabase.from('users').select().not('auth_user_id', 'in', '(${excludeIds.join(',')})').limit(10);
      return res.map((e) => AppUser.fromMap(e)).toList();
    } catch (_) {
      return [];
    }
  }

  // ── Realtime subscriptions ────────────────
  RealtimeChannel subscribeToNotifications(Function(AppNotification) onNew) {
    return _supabase
        .channel('notifications_$currentUserId')
        .onPostgresChanges(
          event: PostgresChangeEvent.insert,
          schema: 'public',
          table: 'notifications',
          filter: PostgresChangeFilter(type: PostgresChangeFilterType.eq, column: 'user_id', value: currentUserId),
          callback: (payload) {
            final notif = AppNotification.fromMap(payload.newRecord);
            onNew(notif);
          },
        )
        .subscribe();
  }

  RealtimeChannel subscribeToMessages(String otherUserId, Function(Message) onNew) {
    return _supabase
        .channel('messages_${currentUserId}_$otherUserId')
        .onPostgresChanges(
          event: PostgresChangeEvent.insert,
          schema: 'public',
          table: 'messages',
          callback: (payload) {
            final msg = Message.fromMap(payload.newRecord);
            if ((msg.senderId == currentUserId && msg.receiverId == otherUserId) ||
                (msg.senderId == otherUserId && msg.receiverId == currentUserId)) {
              onNew(msg);
            }
          },
        )
        .subscribe();
  }
}

// ═══════════════════════════════════════════
// THEME
// ═══════════════════════════════════════════

class GameTheme {
  static const bg = Color(0xFF0A0E17);
  static const surface = Color(0xFF141B26);
  static const card = Color(0xFF1A2235);
  static const cardLight = Color(0xFF1F2840);
  static const gold = Color(0xFFFFD700);
  static const goldDark = Color(0xFFB8960F);
  static const green = Color(0xFF00E676);
  static const red = Color(0xFFFF1744);
  static const blue = Color(0xFF448AFF);
  static const purple = Color(0xFF7C4DFF);
  static const textPrimary = Color(0xFFF5F5F5);
  static const textSecondary = Color(0xFF8A94A8);
  static const border = Color(0xFF2A3347);

  static final gradientGold = LinearGradient(colors: [gold, const Color(0xFFFFA000)]);
  static final gradientPurple = LinearGradient(colors: [purple, const Color(0xFF651FFF)]);
  static final gradientBg = LinearGradient(colors: [bg, surface], begin: Alignment.topCenter, end: Alignment.bottomCenter);

  static BoxDecoration cardDecoration = BoxDecoration(
    gradient: LinearGradient(colors: [cardLight, card]),
    borderRadius: BorderRadius.circular(16),
    border: Border.all(color: border.withOpacity(0.5)),
    boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.3), blurRadius: 10, offset: Offset(0, 4))],
  );
}

// ═══════════════════════════════════════════
// APP ENTRY
// ═══════════════════════════════════════════

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Supabase.initialize(
    url: 'YOUR_SUPABASE_URL',
    anonKey: 'YOUR_ANON_KEY',
  );
  runApp(const GameFriendsApp());
}

class GameFriendsApp extends StatelessWidget {
  const GameFriendsApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Game Friends',
      theme: ThemeData(
        brightness: Brightness.dark,
        scaffoldBackgroundColor: GameTheme.bg,
        colorScheme: ColorScheme.dark(primary: GameTheme.gold, surface: GameTheme.surface),
        fontFamily: 'Roboto',
      ),
      home: const MainScreen(),
    );
  }
}

// ═══════════════════════════════════════════
// MAIN SCREEN
// ═══════════════════════════════════════════

class MainScreen extends StatefulWidget {
  const MainScreen({super.key});

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  final _service = FriendService();
  int _unreadNotifs = 0;
  int _selectedTab = 0;
  final _searchCtrl = TextEditingController();
  AppUser? _searchResult;
  bool _searching = false;
  late RealtimeChannel _notifChannel;

  @override
  void initState() {
    super.initState();
    _loadUnread();
    _notifChannel = _service.subscribeToNotifications((n) {
      if (mounted) {
        setState(() => _unreadNotifs++);
        _showPopup(n.message);
      }
    });
  }

  Future<void> _loadUnread() async {
    final notifs = await _service.getNotifications();
    if (mounted) setState(() => _unreadNotifs = notifs.where((n) => !n.isRead).length);
  }

  void _showPopup(String msg) {
    if (!mounted) return;
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        backgroundColor: GameTheme.card,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        content: Row(children: [
          Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(gradient: GameTheme.gradientGold, shape: BoxShape.circle),
            child: const Icon(Icons.notifications, color: Colors.black, size: 24),
          ),
          const SizedBox(width: 16),
          Expanded(child: Text(msg, style: const TextStyle(color: GameTheme.textPrimary, fontSize: 16))),
        ]),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context), child: const Text('OK', style: TextStyle(color: GameTheme.gold))),
        ],
      ),
    );
  }

  Future<void> _search() async {
    final q = _searchCtrl.text.trim();
    if (q.isEmpty) return;
    setState(() => _searching = true);
    final user = await _service.searchUser(q);
    if (mounted) {
      setState(() {
        _searching = false;
        _searchResult = user;
      });
    }
  }

  Future<void> _sendRequest(AppUser user) async {
    final err = await _service.sendFriendRequest(user.authUserId);
    if (!mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
      content: Text(err ?? 'Friend request sent! 🎮', style: const TextStyle(color: Colors.white)),
      backgroundColor: err != null ? GameTheme.red : GameTheme.green,
      behavior: SnackBarBehavior.floating,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
    ));
    if (err == null) {
      setState(() {
        _searchResult = null;
        _searchCtrl.clear();
      });
    }
  }

  @override
  void dispose() {
    _notifChannel.unsubscribe();
    _searchCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(gradient: GameTheme.gradientBg),
        child: SafeArea(
          child: Column(children: [
            _buildHeader(),
            _buildSearchBar(),
            _buildTabNav(),
            if (_searchResult != null) _buildSearchResultCard() else Expanded(child: _buildTabContent()),
          ]),
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return Container(
      padding: const EdgeInsets.fromLTRB(20, 16, 20, 12),
      decoration: BoxDecoration(border: Border(bottom: BorderSide(color: GameTheme.border.withOpacity(0.3)))),
      child: Row(children: [
        Container(
          padding: const EdgeInsets.all(10),
          decoration: BoxDecoration(
            gradient: GameTheme.gradientGold,
            borderRadius: BorderRadius.circular(12),
            boxShadow: [BoxShadow(color: GameTheme.gold.withOpacity(0.3), blurRadius: 15)],
          ),
          child: const Text('♛', style: TextStyle(fontSize: 24, color: Colors.black)),
        ),
        const SizedBox(width: 12),
        const Expanded(
          child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            Text('SOCIAL HUB', style: TextStyle(color: GameTheme.textPrimary, fontSize: 18, fontWeight: FontWeight.w800, letterSpacing: 2)),
            Text('Connect & Conquer', style: TextStyle(color: GameTheme.gold, fontSize: 11, fontWeight: FontWeight.w600, letterSpacing: 1)),
          ]),
        ),
        _buildIconBadge(Icons.notifications_outlined, _unreadNotifs, () => _showNotifications()),
      ]),
    );
  }

  Widget _buildIconBadge(IconData icon, int count, VoidCallback onTap) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 44,
        height: 44,
        decoration: BoxDecoration(
          color: GameTheme.card,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: GameTheme.border.withOpacity(0.5)),
        ),
        child: Stack(children: [
          Center(child: Icon(icon, color: GameTheme.textPrimary, size: 22)),
          if (count > 0)
            Positioned(
              right: 6,
              top: 6,
              child: Container(
                padding: const EdgeInsets.all(4),
                decoration: const BoxDecoration(color: GameTheme.red, shape: BoxShape.circle),
                child: Text(count > 99 ? '99+' : '$count', style: const TextStyle(color: Colors.white, fontSize: 8, fontWeight: FontWeight.w800)),
              ),
            ),
        ]),
      ),
    );
  }

  Widget _buildSearchBar() {
    return Container(
      margin: const EdgeInsets.fromLTRB(20, 12, 20, 0),
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      decoration: GameTheme.cardDecoration.copyWith(borderRadius: BorderRadius.circular(16)),
      child: Row(children: [
        const Icon(Icons.search, color: GameTheme.gold, size: 22),
        const SizedBox(width: 12),
        Expanded(
          child: TextField(
            controller: _searchCtrl,
            style: const TextStyle(color: GameTheme.textPrimary, fontSize: 14),
            decoration: const InputDecoration(
              hintText: 'Search players by ID...',
              hintStyle: TextStyle(color: GameTheme.textSecondary, fontSize: 13),
              border: InputBorder.none,
            ),
            onSubmitted: (_) => _search(),
          ),
        ),
        if (_searching)
          const Padding(padding: EdgeInsets.all(8), child: SizedBox(width: 20, height: 20, child: CircularProgressIndicator(strokeWidth: 2, color: GameTheme.gold)))
        else
          GestureDetector(
            onTap: _search,
            child: Container(
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(gradient: GameTheme.gradientGold, borderRadius: BorderRadius.circular(10)),
              child: const Icon(Icons.search, color: Colors.black, size: 20),
            ),
          ),
      ]),
    );
  }

  Widget _buildTabNav() {
    final tabs = [
      _TabData('Friends', Icons.people, 0),
      _TabData('Chats', Icons.messenger, 1),
      _TabData('Requests', Icons.person_add, 2),
      _TabData('Discover', Icons.explore, 3),
    ];
    return Container(
      margin: const EdgeInsets.fromLTRB(20, 16, 20, 8),
      height: 48,
      child: Row(
        children: tabs.map((tab) {
          final sel = _selectedTab == tab.index;
          return Expanded(
            child: GestureDetector(
              onTap: () => setState(() => _selectedTab = tab.index),
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 200),
                margin: const EdgeInsets.symmetric(horizontal: 4),
                decoration: BoxDecoration(
                  gradient: sel ? GameTheme.gradientGold : null,
                  color: sel ? null : GameTheme.card,
                  borderRadius: BorderRadius.circular(12),
                  border: sel ? null : Border.all(color: GameTheme.border.withOpacity(0.5)),
                ),
                child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
                  Icon(tab.icon, color: sel ? Colors.black : GameTheme.textSecondary, size: 18),
                  const SizedBox(height: 2),
                  Text(tab.label, style: TextStyle(color: sel ? Colors.black : GameTheme.textSecondary, fontSize: 9, fontWeight: FontWeight.w700, letterSpacing: 0.5)),
                ]),
              ),
            ),
          );
        }).toList(),
      ),
    );
  }

  Widget _buildSearchResultCard() {
    final user = _searchResult!;
    return Container(
      margin: const EdgeInsets.fromLTRB(20, 16, 20, 0),
      padding: const EdgeInsets.all(20),
      decoration: GameTheme.cardDecoration,
      child: Column(mainAxisSize: MainAxisSize.min, children: [
        Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
          const Text('SEARCH RESULT', style: TextStyle(color: GameTheme.gold, fontSize: 12, fontWeight: FontWeight.w700, letterSpacing: 2)),
          IconButton(icon: const Icon(Icons.close, color: GameTheme.textSecondary), onPressed: () { setState(() { _searchResult = null; _searchCtrl.clear(); }); }),
        ]),
        const SizedBox(height: 16),
        Container(
          width: 80, height: 80,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            border: Border.all(color: GameTheme.gold, width: 2),
            boxShadow: [BoxShadow(color: GameTheme.gold.withOpacity(0.3), blurRadius: 15)],
          ),
          child: ClipOval(child: _avatarWidget(user, size: 80)),
        ),
        const SizedBox(height: 16),
        Text(user.displayName, style: const TextStyle(color: GameTheme.textPrimary, fontSize: 20, fontWeight: FontWeight.w800)),
        const SizedBox(height: 4),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
          decoration: BoxDecoration(color: GameTheme.border.withOpacity(0.3), borderRadius: BorderRadius.circular(8)),
          child: Row(mainAxisSize: MainAxisSize.min, children: [
            const Icon(Icons.tag, size: 14, color: GameTheme.gold),
            const SizedBox(width: 4),
            Text(user.shortId, style: const TextStyle(color: GameTheme.gold, fontSize: 13)),
          ]),
        ),
        const SizedBox(height: 20),
        GestureDetector(
          onTap: () => _sendRequest(user),
          child: Container(
            width: double.infinity,
            padding: const EdgeInsets.symmetric(vertical: 14),
            decoration: BoxDecoration(
              gradient: GameTheme.gradientGold,
              borderRadius: BorderRadius.circular(12),
              boxShadow: [BoxShadow(color: GameTheme.gold.withOpacity(0.3), blurRadius: 10)],
            ),
            child: const Center(child: Text('SEND FRIEND REQUEST', style: TextStyle(color: Colors.black, fontWeight: FontWeight.w800, fontSize: 14, letterSpacing: 1))),
          ),
        ),
      ]),
    );
  }

  Widget _avatarWidget(AppUser user, {double size = 48}) {
    return user.imageUrl != null && user.imageUrl!.isNotEmpty
        ? Image.network(user.imageUrl!, fit: BoxFit.cover, errorBuilder: (_, __, ___) => _avatarFallback(user, size))
        : _avatarFallback(user, size);
  }

  Widget _avatarFallback(AppUser user, double size) {
    return Container(
      color: GameTheme.purple,
      alignment: Alignment.center,
      child: Text(user.displayName[0].toUpperCase(), style: TextStyle(color: Colors.white, fontSize: size * 0.4, fontWeight: FontWeight.w800)),
    );
  }

  Widget _buildTabContent() {
    switch (_selectedTab) {
      case 0: return _FriendsTab(service: _service);
      case 1: return _ChatsList(service: _service);
      case 2: return _RequestsTab(service: _service, onRefresh: () => setState(() {}));
      case 3: return _DiscoverTab(service: _service);
      default: return const SizedBox();
    }
  }

  void _showNotifications() {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      isScrollControlled: true,
      builder: (_) => _NotificationsPanel(service: _service, onRead: () => setState(() => _unreadNotifs = 0)),
    );
  }
}

// ═══════════════════════════════════════════
// FRIENDS TAB
// ═══════════════════════════════════════════

class _FriendsTab extends StatefulWidget {
  final FriendService service;
  const _FriendsTab({required this.service});

  @override
  State<_FriendsTab> createState() => _FriendsTabState();
}

class _FriendsTabState extends State<_FriendsTab> {
  List<AppUser> _friends = [];
  bool _loading = true;

  @override
  void initState() {
    super.initState();
    _load();
  }

  Future<void> _load() async {
    setState(() => _loading = true);
    final f = await widget.service.getFriends();
    if (mounted) setState(() { _friends = f; _loading = false; });
  }

  @override
  Widget build(BuildContext context) {
    if (_loading) return const Center(child: CircularProgressIndicator(color: GameTheme.gold));
    if (_friends.isEmpty) return _emptyState('NO FRIENDS YET', 'Search for players and add them!', Icons.people_outline);
    return RefreshIndicator(
      onRefresh: _load,
      color: GameTheme.gold,
      child: ListView.builder(
        padding: const EdgeInsets.fromLTRB(20, 12, 20, 20),
        itemCount: _friends.length,
        itemBuilder: (_, i) => _FriendCard(user: _friends[i], service: widget.service, onRemove: _load),
      ),
    );
  }

  Widget _emptyState(String title, String subtitle, IconData icon) {
    return Center(
      child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
        Container(padding: const EdgeInsets.all(30), decoration: BoxDecoration(shape: BoxShape.circle, border: Border.all(color: GameTheme.border, width: 2)), child: Icon(icon, size: 60, color: GameTheme.textSecondary)),
        const SizedBox(height: 24),
        Text(title, style: const TextStyle(color: GameTheme.textSecondary, fontSize: 18, fontWeight: FontWeight.w700, letterSpacing: 2)),
        const SizedBox(height: 8),
        Text(subtitle, style: const TextStyle(color: GameTheme.textSecondary, fontSize: 14)),
      ]),
    );
  }
}

class _FriendCard extends StatelessWidget {
  final AppUser user;
  final FriendService service;
  final VoidCallback onRemove;
  const _FriendCard({required this.user, required this.service, required this.onRemove});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      decoration: GameTheme.cardDecoration,
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Row(children: [
          Stack(children: [
            Container(
              width: 52, height: 52,
              decoration: BoxDecoration(shape: BoxShape.circle, border: Border.all(color: user.isOnline ? GameTheme.green : GameTheme.border, width: 2), boxShadow: [if (user.isOnline) BoxShadow(color: GameTheme.green.withOpacity(0.3), blurRadius: 10)]),
              child: ClipOval(child: _avatarWidget(user, size: 52)),
            ),
            if (user.isOnline)
              Positioned(right: 0, bottom: 0, child: Container(width: 14, height: 14, decoration: BoxDecoration(color: GameTheme.green, shape: BoxShape.circle, border: Border.all(color: GameTheme.card, width: 2)))),
          ]),
          const SizedBox(width: 14),
          Expanded(
            child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              Text(user.displayName, style: const TextStyle(color: GameTheme.textPrimary, fontSize: 15, fontWeight: FontWeight.w700)),
              const SizedBox(height: 4),
              Row(children: [
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                  decoration: BoxDecoration(color: user.isOnline ? GameTheme.green.withOpacity(0.15) : GameTheme.border.withOpacity(0.5), borderRadius: BorderRadius.circular(4)),
                  child: Text(user.isOnline ? 'ONLINE' : 'OFFLINE', style: TextStyle(color: user.isOnline ? GameTheme.green : GameTheme.textSecondary, fontSize: 9, fontWeight: FontWeight.w700, letterSpacing: 1)),
                ),
                const SizedBox(width: 8),
                Text('ID: ${user.shortId}', style: const TextStyle(color: GameTheme.textSecondary, fontSize: 11)),
              ]),
            ]),
          ),
          _ActionIcon(icon: Icons.sports_esports, color: GameTheme.gold, onTap: () => _showMatchInvite(context)),
          const SizedBox(width: 8),
          _ActionIcon(icon: Icons.message, color: GameTheme.blue, onTap: () => _openChat(context)),
          const SizedBox(width: 8),
          _ActionIcon(icon: Icons.person_remove, color: GameTheme.red, onTap: () => _confirmRemove(context)),
        ]),
      ),
    );
  }

  Widget _avatarWidget(AppUser user, {double size = 48}) {
    return user.imageUrl != null && user.imageUrl!.isNotEmpty
        ? Image.network(user.imageUrl!, fit: BoxFit.cover, errorBuilder: (_, __, ___) => _fallback(size))
        : _fallback(size);
  }

  Widget _fallback(double size) {
    return Container(
      color: GameTheme.purple,
      alignment: Alignment.center,
      child: Text(user.displayName[0].toUpperCase(), style: TextStyle(color: Colors.white, fontSize: size * 0.4, fontWeight: FontWeight.w800)),
    );
  }

  void _showMatchInvite(BuildContext context) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Inviting ${user.displayName} to match...'), backgroundColor: GameTheme.goldDark));
  }

  void _openChat(BuildContext context) {
    Navigator.push(context, MaterialPageRoute(builder: (_) => _ChatScreen(service: service, otherUser: user)));
  }

  void _confirmRemove(BuildContext context) {
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        backgroundColor: GameTheme.card,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        title: const Text('Remove Friend', style: TextStyle(color: GameTheme.textPrimary)),
        content: Text('Remove ${user.displayName} from friends?', style: const TextStyle(color: GameTheme.textSecondary)),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context), child: const Text('Cancel', style: TextStyle(color: GameTheme.textSecondary))),
          TextButton(onPressed: () async { Navigator.pop(context); await service.removeFriend(user.authUserId); onRemove(); }, child: const Text('Remove', style: TextStyle(color: GameTheme.red))),
        ],
      ),
    );
  }
}

class _ActionIcon extends StatelessWidget {
  final IconData icon;
  final Color color;
  final VoidCallback onTap;
  const _ActionIcon({required this.icon, required this.color, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 36, height: 36,
        decoration: BoxDecoration(color: color.withOpacity(0.15), borderRadius: BorderRadius.circular(10), border: Border.all(color: color.withOpacity(0.3))),
        child: Icon(icon, color: color, size: 18),
      ),
    );
  }
}

// ═══════════════════════════════════════════
// CHATS LIST
// ═══════════════════════════════════════════

class _ChatsList extends StatefulWidget {
  final FriendService service;
  const _ChatsList({required this.service});

  @override
  State<_ChatsList> createState() => _ChatsListState();
}

class _ChatsListState extends State<_ChatsList> {
  List<AppUser> _friends = [];
  bool _loading = true;

  @override
  void initState() {
    super.initState();
    _load();
  }

  Future<void> _load() async {
    setState(() => _loading = true);
    final f = await widget.service.getFriends();
    if (mounted) setState(() { _friends = f; _loading = false; });
  }

  @override
  Widget build(BuildContext context) {
    if (_loading) return const Center(child: CircularProgressIndicator(color: GameTheme.gold));
    if (_friends.isEmpty) {
      return Center(
        child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
          Container(padding: const EdgeInsets.all(30), decoration: BoxDecoration(shape: BoxShape.circle, border: Border.all(color: GameTheme.border, width: 2)), child: const Icon(Icons.messenger_outline, size: 60, color: GameTheme.textSecondary)),
          const SizedBox(height: 24),
          const Text('NO CONVERSATIONS', style: TextStyle(color: GameTheme.textSecondary, fontSize: 18, fontWeight: FontWeight.w700, letterSpacing: 2)),
          const SizedBox(height: 8),
          const Text('Add friends to start chatting!', style: TextStyle(color: GameTheme.textSecondary, fontSize: 14)),
        ]),
      );
    }
    return ListView.builder(
      padding: const EdgeInsets.fromLTRB(20, 12, 20, 20),
      itemCount: _friends.length,
      itemBuilder: (_, i) => GestureDetector(
        onTap: () => Navigator.push(context, MaterialPageRoute(builder: (_) => _ChatScreen(service: widget.service, otherUser: _friends[i]))),
        child: Container(
          margin: const EdgeInsets.only(bottom: 10),
          decoration: GameTheme.cardDecoration,
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Row(children: [
              _buildAvatar(_friends[i]),
              const SizedBox(width: 14),
              Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                Text(_friends[i].displayName, style: const TextStyle(color: GameTheme.textPrimary, fontSize: 15, fontWeight: FontWeight.w700)),
                const SizedBox(height: 4),
                Text('Tap to open chat', style: TextStyle(color: GameTheme.textSecondary.withOpacity(0.7), fontSize: 12)),
              ])),
              const Icon(Icons.chevron_right, color: GameTheme.textSecondary),
            ]),
          ),
        ),
      ),
    );
  }

  Widget _buildAvatar(AppUser user) {
    return Stack(children: [
      Container(
        width: 50, height: 50,
        decoration: BoxDecoration(shape: BoxShape.circle, border: Border.all(color: GameTheme.gold.withOpacity(0.3))),
        child: ClipOval(child: user.imageUrl != null && user.imageUrl!.isNotEmpty
            ? Image.network(user.imageUrl!, fit: BoxFit.cover, errorBuilder: (_, __, ___) => _fallback(user))
            : _fallback(user)),
      ),
      if (user.isOnline)
        Positioned(right: 0, bottom: 0, child: Container(width: 14, height: 14, decoration: BoxDecoration(color: GameTheme.green, shape: BoxShape.circle, border: Border.all(color: GameTheme.card, width: 2)))),
    ]);
  }

  Widget _fallback(AppUser user) {
    return Container(
      color: GameTheme.purple,
      child: Center(child: Text(user.displayName[0].toUpperCase(), style: const TextStyle(color: Colors.white, fontSize: 20, fontWeight: FontWeight.w800))),
    );
  }
}

// ═══════════════════════════════════════════
// CHAT SCREEN
// ═══════════════════════════════════════════

class _ChatScreen extends StatefulWidget {
  final FriendService service;
  final AppUser otherUser;
  const _ChatScreen({required this.service, required this.otherUser});

  @override
  State<_ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends State<_ChatScreen> {
  final _msgCtrl = TextEditingController();
  List<Message> _messages = [];
  bool _loading = true;
  late RealtimeChannel _msgChannel;
  final _scrollCtrl = ScrollController();

  @override
  void initState() {
    super.initState();
    _loadMessages();
    _msgChannel = widget.service.subscribeToMessages(widget.otherUser.authUserId, (msg) {
      if (mounted) {
        setState(() => _messages.add(msg));
        _scrollToBottom();
      }
    });
  }

  Future<void> _loadMessages() async {
    final msgs = await widget.service.getMessages(widget.otherUser.authUserId);
    if (mounted) {
      setState(() { _messages = msgs; _loading = false; });
      _scrollToBottom();
    }
  }

  void _scrollToBottom() {
    Future.delayed(const Duration(milliseconds: 100), () {
      if (_scrollCtrl.hasClients) _scrollCtrl.animateTo(_scrollCtrl.position.maxScrollExtent, duration: const Duration(milliseconds: 300), curve: Curves.easeOut);
    });
  }

  Future<void> _send() async {
    final text = _msgCtrl.text.trim();
    if (text.isEmpty) return;
    await widget.service.sendMessage(widget.otherUser.authUserId, text);
    _msgCtrl.clear();
  }

  @override
  void dispose() {
    _msgChannel.unsubscribe();
    _msgCtrl.dispose();
    _scrollCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(gradient: GameTheme.gradientBg),
        child: SafeArea(child: Column(children: [
          _buildHeader(),
          Expanded(
            child: _loading
                ? const Center(child: CircularProgressIndicator(color: GameTheme.gold))
                : _messages.isEmpty
                    ? Center(child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
                        const Icon(Icons.chat_bubble_outline, size: 60, color: GameTheme.textSecondary),
                        const SizedBox(height: 16),
                        Text('Say hello to ${widget.otherUser.displayName}!', style: const TextStyle(color: GameTheme.textSecondary, fontSize: 14)),
                      ]))
                    : ListView.builder(
                        controller: _scrollCtrl,
                        padding: const EdgeInsets.all(16),
                        itemCount: _messages.length,
                        itemBuilder: (_, i) => _MessageBubble(message: _messages[i], isMe: _messages[i].senderId == widget.service.currentUserId),
                      ),
          ),
          _buildInput(),
        ])),
      ),
    );
  }

  Widget _buildHeader() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(color: GameTheme.card, border: Border(bottom: BorderSide(color: GameTheme.border.withOpacity(0.3)))),
      child: Row(children: [
        IconButton(icon: const Icon(Icons.arrow_back, color: GameTheme.textPrimary), onPressed: () => Navigator.pop(context)),
        const SizedBox(width: 8),
        Container(
          width: 42, height: 42,
          decoration: BoxDecoration(shape: BoxShape.circle, border: Border.all(color: widget.otherUser.isOnline ? GameTheme.green : GameTheme.border, width: 2)),
          child: ClipOval(child: _avatarWidget(widget.otherUser, size: 42)),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            Text(widget.otherUser.displayName, style: const TextStyle(color: GameTheme.textPrimary, fontSize: 16, fontWeight: FontWeight.w700)),
            Text(widget.otherUser.isOnline ? 'Online' : 'Offline', style: TextStyle(color: widget.otherUser.isOnline ? GameTheme.green : GameTheme.textSecondary, fontSize: 12)),
          ]),
        ),
        Container(
          padding: const EdgeInsets.all(10),
          decoration: BoxDecoration(gradient: GameTheme.gradientGold, borderRadius: BorderRadius.circular(12)),
          child: const Icon(Icons.sports_esports, color: Colors.black, size: 20),
        ),
      ]),
    );
  }

  Widget _avatarWidget(AppUser user, {double size = 42}) {
    return user.imageUrl != null && user.imageUrl!.isNotEmpty
        ? Image.network(user.imageUrl!, fit: BoxFit.cover, errorBuilder: (_, __, ___) => _fallback(size))
        : _fallback(size);
  }

  Widget _fallback(double size) {
    return Container(
      color: GameTheme.purple,
      alignment: Alignment.center,
      child: Text(widget.otherUser.displayName[0].toUpperCase(), style: TextStyle(color: Colors.white, fontSize: size * 0.4, fontWeight: FontWeight.w800)),
    );
  }

  Widget _buildInput() {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(color: GameTheme.card, border: Border(top: BorderSide(color: GameTheme.border.withOpacity(0.3)))),
      child: Row(children: [
        Expanded(
          child: Container(
            decoration: BoxDecoration(color: GameTheme.surface, borderRadius: BorderRadius.circular(25), border: Border.all(color: GameTheme.border.withOpacity(0.5))),
            child: TextField(
              controller: _msgCtrl,
              style: const TextStyle(color: GameTheme.textPrimary),
              decoration: const InputDecoration(hintText: 'Type a message...', hintStyle: TextStyle(color: GameTheme.textSecondary), border: InputBorder.none, contentPadding: EdgeInsets.symmetric(horizontal: 20, vertical: 14)),
              onSubmitted: (_) => _send(),
            ),
          ),
        ),
        const SizedBox(width: 8),
        GestureDetector(
          onTap: _send,
          child: Container(
            padding: const EdgeInsets.all(14),
            decoration: BoxDecoration(gradient: GameTheme.gradientGold, shape: BoxShape.circle, boxShadow: [BoxShadow(color: GameTheme.gold.withOpacity(0.3), blurRadius: 8)]),
            child: const Icon(Icons.send, color: Colors.black, size: 20),
          ),
        ),
      ]),
    );
  }
}

class _MessageBubble extends StatelessWidget {
  final Message message;
  final bool isMe;
  const _MessageBubble({required this.message, required this.isMe});

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: isMe ? Alignment.centerRight : Alignment.centerLeft,
      child: Container(
        margin: const EdgeInsets.only(bottom: 8),
        constraints: BoxConstraints(maxWidth: MediaQuery.of(context).size.width * 0.75),
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        decoration: BoxDecoration(
          gradient: isMe ? GameTheme.gradientGold : null,
          color: isMe ? null : GameTheme.card,
          borderRadius: BorderRadius.only(
            topLeft: const Radius.circular(16), topRight: const Radius.circular(16),
            bottomLeft: isMe ? const Radius.circular(16) : Radius.zero,
            bottomRight: isMe ? Radius.zero : const Radius.circular(16),
          ),
          border: isMe ? null : Border.all(color: GameTheme.border.withOpacity(0.3)),
        ),
        child: Column(crossAxisAlignment: isMe ? CrossAxisAlignment.end : CrossAxisAlignment.start, children: [
          Text(message.content, style: TextStyle(color: isMe ? Colors.black : GameTheme.textPrimary, fontSize: 14)),
          const SizedBox(height: 4),
          Text(DateFormat('HH:mm').format(message.createdAt), style: TextStyle(color: isMe ? Colors.black54 : GameTheme.textSecondary, fontSize: 10)),
        ]),
      ),
    );
  }
}

// ═══════════════════════════════════════════
// REQUESTS TAB
// ═══════════════════════════════════════════

class _RequestsTab extends StatefulWidget {
  final FriendService service;
  final VoidCallback onRefresh;
  const _RequestsTab({required this.service, required this.onRefresh});

  @override
  State<_RequestsTab> createState() => _RequestsTabState();
}

class _RequestsTabState extends State<_RequestsTab> with SingleTickerProviderStateMixin {
  late TabController _tabCtrl;
  @override
  void initState() { super.initState(); _tabCtrl = TabController(length: 2, vsync: this); }
  @override
  void dispose() { _tabCtrl.dispose(); super.dispose(); }

  @override
  Widget build(BuildContext context) {
    return Column(children: [
      Container(
        margin: const EdgeInsets.fromLTRB(20, 12, 20, 8), height: 40,
        decoration: BoxDecoration(color: GameTheme.card, borderRadius: BorderRadius.circular(12)),
        child: TabBar(
          controller: _tabCtrl,
          indicator: BoxDecoration(gradient: GameTheme.gradientGold, borderRadius: BorderRadius.circular(10)),
          indicatorSize: TabBarIndicatorSize.tab,
          labelColor: Colors.black,
          unselectedLabelColor: GameTheme.textSecondary,
          labelStyle: const TextStyle(fontWeight: FontWeight.w700, fontSize: 11, letterSpacing: 1),
          tabs: const [Tab(text: 'RECEIVED'), Tab(text: 'SENT')],
        ),
      ),
      Expanded(child: TabBarView(controller: _tabCtrl, children: [
        _ReceivedRequests(service: widget.service, onRefresh: widget.onRefresh),
        _SentRequests(service: widget.service, onRefresh: widget.onRefresh),
      ])),
    ]);
  }
}

class _ReceivedRequests extends StatefulWidget {
  final FriendService service;
  final VoidCallback onRefresh;
  const _ReceivedRequests({required this.service, required this.onRefresh});

  @override
  State<_ReceivedRequests> createState() => _ReceivedRequestsState();
}

class _ReceivedRequestsState extends State<_ReceivedRequests> {
  List<FriendRequest> _requests = [];
  bool _loading = true;

  @override
  void initState() { super.initState(); _load(); }
  Future<void> _load() async {
    setState(() => _loading = true);
    final r = await widget.service.getIncomingRequests();
    if (mounted) setState(() { _requests = r; _loading = false; });
  }

  @override
  Widget build(BuildContext context) {
    if (_loading) return const Center(child: CircularProgressIndicator(color: GameTheme.gold));
    if (_requests.isEmpty) {
      return Center(
        child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
          Container(padding: const EdgeInsets.all(24), decoration: BoxDecoration(shape: BoxShape.circle, border: Border.all(color: GameTheme.border, width: 2)), child: const Icon(Icons.inbox, size: 40, color: GameTheme.textSecondary)),
          const SizedBox(height: 16),
          const Text('NO PENDING REQUESTS', style: TextStyle(color: GameTheme.textSecondary, fontSize: 14, fontWeight: FontWeight.w700, letterSpacing: 2)),
        ]),
      );
    }
    return ListView.builder(
      padding: const EdgeInsets.fromLTRB(20, 0, 20, 20),
      itemCount: _requests.length,
      itemBuilder: (_, i) {
        final req = _requests[i];
        final user = req.senderUser;
        if (user == null) return const SizedBox();
        return _requestCard(user, req);
      },
    );
  }

  Widget _requestCard(AppUser user, FriendRequest req) {
    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      decoration: GameTheme.cardDecoration,
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Row(children: [
          _avatar(user),
          const SizedBox(width: 12),
          Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            Text(user.displayName, style: const TextStyle(color: GameTheme.textPrimary, fontSize: 15, fontWeight: FontWeight.w700)),
            Text('ID: ${user.shortId}', style: const TextStyle(color: GameTheme.textSecondary, fontSize: 11)),
          ])),
          Column(children: [
            GestureDetector(
              onTap: () async { await widget.service.acceptRequest(req.id, req.senderId); widget.onRefresh(); _load(); },
              child: Container(padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8), decoration: BoxDecoration(gradient: GameTheme.gradientGold, borderRadius: BorderRadius.circular(8)), child: const Text('ACCEPT', style: TextStyle(color: Colors.black, fontSize: 11, fontWeight: FontWeight.w800, letterSpacing: 1))),
            ),
            const SizedBox(height: 6),
            GestureDetector(
              onTap: () async { await widget.service.rejectRequest(req.id); _load(); },
              child: Container(padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8), decoration: BoxDecoration(color: GameTheme.red.withOpacity(0.15), borderRadius: BorderRadius.circular(8), border: Border.all(color: GameTheme.red.withOpacity(0.3))), child: const Text('DECLINE', style: TextStyle(color: GameTheme.red, fontSize: 11, fontWeight: FontWeight.w800, letterSpacing: 1))),
            ),
          ]),
        ]),
      ),
    );
  }

  Widget _avatar(AppUser user) {
    return Container(
      width: 48, height: 48,
      decoration: BoxDecoration(shape: BoxShape.circle, border: Border.all(color: GameTheme.gold.withOpacity(0.3))),
      child: ClipOval(child: user.imageUrl != null ? Image.network(user.imageUrl!, fit: BoxFit.cover) : _fallback(user)),
    );
  }
  Widget _fallback(AppUser user) {
    return Container(color: GameTheme.purple, child: Center(child: Text(user.displayName[0].toUpperCase(), style: const TextStyle(color: Colors.white, fontSize: 20, fontWeight: FontWeight.w800))));
  }
}

class _SentRequests extends StatefulWidget {
  final FriendService service;
  final VoidCallback onRefresh;
  const _SentRequests({required this.service, required this.onRefresh});

  @override
  State<_SentRequests> createState() => _SentRequestsState();
}

class _SentRequestsState extends State<_SentRequests> {
  List<FriendRequest> _requests = [];
  bool _loading = true;

  @override
  void initState() { super.initState(); _load(); }
  Future<void> _load() async {
    setState(() => _loading = true);
    final r = await widget.service.getSentRequests();
    if (mounted) setState(() { _requests = r; _loading = false; });
  }

  @override
  Widget build(BuildContext context) {
    if (_loading) return const Center(child: CircularProgressIndicator(color: GameTheme.gold));
    if (_requests.isEmpty) {
      return Center(
        child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
          Container(padding: const EdgeInsets.all(24), decoration: BoxDecoration(shape: BoxShape.circle, border: Border.all(color: GameTheme.border, width: 2)), child: const Icon(Icons.send, size: 40, color: GameTheme.textSecondary)),
          const SizedBox(height: 16),
          const Text('NO SENT REQUESTS', style: TextStyle(color: GameTheme.textSecondary, fontSize: 14, fontWeight: FontWeight.w700, letterSpacing: 2)),
        ]),
      );
    }
    return ListView.builder(
      padding: const EdgeInsets.fromLTRB(20, 0, 20, 20),
      itemCount: _requests.length,
      itemBuilder: (_, i) {
        final req = _requests[i];
        final user = req.receiverUser;
        if (user == null) return const SizedBox();
        return Container(
          margin: const EdgeInsets.only(bottom: 10),
          decoration: GameTheme.cardDecoration,
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Row(children: [
              _avatar(user),
              const SizedBox(width: 12),
              Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                Text(user.displayName, style: const TextStyle(color: GameTheme.textPrimary, fontSize: 15, fontWeight: FontWeight.w700)),
                Container(
                  margin: const EdgeInsets.only(top: 4),
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                  decoration: BoxDecoration(color: GameTheme.gold.withOpacity(0.15), borderRadius: BorderRadius.circular(4)),
                  child: const Text('PENDING', style: TextStyle(color: GameTheme.gold, fontSize: 9, fontWeight: FontWeight.w700, letterSpacing: 1)),
                ),
              ])),
              GestureDetector(
                onTap: () async { await widget.service.cancelRequest(req.id); widget.onRefresh(); _load(); },
                child: Container(padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8), decoration: BoxDecoration(color: GameTheme.red.withOpacity(0.15), borderRadius: BorderRadius.circular(8), border: Border.all(color: GameTheme.red.withOpacity(0.3))), child: const Text('CANCEL', style: TextStyle(color: GameTheme.red, fontSize: 11, fontWeight: FontWeight.w800, letterSpacing: 1))),
              ),
            ]),
          ),
        );
      },
    );
  }

  Widget _avatar(AppUser user) {
    return Container(
      width: 48, height: 48,
      decoration: BoxDecoration(shape: BoxShape.circle, border: Border.all(color: GameTheme.gold.withOpacity(0.3))),
      child: ClipOval(child: user.imageUrl != null ? Image.network(user.imageUrl!, fit: BoxFit.cover) : _fallback(user)),
    );
  }
  Widget _fallback(AppUser user) {
    return Container(color: GameTheme.purple, child: Center(child: Text(user.displayName[0].toUpperCase(), style: const TextStyle(color: Colors.white, fontSize: 20, fontWeight: FontWeight.w800))));
  }
}

// ═══════════════════════════════════════════
// DISCOVER TAB
// ═══════════════════════════════════════════

class _DiscoverTab extends StatefulWidget {
  final FriendService service;
  const _DiscoverTab({required this.service});

  @override
  State<_DiscoverTab> createState() => _DiscoverTabState();
}

class _DiscoverTabState extends State<_DiscoverTab> {
  List<AppUser> _users = [];
  bool _loading = true;
  final Set<String> _sent = {};

  @override
  void initState() { super.initState(); _load(); }
  Future<void> _load() async {
    setState(() => _loading = true);
    final u = await widget.service.getSuggestedFriends();
    if (mounted) setState(() { _users = u; _loading = false; });
  }

  @override
  Widget build(BuildContext context) {
    if (_loading) return const Center(child: CircularProgressIndicator(color: GameTheme.gold));
    if (_users.isEmpty) {
      return Center(
        child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
          Container(padding: const EdgeInsets.all(30), decoration: BoxDecoration(shape: BoxShape.circle, border: Border.all(color: GameTheme.border, width: 2)), child: const Icon(Icons.explore, size: 60, color: GameTheme.textSecondary)),
          const SizedBox(height: 24),
          const Text('NO SUGGESTIONS', style: TextStyle(color: GameTheme.textSecondary, fontSize: 18, fontWeight: FontWeight.w700, letterSpacing: 2)),
          const SizedBox(height: 8),
          const Text('Check back later!', style: TextStyle(color: GameTheme.textSecondary, fontSize: 14)),
        ]),
      );
    }
    return RefreshIndicator(
      onRefresh: _load,
      color: GameTheme.gold,
      child: ListView.builder(
        padding: const EdgeInsets.fromLTRB(20, 12, 20, 20),
        itemCount: _users.length,
        itemBuilder: (_, i) {
          final user = _users[i];
          final sent = _sent.contains(user.authUserId);
          return Container(
            margin: const EdgeInsets.only(bottom: 10),
            decoration: GameTheme.cardDecoration,
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Row(children: [
                Container(
                  width: 48, height: 48,
                  decoration: BoxDecoration(shape: BoxShape.circle, gradient: GameTheme.gradientPurple),
                  child: Center(child: Text(user.displayName[0].toUpperCase(), style: const TextStyle(color: Colors.white, fontSize: 22, fontWeight: FontWeight.w800))),
                ),
                const SizedBox(width: 12),
                Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                  Text(user.displayName, style: const TextStyle(color: GameTheme.textPrimary, fontSize: 15, fontWeight: FontWeight.w700)),
                  Text('ID: ${user.shortId}', style: const TextStyle(color: GameTheme.textSecondary, fontSize: 11)),
                ])),
                GestureDetector(
                  onTap: sent ? null : () async { await widget.service.sendFriendRequest(user.authUserId); setState(() => _sent.add(user.authUserId)); },
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                    decoration: sent
                        ? BoxDecoration(color: GameTheme.card, borderRadius: BorderRadius.circular(8), border: Border.all(color: GameTheme.border))
                        : BoxDecoration(gradient: GameTheme.gradientGold, borderRadius: BorderRadius.circular(8), boxShadow: [BoxShadow(color: GameTheme.gold.withOpacity(0.3), blurRadius: 8)]),
                    child: Text(sent ? 'SENT ✓' : 'ADD', style: TextStyle(color: sent ? GameTheme.textSecondary : Colors.black, fontSize: 11, fontWeight: FontWeight.w800, letterSpacing: 1)),
                  ),
                ),
              ]),
            ),
          );
        },
      ),
    );
  }
}

// ═══════════════════════════════════════════
// NOTIFICATIONS PANEL
// ═══════════════════════════════════════════

class _NotificationsPanel extends StatefulWidget {
  final FriendService service;
  final VoidCallback onRead;
  const _NotificationsPanel({required this.service, required this.onRead});

  @override
  State<_NotificationsPanel> createState() => _NotificationsPanelState();
}

class _NotificationsPanelState extends State<_NotificationsPanel> {
  List<AppNotification> _notifs = [];
  bool _loading = true;

  @override
  void initState() { super.initState(); _load(); }
  Future<void> _load() async {
    final n = await widget.service.getNotifications();
    if (mounted) setState(() { _notifs = n; _loading = false; });
  }

  IconData _iconFor(String type) {
    switch (type) {
      case 'friend_request': return Icons.person_add;
      case 'request_accepted': return Icons.people;
      case 'match_invite': return Icons.sports_esports;
      default: return Icons.notifications;
    }
  }
  Color _colorFor(String type) {
    switch (type) {
      case 'friend_request': return GameTheme.gold;
      case 'request_accepted': return GameTheme.green;
      case 'match_invite': return GameTheme.blue;
      default: return GameTheme.purple;
    }
  }
  String _timeAgo(DateTime dt) {
    final diff = DateTime.now().difference(dt);
    if (diff.inMinutes < 1) return 'Just now';
    if (diff.inHours < 1) return '${diff.inMinutes}m ago';
    if (diff.inDays < 1) return '${diff.inHours}h ago';
    return '${diff.inDays}d ago';
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: MediaQuery.of(context).size.height * 0.7,
      decoration: const BoxDecoration(color: GameTheme.surface, borderRadius: BorderRadius.vertical(top: Radius.circular(24))),
      child: Column(children: [
        Container(margin: const EdgeInsets.symmetric(vertical: 12), width: 40, height: 4, decoration: BoxDecoration(color: GameTheme.border, borderRadius: BorderRadius.circular(2))),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
            const Text('NOTIFICATIONS', style: TextStyle(color: GameTheme.textPrimary, fontSize: 18, fontWeight: FontWeight.w800, letterSpacing: 2)),
            TextButton(
              onPressed: () async {
                for (final n in _notifs.where((n) => !n.isRead)) { await widget.service.markNotificationRead(n.id); }
                widget.onRead();
                await _load();
              },
              child: const Text('MARK ALL READ', style: TextStyle(color: GameTheme.gold, fontSize: 11, fontWeight: FontWeight.w700, letterSpacing: 1)),
            ),
          ]),
        ),
        const SizedBox(height: 12),
        Expanded(
          child: _loading
              ? const Center(child: CircularProgressIndicator(color: GameTheme.gold))
              : _notifs.isEmpty
                  ? Center(child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [const Icon(Icons.notifications_off, size: 48, color: GameTheme.textSecondary), const SizedBox(height: 12), const Text('NO NOTIFICATIONS', style: TextStyle(color: GameTheme.textSecondary, fontSize: 14, fontWeight: FontWeight.w700, letterSpacing: 2))]))
                  : ListView.builder(
                      padding: const EdgeInsets.symmetric(horizontal: 20),
                      itemCount: _notifs.length,
                      itemBuilder: (_, i) {
                        final n = _notifs[i];
                        final color = _colorFor(n.type);
                        return Container(
                          margin: const EdgeInsets.only(bottom: 8),
                          padding: const EdgeInsets.all(14),
                          decoration: BoxDecoration(color: GameTheme.card, borderRadius: BorderRadius.circular(12), border: Border.all(color: n.isRead ? GameTheme.border.withOpacity(0.3) : color.withOpacity(0.5))),
                          child: Row(children: [
                            Container(padding: const EdgeInsets.all(10), decoration: BoxDecoration(color: color.withOpacity(0.15), shape: BoxShape.circle), child: Icon(_iconFor(n.type), color: color, size: 20)),
                            const SizedBox(width: 12),
                            Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                              Text(n.message, style: TextStyle(color: n.isRead ? GameTheme.textSecondary : GameTheme.textPrimary, fontSize: 13, fontWeight: FontWeight.w600)),
                              const SizedBox(height: 4),
                              Text(_timeAgo(n.createdAt), style: const TextStyle(color: GameTheme.textSecondary, fontSize: 11)),
                            ])),
                            if (!n.isRead) Container(width: 8, height: 8, decoration: const BoxDecoration(color: GameTheme.gold, shape: BoxShape.circle)),
                          ]),
                        );
                      },
                    ),
        ),
      ]),
    );
  }
}

class _TabData {
  final String label;
  final IconData icon;
  final int index;
  _TabData(this.label, this.icon, this.index);
}