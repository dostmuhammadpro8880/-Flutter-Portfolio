// import 'dart:io';

// import 'package:flutter/material.dart';
// import 'package:image_picker/image_picker.dart';
// import 'package:supabase_flutter/supabase_flutter.dart';

// class AppDrawer extends StatefulWidget {
//   final String email;
//   final String customId;
//   final VoidCallback logout;

//   const AppDrawer({
//     super.key,
//     required this.email,
//     required this.customId,
//     required this.logout,
//   });

//   @override
//   State<AppDrawer> createState() => _AppDrawerState();
// }

// class _AppDrawerState extends State<AppDrawer> {

//   File? imageFile;

//   String imageUrl = "";

//   final ImagePicker picker = ImagePicker();

//   @override
//   void initState() {
//     super.initState();

//     getProfileImage();
//   }

//   /// GET SAVED IMAGE
//   Future<void> getProfileImage() async {

//     try {

//       final currentUser =
//           Supabase.instance.client.auth.currentUser;

//       if (currentUser == null) return;

//       final data = await Supabase.instance.client
//           .from('users')
//           .select('image_url')
//           .eq('auth_user_id', currentUser.id)
//           .single();

//       if (mounted) {

//         setState(() {
//           imageUrl = data['image_url'] ?? "";
//         });
//       }

//     } catch (e) {

//       print(e.toString());
//     }
//   }

//   /// PICK IMAGE
//   Future<void> pickImage() async {

//     final XFile? pickedImage =
//         await picker.pickImage(
//       source: ImageSource.gallery,
//     );

//     if (pickedImage != null) {

//       setState(() {
//         imageFile = File(pickedImage.path);
//       });

//       await uploadImage();
//     }
//   }

//   /// UPLOAD IMAGE
//   Future<void> uploadImage() async {

//     try {

//       final currentUser =
//           Supabase.instance.client.auth.currentUser;

//       if (currentUser == null || imageFile == null) {
//         return;
//       }

//       final fileName =
//           "${currentUser.id}.jpg";

//       /// UPLOAD TO STORAGE
//       await Supabase.instance.client.storage
//           .from('profile-images')
//           .upload(
//             fileName,
//             imageFile!,
//             fileOptions: const FileOptions(
//               upsert: true,
//             ),
//           );

//       /// GET PUBLIC URL
//       final publicUrl =
//           Supabase.instance.client.storage
//               .from('profile-images')
//               .getPublicUrl(fileName);

//       /// SAVE URL
//       await Supabase.instance.client
//           .from('users')
//           .update({
//             'image_url': publicUrl,
//           })
//           .eq('auth_user_id', currentUser.id);

//       setState(() {
//         imageUrl = publicUrl;
//       });

//       print("Image Uploaded");

//     } catch (e) {

//       print(e.toString());
//     }
//   }

//   @override
//   Widget build(BuildContext context) {

//     return Drawer(
//       backgroundColor: Colors.white,

//       child: Column(
//         children: [

//           /// HEADER
//           Container(
//             width: double.infinity,

//             padding: const EdgeInsets.only(
//               top: 60,
//               left: 20,
//               right: 20,
//               bottom: 25,
//             ),

//             decoration: const BoxDecoration(
//               gradient: LinearGradient(
//                 colors: [
//                   Colors.blueAccent,
//                   Colors.indigo,
//                 ],
//                 begin: Alignment.topLeft,
//                 end: Alignment.bottomRight,
//               ),
//             ),

//             child: Column(
//               crossAxisAlignment:
//                   CrossAxisAlignment.start,

//               children: [

//                 /// PROFILE IMAGE
//                 GestureDetector(
//                   onTap: pickImage,

//                   child: Container(
//                     height: 85,
//                     width: 85,

//                     decoration: BoxDecoration(
//                       color: Colors.white,
//                       borderRadius:
//                           BorderRadius.circular(50),

//                       image: imageUrl.isNotEmpty
//                           ? DecorationImage(
//                               image:
//                                   NetworkImage(imageUrl),
//                               fit: BoxFit.cover,
//                             )
//                           : null,
//                     ),

//                     child: imageUrl.isEmpty
//                         ? const Icon(
//                             Icons.add_a_photo,
//                             size: 35,
//                             color: Colors.blueAccent,
//                           )
//                         : null,
//                   ),
//                 ),

//                 const SizedBox(height: 15),

//                 /// EMAIL
//                 Text(
//                   widget.email,

//                   style: const TextStyle(
//                     color: Colors.white,
//                     fontSize: 18,
//                     fontWeight: FontWeight.bold,
//                   ),
//                 ),

//                 const SizedBox(height: 10),

//                 /// USER ID
//                 Container(
//                   padding:
//                       const EdgeInsets.symmetric(
//                     horizontal: 12,
//                     vertical: 8,
//                   ),

//                   decoration: BoxDecoration(
//                     color:
//                         Colors.white.withOpacity(0.2),

//                     borderRadius:
//                         BorderRadius.circular(12),
//                   ),

//                   child: Row(
//                     mainAxisSize: MainAxisSize.min,

//                     children: [

//                       const Icon(
//                         Icons.badge,
//                         color: Colors.white,
//                         size: 18,
//                       ),

//                       const SizedBox(width: 8),

//                       Expanded(
//                         child: Text(
//                           widget.customId,

//                           overflow:
//                               TextOverflow.ellipsis,

//                           style: const TextStyle(
//                             color: Colors.white,
//                             fontWeight:
//                                 FontWeight.w600,
//                           ),
//                         ),
//                       ),
//                     ],
//                   ),
//                 ),
//               ],
//             ),
//           ),

//           const SizedBox(height: 15),

//           /// HOME
//           ListTile(
//             leading: const Icon(
//               Icons.home,
//               color: Colors.blueAccent,
//             ),

//             title: const Text(
//               "Home",
//               style: TextStyle(
//                 fontWeight: FontWeight.w600,
//               ),
//             ),

//             onTap: () {
//               Navigator.pop(context);
//             },
//           ),

//           /// PROFILE
//           ListTile(
//             leading: const Icon(
//               Icons.person_outline,
//               color: Colors.blueAccent,
//             ),

//             title: const Text(
//               "Profile",
//               style: TextStyle(
//                 fontWeight: FontWeight.w600,
//               ),
//             ),

//             onTap: () {},
//           ),

//           /// SETTINGS
//           ListTile(
//             leading: const Icon(
//               Icons.settings,
//               color: Colors.blueAccent,
//             ),

//             title: const Text(
//               "Settings",
//               style: TextStyle(
//                 fontWeight: FontWeight.w600,
//               ),
//             ),

//             onTap: () {},
//           ),

//           const Spacer(),

//           /// LOGOUT
//           Padding(
//             padding: const EdgeInsets.all(20),

//             child: SizedBox(
//               width: double.infinity,
//               height: 50,

//               child: ElevatedButton.icon(
//                 onPressed: widget.logout,

//                 style:
//                     ElevatedButton.styleFrom(
//                   backgroundColor:
//                       Colors.redAccent,

//                   shape:
//                       RoundedRectangleBorder(
//                     borderRadius:
//                         BorderRadius.circular(15),
//                   ),
//                 ),

//                 icon: const Icon(
//                   Icons.logout,
//                   color: Colors.white,
//                 ),

//                 label: const Text(
//                   "Logout",

//                   style: TextStyle(
//                     color: Colors.white,
//                     fontWeight: FontWeight.bold,
//                   ),
//                 ),
//               ),
//             ),
//           ),
//         ],
//       ),
//     );
//   }
// }


import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class AppDrawer extends StatefulWidget {
  final String email;
  final String customId;
  final VoidCallback logout;

  const AppDrawer({
    super.key,
    required this.email,
    required this.customId,
    required this.logout,
  });

  @override
  State<AppDrawer> createState() => _AppDrawerState();
}

class _AppDrawerState extends State<AppDrawer> {
  final ImagePicker _picker = ImagePicker();
  File? _imageFile;
  String _imageUrl = "";
  bool _uploading = false;

  @override
  void initState() {
    super.initState();
    _loadProfileImage();
  }

  Future<void> _loadProfileImage() async {
    try {
      final currentUser = Supabase.instance.client.auth.currentUser;
      if (currentUser == null) return;

      final data = await Supabase.instance.client
          .from('users')
          .select('image_url')
          .eq('auth_user_id', currentUser.id)
          .single();

      if (!mounted) return;

      setState(() {
        _imageUrl = (data['image_url'] ?? '') as String;
      });
    } catch (e) {
      debugPrint('Load image error: $e');
    }
  }

Future<void> _pickAndUploadImage() async {

  final picked =
      await _picker.pickImage(
    source: ImageSource.gallery,
  );

  if (picked == null) return;

  final currentUser =
      Supabase.instance.client.auth.currentUser;

  if (currentUser == null) return;

  setState(() {
    _uploading = true;
  });

  try {

    final bytes =
        await picked.readAsBytes();

    final fileName =
        "${currentUser.id}.jpg";

    /// UPLOAD IMAGE
    await Supabase.instance.client.storage
        .from('profile-images')
        .uploadBinary(
          fileName,
          bytes,

          fileOptions: const FileOptions(
            upsert: true,
            contentType: 'image/jpeg',
          ),
        );

    /// GET URL
    final publicUrl =
        Supabase.instance.client.storage
            .from('profile-images')
            .getPublicUrl(fileName);

    /// SAVE URL
    await Supabase.instance.client
        .from('users')
        .update({
          'image_url': publicUrl,
        })
        .eq(
          'auth_user_id',
          currentUser.id,
        );

    setState(() {
      _imageUrl = publicUrl;
      _uploading = false;
    });

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text("Profile image updated"),
      ),
    );

  } catch (e) {

    setState(() {
      _uploading = false;
    });

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text("Upload failed: $e"),
      ),
    );
  }
}

  // Future<void> _pickAndUploadImage() async {
  //   final picked = await _picker.pickImage(source: ImageSource.gallery);
  //   if (picked == null) return;

  //   final currentUser = Supabase.instance.client.auth.currentUser;
  //   if (currentUser == null) return;

  //   setState(() {
  //     _imageFile = File(picked.path);
  //     _uploading = true;
  //   });

  //   try {
  //     final fileName = '${currentUser.id}.jpg';

  //     await Supabase.instance.client.storage
  //         .from('profile-images')
  //         .upload(
  //           fileName,
  //           _imageFile!,
  //           fileOptions: const FileOptions(upsert: true),
  //         );

  //     final publicUrl = Supabase.instance.client.storage
  //         .from('profile-images')
  //         .getPublicUrl(fileName);

  //     await Supabase.instance.client.from('users').update({
  //       'image_url': publicUrl,
  //     }).eq('auth_user_id', currentUser.id);

  //     if (!mounted) return;

  //     setState(() {
  //       _imageUrl = publicUrl;
  //       _uploading = false;
  //     });
  //   } catch (e) {
  //     if (!mounted) return;
  //     setState(() => _uploading = false);

  //     ScaffoldMessenger.of(context).showSnackBar(
  //       SnackBar(content: Text('Upload failed: $e')),
  //     );
  //   }
  // }

  @override
  Widget build(BuildContext context) {
    return Drawer(
      backgroundColor: Colors.white,
      child: Column(
        children: [
          Container(
            width: double.infinity,
            padding: const EdgeInsets.only(
              top: 60,
              left: 20,
              right: 20,
              bottom: 25,
            ),
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                colors: [Colors.blueAccent, Colors.indigo],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                GestureDetector(
                  onTap: _pickAndUploadImage,
                  child: Stack(
                    alignment: Alignment.center,
                    children: [
                      Container(
                        height: 85,
                        width: 85,
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(50),
                          image: _imageUrl.isNotEmpty
                              ? DecorationImage(
                                  image: NetworkImage(_imageUrl),
                                  fit: BoxFit.cover,
                                )
                              : null,
                        ),
                        child: _imageUrl.isEmpty
                            ? const Icon(
                                Icons.person,
                                size: 45,
                                color: Colors.blueAccent,
                              )
                            : null,
                      ),
                      if (_uploading)
                        Container(
                          height: 85,
                          width: 85,
                          decoration: BoxDecoration(
                            color: Colors.black.withOpacity(0.35),
                            borderRadius: BorderRadius.circular(50),
                          ),
                          child: const CircularProgressIndicator(
                            color: Colors.white,
                            strokeWidth: 2,
                          ),
                        ),
                    ],
                  ),
                ),
                const SizedBox(height: 15),
                Text(
                  widget.email,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 10),
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 12,
                    vertical: 8,
                  ),
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.2),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const Icon(
                        Icons.badge,
                        color: Colors.white,
                        size: 18,
                      ),
                      const SizedBox(width: 8),
                      Flexible(
                        child: Text(
                          widget.customId,
                          overflow: TextOverflow.ellipsis,
                          style: const TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 15),
          ListTile(
            leading: const Icon(Icons.home, color: Colors.blueAccent),
            title: const Text(
              "Home",
              style: TextStyle(fontWeight: FontWeight.w600),
            ),
            onTap: () => Navigator.pop(context),
          ),
          ListTile(
            leading: const Icon(Icons.person_outline, color: Colors.blueAccent),
            title: const Text(
              "Profile",
              style: TextStyle(fontWeight: FontWeight.w600),
            ),
            onTap: () {},
          ),
          ListTile(
            leading: const Icon(Icons.settings, color: Colors.blueAccent),
            title: const Text(
              "Settings",
              style: TextStyle(fontWeight: FontWeight.w600),
            ),
            onTap: () {},
          ),
          const Spacer(),
          Padding(
            padding: const EdgeInsets.all(20),
            child: SizedBox(
              width: double.infinity,
              height: 50,
              child: ElevatedButton.icon(
                onPressed: widget.logout,
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.redAccent,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(15),
                  ),
                ),
                icon: const Icon(Icons.logout, color: Colors.white),
                label: const Text(
                  "Logout",
                  style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
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