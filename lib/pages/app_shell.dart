import 'package:flutter/material.dart';
import 'package:coco/pages/home_page.dart';
import 'package:coco/pages/profile_page.dart';
import 'package:coco/widgets/bottom_nav.dart';

class AppShell extends StatefulWidget {
  const AppShell({super.key});

  @override
  State<AppShell> createState() => _AppShellState();
}

class _AppShellState extends State<AppShell> {
  int index = 0;

  final pages = const [
    HomePage(),
    Placeholder(), // analytics / whatever
    Placeholder(), // chat / whatever
    ProfilePage(), // <- PROFILE TAB
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: pages[index],
      bottomNavigationBar: BottomNav(
        currentIndex: index,
        onTap: (i) => setState(() => index = i),
      ),
    );
  }
}
