import 'package:flutter/material.dart';

class ActivityPage extends StatefulWidget {
  const ActivityPage({super.key});

  @override
  State<ActivityPage> createState() => _ActivityPageState();
}

class _ActivityPageState extends State<ActivityPage> {
  int _tabIndex = 0; // 0 = Posts, 1 = Blogs

  @override
  Widget build(BuildContext context) {
    final media = MediaQuery.of(context);
    final w = media.size.width;
    final h = media.size.height;

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
            // Top green curve
            Positioned(
              left: 0,
              right: 0,
              top: 0,
              child: SizedBox(
                height: clamp(h * 0.18, 120, 190),
                child: CustomPaint(
                  painter: _TopCurvePainter(color: green),
                ),
              ),
            ),

            // Bottom green curve
            Positioned(
              left: 0,
              right: 0,
              bottom: 0,
              child: SizedBox(
                height: clamp(h * 0.22, 150, 240),
                child: CustomPaint(
                  painter: _BottomCurvePainter(color: green),
                ),
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

                // Stories row (placeholders)
                SizedBox(
                  height: clamp(h * 0.105, 72, 96),
                  child: ListView.separated(
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
                  child: AnimatedSwitcher(
                    duration: const Duration(milliseconds: 250),
                    child: _tabIndex == 0
                        ? _EmptyCard(
                            key: const ValueKey('posts'),
                            horizontalPad: horizontalPad,
                            radius: cardRadius,
                            dark: dark,
                            text: 'No posts yet',
                          )
                        : _EmptyCard(
                            key: const ValueKey('blogs'),
                            horizontalPad: horizontalPad,
                            radius: cardRadius,
                            dark: dark,
                            text: 'No blogs posted yet!',
                          ),
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

class _TopCurvePainter extends CustomPainter {
  _TopCurvePainter({required this.color});
  final Color color;

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()..color = color;
    final path = Path()
      ..lineTo(0, size.height * 0.70)
      ..quadraticBezierTo(size.width * 0.65, size.height * 0.95, size.width, size.height * 0.55)
      ..lineTo(size.width, 0)
      ..close();
    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

class _BottomCurvePainter extends CustomPainter {
  _BottomCurvePainter({required this.color});
  final Color color;

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()..color = color;
    final path = Path()
      ..moveTo(0, size.height)
      ..lineTo(0, size.height * 0.35)
      ..quadraticBezierTo(size.width * 0.45, size.height * 0.10, size.width, size.height * 0.40)
      ..lineTo(size.width, size.height)
      ..close();
    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
