import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:image_picker/image_picker.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  // ✅ Demo “already signed in” user id (no auth flow)
  static const String _uid = "demo-user";

  // Local UI state (synced with Firestore)
  String name = "Dr Maria Sofia Mathis";
  String email = "drmathis@kabbe.com";
  String password = "password123";
  String? photoUrl;

  bool _loading = true;

  static const dark = Color(0xFF2B2B2B);
  static const bg = Color(0xFFEBEBEB);

  // SVG aspect ratios
  static const double _topAspect = 393 / 174;
  static const double _bottomAspect = 393 / 194;

  @override
  void initState() {
    super.initState();
    _loadProfile();
  }

  DocumentReference<Map<String, dynamic>> get _userDoc =>
      FirebaseFirestore.instance.collection('users').doc(_uid);

  Future<void> _loadProfile() async {
    try {
      final snap = await _userDoc.get();

      if (snap.exists) {
        final data = snap.data()!;
        setState(() {
          name = (data['displayName'] as String?) ?? name;
          email = (data['email'] as String?) ?? email;
          password = (data['password'] as String?) ?? password; // demo only
          photoUrl = data['photoUrl'] as String?;
        });
      } else {
        // Create initial profile doc
        await _userDoc.set({
          'displayName': name,
          'email': email,
          'password': password, // demo only
          'photoUrl': null,
          'social': {
            'instagram': '',
            'facebook': '',
            'tiktok': '',
            'x': '',
            'linkedin': '',
          },
          'updatedAt': FieldValue.serverTimestamp(),
        });
      }
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Profile load failed: $e")),
      );
    } finally {
      if (mounted) setState(() => _loading = false);
    }
  }

  Future<void> _updateProfile(Map<String, dynamic> updates) async {
    await _userDoc.set(
      {
        ...updates,
        'updatedAt': FieldValue.serverTimestamp(),
      },
      SetOptions(merge: true),
    );
  }

  Future<void> _editField({
    required String title,
    required String initialValue,
    required bool obscure,
    required void Function(String v) applyLocal,
    required Map<String, dynamic> Function(String v) firestoreUpdate,
  }) async {
    final controller = TextEditingController(text: initialValue);

    final result = await showDialog<String>(
      context: context,
      builder: (_) => AlertDialog(
        backgroundColor: const Color(0xFFEBEBEB),
        title: Text(title),
        content: TextField(
          controller: controller,
          obscureText: obscure,
          decoration: const InputDecoration(border: OutlineInputBorder()),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text("Cancel"),
          ),
          ElevatedButton(
            onPressed: () => Navigator.pop(context, controller.text.trim()),
            child: const Text("Save"),
          ),
        ],
      ),
    );

    if (result == null || result.isEmpty) return;

    try {
      setState(() => applyLocal(result));
      await _updateProfile(firestoreUpdate(result));
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Save failed: $e")),
      );
    }
  }

  String get maskedPassword => "•" * (password.length.clamp(8, 12));

  Future<void> _pickAndUploadAvatar() async {
    try {
      final picker = ImagePicker();
      final picked = await picker.pickImage(
        source: ImageSource.gallery,
        imageQuality: 85,
      );
      if (picked == null) return;

      setState(() => _loading = true);

      final file = File(picked.path);

      // ✅ Unique path so caching won’t fight you
      final filename = "avatar_${DateTime.now().millisecondsSinceEpoch}.jpg";
      final ref = FirebaseStorage.instance.ref().child('users/$_uid/$filename');

      await ref.putFile(file);
      final url = await ref.getDownloadURL();

      await _updateProfile({'photoUrl': url});
      setState(() => photoUrl = url);
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Upload failed: $e")),
      );
    } finally {
      if (mounted) setState(() => _loading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.transparent,
      body: LayoutBuilder(
        builder: (context, constraints) {
          final w = constraints.maxWidth;
          final h = constraints.maxHeight;

          final topSvgH = w / _topAspect;
          final bottomSvgH = w / _bottomAspect;

          const avatarRadius = 36.0;
          final avatarTop = topSvgH - avatarRadius;

          const btnW = 167.0;
          const btnH = 62.0;
          final bottomSvgTopY = h - bottomSvgH;
          final signOutTop = bottomSvgTopY - (btnH / 2);

          final contentTop = avatarTop + (avatarRadius * 2) + 14;
          final contentBottom = (h - signOutTop) + 12;

          return Stack(
            children: [
              // TOP SVG
              Positioned(
                top: 0,
                left: 0,
                right: 0,
                child: SizedBox(
                  height: topSvgH,
                  child: SvgPicture.asset(
                    'assets/profile_top.svg',
                    fit: BoxFit.cover,
                    alignment: Alignment.topLeft,
                  ),
                ),
              ),

              // BOTTOM SVG
              Positioned(
                left: 0,
                right: 0,
                bottom: 0,
                child: SizedBox(
                  height: bottomSvgH,
                  child: SvgPicture.asset(
                    'assets/profile_bottom.svg',
                    fit: BoxFit.cover,
                    alignment: Alignment.bottomCenter,
                  ),
                ),
              ),

              // CONTENT
              SafeArea(
                child: Padding(
                  padding: EdgeInsets.fromLTRB(24, 30, 24, contentBottom),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          const Expanded(
                            child: Text(
                              "Profile",
                              style: TextStyle(
                                fontSize: 36,
                                fontWeight: FontWeight.w700,
                                fontFamily: "Inter",
                                color: dark,
                              ),
                            ),
                          ),
                          IconButton(
                            onPressed: () {},
                            icon: const Icon(Icons.settings),
                            color: dark,
                          ),
                        ],
                      ),

                      SizedBox(height: (contentTop - 24 - 56).clamp(0, 9999)),

                      // Name + edit
                      Center(
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Text(
                              name,
                              style: const TextStyle(
                                fontSize: 22,
                                fontWeight: FontWeight.w700,
                                fontFamily: "Inter",
                                color: dark,
                              ),
                            ),
                            const SizedBox(width: 6),
                            GestureDetector(
                              onTap: () => _editField(
                                title: "Edit name",
                                initialValue: name,
                                obscure: false,
                                applyLocal: (v) => name = v,
                                firestoreUpdate: (v) => {'displayName': v},
                              ),
                              child: const Icon(Icons.edit,
                                  size: 18, color: dark),
                            ),
                          ],
                        ),
                      ),

                      const SizedBox(height: 10),

                      _InfoRow(
                        label: "Email:",
                        value: email,
                        onEdit: () => _editField(
                          title: "Edit email",
                          initialValue: email,
                          obscure: false,
                          applyLocal: (v) => email = v,
                          firestoreUpdate: (v) => {'email': v},
                        ),
                      ),

                      const SizedBox(height: 6),

                      _InfoRow(
                        label: "Password:",
                        value: maskedPassword,
                        onEdit: () => _editField(
                          title: "Edit password",
                          initialValue: password,
                          obscure: true,
                          applyLocal: (v) => password = v,
                          firestoreUpdate: (v) => {'password': v}, // demo only
                        ),
                      ),

                      const SizedBox(height: 30),

                      const Text(
                        "Social media",
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.w700,
                          fontFamily: "Inter",
                          color: dark,
                        ),
                      ),

                      const SizedBox(height: 16),

                      IntrinsicHeight(
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.stretch,
                          children: [
                            Expanded(
                              child: Column(
                                children: [
                                  _SocialTile(
                                      icon: Icons.camera_alt_outlined,
                                      label: "Instagram",
                                      onTap: () {}),
                                  _SocialTile(
                                      icon: Icons.facebook,
                                      label: "Facebook",
                                      onTap: () {}),
                                  _SocialTile(
                                      icon: Icons.music_note,
                                      label: "TikTok",
                                      onTap: () {}),
                                ],
                              ),
                            ),
                            const Padding(
                              padding: EdgeInsets.symmetric(horizontal: 14),
                              child: VerticalDivider(
                                thickness: 1,
                                width: 1,
                                color: dark,
                              ),
                            ),
                            Expanded(
                              child: Column(
                                children: [
                                  _SocialTile(
                                      icon: Icons.close, label: "X", onTap: () {}),
                                  _SocialTile(
                                      icon: Icons.business_center_outlined,
                                      label: "LinkedIn",
                                      onTap: () {}),
                                  _SocialTile(
                                      icon: Icons.add_box_outlined,
                                      label: "Add more",
                                      onTap: () {}),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),

              // AVATAR (tap to change)
              Positioned(
                top: avatarTop,
                left: 0,
                right: 0,
                child: Center(
                  child: InkWell(
                    borderRadius: BorderRadius.circular(999),
                    onTap: _loading ? null : _pickAndUploadAvatar,
                    child: CircleAvatar(
                      radius: avatarRadius,
                      backgroundColor: bg,
                      child: ClipOval(child: _buildAvatarImage()),
                    ),
                  ),
                ),
              ),

              // Sign out (for show)
              Positioned(
                top: signOutTop,
                left: 0,
                right: 0,
                child: Center(
                  child: SizedBox(
                    width: btnW,
                    height: btnH,
                    child: ElevatedButton(
                      onPressed: () {},
                      style: ElevatedButton.styleFrom(
                        backgroundColor: dark,
                        elevation: 0,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(16),
                        ),
                      ),
                      child: const Text(
                        "Sign out",
                        style: TextStyle(
                          color: bg,
                          fontSize: 24,
                          fontWeight: FontWeight.w700,
                          fontFamily: "Inter",
                        ),
                      ),
                    ),
                  ),
                ),
              ),

              if (_loading)
                Positioned.fill(
                  child: IgnorePointer(
                    child: Container(
                      // ignore: deprecated_member_use
                      color: Colors.black.withOpacity(0.05),
                      child: const Center(child: CircularProgressIndicator()),
                    ),
                  ),
                ),
            ],
          );
        },
      ),
    );
  }

  Widget _buildAvatarImage() {
    if (photoUrl != null && photoUrl!.isNotEmpty) {
      return Image.network(
        photoUrl!,
        width: 96,
        height: 96,
        fit: BoxFit.cover,
        errorBuilder: (_, __, ___) => Image.asset(
          'assets/profile_pic.png',
          width: 96,
          height: 96,
          fit: BoxFit.cover,
        ),
      );
    }
    return Image.asset(
      'assets/profile_pic.png',
      width: 96,
      height: 96,
      fit: BoxFit.cover,
    );
  }
}

class _InfoRow extends StatelessWidget {
  final String label;
  final String value;
  final VoidCallback onEdit;

  const _InfoRow({
    required this.label,
    required this.value,
    required this.onEdit,
  });

  static const dark = Color(0xFF2B2B2B);

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            label,
            style: const TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w600,
              fontFamily: "Inter",
              color: dark,
            ),
          ),
          const SizedBox(width: 6),
          Text(
            value,
            style: const TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w500,
              fontFamily: "Inter",
              color: dark,
            ),
          ),
          const SizedBox(width: 6),
          GestureDetector(
            onTap: onEdit,
            child: const Icon(Icons.edit, size: 16, color: dark),
          ),
        ],
      ),
    );
  }
}

class _SocialTile extends StatelessWidget {
  final IconData icon;
  final String label;
  final VoidCallback onTap;

  const _SocialTile({
    required this.icon,
    required this.label,
    required this.onTap,
  });

  static const dark = Color(0xFF2B2B2B);

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 10),
        child: Row(
          children: [
            Icon(icon, size: 18, color: dark),
            const SizedBox(width: 10),
            Expanded(
              child: Text(
                label,
                style: const TextStyle(
                  fontSize: 13,
                  fontWeight: FontWeight.w600,
                  fontFamily: "Inter",
                  color: dark,
                ),
              ),
            ),
            const Icon(Icons.chevron_right, size: 18, color: dark),
          ],
        ),
      ),
    );
  }
}
