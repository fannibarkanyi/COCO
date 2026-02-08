import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'dart:io';

class ActivityPage extends StatefulWidget {
  const ActivityPage({super.key});

  @override
  State<ActivityPage> createState() => _ActivityPageState();
}

class _ActivityPageState extends State<ActivityPage> {
  int _tabIndex = 0; // 0 = Posts, 1 = Blogs

  late final Widget _topSvg;
  late final Widget _bottomSvg;

  @override
void initState() {
  super.initState();

  _topSvg = SvgPicture.asset(
    'assets/activity_top.svg',
    fit: BoxFit.fitWidth,
    alignment: Alignment.topLeft,
  );

  _bottomSvg = SvgPicture.asset(
    'assets/activity_bottom.svg',
    fit: BoxFit.cover,
    alignment: Alignment.bottomCenter,
  );
}

  @override
  Widget build(BuildContext context) {
    final media = MediaQuery.of(context);
    final w = media.size.width;
    final h = media.size.height;
    
    // TOP SVG sizing
    const double svgViewBoxWidth = 393;
    const double svgViewBoxHeight = 143;
    final double topSvgHeight = w * (svgViewBoxHeight / svgViewBoxWidth);

    // BOTTOM SVG SIZING
    const double svgViewBoxW = 393;
    const double svgViewBoxH = 471;
    final double bottomSvgHeight = w * (svgViewBoxH / svgViewBoxW);

    double clamp(double v, double min, double max) => v.clamp(min, max);

    final horizontalPad = clamp(w * 0.06, 16, 28);
    final cardRadius = clamp(w * 0.05, 16, 24);

    final green = const Color(0xFF9BE28C);
    final bg = const Color(0xFFF4F4F4);
    final dark = const Color(0xFF2F2F2F);

    return Scaffold(
      backgroundColor: bg,
      body: SafeArea(
        child: Stack(
          children: [
            // Top SVG
            Positioned(
                top: 0,
                left: 0,
                right: 0,
                child: SizedBox(
                  height: topSvgHeight,
                  child: _topSvg,
                ),
              ),

            // Bottom SVG
            Positioned(
                left: 0,
                right: 0,
                bottom: 0,
                child: SizedBox(
                  height: bottomSvgHeight,
                  child: _bottomSvg,
                ),
              ),

            // Content
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(height: clamp(h * 0.012, 8, 14)),

                // Back + Title on the same row: "< Activity"
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: horizontalPad),
                  child: Row(
                    children: [
                      InkWell(
                        borderRadius: BorderRadius.circular(12),
                        onTap: () => Navigator.pop(context),
                        child: Padding(
                          padding: const EdgeInsets.all(4),
                          child: Icon(
                            Icons.chevron_left,
                            size: clamp(w * 0.085, 24, 30),
                            color: dark,
                          ),
                        ),
                      ),
                      SizedBox(width: clamp(w * 0.02, 8, 12)),
                      Text(
                        'Activity',
                        style: TextStyle(
                          fontSize: clamp(w * 0.09, 28, 40),
                          fontWeight: FontWeight.w800,
                          color: dark,
                        ),
                      ),
                    ],
                  ),
                ),

                // Push everything BELOW title down a bit (as you asked)
                SizedBox(height: clamp(h * 0.035, 20, 28)),

                Padding(
                  padding: EdgeInsets.symmetric(horizontal: horizontalPad),
                  child: Text(
                    'Your previous stories',
                    style: TextStyle(
                      fontSize: clamp(w * 0.04, 14, 18),
                      fontWeight: FontWeight.w700,
                      color: dark,
                    ),
                  ),
                ),

                SizedBox(height: clamp(h * 0.015, 10, 14)),

                // Stories row 
                SizedBox(
  height: clamp(h * 0.105, 72, 96),
  child: StreamBuilder<QuerySnapshot>(
    stream: FirebaseFirestore.instance
        .collection("activity")
        .where("type", isEqualTo: "story")
        .orderBy("createdAt", descending: true)
        .snapshots(),
    builder: (context, snap) {
      if (!snap.hasData) {
        return const SizedBox();
      }

      final docs = snap.data!.docs;
      if (docs.isEmpty) {
        // first start: empty
        return ListView.separated(
          padding: EdgeInsets.symmetric(horizontal: horizontalPad),
          scrollDirection: Axis.horizontal,
          itemCount: 4,
          separatorBuilder: (_, __) => SizedBox(width: clamp(w * 0.03, 10, 14)),
          itemBuilder: (context, i) {
            return _PlusPlaceholder(
              width: clamp(w * 0.18, 64, 82),
              height: clamp(h * 0.105, 72, 96),
              radius: clamp(w * 0.045, 14, 18),
            );
          },
        );
      }

      return ListView.separated(
        padding: EdgeInsets.symmetric(horizontal: horizontalPad),
        scrollDirection: Axis.horizontal,
        itemCount: docs.length,
        separatorBuilder: (_, __) => SizedBox(width: clamp(w * 0.03, 10, 14)),
        itemBuilder: (context, i) {
          final data = docs[i].data() as Map<String, dynamic>;
          final path = (data["imagePath"] ?? "") as String;

          return ClipRRect(
            borderRadius: BorderRadius.circular(clamp(w * 0.045, 14, 18)),
            child: Container(
              width: clamp(w * 0.18, 64, 82),
              height: clamp(h * 0.105, 72, 96),
              color: Colors.white,
              child: path.isEmpty
                  ? const Icon(Icons.image)
                  : Image.file(File(path), fit: BoxFit.cover),
            ),
          );
        },
      );
    },
  ),
),


                SizedBox(height: clamp(h * 0.02, 12, 18)),

                // Posts / Blogs switcher
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: horizontalPad),
                  child: _PostsBlogsSwitcher(
                    index: _tabIndex,
                    onChanged: (i) => setState(() => _tabIndex = i),
                    green: green,
                    dark: dark,
                  ),
                ),

                SizedBox(height: clamp(h * 0.015, 10, 14)),

                // Body changes based on tab (empty states only)
                Expanded(
  child: StreamBuilder<QuerySnapshot>(
    key: ValueKey(_tabIndex), // ✅ force clean rebuild when tab changes
    stream: FirebaseFirestore.instance
        .collection("activity")
        .where("type", isEqualTo: _tabIndex == 0 ? "post" : "blog")
        .orderBy("createdAt", descending: true)
        .snapshots(),
    builder: (context, snap) {
      if (snap.hasError) {
        return Center(
          child: Text(
            "Firestore error:\n${snap.error}",
            textAlign: TextAlign.center,
          ),
        );
      }

      if (!snap.hasData) {
        return const Center(child: CircularProgressIndicator());
      }

      final docs = snap.data!.docs;

      if (docs.isEmpty) {
        return _EmptyCard(
          horizontalPad: horizontalPad,
          radius: cardRadius,
          dark: dark,
          text: _tabIndex == 0 ? "No posts yet" : "No blogs posted yet!",
        );
      }

      return ListView.separated(
        padding: EdgeInsets.fromLTRB(
          horizontalPad,
          clamp(w * 0.02, 6, 10),
          horizontalPad,
          clamp(w * 0.12, 28, 44),
        ),
        itemCount: docs.length,
        separatorBuilder: (_, __) => const SizedBox(height: 12),
        itemBuilder: (context, i) {
          final data = docs[i].data() as Map<String, dynamic>;
          final caption = (data["caption"] ?? "") as String;
          // ignore: unused_local_variable
          final path = (data["imagePath"] ?? "") as String;
          final file = File(path);

          return Container(
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(cardRadius),
              border: Border.all(color: Colors.black12),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // header row (platform icon + caption)
                Padding(
                  padding: const EdgeInsets.fromLTRB(12, 10, 12, 8),
                  child: Row(
                    children: [
                      Icon(
                        _tabIndex == 0 ? Icons.facebook : Icons.article,
                        size: 18,
                        color: dark,
                      ),
                      const SizedBox(width: 10),
                      Expanded(
                        child: Text(
                          caption.isEmpty ? "(no caption)" : caption,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: TextStyle(fontWeight: FontWeight.w700, color: dark),
                        ),
                      ),
                      const Icon(Icons.more_horiz),
                    ],
                  ),
                ),

                // image
               AspectRatio(
  aspectRatio: 16 / 10,
  child: path.isEmpty || !file.existsSync()
      ? Container(color: const Color(0xFFEAEAEA))
      : ClipRRect(
          borderRadius: BorderRadius.only(
            bottomLeft: Radius.circular(cardRadius),
            bottomRight: Radius.circular(cardRadius),
          ),
          child: Image.file(
            file,
            fit: BoxFit.cover,

            // ✅ HUGE: prevents decoding full-size 12MP images every rebuild
            cacheWidth: (MediaQuery.of(context).size.width * 2).round(),
          ),
        ),
),
              ],
            ),
          );
        },
      );
    },
  ),
),


                // little breathing room at bottom
                SizedBox(height: clamp(h * 0.02, 10, 18)),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class _EmptyCard extends StatelessWidget {
  const _EmptyCard({
    // ignore: unused_element_parameter
    super.key,
    required this.horizontalPad,
    required this.radius,
    required this.dark,
    required this.text,
  });

  final double horizontalPad;
  final double radius;
  final Color dark;
  final String text;

  @override
  Widget build(BuildContext context) {
    final w = MediaQuery.of(context).size.width;
    double clamp(double v, double min, double max) => v.clamp(min, max);

    return Padding(
      padding: EdgeInsets.fromLTRB(
        horizontalPad,
        clamp(w * 0.02, 6, 10),
        horizontalPad,
        clamp(w * 0.10, 24, 36),
      ),
      child: Container(
        padding: EdgeInsets.all(clamp(w * 0.07, 18, 26)),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(radius),
          border: Border.all(color: Colors.black12),
        ),
        child: Center(
          child: Text(
            text,
            style: TextStyle(
              fontSize: clamp(w * 0.05, 16, 20),
              fontWeight: FontWeight.w700,
              color: dark,
            ),
            textAlign: TextAlign.center,
          ),
        ),
      ),
    );
  }
}

class _PlusPlaceholder extends StatelessWidget {
  const _PlusPlaceholder({
    this.width,
    this.height,
    required this.radius,
  });

  final double? width;
  final double? height;
  final double radius;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: width,
      height: height,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(radius),
        border: Border.all(color: Colors.black12),
      ),
      child: const Center(
        child: Icon(Icons.add, size: 30),
      ),
    );
  }
}

class _PostsBlogsSwitcher extends StatelessWidget {
  const _PostsBlogsSwitcher({
    required this.index,
    required this.onChanged,
    required this.green,
    required this.dark,
  });

  final int index;
  final ValueChanged<int> onChanged;
  final Color green;
  final Color dark;

  @override
  Widget build(BuildContext context) {
    final w = MediaQuery.of(context).size.width;
    double clamp(double v, double min, double max) => v.clamp(min, max);

    final barHeight = clamp(w * 0.02, 10, 14);
    final radius = barHeight;

    return Column(
      children: [
        Row(
          children: [
            Expanded(
              child: _TabTextButton(
                text: 'Posts',
                onTap: () => onChanged(0),
                dark: dark,
              ),
            ),
            Expanded(
              child: _TabTextButton(
                text: 'Blogs',
                onTap: () => onChanged(1),
                dark: dark,
              ),
            ),
          ],
        ),
        SizedBox(height: clamp(w * 0.02, 8, 10)),
        LayoutBuilder(
          builder: (context, c) {
            final fullW = c.maxWidth;
            final halfW = fullW / 2;

            return Container(
              height: barHeight,
              width: fullW,
              decoration: BoxDecoration(
                color: const Color(0xFFDCDCDC),
                borderRadius: BorderRadius.circular(radius),
              ),
              child: Stack(
                children: [
                  AnimatedPositioned(
                    duration: const Duration(milliseconds: 220),
                    curve: Curves.easeOut,
                    left: index == 0 ? 0 : halfW,
                    top: 0,
                    bottom: 0,
                    child: Container(
                      width: halfW,
                      decoration: BoxDecoration(
                        color: green,
                        borderRadius: BorderRadius.circular(radius),
                      ),
                    ),
                  ),
                ],
              ),
            );
          },
        ),
      ],
    );
  }
}

class _TabTextButton extends StatelessWidget {
  const _TabTextButton({
    required this.text,
    required this.onTap,
    required this.dark,
  });

  final String text;
  final VoidCallback onTap;
  final Color dark;

  @override
  Widget build(BuildContext context) {
    final w = MediaQuery.of(context).size.width;
    double clamp(double v, double min, double max) => v.clamp(min, max);

    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(14),
      child: Padding(
        padding: EdgeInsets.symmetric(vertical: clamp(w * 0.015, 6, 10)),
        child: Center(
          child: Text(
            text,
            style: TextStyle(
              fontSize: clamp(w * 0.05, 16, 20),
              fontWeight: FontWeight.w800,
              color: dark,
            ),
          ),
        ),
      ),
    );
  }
}