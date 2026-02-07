import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

import 'creating_page.dart';
import 'activity_page.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    final w = MediaQuery.of(context).size.width;
    // ignore: unused_local_variable
    final h = MediaQuery.of(context).size.height;

    // TOP SVG sizing
    const double svgViewBoxWidth = 393;
    const double svgViewBoxHeight = 194;
    final double topSvgHeight = w * (svgViewBoxHeight / svgViewBoxWidth);

    // BOTTOM SVG SIZING
    const double svgViewBoxW = 393;
    const double svgViewBoxH = 364;
    final double bottomSvgHeight = w * (svgViewBoxH / svgViewBoxW);


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
              height: topSvgHeight,
              child: SvgPicture.asset(
                'assets/circ2.svg',
                fit: BoxFit.fitWidth,
                alignment: Alignment.topLeft,
              ),
            ),
          ),

          // BOTTOM GREEN SHAPE
          Positioned(
                left: 0,
                right: 0,
                bottom: 0,
                child: SizedBox(
                  height: bottomSvgHeight,
                  child: SvgPicture.asset(
                    'assets/circlehp.svg',
                    fit: BoxFit.cover,
                    alignment: Alignment.bottomCenter,
                  ),
                ),
              ),

          // CONTENT
          SafeArea(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // HEADER
                const Padding(
                  padding: EdgeInsets.fromLTRB(24, 24, 24, 0),
                  child: Column(
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

                const Spacer(),

                // BIG ACTION CARD (Create Post)
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 24),
                  child: Material(
                    color: Colors.transparent,
                    child: InkWell(
                      borderRadius: BorderRadius.circular(18),
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) => const CreatingPage(),
                          ),
                        );
                      },
                      child: Container(
                        width: double.infinity,
                        height: 120,
                        padding: const EdgeInsets.all(18),
                        decoration: BoxDecoration(
                          color: darkCard,
                          borderRadius: BorderRadius.circular(18),
                        ),
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    "Create a",
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 18,
                                      fontWeight: FontWeight.w600,
                                      fontFamily: "Inter",
                                    ),
                                  ),
                                  SizedBox(height: 2),
                                  Text(
                                    "Post",
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 38,
                                      fontWeight: FontWeight.w800,
                                      fontFamily: "Inter",
                                      height: 0.95,
                                    ),
                                  ),
                                  SizedBox(height: 6),
                                  Text(
                                    "post something for your page",
                                    style: TextStyle(
                                      color: Color.fromRGBO(220, 220, 220, 1),
                                      fontSize: 11,
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
                                color: const Color.fromRGBO(255, 255, 255, 0.18),
                                borderRadius: BorderRadius.circular(12),
                              ),
                              child: const Icon(
                                Icons.chevron_right,
                                color: Colors.white,
                                size: 22,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),

                const Spacer(),

                // SMALL CARDS
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 24),
                  child: Row(
                    children: [
                      // ✅ YOUR ACTIVITY CARD (ONLY place ActivityPage is opened)
                      Expanded(
                        child: Material(
                          color: Colors.transparent,
                          child: InkWell(
                            borderRadius: BorderRadius.circular(18),
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (_) => const ActivityPage(),
                                ),
                              );
                            },
                            child: const _SmallCard(
                              titleTop: "Your",
                              titleBig: "Activity",
                              subtitle: "see your\nprevious posts,\nstories, etc",
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(width: 14),

                      // HELP CARD (no navigation yet)
                      const Expanded(
                        child: _SmallCard(
                          titleTop: "Need",
                          titleBig: "Help?",
                          subtitle: "improve your\nwork with\ntutorials and\ncourses",
                        ),
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 24),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

/* ---------------- SMALL CARD ---------------- */

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
      height: 190,
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
