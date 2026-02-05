import 'package:flutter/material.dart';

class StatisticsPage extends StatelessWidget {
  const StatisticsPage({super.key});

  static const Color _green = Color(0xFF8FE08B);
  static const Color _text = Color(0xFF1F1F1F);
  static const Color _card = Color(0xFFF3F3F3);
  static const Color _chipSelected = Color(0xFF4FAE56);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.transparent,
      body: Stack(
        children: [
          // White base
          const Positioned.fill(child: ColoredBox(color: Colors.white)),

          // Green curved background like your screenshot
          Positioned.fill(
            child: ClipPath(
              clipper: _GreenCurveClipper(),
              child: const ColoredBox(color: _green),
            ),
          ),

          SafeArea(
            child: LayoutBuilder(
              builder: (context, constraints) {
                return SingleChildScrollView(
                  padding: const EdgeInsets.fromLTRB(20, 16, 20, 110),
                  child: ConstrainedBox(
                    constraints: BoxConstraints(minHeight: constraints.maxHeight - 110),
                    child: IntrinsicHeight(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          // Header
                          Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Expanded(
                                child: Text(
                                  "Statistics",
                                  style: TextStyle(
                                    fontSize: 34,
                                    fontWeight: FontWeight.w900,
                                    color: _text,
                                    height: 1.05,
                                  ),
                                ),
                              ),
                              _MonthDropdown(label: "Last month", onTap: () {}),
                            ],
                          ),

                          const SizedBox(height: 14),

                          // Horizontal scroll app row
                          SizedBox(
                            height: 44,
                            child: ListView(
                              scrollDirection: Axis.horizontal,
                              children: const [
                                _AppChip(
                                  label: "Overview",
                                  selected: true,
                                  icon: Icons.bar_chart_rounded,
                                ),
                                SizedBox(width: 10),
                                _AppChip(
                                  label: "Instagram",
                                  selected: false,
                                  icon: Icons.camera_alt_outlined,
                                ),
                                SizedBox(width: 10),
                                _AppChip(
                                  label: "Facebook",
                                  selected: false,
                                  icon: Icons.facebook,
                                ),
                                SizedBox(width: 10),
                                _AppChip(
                                  label: "TikTok",
                                  selected: false,
                                  icon: Icons.music_note_outlined,
                                ),
                                SizedBox(width: 10),
                                _AppChip(
                                  label: "LinkedIn",
                                  selected: false,
                                  icon: Icons.business_center_outlined,
                                ),
                                SizedBox(width: 10),
                                _AppChip(
                                  label: "X",
                                  selected: false,
                                  icon: Icons.close,
                                ),
                              ],
                            ),
                          ),

                          const SizedBox(height: 14),

                          // Stats grid
                          Row(
                            children: const [
                              Expanded(
                                child: _StatCard(
                                  bigText: "856",
                                  label: "Followers",
                                  icon: Icons.person_add_alt_1_outlined,
                                ),
                              ),
                              SizedBox(width: 14),
                              Expanded(
                                child: _StatCard(
                                  bigText: "67",
                                  label: "Posts",
                                  icon: Icons.description_outlined,
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 14),
                          Row(
                            children: const [
                              Expanded(
                                child: _StatCard(
                                  bigText: "2,1k",
                                  label: "Views",
                                  icon: Icons.remove_red_eye_outlined,
                                ),
                              ),
                              SizedBox(width: 14),
                              Expanded(
                                child: _StatCard(
                                  bigText: "1,8k",
                                  label: "Likes",
                                  icon: Icons.thumb_up_alt_outlined,
                                ),
                              ),
                            ],
                          ),

                          const SizedBox(height: 14),

                          // ✅ Now Spacer is safe because IntrinsicHeight gives bounded height
                          const Spacer(),

                          const _DiscoveryCard(),
                        ],
                      ),
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}

class _MonthDropdown extends StatelessWidget {
  final String label;
  final VoidCallback onTap;

  const _MonthDropdown({required this.label, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(12),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              label,
              style: const TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.w700,
                color: Color(0xFF2E2E2E),
              ),
            ),
            const SizedBox(width: 4),
            const Icon(Icons.keyboard_arrow_down_rounded, size: 18, color: Color(0xFF2E2E2E)),
          ],
        ),
      ),
    );
  }
}

class _AppChip extends StatelessWidget {
  final String label;
  final bool selected;
  final IconData icon;

  const _AppChip({
    required this.label,
    required this.selected,
    required this.icon,
  });

  static const Color _chipSelected = Color(0xFF4FAE56);

  @override
  Widget build(BuildContext context) {
    final bg = selected ? _chipSelected : Colors.white;
    final fg = selected ? Colors.white : const Color(0xFF2A2A2A);
    final border = selected ? Colors.transparent : const Color(0x22000000);

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 9),
      decoration: BoxDecoration(
        color: bg,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: border),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 16, color: fg),
          const SizedBox(width: 7),
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
    );
  }
}

class _StatCard extends StatelessWidget {
  final String bigText;
  final String label;
  final IconData icon;

  const _StatCard({
    required this.bigText,
    required this.label,
    required this.icon,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 132,
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: StatisticsPage._card,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Stack(
        children: [
          Align(
            alignment: Alignment.topLeft,
            child: Text(
              bigText,
              style: const TextStyle(
                fontSize: 42,
                fontWeight: FontWeight.w900,
                color: StatisticsPage._text,
                height: 1.0,
              ),
            ),
          ),
          Align(
            alignment: Alignment.bottomLeft,
            child: Text(
              label,
              style: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w900,
                color: StatisticsPage._text,
              ),
            ),
          ),
          Align(
            alignment: Alignment.bottomRight,
            child: Icon(icon, size: 22, color: StatisticsPage._text),
          ),
        ],
      ),
    );
  }
}

class _DiscoveryCard extends StatelessWidget {
  const _DiscoveryCard();

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: StatisticsPage._card,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            "Profile Discovery",
            style: TextStyle(
              fontSize: 13,
              fontWeight: FontWeight.w900,
              color: StatisticsPage._text,
            ),
          ),
          const SizedBox(height: 2),
          const Text(
            "See your growth in a month",
            style: TextStyle(
              fontSize: 11,
              fontWeight: FontWeight.w600,
              color: Color(0xFF3D3D3D),
            ),
          ),
          const SizedBox(height: 12),
          SizedBox(
            height: 72,
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: List.generate(12, (i) {
                final heights = [18, 24, 28, 38, 46, 54, 42, 28, 36, 60, 50, 44];
                final h = heights[i].toDouble();
                final isAccent = i == 9;

                return Expanded(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 3),
                    child: Container(
                      height: h,
                      decoration: BoxDecoration(
                        color: isAccent ? StatisticsPage._chipSelected : const Color(0xFF222222),
                        borderRadius: BorderRadius.circular(6),
                      ),
                    ),
                  ),
                );
              }),
            ),
          ),
        ],
      ),
    );
  }
}

class _GreenCurveClipper extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    final w = size.width;
    final h = size.height;

    // Curve positions tuned to resemble your screenshot
    final leftY = h * 0.17;
    final midY = h * 0.07;
    final rightY = h * 0.14;

    final path = Path();
    path.moveTo(0, leftY);
    path.quadraticBezierTo(w * 0.35, midY, w * 0.72, leftY + 10);
    path.quadraticBezierTo(w * 0.90, rightY + 20, w, rightY);

    path.lineTo(w, h);
    path.lineTo(0, h);
    path.close();
    return path;
  }

  @override
  bool shouldReclip(covariant CustomClipper<Path> oldClipper) => false;
}
