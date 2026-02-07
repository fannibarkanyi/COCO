// ignore_for_file: deprecated_member_use

import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

import '../widgets/bottom_nav.dart';
import 'app_shell.dart';

class PostPreviewChoosePage extends StatefulWidget {
  const PostPreviewChoosePage({
    super.key,
    required this.imagePath, // can be '' for now if you’re not passing it yet
    required this.caption,
    required this.description,
    required this.location,
    required this.music,
  });

  final String imagePath;
  final String caption;
  final String description;
  final String location;
  final String music;

  @override
  State<PostPreviewChoosePage> createState() => _PostPreviewChoosePageState();
}

class _PostPreviewChoosePageState extends State<PostPreviewChoosePage> {
  static const _iconColor = Color(0xFF2B2B2B);
  static const _bg = Color(0xFFEBEBEB);

  // 0 = Story, 1 = Post, 2 = Blog
  int selected = 0;

  void _goToTab(int index) {
    Navigator.pushAndRemoveUntil(
      context,
      MaterialPageRoute(builder: (_) => AppShell(initialIndex: index)),
      (route) => false,
    );
  }

  String get _helperText {
    switch (selected) {
      case 0:
        return "Stories disappear after 24 hours, so they're ideal for quick\nand timely updates that are relevant today";
      case 1:
        return "Posts are permanent, making\nthem ideal for content that\nremains relevant over time";
      case 2:
      default:
        return "Blogs are long-form posts for\nsharing detailed ideas, stories,\nor updates that people can read\nanytime";
    }
  }

  // Placeholder “preview box” size depends on selected type
  Size _previewSize(double w, double h) {
    final cardW = (w * 0.55).clamp(210.0, 260.0);
    if (selected == 0) {
      // story: taller
      return Size(cardW, (h * 0.42).clamp(300.0, 420.0));
    }
    if (selected == 1) {
      // post: medium
      return Size(cardW, (h * 0.30).clamp(220.0, 320.0));
    }
    // blog: shorter, wider feel
    return Size(cardW, (h * 0.26).clamp(200.0, 280.0));
  }

  @override
  Widget build(BuildContext context) {
    final media = MediaQuery.of(context);
    final w = media.size.width;
    final h = media.size.height;

    // bottom svg size
    const double svgViewBoxW = 393;
    const double svgViewBoxH = 448;
    final double bottomSvgHeight = w * (svgViewBoxH / svgViewBoxW);

    final preview = _previewSize(w, h);

    return Scaffold(
      extendBody: true,
      backgroundColor: Colors.transparent,
      bottomNavigationBar: BottomNav(
        currentIndex: 0,
        onTap: (i) => _goToTab(i),
      ),
      body: Stack(
        children: [
          Positioned.fill(child: Container(color: _bg)),

          // BOTTOM SVG
          Positioned(
                left: 0,
                right: 0,
                bottom: 0,
                child: SizedBox(
                  height: bottomSvgHeight,
                  child: SvgPicture.asset(
                    'assets/preview_bottom.svg',
                    fit: BoxFit.cover,
                    alignment: Alignment.bottomCenter,
                  ),
                ),
              ),

          SafeArea(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(18, 18, 18, 120),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Header
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
                            color: _iconColor,
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
                          color: _iconColor,
                        ),
                      ),
                    ],
                  ),

                  const SizedBox(height: 12),

                  // Segmented buttons: Story / Post / Blog
                  _SegmentedTabs(
                    selectedIndex: selected,
                    onChanged: (i) => setState(() => selected = i),
                  ),

                  const SizedBox(height: 16),

                  // Preview area
                  Expanded(
                    child: Center(
                      child: SizedBox(
                        width: preview.width,
                        height: preview.height,
                        child: _PreviewCardSkeleton(
                          mode: selected,
                          imagePath: widget.imagePath,
                          caption: widget.caption,
                          description: widget.description,
                        ),
                      ),
                    ),
                  ),

                  const SizedBox(height: 12),

                  // Helper text
                  Center(
                    child: Text(
                      _helperText,
                      textAlign: TextAlign.center,
                      style: const TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.w500,
                        fontFamily: "Inter",
                        color: _iconColor,
                        height: 1.3,
                      ),
                    ),
                  ),

                  const SizedBox(height: 16),

                  // Choose button
                  Center(
                    child: SizedBox(
                      width: 120,
                      height: 42,
                      child: ElevatedButton(
                        onPressed: () {
                          // skeleton: do nothing for now
                          // later: create the post in backend and navigate to success page
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: _iconColor,
                          foregroundColor: _bg,
                          elevation: 0,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                        child: const Text(
                          "Choose",
                          style: TextStyle(
                            fontSize: 13,
                            fontWeight: FontWeight.w800,
                            fontFamily: "Inter",
                          ),
                        ),
                      ),
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

class _SegmentedTabs extends StatelessWidget {
  const _SegmentedTabs({
    required this.selectedIndex,
    required this.onChanged,
  });

  final int selectedIndex;
  final ValueChanged<int> onChanged;

  static const _iconColor = Color(0xFF2B2B2B);

  @override
  Widget build(BuildContext context) {
    Widget chip(String label, int index) {
      final active = selectedIndex == index;
      return Expanded(
        child: InkWell(
          borderRadius: BorderRadius.circular(10),
          onTap: () => onChanged(index),
          child: Container(
            height: 34,
            alignment: Alignment.center,
            decoration: BoxDecoration(
              color: active ? _iconColor : Colors.transparent,
              borderRadius: BorderRadius.circular(10),
              border: Border.all(color: _iconColor, width: 1),
            ),
            child: Text(
              label,
              style: TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.w700,
                fontFamily: "Inter",
                color: active ? Colors.white : _iconColor,
              ),
            ),
          ),
        ),
      );
    }

    return Row(
      children: [
        chip("Story", 0),
        const SizedBox(width: 10),
        chip("Post", 1),
        const SizedBox(width: 10),
        chip("Blog", 2),
      ],
    );
  }
}

class _PreviewCardSkeleton extends StatelessWidget {
  const _PreviewCardSkeleton({
    required this.mode,
    required this.imagePath,
    required this.caption,
    required this.description,
  });

  final int mode;
  final String imagePath;
  final String caption;
  final String description;

  static const _iconColor = Color(0xFF2B2B2B);

  @override
  Widget build(BuildContext context) {
    // This is intentionally a “fake preview”.
    // Next step we can replace this with real layouts + image render.
    return Container(
      decoration: BoxDecoration(
        color: const Color(0xFFE6E6E6),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: _iconColor.withOpacity(0.25), width: 1),
      ),
      child: Padding(
        padding: const EdgeInsets.all(10),
        child: mode == 0
            ? _StoryPreviewSkeleton()
            : mode == 1
                ? _PostPreviewSkeleton()
                : _BlogPreviewSkeleton(),
      ),
    );
  }
}

class _StoryPreviewSkeleton extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        // “story top bar”
        Row(
          children: [
            const CircleAvatar(radius: 10, backgroundColor: Colors.white),
            const SizedBox(width: 8),
            Expanded(
              child: Container(height: 10, color: Colors.white.withOpacity(0.9)),
            ),
          ],
        ),
        const SizedBox(height: 10),
        Expanded(
          child: Container(
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.75),
              borderRadius: BorderRadius.circular(10),
            ),
          ),
        ),
        const SizedBox(height: 10),
        // “icons row”
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: List.generate(
            4,
            (_) => Container(width: 16, height: 16, color: Colors.white.withOpacity(0.9)),
          ),
        ),
      ],
    );
  }
}

class _PostPreviewSkeleton extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        // “header”
        Row(
          children: [
            const CircleAvatar(radius: 10, backgroundColor: Colors.white),
            const SizedBox(width: 8),
            Expanded(child: Container(height: 10, color: Colors.white.withOpacity(0.9))),
          ],
        ),
        const SizedBox(height: 10),
        Expanded(
          child: Container(
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.75),
              borderRadius: BorderRadius.circular(10),
            ),
          ),
        ),
        const SizedBox(height: 10),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Container(width: 60, height: 10, color: Colors.white.withOpacity(0.9)),
            Container(width: 16, height: 16, color: Colors.white.withOpacity(0.9)),
          ],
        ),
      ],
    );
  }
}

class _BlogPreviewSkeleton extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Expanded(
          child: Container(
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.75),
              borderRadius: BorderRadius.circular(10),
            ),
          ),
        ),
        const SizedBox(height: 10),
        Container(height: 10, width: double.infinity, color: Colors.white.withOpacity(0.9)),
        const SizedBox(height: 6),
        Container(height: 10, width: double.infinity, color: Colors.white.withOpacity(0.9)),
        const SizedBox(height: 6),
        Container(height: 10, width: double.infinity, color: Colors.white.withOpacity(0.9)),
      ],
    );
  }
}
