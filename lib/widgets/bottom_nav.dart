import 'package:flutter/material.dart';

class BottomNav extends StatelessWidget {
  final int currentIndex;
  final ValueChanged<int> onTap;

  const BottomNav({
    super.key,
    required this.currentIndex,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    const iconColor = Color.fromRGBO(43, 43, 43, 1);

    return Padding(
      padding: const EdgeInsets.fromLTRB(24, 0, 24, 18),
      child: Container(
        height: 64,
        decoration: BoxDecoration(
          color: Colors.transparent,
          borderRadius: BorderRadius.circular(22),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            _NavItem(
              icon: Icons.home_outlined,
              isActive: currentIndex == 0,
              onTap: () => onTap(0),
              iconColor: iconColor,
            ),
            _NavItem(
              icon: Icons.bar_chart_outlined,
              isActive: currentIndex == 1,
              onTap: () => onTap(1),
              iconColor: iconColor,
            ),
            _NavItem(
              icon: Icons.chat_bubble_outline,
              isActive: currentIndex == 2,
              onTap: () => onTap(2),
              iconColor: iconColor,
            ),
            _NavItem(
              icon: Icons.person_outline,
              isActive: currentIndex == 3,
              onTap: () => onTap(3),
              iconColor: iconColor,
            ),
          ],
        ),
      ),
    );
  }
}

class _NavItem extends StatelessWidget {
  final IconData icon;
  final bool isActive;
  final VoidCallback onTap;
  final Color iconColor;

  const _NavItem({
    required this.icon,
    required this.isActive,
    required this.onTap,
    required this.iconColor,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      borderRadius: BorderRadius.circular(18),
      onTap: onTap,
      child: SizedBox(
        width: 64,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, color: iconColor),
            const SizedBox(height: 6),
            AnimatedContainer(
              duration: const Duration(milliseconds: 150),
              width: 22,
              height: 3,
              decoration: BoxDecoration(
                color: isActive ? iconColor : Colors.transparent,
                borderRadius: BorderRadius.circular(99),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
