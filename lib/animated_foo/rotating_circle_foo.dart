import 'package:flutter/material.dart';
import 'dart:math';

class RotatingCircleFoo extends StatefulWidget {
  const RotatingCircleFoo({super.key});

  @override
  State<RotatingCircleFoo> createState() => _RotatingCircleFooState();
}

enum CircleSide { left, right }

extension ToPath on CircleSide {
  Path toPath(Size size) {
    final path = Path();

    switch (this) {
      case CircleSide.left:
        path.moveTo(size.width, 0);
        path.arcToPoint(
          Offset(size.width, size.height),
          radius: Radius.elliptical(size.width / 2, size.height / 2),
          clockwise: false,
        );
        path.close();
        break;
      case CircleSide.right:
        path.moveTo(0, 0);
        path.arcToPoint(
          Offset(0, size.height),
          radius: Radius.elliptical(size.width / 2, size.height / 2),
          clockwise: true,
        );
        path.close();
        break;
    }
    return path;
  }
}

extension on VoidCallback {
  Future<void> delayed(Duration duration) {
    return Future.delayed(duration, this);
  }
}

class _RotatingCircleFooState extends State<RotatingCircleFoo>
    with TickerProviderStateMixin {
  late AnimationController _counterClockwiseRotationController;
  late Animation<double> _counterClockwiseRotation;
  late AnimationController _flipcounterClockwiseRotationController;
  late Animation<double> _flipcounterClockwiseRotation;

  @override
  void initState() {
    super.initState();
    _counterClockwiseRotationController = AnimationController(
      duration: const Duration(seconds: 1),
      vsync: this,
    );
    _counterClockwiseRotation = Tween<double>(begin: 0, end: -pi / 2).animate(
      CurvedAnimation(
        parent: _counterClockwiseRotationController,
        curve: Curves.bounceOut,
      ),
    );
    _counterClockwiseRotationController
      ..reset()
      ..forward.delayed(const Duration(seconds: 1));

    _flipcounterClockwiseRotationController = AnimationController(
      duration: const Duration(seconds: 1),
      vsync: this,
    );
    _flipcounterClockwiseRotation = Tween<double>(begin: 0, end: pi).animate(
      CurvedAnimation(
        parent: _flipcounterClockwiseRotationController,
        curve: Curves.bounceOut,
      ),
    );

    //add a status listener to the _counterClockwiseRotationController
    _counterClockwiseRotationController.addStatusListener((status) {
      if (status == AnimationStatus.completed) {
        _flipcounterClockwiseRotation =
            Tween<double>(
              begin: _flipcounterClockwiseRotation.value,
              end: _flipcounterClockwiseRotation.value + pi,
            ).animate(
              CurvedAnimation(
                parent: _flipcounterClockwiseRotationController,
                curve: Curves.bounceOut,
              ),
            );
        //reset the flip animation controller
        _flipcounterClockwiseRotationController
          ..reset()
          ..forward();
      }
    });

    // add a status listener to the _flipcounterClockwiseRotationController
    _flipcounterClockwiseRotationController.addStatusListener((status) {
      if (status == AnimationStatus.completed) {
        _counterClockwiseRotation =
            Tween<double>(
              begin: _counterClockwiseRotation.value,
              end: _counterClockwiseRotation.value - pi / 2,
            ).animate(
              CurvedAnimation(
                parent: _counterClockwiseRotationController,
                curve: Curves.bounceOut,
              ),
            );
        // reset the counter clockwise rotation controller
        _counterClockwiseRotationController
          ..reset()
          ..forward();
      }
    });
  }

  @override
  void dispose() {
    _counterClockwiseRotationController.dispose();
    _flipcounterClockwiseRotationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: AnimatedBuilder(
          animation: _counterClockwiseRotationController,
          builder: (context, child) {
            return Transform(
              alignment: Alignment.center,
              transform: Matrix4.identity()
                ..rotateZ(_counterClockwiseRotation.value),
              child: SizedBox(
                width: 200,
                height: 100,
                child: Row(
                  children: [
                    AnimatedBuilder(
                      animation: _flipcounterClockwiseRotationController,
                      builder: (context, child) {
                        return Transform(
                          alignment: Alignment.centerRight,
                          transform: Matrix4.identity()
                            ..rotateY(_flipcounterClockwiseRotation.value),
                          child: ClipPath(
                            clipper: HalfCircleClipper(side: CircleSide.left),
                            child: Container(
                              width: 100,
                              height: 100,
                              decoration: BoxDecoration(color: Colors.blue),
                            ),
                          ),
                        );
                      },
                    ),

                    AnimatedBuilder(
                      animation: _flipcounterClockwiseRotationController,
                      builder: (context, child) {
                        return Transform(
                          alignment: Alignment.centerLeft,
                          transform: Matrix4.identity()
                            ..rotateY(_flipcounterClockwiseRotation.value),
                          child: ClipPath(
                            clipper: HalfCircleClipper(side: CircleSide.right),
                            child: Container(
                              width: 100,
                              height: 100,
                              decoration: BoxDecoration(color: Colors.yellow),
                            ),
                          ),
                        );
                      },
                    ),
                  ],
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}

class HalfCircleClipper extends CustomClipper<Path> {
  final CircleSide side;

  const HalfCircleClipper({required this.side});

  @override
  Path getClip(Size size) {
    return side.toPath(size);
  }

  @override
  bool shouldReclip(covariant CustomClipper<Path> oldClipper) {
    return oldClipper is! HalfCircleClipper || oldClipper.side != side;
  }
}
