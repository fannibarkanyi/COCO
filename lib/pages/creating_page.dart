import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class CreatingPage extends StatelessWidget {
  const CreatingPage({super.key});

  static const _iconColor = Color(0xFF2B2B2B);
  static const _pageBg = Color(0xFFF3F3F3);
  static const _greenBox = Color(0xFFAFC9AB);

  // If your header svg is the same style as Profile:
  // (adjust if your asset has a different ratio)
  static const double _topAspect = 393 / 174;

  void _showMediaOptions(BuildContext context) {
    showModalBottomSheet(
      context: context,
      showDragHandle: true,
      backgroundColor: Colors.white,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(18)),
      ),
      builder: (_) {
        return SafeArea(
          child: Padding(
            padding: const EdgeInsets.fromLTRB(16, 8, 16, 16),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                ListTile(
                  leading: const Icon(Icons.upload_file, color: _iconColor),
                  title: const Text(
                    "Upload from device",
                    style: TextStyle(
                      fontWeight: FontWeight.w600,
                      color: _iconColor,
                    ),
                  ),
                  onTap: () => Navigator.pop(context),
                ),
                ListTile(
                  leading: const Icon(Icons.auto_awesome, color: _iconColor),
                  title: const Text(
                    "Generate with AI",
                    style: TextStyle(
                      fontWeight: FontWeight.w600,
                      color: _iconColor,
                    ),
                  ),
                  onTap: () => Navigator.pop(context),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.transparent,
      body: LayoutBuilder(
        builder: (context, constraints) {
          final w = constraints.maxWidth;
          final topSvgH = w / _topAspect;

          return Stack(
            children: [
              // background
              Positioned.fill(
                child: Container(color: _pageBg),
              ),

              // TOP SVG header (like your design)
              Positioned(
                top: 0,
                left: 0,
                right: 0,
                child: SizedBox(
                  height: topSvgH,
                  child: SvgPicture.asset(
                    'assets/posting_top.svg', // <-- use your actual asset name
                    fit: BoxFit.cover,
                    alignment: Alignment.topLeft,
                  ),
                ),
              ),

              SafeArea(
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(20, 16, 20, 18),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Title (matches screenshot)
                      const Text(
                        "Posting",
                        style: TextStyle(
                          fontSize: 28,
                          fontWeight: FontWeight.w800,
                          color: _iconColor,
                          fontFamily: "Inter",
                        ),
                      ),

                      const SizedBox(height: 18),

                      // Green media box (tap to show options)
                      Expanded(
                        child: Center(
                          child: AspectRatio(
                            aspectRatio: 1, // makes it square-ish like the mock
                            child: InkWell(
                              onTap: () => _showMediaOptions(context),
                              borderRadius: BorderRadius.circular(16),
                              child: Container(
                                decoration: BoxDecoration(
                                  color: _greenBox,
                                  borderRadius: BorderRadius.circular(16),
                                  border: Border.all(
                                    color: _iconColor,
                                    width: 2,
                                    style: BorderStyle.solid,
                                  ),
                                ),
                                child: CustomPaint(
                                  painter: _DashedBorderPainter(
                                    color: _iconColor.withOpacity(0.6),
                                    radius: 16,
                                    strokeWidth: 2,
                                    dashLength: 8,
                                    gapLength: 6,
                                  ),
                                  child: Center(
                                    child: Column(
                                      mainAxisSize: MainAxisSize.min,
                                      children: const [
                                        Icon(Icons.add_photo_alternate_outlined,
                                            size: 70, color: _iconColor),
                                        SizedBox(height: 10),
                                        Text(
                                          "Add media or generate with AI",
                                          style: TextStyle(
                                            fontSize: 12,
                                            fontWeight: FontWeight.w600,
                                            color: _iconColor,
                                            fontFamily: "Inter",
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),

                      const SizedBox(height: 18),

                      // Bottom buttons: Skip / Next
                      Row(
                        children: [
                          Expanded(
                            child: OutlinedButton(
                              onPressed: () {},
                              style: OutlinedButton.styleFrom(
                                foregroundColor: _iconColor,
                                side: const BorderSide(color: _iconColor, width: 1.2),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(10),
                                ),
                                padding: const EdgeInsets.symmetric(vertical: 12),
                              ),
                              child: const Text(
                                "Skip",
                                style: TextStyle(
                                  fontWeight: FontWeight.w700,
                                  fontFamily: "Inter",
                                ),
                              ),
                            ),
                          ),
                          const SizedBox(width: 16),
                          Expanded(
                            child: ElevatedButton(
                              onPressed: () {},
                              style: ElevatedButton.styleFrom(
                                backgroundColor: _iconColor,
                                foregroundColor: Colors.white,
                                elevation: 0,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(10),
                                ),
                                padding: const EdgeInsets.symmetric(vertical: 12),
                              ),
                              child: const Text(
                                "Next",
                                style: TextStyle(
                                  fontWeight: FontWeight.w700,
                                  fontFamily: "Inter",
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
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

/// Draws a dashed rounded-rect border on top of the container.
/// (We keep your solid border so it looks crisp; dashed sits inside it.)
class _DashedBorderPainter extends CustomPainter {
  final Color color;
  final double radius;
  final double strokeWidth;
  final double dashLength;
  final double gapLength;

  _DashedBorderPainter({
    required this.color,
    required this.radius,
    required this.strokeWidth,
    required this.dashLength,
    required this.gapLength,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final rrect = RRect.fromRectAndRadius(
      Rect.fromLTWH(0, 0, size.width, size.height),
      Radius.circular(radius),
    );

    final paint = Paint()
      ..color = color
      ..style = PaintingStyle.stroke
      ..strokeWidth = strokeWidth;

    final path = Path()..addRRect(rrect);

    for (final metric in path.computeMetrics()) {
      double distance = 0;
      while (distance < metric.length) {
        final len = dashLength;
        final next = distance + len;
        canvas.drawPath(
          metric.extractPath(distance, next.clamp(0, metric.length)),
          paint,
        );
        distance = next + gapLength;
      }
    }
  }

  @override
  bool shouldRepaint(covariant _DashedBorderPainter oldDelegate) {
    return oldDelegate.color != color ||
        oldDelegate.radius != radius ||
        oldDelegate.strokeWidth != strokeWidth ||
        oldDelegate.dashLength != dashLength ||
        oldDelegate.gapLength != gapLength;
  }
}
