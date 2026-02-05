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

  // Keep constants OUTSIDE build (removes yellow warnings)
  static const _iconColor = Color(0xFF2B2B2B);
  static const _lightBg = Color(0xFFEBEBEB);
  static const _tileBg = Color(0xFFF5F5F5);

  // SVG aspect ratios (from your design)
  static const double _topAspect = 393 / 174;
  static const double _bottomAspect = 393 / 194;

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
      backgroundColor: Colors.transparent, // important with AppShell + transparent nav
      body: Stack(
        children: [
          // TOP SVG
          Positioned(
            top: 0,
            left: 0,
            right: 0,
            child: AspectRatio(
              aspectRatio: _topAspect,
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
            child: AspectRatio(
              aspectRatio: _bottomAspect,
              child: SvgPicture.asset(
                'assets/profile_bottom.svg',
                fit: BoxFit.cover,
                alignment: Alignment.bottomCenter,
              ),
            ),
          ),

          SafeArea(
            child: ListView(
              padding: const EdgeInsets.fromLTRB(24, 24, 24, 110), // ✅ space for nav
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

                const SizedBox(height: 20),

                // Avatar
                Center(
                  child: CircleAvatar(
                    radius: 38,
                    backgroundColor: _lightBg,
                    child: ClipOval(
                      child: Image.network(
                        "https://i.pravatar.cc/200",
                        width: 72,
                        height: 72,
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
                ),

                const SizedBox(height: 14),

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

                const SizedBox(height: 10),

                Row(
                  children: [
                    Expanded(
                      child: _SocialTile(
                        icon: Icons.camera_alt_outlined,
                        label: "Instagram",
                        onTap: () {},
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: _SocialTile(
                        icon: Icons.close,
                        label: "X",
                        onTap: () {},
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 10),
                Row(
                  children: [
                    Expanded(
                      child: _SocialTile(
                        icon: Icons.facebook,
                        label: "Facebook",
                        onTap: () {},
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: _SocialTile(
                        icon: Icons.business_center_outlined,
                        label: "LinkedIn",
                        onTap: () {},
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 10),
                Row(
                  children: [
                    Expanded(
                      child: _SocialTile(
                        icon: Icons.music_note,
                        label: "TikTok",
                        onTap: () {},
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: _SocialTile(
                        icon: Icons.add,
                        label: "Add more",
                        onTap: () {},
                      ),
                    ),
                  ],
                ),

                const SizedBox(height: 22),

                // Sign out button
                Center(
                  child: SizedBox(
                    width: 170,
                    height: 52,
                    child: ElevatedButton(
                      onPressed: () {},
                      style: ElevatedButton.styleFrom(
                        backgroundColor: _iconColor,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(16),
                        ),
                      ),
                      child: const Text(
                        "Sign out",
                        style: TextStyle(
                          color: _lightBg,
                          fontSize: 16,
                          fontWeight: FontWeight.w700,
                          fontFamily: "Inter",
                        ),
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
  static const _tileBg = Color(0xFFF5F5F5);

  @override
  Widget build(BuildContext context) {
    return Material(
      color: _tileBg,
      borderRadius: BorderRadius.circular(14),
      child: InkWell(
        borderRadius: BorderRadius.circular(14),
        onTap: onTap,
        child: Container(
          height: 44,
          padding: const EdgeInsets.symmetric(horizontal: 12),
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
      ),
    );
  }
}
