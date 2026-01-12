import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'models/button.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      debugShowCheckedModeBanner: false,
      home: OnboardingPage(),
    );
  }
}

class OnboardingPage extends StatelessWidget {
  const OnboardingPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Stack(
        clipBehavior: Clip.none,
        children: [
          // SVG BACKGROUND
          Positioned.fill(
            child: Align(
              alignment: Alignment.centerRight,
              child: Transform.translate(
                offset: const Offset(0, 0), // tweak 80..160
                child: SvgPicture.asset(
                  'assets/circle.svg',
                  width: 325,
                  fit: BoxFit.cover,
                  alignment: Alignment.centerLeft,
                ),
              ),
            ),
          ),

          // CONTENT
          Padding(
            padding: const EdgeInsets.all(24.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 100),
                const Text(
                  "Hello\nMaria!",
                  style: TextStyle(fontSize: 48, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 16),
                const Text(
                  "Sign up in a few easy steps\nand let’s get your business\nbooming right away",
                  style: TextStyle(fontSize: 16),
                ),
                const Spacer(),
                Align(
                  alignment: Alignment.bottomLeft,
                  child: Padding(
                    padding: const EdgeInsets.only(left: 20, bottom: 200),
                    child: PrimaryButton(
                      text: "Make the first step",
                      width: 272,
                      height: 61,
                      fontSize: 26,
                      trailing: Padding(
                        padding: const EdgeInsets.only(left: 10),
                        child: SvgPicture.asset(
                          'assets/arrow.svg',
                          width: 18,
                          height: 18,
                          colorFilter: const ColorFilter.mode(
                            Color.fromRGBO(235, 235, 235, 1),
                            BlendMode.srcIn,
                          ),
                        ),
                      ),
                      onPressed: () {},
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
