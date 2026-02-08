import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class Messages extends StatefulWidget {
  const Messages({super.key});

  @override
  State<Messages> createState() => _MessagesState();
}

class _MessagesState extends State<Messages> {
  static const Color dark = Color(0xFF2B2B2B);
  static const Color divider = Color(0xff51AD42);
  // ignore: unused_field
  static const Color selectedGreen = Color(0xFF4FAE56);

  int _chipIndex = 0; // 0=Overview, 1=Instagram, 2=Facebook, 3=TikTok

  double clamp(double v, double min, double max) => v.clamp(min, max);

  @override
  Widget build(BuildContext context) {
    final m = MediaQuery.of(context);
    final w = m.size.width;
    final h = m.size.height;

    final sidePad = clamp(w * 0.05, 18, 24);
    final _ = clamp(h * 0.22, 155, 190);

    // svg sizing
     const double svgViewBoxWidth = 393;
    const double svgViewBoxHeight = 165;
    final double topSvgHeight = w * (svgViewBoxHeight / svgViewBoxWidth);

    return Scaffold(
      backgroundColor: const Color(0xFFEBEBEB),
      body: Stack(
        children: [
          
          // SVG
          Positioned(
            top: 0,
            left: 0,
            right: 0,
            child: SizedBox(
              height: topSvgHeight,
              child: SvgPicture.asset(
                'assets/messages.svg',
                fit: BoxFit.fitWidth,
                alignment: Alignment.topLeft,
              ),
            ),
          ),

          SafeArea(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Title
                Padding(
                  padding: EdgeInsets.fromLTRB(sidePad, 12, sidePad, 0),
                  child: Text(
                    "Messages",
                    style: TextStyle(
                      fontSize: clamp(w * 0.09, 30, 40),
                      fontWeight: FontWeight.w900,
                      color: dark,
                      height: 1.05,
                    ),
                  ),
                ),

                const SizedBox(height: 12),

                // Chips row (tappable)
                SizedBox(
                  height: 46,
                  child: ListView(
                    padding: EdgeInsets.symmetric(horizontal: sidePad),
                    scrollDirection: Axis.horizontal,
                    children: [
                      _SelectableChip(
                        label: "Overview",
                        icon: Icons.bar_chart_rounded,
                        selected: _chipIndex == 0,
                        onTap: () => setState(() => _chipIndex = 0),
                      ),
                      const SizedBox(width: 10),
                      _SelectableChip(
                        label: "Instagram",
                        icon: Icons.camera_alt_outlined,
                        selected: _chipIndex == 1,
                        onTap: () => setState(() => _chipIndex = 1),
                      ),
                      const SizedBox(width: 10),
                      _SelectableChip(
                        label: "Facebook",
                        icon: Icons.facebook,
                        selected: _chipIndex == 2,
                        onTap: () => setState(() => _chipIndex = 2),
                      ),
                      const SizedBox(width: 10),
                      _SelectableChip(
                        label: "TikTok",
                        icon: Icons.music_note_outlined,
                        selected: _chipIndex == 3,
                        onTap: () => setState(() => _chipIndex = 3),
                      ),
                      const SizedBox(width: 10),
                    ],
                  ),
                ),

                const SizedBox(height: 10),

                // Divider line like the mock
                const Divider(height: 1, thickness: 1, color: divider),

                // Messages list area
                Expanded(
                  child: ListView(
                    padding: EdgeInsets.fromLTRB(sidePad, 8, sidePad, 90),
                    children: [
                      // // Empty-state message (what you asked for)
                      // Container(
                      //   padding: const EdgeInsets.all(14),
                      //   decoration: BoxDecoration(
                      //     color: const Color(0xFFF3F3F3),
                      //     borderRadius: BorderRadius.circular(16),
                      //   ),
                      //   child: const Text(
                      //     "Your incoming messages will appear here.",
                      //     style: TextStyle(
                      //       fontSize: 13,
                      //       fontWeight: FontWeight.w700,
                      //       color: Color(0xFF2B2B2B),
                      //     ),
                      //   ),
                      // ),

                      const SizedBox(height: 12),

                      // Fake rows (optional) to look like the mock
                      const _MessageRow(
                        name: "Company",
                        preview: "Apuasi toi eli rti on etko. Miehensa tynnessa antakon vie sai tuo.",
                        online: true,
                      ),
                      const Divider(height: 1, thickness: 1, color: divider),
                      const _MessageRow(
                        name: "Company",
                        preview: "Apuasi toi eli rti on etko. Miehensa tynnessa antakon vie sai tuo.",
                        online: false,
                      ),
                      const Divider(height: 1, thickness: 1, color: divider),
                      const _MessageRow(
                        name: "Person",
                        preview: "Apuasi toi eli rti on etko. Miehensa tynnessa antakon vie sai tuo.",
                        online: true,
                      ),
                      const Divider(height: 1, thickness: 1, color: divider),
                      const _MessageRow(
                        name: "Person",
                        preview: "Apuasi toi eli rti on etko. Miehensa tynnessa antakon vie sai tuo.",
                        online: false,
                      ),
                      const Divider(height: 1, thickness: 1, color: divider),
                    ],
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

/// Chip that turns green when selected
class _SelectableChip extends StatelessWidget {
  final String label;
  final IconData icon;
  final bool selected;
  final VoidCallback onTap;

  static const Color selectedGreen = Color(0xFF51AD42);

  const _SelectableChip({
    required this.label,
    required this.icon,
    required this.selected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final bg = selected ? selectedGreen : const Color(0xFFEBEBEB);
    final fg = selected ? const Color(0xFFEBEBEB) : const Color(0xFF2B2B2B);
    final border = selected ? Colors.transparent : const Color(0x22000000);

    return InkWell(
      borderRadius: BorderRadius.circular(16),
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
        decoration: BoxDecoration(
          color: bg,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: border),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(icon, size: 16, color: fg),
            const SizedBox(width: 8),
            Text(
              label,
              style: TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.w800,
                color: fg,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

/// Simple message row (fake)
class _MessageRow extends StatelessWidget {
  final String name;
  final String preview;
  final bool online;

  const _MessageRow({
    required this.name,
    required this.preview,
    required this.online,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10),
      child: Row(
        children: [
          Stack(
            children: [
              const CircleAvatar(
                radius: 22,
                backgroundColor: Color(0xFFEBEBEB),
                child: Icon(Icons.person, color: Color(0xFF2B2B2B)),
              ),
              Positioned(
                right: 0,
                bottom: 0,
                child: Container(
                  width: 12,
                  height: 12,
                  decoration: BoxDecoration(
                    color: online ? const Color(0xFF51AD42) : const Color(0xFFBDBDBD),
                    shape: BoxShape.circle,
                    border: Border.all(color: const Color(0xFFEBEBEB), width: 2),
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  name,
                  style: const TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.w900,
                    color: Color(0xFF2B2B2B),
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  preview,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(
                    fontSize: 11.5,
                    fontWeight: FontWeight.w600,
                    color: Color(0xFF4A4A4A),
                    height: 1.2,
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

/// Curved header like your mock (simple, clean)
// ignore: unused_element
class _HeaderCurveClipper extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    final p = Path();
    p.lineTo(0, size.height);
    p.quadraticBezierTo(size.width * 0.65, size.height * 0.75, size.width, size.height * 0.55);
    p.lineTo(size.width, 0);
    p.close();
    return p;
  }

  @override
  bool shouldReclip(covariant CustomClipper<Path> oldClipper) => false;
}
