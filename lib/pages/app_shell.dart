import 'package:flutter/material.dart';

import 'home_page.dart';
import 'profile_page.dart';
import 'statistics_page.dart';
import 'activity_page.dart';
import '../widgets/bottom_nav.dart';

class AppShell extends StatefulWidget {
  final int initialIndex;
  const AppShell({super.key, this.initialIndex = 0});

  @override
  State<AppShell> createState() => _AppShellState();
}

class _AppShellState extends State<AppShell> {
  late int index;

  final List<Widget> pages = const [
    HomePage(),
    StatisticsPage(),
    Placeholder(),
    ProfilePage(),
  ];

  @override
  void initState() {
    super.initState();
    index = widget.initialIndex;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBody: true,
      body: pages[index],
      bottomNavigationBar: BottomNav(
        currentIndex: index,
        onTap: (i) => setState(() => index = i),
      ),
    );
  }
}
