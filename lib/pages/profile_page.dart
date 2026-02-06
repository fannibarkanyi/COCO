import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  String name = "Dr Maria Sofia Mathis";
  String email = "drmathis@kabbe.com";
  String password = "password123";

  static const _iconColor = Color(0xFF2B2B2B);
  static const _lightBg = Color(0xFFEBEBEB);

  // SVG aspect ratios (from your design)
  static const double _topAspect = 393 / 174;
  static const double _bottomAspect = 393 / 194; // ✅ fixed

  Future<void> _editField({
    required String title,
    required String initialValue,
    required bool obscure,
    required void Function(String v) onSave,
  }) async {
    final controller = TextEditingController(text: initialValue);

    final result = await showDialog<String>(
      context: context,
      builder: (_) => AlertDialog(
        backgroundColor: const Color.fromARGB(255, 253, 235, 235),
        title: Text(title),
        content: TextField(
          controller: controller,
          obscureText: obscure,
          decoration: const InputDecoration(
            border: OutlineInputBorder(),
          ),
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

    if (result != null && result.isNotEmpty) {
      setState(() => onSave(result));
    }
  }

  String get maskedPassword => "•" * (password.length.clamp(8, 12));

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.transparent,
      body: LayoutBuilder(
        builder: (context, constraints) {
          final w = constraints.maxWidth;
          final h = constraints.maxHeight;

          // Height of each SVG based on screen width and aspect ratio
          final topSvgH = w / _topAspect;
          final bottomSvgH = w / _bottomAspect;

          // Avatar sizing
          const avatarRadius = 36.0;
          final avatarTop = topSvgH - avatarRadius; // ✅ center hits bottom of top svg

          // Sign out button sizing
          const btnW = 167.0;
          const btnH = 62.0;
          final bottomSvgTopY = h - bottomSvgH;
          final signOutTop = bottomSvgTopY - (btnH / 2); // ✅ center hits top of bottom svg

          // Content spacing (keep content between avatar and signout)
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

              // ✅ CONTENT ONLY in SafeArea (NOT avatar/signout)
              SafeArea(
                child: Padding(
                  padding: EdgeInsets.fromLTRB(24, 24, 24, contentBottom),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Header row
                      Row(
                        children: [
                          const Expanded(
                            child: Text(
                              "Profile",
                              style: TextStyle(
                                fontSize: 36,
                                fontWeight: FontWeight.w700,
                                fontFamily: "Inter",
                                color: _iconColor,
                              ),
                            ),
                          ),
                          IconButton(
                            onPressed: () {},
                            icon: const Icon(Icons.settings),
                            color: _iconColor,
                          ),
                        ],
                      ),

                      // Push content to start BELOW avatar overlay
                      SizedBox(height: (contentTop - 24 - 56).clamp(0, 9999)),

                      // Name + edit
                      Center(
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Text(
                              name,
                              style: const TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.w700,
                                fontFamily: "Inter",
                                color: _iconColor,
                              ),
                            ),
                            const SizedBox(width: 6),
                            GestureDetector(
                              onTap: () => _editField(
                                title: "Edit name",
                                initialValue: name,
                                obscure: false,
                                onSave: (v) => name = v,
                              ),
                              child: const Icon(Icons.edit, size: 18, color: _iconColor),
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
                          onSave: (v) => email = v,
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
                          onSave: (v) => password = v,
                        ),
                      ),

                      const SizedBox(height: 22),

                      const Text(
                        "Social media",
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w700,
                          fontFamily: "Inter",
                          color: _iconColor,
                        ),
                      ),

                      const SizedBox(height: 14),

                      // SOCIAL SECTION (two columns + vertical divider)
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
                                    onTap: () {},
                                  ),
                                  _SocialTile(
                                    icon: Icons.facebook,
                                    label: "Facebook",
                                    onTap: () {},
                                  ),
                                  _SocialTile(
                                    icon: Icons.music_note,
                                    label: "TikTok",
                                    onTap: () {},
                                  ),
                                ],
                              ),
                            ),

                            const Padding(
                              padding: EdgeInsets.symmetric(horizontal: 14),
                              child: VerticalDivider(
                                thickness: 1,
                                width: 1,
                                color: _iconColor,
                              ),
                            ),

                            Expanded(
                              child: Column(
                                children: [
                                  _SocialTile(
                                    icon: Icons.close,
                                    label: "X",
                                    onTap: () {},
                                  ),
                                  _SocialTile(
                                    icon: Icons.business_center_outlined,
                                    label: "LinkedIn",
                                    onTap: () {},
                                  ),
                                  _SocialTile(
                                    icon: Icons.add_box_outlined,
                                    label: "Add more",
                                    onTap: () {},
                                  ),
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

              // ✅ AVATAR aligned in same coordinate system as SVGs
              Positioned(
                top: avatarTop,
                left: 0,
                right: 0,
                child: Center(
                  child: CircleAvatar(
                    radius: avatarRadius,
                    backgroundColor: _lightBg,
                    child: ClipOval(
                      child: Image.asset(
                        'assets/profile_pic.png',
                        width: 72,
                        height: 72,
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
                ),
              ),

              // ✅ SIGN OUT aligned in same coordinate system as SVGs
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
                        backgroundColor: _iconColor,
                        elevation: 0,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(16),
                        ),
                      ),
                      child: const Text(
                        "Sign out",
                        style: TextStyle(
                          color: _lightBg,
                          fontSize: 24,
                          fontWeight: FontWeight.w700,
                          fontFamily: "Inter",
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ],
          );
        },
      ),
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

  static const _iconColor = Color(0xFF2B2B2B);

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            label,
            style: const TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.w600,
              fontFamily: "Inter",
              color: _iconColor,
            ),
          ),
          const SizedBox(width: 6),
          Text(
            value,
            style: const TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.w500,
              fontFamily: "Inter",
              color: _iconColor,
            ),
          ),
          const SizedBox(width: 6),
          GestureDetector(
            onTap: onEdit,
            child: const Icon(Icons.edit, size: 16, color: _iconColor),
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

  static const _iconColor = Color(0xFF2B2B2B);

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 10),
        child: Row(
          children: [
            Icon(icon, size: 18, color: _iconColor),
            const SizedBox(width: 10),
            Expanded(
              child: Text(
                label,
                style: const TextStyle(
                  fontSize: 13,
                  fontWeight: FontWeight.w600,
                  fontFamily: "Inter",
                  color: _iconColor,
                ),
              ),
            ),
            const Icon(Icons.chevron_right, size: 18, color: _iconColor),
          ],
        ),
      ),
    );
  }
}
