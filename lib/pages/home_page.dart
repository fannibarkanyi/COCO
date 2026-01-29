import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;

    const double svgViewBoxWidth = 393;
    const double svgViewBoxHeight = 194;
    final double svgHeight = screenWidth * (svgViewBoxHeight / svgViewBoxWidth);

    const bg = Color.fromRGBO(235, 235, 235, 1);
    const darkCard = Color(0xFF2F2F2F);

    return Scaffold(
      backgroundColor: bg,
      body: Stack(
        children: [
          // TOP SVG
          Positioned(
            top: 0,
            left: 0,
            right: 0,
            child: SizedBox(
              height: svgHeight,
              child: SvgPicture.asset(
                'assets/circ2.svg',
                fit: BoxFit.fitWidth,
                alignment: Alignment.topLeft,
              ),
            ),
          ),

          // NEW: BOTTOM GREEN CIRCLE (HomePage)
          Positioned(
            left: 0,
            right: 300,
            bottom: 0, // change to -20 / -40 if you want it lower
            child: SvgPicture.asset(
              'assets/circlehp.svg',
              fit: BoxFit.fitWidth,
              alignment: Alignment.bottomCenter,
            ),
          ),

          // OPTIONAL: keep/remove your older bottom svg (remove if you don't need it)
          Positioned(
            bottom: -80,
            left: -220,
            child: SvgPicture.asset(
              'assets/circ_bottom.svg',
              width: screenWidth * 1.6,
              fit: BoxFit.cover,
              alignment: Alignment.bottomLeft,
            ),
          ),

          // CONTENT
          SafeArea(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // HEADER TEXT
                Padding(
                  padding: const EdgeInsets.fromLTRB(24, 24, 24, 0),
                  child: const Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "Home",
                        style: TextStyle(
                          fontSize: 36,
                          fontWeight: FontWeight.w700,
                          fontFamily: "Inter",
                          color: Color.fromRGBO(43, 43, 43, 1),
                        ),
                      ),
                      SizedBox(height: 6),
                      Text(
                        "Start growing your business today",
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w500,
                          fontFamily: "Inter",
                          color: Color.fromRGBO(43, 43, 43, 1),
                        ),
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 28),

                // BIG ACTION CARD
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 24),
                  child: Container(
                    height: 120,
                    padding: const EdgeInsets.all(18),
                    decoration: BoxDecoration(
                      color: darkCard,
                      borderRadius: BorderRadius.circular(18),
                    ),
                    child: Row(
                      children: [
                        // plus icon
                        Container(
                          width: 42,
                          height: 42,
                          decoration: BoxDecoration(
                            border: Border.all(color: Colors.white, width: 2),
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: const Center(
                            child: Text(
                              "+",
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 26,
                                fontWeight: FontWeight.w700,
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(width: 14),

                        const Expanded(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                "Create a\nPost",
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 26,
                                  fontWeight: FontWeight.w700,
                                  height: 1.0,
                                  fontFamily: "Inter",
                                ),
                              ),
                              SizedBox(height: 6),
                              Text(
                                "post something for your page",
                                style: TextStyle(
                                  color: Colors.white70,
                                  fontSize: 12,
                                  fontWeight: FontWeight.w500,
                                  fontFamily: "Inter",
                                ),
                              ),
                            ],
                          ),
                        ),

                        Container(
                          width: 34,
                          height: 34,
                          decoration: BoxDecoration(
                            color: Colors.white.withValues(alpha: 0.2),
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: const Icon(
                            Icons.chevron_right,
                            color: Colors.white,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),

                const Spacer(), // pushes the two cards down

                // TWO SMALL CARDS
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 24),
                  child: Row(
                    children: const [
                      Expanded(
                        child: _SmallCard(
                          titleTop: "Your",
                          titleBig: "Activity",
                          subtitle: "see your\nprevious posts,\nstories, etc",
                        ),
                      ),
                      SizedBox(width: 14),
                      Expanded(
                        child: _SmallCard(
                          titleTop: "Need",
                          titleBig: "Help?",
                          subtitle:
                              "improve your\nwork with\ntutorials and\ncourses",
                        ),
                      ),
                    ],
                  ),
                ),

                // Space so the cards don’t feel glued to the bottom nav from AppShell
                const SizedBox(height: 24),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _SmallCard extends StatelessWidget {
  final String titleTop;
  final String titleBig;
  final String subtitle;

  const _SmallCard({
    required this.titleTop,
    required this.titleBig,
    required this.subtitle,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      constraints: const BoxConstraints(minHeight: 170),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: const Color.fromRGBO(245, 245, 245, 1),
        borderRadius: BorderRadius.circular(18),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Align(
            alignment: Alignment.topRight,
            child: Container(
              width: 30,
              height: 30,
              decoration: BoxDecoration(
                color: const Color.fromRGBO(235, 235, 235, 1),
                borderRadius: BorderRadius.circular(12),
              ),
              child: const Icon(Icons.chevron_right, size: 20),
            ),
          ),
          const SizedBox(height: 6),
          Text(
            titleTop,
            style: const TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w600,
              fontFamily: "Inter",
            ),
          ),
          Text(
            titleBig,
            style: const TextStyle(
              fontSize: 26,
              fontWeight: FontWeight.w800,
              fontFamily: "Inter",
              height: 1.0,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            subtitle,
            style: const TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.w500,
              fontFamily: "Inter",
              height: 1.2,
            ),
          ),
        ],
      ),
    );
  }
}
