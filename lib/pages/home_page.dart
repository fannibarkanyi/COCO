import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;

    const double svgViewBoxWidth = 393;
    const double svgViewBoxHeight = 194;

    final double svgHeight = screenWidth * (svgViewBoxHeight / svgViewBoxWidth);

    return Scaffold(
      backgroundColor: const Color.fromRGBO(235, 235, 235, 1),
      body: Stack(
        clipBehavior: Clip.none,
        children: [
          // TOP SVG
          Positioned(
            top: 0,
            left: 0,
            right: 0,
            child: SizedBox(
              height: svgHeight,
              child: SvgPicture.asset(
                'assets/circ2.svg',
                fit: BoxFit.fitWidth,
                alignment: Alignment.topLeft,
              ),
            ),
          ),

          // BOTTOM SVG (auto height)
          Positioned(
            bottom: -80, // tweak
            left: -220, // tweak (push off-screen so only the curve shows)
            child: SvgPicture.asset(
              'assets/circ_bottom.svg',
              width:
                  MediaQuery.of(context).size.width * 1.6, // bigger than screen
              fit: BoxFit.cover,
              alignment: Alignment.bottomLeft,
            ),
          ),

          // page content goes here
        ],
      ),
    );
  }
}
