import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class HelpPage extends StatelessWidget {
  const HelpPage({super.key});

  @override
  Widget build(BuildContext context) {
    final m = MediaQuery.of(context);
    final w = m.size.width;
    final h = m.size.height;

    double clamp(double v, double min, double max) => v.clamp(min, max);

    // svg sizing
    const double svgViewBoxW = 393;
    const double svgViewBoxH = 662;
    final double bottomSvgHeight = w * (svgViewBoxH / svgViewBoxW);

    const bg = Color(0xFFEBEBEB);
    const dark = Color(0xFF2B2B2B);
    const card = Color.fromARGB(255, 203, 231, 198);

    final sidePad = clamp(w * 0.06, 18, 28);
    final bottomPad = clamp(h * 0.16, 110, 140);

    return Scaffold(
      backgroundColor: bg,
      body: Stack(
        children: [
          
          // SVG
          Positioned(
                left: 0,
                right: 0,
                bottom: 0,
                child: SizedBox(
                  height: bottomSvgHeight,
                  child: SvgPicture.asset(
                    'assets/help.svg',
                    fit: BoxFit.cover,
                    alignment: Alignment.bottomCenter,
                  ),
                ),
              ),

          SafeArea(
            child: SingleChildScrollView(
              padding: EdgeInsets.fromLTRB(sidePad, 14, sidePad, bottomPad),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Header row
                  Row(
                    children: [
                      InkWell(
                        borderRadius: BorderRadius.circular(12),
                        onTap: () => Navigator.pop(context),
                        child: const Padding(
                          padding: EdgeInsets.all(4),
                          child: Icon(Icons.chevron_left, size: 30, color: dark),
                        ),
                      ),
                      const SizedBox(width: 10),
                      Text(
                        "Help",
                        style: TextStyle(
                          fontSize: clamp(w * 0.09, 28, 40),
                          fontWeight: FontWeight.w900,
                          color: dark,
                        ),
                      ),
                    ],
                  ),

                  const SizedBox(height: 14),

                  Text(
                    "Quick ways to promote your business",
                    style: TextStyle(
                      fontSize: clamp(w * 0.045, 14, 18),
                      fontWeight: FontWeight.w800,
                      color: dark,
                    ),
                  ),

                  const SizedBox(height: 10),

                  _TipCard(
                    title: "1) Post consistently",
                    body:
                        "Aim for 3–5 posts per week. Reuse the same content across platforms—"
                        "a post can become a story, a short video, and a blog snippet.",
                  ),
                  const SizedBox(height: 10),

                  _TipCard(
                    title: "2) Tell people what to do (CTA)",
                    body:
                        "Add a clear call-to-action: “Book now”, “DM for pricing”, “Visit our website”. "
                        "If your post doesn’t ask for action, it won’t convert.",
                  ),
                  const SizedBox(height: 10),

                  _TipCard(
                    title: "3) Show proof",
                    body:
                        "Share testimonials, before/after, screenshots of reviews, and results. "
                        "People trust proof more than promises.",
                  ),
                  const SizedBox(height: 10),

                  _TipCard(
                    title: "4) Use local + niche hashtags",
                    body:
                        "Mix broad tags (#hairdresser) with local tags (#londonbusiness) and niche tags "
                        "(#bridalhairlondon). Keep it relevant.",
                  ),
                  const SizedBox(height: 10),

                  _TipCard(
                    title: "5) Engage for 10 minutes daily",
                    body:
                        "Comment on local accounts and reply to every message. Social platforms reward engagement, "
                        "and it builds trust fast.",
                  ),

                  const SizedBox(height: 16),

                  Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: card,
                      borderRadius: BorderRadius.circular(18),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: const [
                        Text(
                          "Simple 7-day starter plan",
                          style: TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.w900,
                            color: dark,
                          ),
                        ),
                        SizedBox(height: 8),
                        Text("Day 1: Introduce your business + what you offer"),
                        Text("Day 2: Show behind-the-scenes or your process"),
                        Text("Day 3: Share a customer result / testimonial"),
                        Text("Day 4: Post a tip related to your niche"),
                        Text("Day 5: Post a short video (or story) + CTA"),
                        Text("Day 6: Answer a FAQ (pricing, timing, delivery, etc.)"),
                        Text("Day 7: Offer a small promotion or limited deal"),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _TipCard extends StatelessWidget {
  const _TipCard({required this.title, required this.body});

  final String title;
  final String body;

  static const dark = Color(0xFF2B2B2B);
  static const card = Color(0xFFF3F3F3);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: card,
        borderRadius: BorderRadius.circular(18),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: const TextStyle(
              fontSize: 13,
              fontWeight: FontWeight.w900,
              color: dark,
            ),
          ),
          const SizedBox(height: 6),
          Text(
            body,
            style: const TextStyle(
              fontSize: 12.5,
              fontWeight: FontWeight.w600,
              color: dark,
              height: 1.25,
            ),
          ),
        ],
      ),
    );
  }
}
