import 'package:flutter/material.dart';

class PrimaryButton extends StatelessWidget {
  final String text;
  final VoidCallback onPressed;
  final double width;
  final double height;
  final double fontSize;

  final Widget? trailing;
  final double gap;

  const PrimaryButton({
    super.key,
    required this.text,
    required this.onPressed,
    this.width = 220,
    this.height = 50,
    this.fontSize = 18,
    this.trailing,
    this.gap = 8,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: width,
      height: height,
      child: ElevatedButton(
        onPressed: onPressed,
        style: ElevatedButton.styleFrom(
          backgroundColor: const Color.fromRGBO(43, 43, 43, 1),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(15),
          ),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              text,
              textAlign: TextAlign.center,
              style: const TextStyle(
                color: Color.fromRGBO(235, 235, 235, 1),
                fontSize: 18,
                fontFamily: 'Inter',
                fontWeight: FontWeight.bold,
              ),
            ),
            if (trailing != null) ...[SizedBox(width: gap), trailing!],
          ],
        ),
      ),
    );
  }
}
