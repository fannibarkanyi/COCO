import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class StatisticsPage extends StatefulWidget {
  const StatisticsPage({super.key});

  
  static const Color dark = Color(0xFF2B2B2B);
  static const Color bg = Color(0xFFEBEBEB);
  static const Color selectedGreen = Color(0xFF51AD42);

  @override
  State<StatisticsPage> createState() => _StatisticsPageState();
}

class _StatisticsPageState extends State<StatisticsPage> {
  int _chipIndex = 0; // 0=Overview, 1=Instagram, 2=Facebook, 3=TikTok

  @override
  Widget build(BuildContext context) {
    final m = MediaQuery.of(context);
    final w = m.size.width;
    final h = m.size.height;

    // svg sizing
    const double svgViewBoxW = 393;
    const double svgViewBoxH = 809;
    final double bottomSvgHeight = w * (svgViewBoxH / svgViewBoxW);

    double clamp(double v, double min, double max) => v.clamp(min, max);

    final sidePad = clamp(w * 0.05, 18, 24);
    final gridGap = clamp(w * 0.035, 12, 16);
    final bottomSpace = clamp(h * 0.16, 110, 140);

    return Scaffold(
      backgroundColor: Colors.transparent,
      body: Stack(
        children: [
          const Positioned.fill(child: ColoredBox(color: Color(0xFFEBEBEB))),

          // SVG
          Positioned(
            left: 0,
            right: 0,
            bottom: 0,
            child: SizedBox(
              height: bottomSvgHeight,
              child: SvgPicture.asset(
                'assets/statistics.svg',
                fit: BoxFit.cover,
                alignment: Alignment.bottomCenter,
              ),
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
                            color: StatisticsPage.dark,
                            height: 1.05,
                          ),
                        ),
                      ),
                      _MonthDropdown(label: "Last month", onTap: () {}),
                    ],
                  ),

                  const SizedBox(height: 14),

                  // Chips row (✅ now clickable)
                  SizedBox(
                    height: 46,
                    child: ListView(
                      scrollDirection: Axis.horizontal,
                      children: [
                        _AppChip(
                          label: "Overview",
                          selected: _chipIndex == 0,
                          icon: Icons.bar_chart_rounded,
                          onTap: () => setState(() => _chipIndex = 0),
                        ),
                        const SizedBox(width: 10),
                        _AppChip(
                          label: "instagram",
                          selected: _chipIndex == 1,
                          icon: Icons.camera_alt_outlined,
                          onTap: () => setState(() => _chipIndex = 1),
                        ),
                        const SizedBox(width: 10),
                        _AppChip(
                          label: "Facebook",
                          selected: _chipIndex == 2,
                          icon: Icons.facebook,
                          onTap: () => setState(() => _chipIndex = 2),
                        ),
                        const SizedBox(width: 10),
                        _AppChip(
                          label: "TikTok",
                          selected: _chipIndex == 3,
                          icon: Icons.music_note_outlined,
                          onTap: () => setState(() => _chipIndex = 3),
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
            const Icon(Icons.keyboard_arrow_down_rounded,
                size: 18, color: Color(0xFF2E2E2E)),
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
  final VoidCallback onTap;

  const _AppChip({
    required this.label,
    required this.selected,
    required this.icon,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final bg = selected ? StatisticsPage.selectedGreen : Color(0xFFEBEBEB);
    final fg = selected ? Color(0xFFEBEBEB) : const Color(0xFF2B2B2B);
    final border = selected ? Colors.transparent : const Color(0x22000000);

    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(16),
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

    final double cardHeight = (w * 0.45).clamp(165, 190).toDouble();

    return Container(
      height: cardHeight,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: const Color(0xFFEBEBEB),
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
                color: StatisticsPage.dark,
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
                color: StatisticsPage.dark,
              ),
            ),
          ),
          Align(
            alignment: Alignment.bottomRight,
            child: Icon(icon, size: 22, color: StatisticsPage.dark),
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
        color: const Color(0xFFEBEBEB),
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
              color: StatisticsPage.dark,
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
          SizedBox(height: (w * 0.1).clamp(28, 36).toDouble()),
          SizedBox(
            height: (w * 0.3).clamp(100, 120).toDouble(),
            child: Padding(
              padding: EdgeInsets.only(top: (w * 0.06).clamp(16, 22).toDouble()),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: List.generate(12, (i) {
                  final heights = List.filled(12, 10);
                  return Expanded(
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 3),
                      child: Align(
                        alignment: Alignment.bottomCenter,
                        child: Container(
                          height: heights[i].toDouble(),
                          decoration: BoxDecoration(
                            color: const Color(0xFF222222),
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
