import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'models/button.dart';
import 'package:coco/pages/app_shell.dart' as shell;


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
      backgroundColor: Color.fromRGBO(235, 235, 235, 1),
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
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      "Hello",
                      style: TextStyle(
                        fontSize: 90,
                        fontWeight: FontWeight.w600,
                        fontFamily: 'Inter',
                        color: Color.fromRGBO(43, 43, 43, 1),
                        height: 88 / 90,
                      ),
                    ),

                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 16,
                        vertical: 6,
                      ),
                      decoration: BoxDecoration(
                        color: Color.fromRGBO(235, 235, 235, 1),
                        borderRadius: BorderRadius.circular(15),
                      ),
                      child: const Text(
                        "Maria!",
                        style: TextStyle(
                          fontSize: 90,
                          fontWeight: FontWeight.w600,
                          fontFamily: 'Inter',
                          color: Color.fromRGBO(43, 43, 43, 1),
                          height: 88 / 90,
                        ),
                      ),
                    ),
                  ],
                ),

                const SizedBox(height: 50),
                Padding(
                  padding: const EdgeInsets.only(right: 20),
                  child: Align(
                    alignment: Alignment.centerRight,
                    child: const Text(
                      "Sign up in a few easy steps\nand let’s get your business\nbooming right away",
                      textAlign: TextAlign.left,
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w500,
                        fontFamily: 'Inter',
                        color: Color.fromRGBO(43, 43, 43, 1),
                        height: 20 / 18,
                      ),
                    ),
                  ),
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
                      onPressed: () {
                        Navigator.pushReplacement(
                          context,
                          MaterialPageRoute(
                            builder: (_) => shell.AppShell(),
                          ),
                        );
                      },
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
