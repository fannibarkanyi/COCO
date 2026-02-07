import 'package:flutter/material.dart';

class StatisticsPage extends StatelessWidget {
  const StatisticsPage({super.key});

  static const Color _green = Color(0xFF8FE08B);
  static const Color _text = Color(0xFF1F1F1F);
  static const Color _card = Color(0xFFF3F3F3);
  static const Color _chipSelected = Color(0xFF4FAE56);

  @override
  Widget build(BuildContext context) {
    final m = MediaQuery.of(context);
    final w = m.size.width;
    final h = m.size.height;

    double clamp(double v, double min, double max) => v.clamp(min, max);

    final sidePad = clamp(w * 0.05, 18, 24);
    final gridGap = clamp(w * 0.035, 12, 16);
    final bottomSpace = clamp(h * 0.16, 110, 140);

    return Scaffold(
      backgroundColor: Colors.transparent,
      body: Stack(
        children: [
          const Positioned.fill(child: ColoredBox(color: Colors.white)),

          // Green background curve
          Positioned.fill(
            child: CustomPaint(
              painter: _StatsGreenPainter(color: _green),
            ),
          ),

          SafeArea(
            child: SingleChildScrollView(
              padding: EdgeInsets.fromLTRB(sidePad, 16, sidePad, bottomSpace),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Header row
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Expanded(
                        child: Text(
                          "Statistics",
                          style: TextStyle(
                            fontSize: clamp(w * 0.09, 30, 40),
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

                  // Chips row
                  SizedBox(
                    height: 46,
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
                          label: "instagram",
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
                      ],
                    ),
                  ),

                  const SizedBox(height: 18),

                  // Stats grid (taller cards)
                  Row(
                    children: [
                      const Expanded(
                        child: _StatCard(
                          bigText: "0",
                          label: "Followers",
                          icon: Icons.person_add_alt_1_outlined,
                        ),
                      ),
                      SizedBox(width: gridGap),
                      const Expanded(
                        child: _StatCard(
                          bigText: "0",
                          label: "Posts",
                          icon: Icons.description_outlined,
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: gridGap),
                  Row(
                    children: [
                      const Expanded(
                        child: _StatCard(
                          bigText: "0",
                          label: "Views",
                          icon: Icons.remove_red_eye_outlined,
                        ),
                      ),
                      SizedBox(width: gridGap),
                      const Expanded(
                        child: _StatCard(
                          bigText: "0",
                          label: "Likes",
                          icon: Icons.thumb_up_alt_outlined,
                        ),
                      ),
                    ],
                  ),

                  const SizedBox(height: 20),

                  const _DiscoveryCard(),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

/* ---------------- Dropdown ---------------- */

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

/* ---------------- Chips ---------------- */

class _AppChip extends StatelessWidget {
  final String label;
  final bool selected;
  final IconData icon;

  const _AppChip({
    required this.label,
    required this.selected,
    required this.icon,
  });

  @override
  Widget build(BuildContext context) {
    final bg = selected ? StatisticsPage._chipSelected : Colors.white;
    final fg = selected ? Colors.white : const Color(0xFF2A2A2A);
    final border = selected ? Colors.transparent : const Color(0x22000000);

    return Container(
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
    );
  }
}

/* ---------------- Stat Card ---------------- */

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
    final w = MediaQuery.of(context).size.width;

    // ✅ must be double
    final double cardHeight = (w * 0.45).clamp(165, 190).toDouble();

    return Container(
      height: cardHeight,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: StatisticsPage._card,
        borderRadius: BorderRadius.circular(18),
      ),
      child: Stack(
        children: [
          Align(
            alignment: Alignment.topLeft,
            child: Text(
              bigText,
              style: const TextStyle(
                fontSize: 48,
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

/* ---------------- Discovery Card ---------------- */

class _DiscoveryCard extends StatelessWidget {
  const _DiscoveryCard();

  @override
  Widget build(BuildContext context) {
    final w = MediaQuery.of(context).size.width;

    return Container(
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: StatisticsPage._card,
        borderRadius: BorderRadius.circular(18),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            "Profile Discovery",
            style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w900,
              color: StatisticsPage._text,
            ),
          ),
          const SizedBox(height: 4),
          const Text(
            "See your growth in a month",
            style: TextStyle(
              fontSize: 11,
              fontWeight: FontWeight.w600,
              color: Color(0xFF3D3D3D),
            ),
          ),

          // ✅ push diagram down more
          SizedBox(height: (w * 0.1).clamp(28, 36).toDouble()),

          // ✅ lower bars further by padding top
          SizedBox(
            height: (w * 0.3).clamp(100, 120).toDouble(),
            child: Padding(
              padding: EdgeInsets.only(top: (w * 0.06).clamp(16, 22).toDouble()),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: List.generate(12, (i) {
                  final heights = [18, 22, 26, 32, 40, 48, 34, 22, 30, 56, 44, 38];
                  final isAccent = i == 9;

                  return Expanded(
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 3),
                      child: Align(
                        alignment: Alignment.bottomCenter,
                        child: Container(
                          height: heights[i].toDouble(),
                          decoration: BoxDecoration(
                            color: isAccent ? StatisticsPage._chipSelected : const Color(0xFF222222),
                            borderRadius: BorderRadius.circular(6),
                          ),
                        ),
                      ),
                    ),
                  );
                }),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

/* ---------------- Background Painter ---------------- */

class _StatsGreenPainter extends CustomPainter {
  _StatsGreenPainter({required this.color});
  final Color color;

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()..color = color;

    final path = Path()
      ..lineTo(0, size.height * 0.22)
      ..quadraticBezierTo(size.width * 0.55, size.height * 0.04, size.width, size.height * 0.18)
      ..lineTo(size.width, 0)
      ..close();

    canvas.drawPath(path, paint);
    canvas.drawRect(Rect.fromLTWH(0, size.height * 0.18, size.width, size.height), paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
