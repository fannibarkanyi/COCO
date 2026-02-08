import 'dart:math' as math;
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

import '../widgets/bottom_nav.dart';
import 'app_shell.dart';
import 'post_details.dart';
import 'dart:io';
import 'package:image_picker/image_picker.dart';

class CreatingPage extends StatefulWidget {
  const CreatingPage({super.key});

  @override
  State<CreatingPage> createState() => _CreatingPageState();
}

class _CreatingPageState extends State<CreatingPage> {
  static const dark = Color(0xFF2B2B2B);
  // ignore: unused_field
  static const bg = Color(0xFFEBEBEB);

  bool hasUploadedPhoto = false;
  final ImagePicker _picker = ImagePicker();
File? _selectedImage;

Future<void> _pickFromGallery() async {
  try {
    final XFile? file = await _picker.pickImage(
      source: ImageSource.gallery,
      imageQuality: 85,
    );

    if (!mounted) return;

    if (file == null) {
      // user cancelled
      return;
    }

    setState(() {
      _selectedImage = File(file.path);
      hasUploadedPhoto = true;
    });
  } catch (e) {
    if (!mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text("Couldn’t open gallery: $e")),
    );
  }
}

  void _showMediaOptions(BuildContext context) {
    showModalBottomSheet(
      context: context,
      showDragHandle: true,
      backgroundColor: bg,
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
                  leading: const Icon(Icons.upload_file, color: dark),
                  title: const Text(
                    "Upload from device",
                    style: TextStyle(
                      fontWeight: FontWeight.w600,
                      color: dark,
                      fontFamily: "Inter",
                    ),
                  ),
                  onTap: () async {
  Navigator.pop(context);      // close the sheet first
  await _pickFromGallery();    // open picker
},
                ),
                ListTile(
                  leading: const Icon(Icons.auto_awesome, color: dark),
                  title: const Text(
                    "Generate with AI",
                    style: TextStyle(
                      fontWeight: FontWeight.w600,
                      color: dark,
                      fontFamily: "Inter",
                    ),
                  ),
                  onTap: () {
                    // not counting as “uploaded photo” per your requirement
                    Navigator.pop(context);
                  },
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  void _goToTab(BuildContext context, int index) {
    Navigator.pushAndRemoveUntil(
      context,
      MaterialPageRoute(builder: (_) => AppShell(initialIndex: index)),
      (route) => false,
    );
  }

  void _goToPostDetails() {
  Navigator.push(
    context,
    MaterialPageRoute(
      builder: (_) => PostDetailsPage(
        imagePath: _selectedImage?.path ?? "",
      ),
    ),
  );
}

  void _onNext() {
    if (!hasUploadedPhoto) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("Please upload a photo before continuing."),
        ),
      );
      return;
    }
    _goToPostDetails();
  }

  @override
  Widget build(BuildContext context) {
    final media = MediaQuery.of(context);
    final w = media.size.width;

    final topSvgHeight = w * 0.38;

    return Scaffold(
      extendBody: true,
      backgroundColor: Colors.transparent,
      bottomNavigationBar: BottomNav(
        currentIndex: 0,
        onTap: (i) => _goToTab(context, i),
      ),
      body: LayoutBuilder(
        builder: (context, constraints) {
          return Stack(
            children: [
              Positioned.fill(
                child: Container(color: bg),
              ),

              // TOP SVG
              Positioned(
                top: 0,
                left: 0,
                right: 0,
                child: SizedBox(
                  height: topSvgHeight,
                  child: SvgPicture.asset(
                    'assets/posting1_top.svg',
                    fit: BoxFit.fitWidth,
                    alignment: Alignment.topLeft,
                  ),
                ),
              ),

              SafeArea(
                child: Padding(
                  padding: const EdgeInsets.only(bottom: 12),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // HEADER
                      Padding(
                        padding: const EdgeInsets.fromLTRB(16, 24, 24, 0),
                        child: Row(
                          children: [
                            InkWell(
                              borderRadius: BorderRadius.circular(20),
                              onTap: () => Navigator.pop(context),
                              child: const Padding(
                                padding: EdgeInsets.all(1),
                                child: Icon(
                                  Icons.chevron_left,
                                  size: 35,
                                  color: dark,
                                ),
                              ),
                            ),
                            const SizedBox(width: 10),
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
                      ),

                      const SizedBox(height: 14),

                      // GREEN MEDIA BOX
                      Expanded(
                        child: LayoutBuilder(
                          builder: (context, boxConstraints) {
                            final availableH = boxConstraints.maxHeight;

                            final boxW = math.min(w * 0.86, 340.0);

                            final desiredH = availableH * 0.78;
                            final boxH = math.min(desiredH, 520.0);

                            return Center(
                              child: SizedBox(
                                width: boxW,
                                height: boxH,
                                child: InkWell(
                                  onTap: () => _showMediaOptions(context),
                                  borderRadius: BorderRadius.circular(18),
                                  child: Container(
                                    decoration: BoxDecoration(
                                      color: const Color(0xFFA5C5A0),
                                      borderRadius: BorderRadius.circular(18),
                                      boxShadow: [
                                        // BoxShadow(
                                        //   color: const Color.fromRGBO(43, 43, 43, 1),
                                        //   blurRadius: 10,
                                        //   offset: const Offset(0, 6),
                                        // ),
                                      ],
                                    ),
                                    child: ClipRRect(
                                      borderRadius: BorderRadius.circular(18),
                                      child: Stack(
                                        fit: StackFit.expand,
                                        children: [
                                          // ✅ image preview
                                          if (_selectedImage != null)
                                            Image.file(
                                              _selectedImage!,
                                              fit: BoxFit.cover,
                                            ),

                                          // ✅ dashed border + overlay content
                                          CustomPaint(
                                            painter: _DashedBorderPainter(
                                              color: dark,
                                              radius: 18,
                                              strokeWidth: 2,
                                              dashLength: 8,
                                              gapLength: 6,
                                            ),
                                            child: Center(
                                              child: Column(
                                                mainAxisSize: MainAxisSize.min,
                                                children: [
                                                  Icon(
                                                    _selectedImage == null
                                                        ? Icons.add_photo_alternate_outlined
                                                        : Icons.check_circle_outline,
                                                    size: 78,
                                                    color: dark,
                                                  ),
                                                  const SizedBox(height: 10),
                                                  Text(
                                                    _selectedImage == null
                                                        ? "Add media or generate with AI"
                                                        : "Photo added ✓",
                                                    style: const TextStyle(
                                                      fontSize: 12,
                                                      fontWeight: FontWeight.w600,
                                                      color: dark,
                                                      fontFamily: "Inter",
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            );
                          },
                        ),
                      ),

                      const SizedBox(height: 14),

                      // Buttons
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 24),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            SizedBox(
                              width: 108,
                              child: OutlinedButton(
                                onPressed: _goToPostDetails, // ✅ Skip always works
                                style: OutlinedButton.styleFrom(
                                  foregroundColor: dark,
                                  side: const BorderSide(color: dark, width: 1.2),
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(10),
                                  ),
                                  padding: const EdgeInsets.symmetric(vertical: 12),
                                ),
                                child: const Text(
                                  "Skip",
                                  style: TextStyle(
                                    fontSize: 14,
                                    fontWeight: FontWeight.w700,
                                    fontFamily: "Inter",
                                  ),
                                ),
                              ),
                            ),
                            const SizedBox(width: 60),
                            SizedBox(
                              width: 108,
                              child: ElevatedButton(
                                onPressed: hasUploadedPhoto ? _onNext : null, // ✅ gated
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: dark,
                                  foregroundColor: bg,
                                  disabledBackgroundColor:
                                      const Color.fromRGBO(43, 43, 43, 0.35),
                                  disabledForegroundColor:
                                      const Color.fromRGBO(235, 235, 235, 0.8),
                                  elevation: 0,
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(10),
                                  ),
                                  padding: const EdgeInsets.symmetric(vertical: 12),
                                ),
                                child: const Text(
                                  "Next",
                                  style: TextStyle(
                                    fontSize: 14,
                                    fontWeight: FontWeight.w700,
                                    fontFamily: "Inter",
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),

                      const SizedBox(height: 20),
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

/// Dashed rounded-rect border painter
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
        final next = distance + dashLength;
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
