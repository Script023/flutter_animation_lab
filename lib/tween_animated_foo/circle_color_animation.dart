import 'package:flutter/material.dart';
import 'dart:math' as math;

class CircleColorAnimation extends StatefulWidget {
  const CircleColorAnimation({super.key});

  @override
  State<CircleColorAnimation> createState() => _CircleColorAnimationState();
}

class _CircleColorAnimationState extends State<CircleColorAnimation> {
  Color _getRandomColor() {
    return Color(0xFF000000 + math.Random().nextInt(0x00FFFFFF));
  }

  late var _color = _getRandomColor();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: SafeArea(
        child: SingleChildScrollView(
          child: Center(
            child: Column(
              children: [
                const SizedBox(height: 50),

                ClipPath(
                  clipper: const CircleClipper(),
                  child: TweenAnimationBuilder(
                    duration: const Duration(seconds: 3),
                    tween: ColorTween(begin: _getRandomColor(), end: _color),
                    builder: (context, Color? color, child) {
                      return ColorFiltered(
                        colorFilter: ColorFilter.mode(
                          color!,
                          BlendMode.srcATop,
                        ),
                        child: child,
                      );
                    },
                    curve: Curves.bounceInOut,
                    child: Container(
                      width: MediaQuery.of(context).size.width,
                      height: MediaQuery.of(context).size.height,
                      decoration: BoxDecoration(color: Colors.red),
                    ),
                    onEnd: () {
                      setState(() {
                        _color = _getRandomColor();
                      });
                    },
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class CircleClipper extends CustomClipper<Path> {
  const CircleClipper();
  @override
  Path getClip(Size size) {
    var path = Path();

    final rect = Rect.fromCircle(
      center: Offset(size.width / 2, size.height / 2),
      radius: size.width / 2,
    );

    path.addOval(rect);
    return path;
  }

  @override
  bool shouldReclip(covariant CircleClipper oldClipper) => false;
}
