// ignore_for_file: deprecated_member_use

import 'dart:io';
import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

import '../widgets/bottom_nav.dart';
import 'app_shell.dart';

class PostPreviewChoosePage extends StatefulWidget {
  const PostPreviewChoosePage({
    super.key,
    required this.imagePath, // can be '' for now
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

  /// ✅ Max width like the mock
  double _previewWidth(double screenW) {
    return math.min(screenW * 0.72, 320.0);
  }

  /// ✅ Aspect ratios by mode
  /// Story: 9/16 (tall)
  /// Post: 4/5 (feed-ish)
  /// Blog: 3/4 (still tall, room for text)
  double get _previewAspect {
    if (selected == 0) return 9 / 16;
    if (selected == 1) return 4 / 5;
    return 3 / 4;
  }

 Widget _buildPreview() {
  const username = "User_Name";

  switch (selected) {
    case 0:
      return StoryPreview(
        username: username,
        imagePath: widget.imagePath,
        caption: widget.caption,
        location: widget.location,
        music: widget.music,
      );
    case 1:
      return PostPreview(
  username: username,
  imagePath: widget.imagePath,
  caption: widget.caption,
  description: widget.description,
  location: widget.location,
);
    default:
      return BlogPreview(
        username: username,
        imagePath: widget.imagePath,
        title: widget.caption,
        body: widget.description,
      );
  }
}


  @override
  Widget build(BuildContext context) {
    final media = MediaQuery.of(context);
    final w = media.size.width;

    // bottom svg size
    const double svgViewBoxW = 393;
    const double svgViewBoxH = 448;
    final double bottomSvgHeight = w * (svgViewBoxH / svgViewBoxW);

    final aspect = _previewAspect;

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

                  // Segmented buttons
                  _SegmentedTabs(
                    selectedIndex: selected,
                    onChanged: (i) => setState(() => selected = i),
                  ),

                  const SizedBox(height: 16),

                  // ✅ Preview area (ratio always preserved)
                  Expanded(
                    child: LayoutBuilder(
                      builder: (context, c) {
                        final maxW = _previewWidth(w);

                        // height = width / aspect  =>  width = height * aspect
                        final maxWFromHeight = c.maxHeight * aspect;
                        final cardW = math.min(maxW, maxWFromHeight);

                        return Center(
                          child: SizedBox(
                            width: cardW,
                            child: AspectRatio(
                              aspectRatio: aspect,
                              child: _buildPreview(),
                            ),
                          ),
                        );
                      },
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
                          // later: create post + go to activity page etc
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

/// ==============================
// STORY PREVIEW

class StoryPreview extends StatelessWidget {
  const StoryPreview({
    super.key,
    required this.username,
    required this.imagePath,
    required this.caption,
    required this.location,
    required this.music,
  });

  final String username;
  final String imagePath;
  final String caption;
  final String location;
  final String music;

  @override
  Widget build(BuildContext context) {
    final hasMusic = music.trim().isNotEmpty;

    return ClipRRect(
      borderRadius: BorderRadius.circular(14),
      child: Stack(
        children: [
          // image
          Positioned.fill(child: _PreviewImage(imagePath: imagePath)),

          // ✅ top bar: avatar + username + song under username
          Positioned(
            top: 10,
            left: 10,
            right: 10,
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const CircleAvatar(
                  radius: 14,
                  backgroundColor: Colors.white,
                  child: CircleAvatar(
                    radius: 13,
                    backgroundImage: AssetImage('assets/profile_pic.png'),
                  ),
                ),
                const SizedBox(width: 8),

                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        username,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: const TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.w700,
                          fontFamily: "Inter",
                          fontSize: 12,
                          shadows: [Shadow(blurRadius: 8, color: Colors.black54)],
                        ),
                      ),

                      if (hasMusic) ...[
                        const SizedBox(height: 2),
                        Row(
                          children: [
                            const Icon(Icons.music_note, size: 12, color: Colors.white),
                            const SizedBox(width: 4),
                            Expanded(
                              child: Text(
                                music,
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                                style: const TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.w600,
                                  fontFamily: "Inter",
                                  fontSize: 11,
                                  shadows: [Shadow(blurRadius: 8, color: Colors.black54)],
                                ),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ],
                  ),
                ),

                const SizedBox(width: 8),
                const Icon(Icons.more_horiz, color: Colors.white),
              ],
            ),
          ),

          // caption/details overlay
          Positioned(
            left: 14,
            right: 14,
            bottom: 70,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                if (caption.trim().isNotEmpty)
                  Text(
                    caption,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 16,
                      fontWeight: FontWeight.w800,
                      fontFamily: "Inter",
                      shadows: [Shadow(blurRadius: 10, color: Colors.black)],
                    ),
                  ),
                const SizedBox(height: 6),
                Row(
                  children: [
                    if (location.trim().isNotEmpty) ...[
                      const Icon(Icons.location_on, size: 14, color: Colors.white),
                      const SizedBox(width: 4),
                      Flexible(
                        child: Text(
                          location,
                          overflow: TextOverflow.ellipsis,
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 12,
                            fontWeight: FontWeight.w700,
                            fontFamily: "Inter",
                            shadows: [Shadow(blurRadius: 10, color: Colors.black)],
                          ),
                        ),
                      ),
                    ],
                    // (optional) keep the bottom row music if you still want it there:
                    // if (location.trim().isNotEmpty && music.trim().isNotEmpty)
                    //   const SizedBox(width: 10),
                    // if (music.trim().isNotEmpty) ...[
                    //   const Icon(Icons.music_note, size: 14, color: Colors.white),
                    //   const SizedBox(width: 4),
                    //   Flexible(
                    //     child: Text(
                    //       music,
                    //       overflow: TextOverflow.ellipsis,
                    //       style: const TextStyle(
                    //         color: Colors.white,
                    //         fontSize: 12,
                    //         fontWeight: FontWeight.w700,
                    //         fontFamily: "Inter",
                    //         shadows: [Shadow(blurRadius: 10, color: Colors.black)],
                    //       ),
                    //     ),
                    //   ),
                    // ],
                  ],
                ),
              ],
            ),
          ),

          // bottom bar
          Positioned(
            left: 12,
            right: 12,
            bottom: 12,
            child: Row(
              children: [
                Expanded(
                  child: Container(
                    height: 34,
                    padding: const EdgeInsets.symmetric(horizontal: 12),
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.18),
                      borderRadius: BorderRadius.circular(22),
                      border: Border.all(color: Colors.white.withOpacity(0.35)),
                    ),
                    alignment: Alignment.centerLeft,
                    child: Text(
                      "Send message",
                      style: TextStyle(
                        color: Colors.white.withOpacity(0.95),
                        fontSize: 12,
                        fontFamily: "Inter",
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 10),
                const Icon(Icons.favorite_border, color: Colors.white),
                const SizedBox(width: 10),
                const Icon(Icons.send, color: Colors.white),
              ],
            ),
          ),

          // readability gradient
          Positioned.fill(
            child: DecoratedBox(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [
                    Colors.black.withOpacity(0.25),
                    Colors.transparent,
                    Colors.black.withOpacity(0.35),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}



// POST PREVIEW

class PostPreview extends StatelessWidget {
  const PostPreview({
    super.key,
    required this.username,
    required this.imagePath,
    required this.caption,
    required this.description,
    required this.location,
  });

  final String username;
  final String imagePath;
  final String caption;
  final String description;
  final String location;

  static const _iconColor = Color(0xFF2B2B2B);

  @override
  Widget build(BuildContext context) {
    final hasLocation = location.trim().isNotEmpty;
    final hasDescription = description.trim().isNotEmpty;

    return ClipRRect(
      borderRadius: BorderRadius.circular(14),
      child: Container(
        color: const Color(0xFFF2F2F2),
        child: Column(
          children: [
            // Header row (avatar + username + optional location)
            Padding(
              padding: const EdgeInsets.fromLTRB(10, 10, 10, 8),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const CircleAvatar(
                    radius: 12,
                    backgroundImage: AssetImage('assets/profile_pic.png'),
                  ),
                  const SizedBox(width: 8),

                  // username + location stacked
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          username,
                          style: const TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.w800,
                            fontFamily: "Inter",
                            color: _iconColor,
                            height: 1.1,
                          ),
                        ),
                        if (hasLocation) ...[
                          const SizedBox(height: 2),
                          Text(
                            location,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: TextStyle(
                              fontSize: 10.5,
                              fontWeight: FontWeight.w600,
                              fontFamily: "Inter",
                              color: _iconColor.withOpacity(0.75),
                              height: 1.1,
                            ),
                          ),
                        ],
                      ],
                    ),
                  ),

                  const Icon(Icons.more_horiz, color: _iconColor),
                ],
              ),
            ),

            // Image
            Expanded(
              child: _PreviewImage(imagePath: imagePath),
            ),

            // Icons + caption + description
            Padding(
              padding: const EdgeInsets.fromLTRB(10, 8, 10, 10),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: const [
                      Icon(Icons.favorite_border, size: 18, color: _iconColor),
                      SizedBox(width: 10),
                      Icon(Icons.chat_bubble_outline, size: 18, color: _iconColor),
                      SizedBox(width: 10),
                      Icon(Icons.send, size: 18, color: _iconColor),
                      Spacer(),
                      Icon(Icons.bookmark_border, size: 18, color: _iconColor),
                    ],
                  ),
                  const SizedBox(height: 6),

                  Text(
                    caption.isEmpty ? "Your caption..." : caption,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(
                      fontSize: 11.5,
                      fontWeight: FontWeight.w700,
                      fontFamily: "Inter",
                      color: _iconColor,
                      height: 1.25,
                    ),
                  ),

                  if (hasDescription) ...[
                    const SizedBox(height: 4),
                    Text(
                      description,
                      maxLines: 3,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                        fontSize: 10.8,
                        fontWeight: FontWeight.w600,
                        fontFamily: "Inter",
                        color: _iconColor.withOpacity(0.85),
                        height: 1.25,
                      ),
                    ),
                  ],
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}


// BLOG PREVIEW

class BlogPreview extends StatelessWidget {
  const BlogPreview({
    super.key,
    required this.username,
    required this.imagePath,
    required this.title,
    required this.body,
  });

  final String username;
  final String imagePath;
  final String title;
  final String body;

  static const _iconColor = Color(0xFF2B2B2B);

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(14),
      child: Container(
        color: const Color(0xFFF2F2F2),
        child: Column(
          children: [
            // image header
            Expanded(
              flex: 4,
              child: _PreviewImage(imagePath: imagePath),
            ),

            // blog content
            Expanded(
              flex: 3,
              child: Padding(
                padding: const EdgeInsets.fromLTRB(10, 10, 10, 10),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title.isEmpty ? "Headline" : title,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.w800,
                        fontFamily: "Inter",
                        color: _iconColor,
                      ),
                    ),
                    const SizedBox(height: 6),
                    Expanded(
                      child: Text(
                        body.isEmpty ? "Your blog text..." : body,
                        maxLines: 6,
                        overflow: TextOverflow.ellipsis,
                        style: const TextStyle(
                          fontSize: 10.5,
                          fontWeight: FontWeight.w600,
                          fontFamily: "Inter",
                          color: _iconColor,
                          height: 1.25,
                        ),
                      ),
                    ),
                    const SizedBox(height: 6),
                    Row(
                      children: const [
                        Icon(Icons.favorite_border, size: 16, color: _iconColor),
                        SizedBox(width: 10),
                        Icon(Icons.chat_bubble_outline, size: 16, color: _iconColor),
                        Spacer(),
                        Icon(Icons.bookmark_border, size: 16, color: _iconColor),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

/// Shared image widget: shows placeholder if no image yet
class _PreviewImage extends StatelessWidget {
  const _PreviewImage({required this.imagePath});

  final String imagePath;

  @override
  Widget build(BuildContext context) {
    if (imagePath.isEmpty) {
      return Container(
        color: const Color(0xFFE0E0E0),
        child: const Center(
          child: Icon(Icons.image, size: 60, color: Color(0xFFB0B0B0)),
        ),
      );
    }

    // if you pass local file paths from image_picker
    final file = File(imagePath);
    return Image.file(
      file,
      fit: BoxFit.cover,
      errorBuilder: (_, __, ___) => Container(
        color: const Color(0xFFE0E0E0),
        child: const Center(
          child: Icon(Icons.broken_image, size: 50, color: Color(0xFFB0B0B0)),
        ),
      ),
    );
  }
}
