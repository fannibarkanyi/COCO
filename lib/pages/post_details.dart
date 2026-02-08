import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

import '../widgets/bottom_nav.dart';
import 'app_shell.dart';
import 'post_preview.dart';


class PostDetailsPage extends StatefulWidget {
  const PostDetailsPage({
    super.key,
    required this.imagePath,
  });

  final String imagePath;

  @override
  State<PostDetailsPage> createState() => _PostDetailsPageState();
}

class _PostDetailsPageState extends State<PostDetailsPage> {
  static const dark = Color(0xFF2B2B2B);
  static const bg = Color(0xFFEBEBEB);
  static const double _topAspect = 393/504;

  final captionCtrl = TextEditingController();
  final descCtrl = TextEditingController();
  final locationCtrl = TextEditingController();
  final musicCtrl = TextEditingController();

  bool ig = false, fb = false, tt = false, x = false, li = false;

  @override
  void dispose() {
    captionCtrl.dispose();
    descCtrl.dispose();
    locationCtrl.dispose();
    musicCtrl.dispose();
    super.dispose();
  }

  void _goToTab(int index) {
    Navigator.pushAndRemoveUntil(
      context,
      MaterialPageRoute(builder: (_) => AppShell(initialIndex: index)),
      (route) => false,
    );
  }

  List<String> _selectedPlatforms() {
  final p = <String>[];
  if (ig) p.add("ig");
  if (fb) p.add("fb");
  if (tt) p.add("tt");
  if (x)  p.add("x");
  if (li) p.add("li");
  return p;
}

  @override
  Widget build(BuildContext context) {
    final media = MediaQuery.of(context);
    final w = media.size.width;
    final h = media.size.height;

   

    return Scaffold(
      extendBody: true,
      backgroundColor: Colors.transparent,
      bottomNavigationBar: BottomNav(
        currentIndex: 0,
        onTap: (i) => _goToTab(i),
      ),
      body: Stack(
        children: [
          Positioned.fill(child: Container(color: bg)),

          // TOP SVG
           Positioned(
  top: 0,
  left: 0,
  right: 0,
  child: AspectRatio(
    aspectRatio: _topAspect,
    child: SvgPicture.asset(
      'assets/posting2_top.svg',
      fit: BoxFit.contain, // or BoxFit.fill (see note below)
      alignment: Alignment.topLeft,
    ),
  ),
),

          SafeArea(
            child: SingleChildScrollView(
              padding: const EdgeInsets.fromLTRB(18, 18, 18, 120),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Header (back + title)
                  Row(
                    children: [
                      InkWell(
                        borderRadius: BorderRadius.circular(20),
                        onTap: () => Navigator.pop(context),
                        child: const Padding(
                          padding: EdgeInsets.all(2),
                          child: Icon(
                            Icons.chevron_left,
                            size: 32,
                            color: dark,
                          ),
                        ),
                      ),
                      const SizedBox(width: 8),
                      const Text(
                        "Posting",
                        style: TextStyle(
                          fontSize: 35,
                          fontWeight: FontWeight.w800,
                          fontFamily: "Inter",
                          color: dark,
                        ),
                      ),
                    ],
                  ),

                  const SizedBox(height: 18),

                  _InputField(
                    controller: captionCtrl,
                    hint: "Add caption",
                    maxLines: 1,
                  ),
                  const SizedBox(height: 12),

                  _InputField(
                    controller: descCtrl,
                    hint: "Add description*",
                    maxLines: 4,
                  ),
                  const SizedBox(height: 12),

                  _InputField(
                    controller: locationCtrl,
                    hint: "Add location",
                    maxLines: 1,
                  ),
                  const SizedBox(height: 12),

                  _InputField(
                    controller: musicCtrl,
                    hint: "Add music*",
                    maxLines: 1,
                  ),

                  const SizedBox(height: 12),
                  const Text(
                    "Or",
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w500,
                      fontFamily: "Inter",
                      color: dark,
                    ),
                  ),
                  const SizedBox(height: 10),

                  // Generate with AI button (same style language as your other buttons)
                  SizedBox(
                    height: 44,
                    child: ElevatedButton(
                      onPressed: () {},
                      style: ElevatedButton.styleFrom(
                        backgroundColor: dark,
                        foregroundColor: bg,
                        elevation: 0,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                        padding: const EdgeInsets.symmetric(horizontal: 14),
                      ),
                      child: const Text(
                        "Generate text with AI",
                        style: TextStyle(
                          fontSize: 13,
                          fontWeight: FontWeight.w700,
                          fontFamily: "Inter",
                        ),
                      ),
                    ),
                  ),

                  const SizedBox(height: 18),

                  const Text(
                    "Publish on..",
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                      fontFamily: "Inter",
                      color: dark,
                    ),
                  ),

                  const SizedBox(height: 10),

                  // Social icons row
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      _SocialSquare(
                        label: "IG",
                        icon: Icons.camera_alt_outlined,
                        selected: ig,
                        onTap: () => setState(() => ig = !ig),
                      ),
                      _SocialSquare(
                        label: "F",
                        icon: Icons.facebook,
                        selected: fb,
                        onTap: () => setState(() => fb = !fb),
                      ),
                      _SocialSquare(
                        label: "TT",
                        icon: Icons.music_note,
                        selected: tt,
                        onTap: () => setState(() => tt = !tt),
                      ),
                      _SocialSquare(
                        label: "X",
                        icon: Icons.close,
                        selected: x,
                        onTap: () => setState(() => x = !x),
                      ),
                      _SocialSquare(
                        label: "IN",
                        icon: Icons.business_center_outlined,
                        selected: li,
                        onTap: () => setState(() => li = !li),
                      ),
                    ],
                  ),

                  const SizedBox(height: 22),

                  // NEXT BUTTON 
                  Center(
                    child: SizedBox(
                      width: mathMin(160.0, w * 0.46),
                      height: 44,
                      child: ElevatedButton(
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (_) => PostPreviewChoosePage(
                                imagePath: widget.imagePath,
                                caption: captionCtrl.text.trim(),
                                description: descCtrl.text.trim(),
                                location: locationCtrl.text.trim(),
                                music: musicCtrl.text.trim(),
                                platforms: _selectedPlatforms(), // ✅ NEW
                              ),
                            ),
                          );
                        }, // ✅ IMPORTANT: closes onPressed

                        style: ElevatedButton.styleFrom(
                          backgroundColor: dark,
                          foregroundColor: bg,
                          elevation: 0,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                        child: const Text(
                          "Next",
                          style: TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.w800,
                            fontFamily: "Inter",
                          ),
                        ),
                      ),
                    ),
                  ),


                  // a little extra so it feels like the mock (big airy bottom)
                  SizedBox(height: h * 0.04),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  double mathMin(double a, double b) => a < b ? a : b;
}

class _InputField extends StatelessWidget {
  const _InputField({
    required this.controller,
    required this.hint,
    required this.maxLines,
  });

  final TextEditingController controller;
  final String hint;
  final int maxLines;

  static const dark = Color(0xFF2B2B2B);

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: controller,
      maxLines: maxLines,
      style: const TextStyle(
        fontSize: 13,
        fontWeight: FontWeight.w600,
        fontFamily: "Inter",
        color: dark,
      ),
      decoration: InputDecoration(
        hintText: hint,
        hintStyle: const TextStyle(
          fontSize: 13,
          fontWeight: FontWeight.w600,
          fontFamily: "Inter",
          color: dark,
        ),
        filled: true,
        fillColor: const Color(0xFFEBEBEB),
        contentPadding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: const BorderSide(color: dark, width: 1),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: const BorderSide(color: dark, width: 1),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: const BorderSide(color: dark, width: 1.4),
        ),
      ),
    );
  }
}

class _SocialSquare extends StatelessWidget {
  const _SocialSquare({
    required this.icon,
    required this.selected,
    required this.onTap,
    required this.label,
  });

  final IconData icon;
  final bool selected;
  final VoidCallback onTap;
  final String label;

  static const dark = Color(0xFF2B2B2B);

  @override
  Widget build(BuildContext context) {
    return InkWell(
      borderRadius: BorderRadius.circular(10),
      onTap: onTap,
      child: Container(
        width: 54,
        height: 54,
        decoration: BoxDecoration(
          color: const Color(0xFFE0E0E0),
          borderRadius: BorderRadius.circular(10),
          border: Border.all(
            color: selected ? dark : Colors.transparent,
            width: 2,
          ),
        ),
        child: Icon(icon, color: dark),
      ),
    );
  }
}
