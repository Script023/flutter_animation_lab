// lets create a container of four different colours
import 'package:flutter/material.dart';
import 'dart:math';

class QuadrantRotate extends StatefulWidget {
  const QuadrantRotate({super.key});

  @override
  State<QuadrantRotate> createState() => _QuadrantRotateState();
}

class _QuadrantRotateState extends State<QuadrantRotate>
    with TickerProviderStateMixin {
  late AnimationController _animationController;
  late AnimationController _rotationAnimationController;
  late Animation<double> _animation;
  late Animation<double> _rotationAnimation;

  @override
  void initState() {
    super.initState();
    // create the animation controller

    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 2),
    );

    _rotationAnimationController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 2),
    );
    _animation = Tween<double>(begin: 0, end: -pi / 2).animate(
      CurvedAnimation(parent: _animationController, curve: Curves.bounceOut),
    );
    // create the rotation animation
    _rotationAnimation = Tween<double>(begin: 0, end: pi).animate(
      CurvedAnimation(
        parent: _rotationAnimationController,
        curve: Curves.elasticInOut,
      ),
    );
    _animationController
      ..reset()
      ..forward.delayed(const Duration(seconds: 2));
    // status listeners

    // status linear 1
    _animationController.addStatusListener((status) {
      if (status == AnimationStatus.completed) {
        _rotationAnimation =
            Tween<double>(
              begin: _rotationAnimation.value,
              end: _rotationAnimation.value + pi,
            ).animate(
              CurvedAnimation(
                parent: _rotationAnimationController,
                curve: Curves.elasticInOut,
              ),
            );
        _rotationAnimationController
          ..reset()
          ..forward();
      }
    });
    _rotationAnimationController.addStatusListener((status) {
      if (status == AnimationStatus.completed) {
        _animation =
            Tween<double>(
              begin: _animation.value,
              end: _animation.value - pi / 2,
            ).animate(
              CurvedAnimation(
                parent: _animationController,
                curve: Curves.bounceOut,
              ),
            );
        _animationController
          ..reset()
          ..forward();
      }
    });
  }

  // dispose the animation controller
  @override
  void dispose() {
    _animationController.dispose();
    _rotationAnimationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: SafeArea(
        child: Center(
          child: AnimatedBuilder(
            animation: _animationController,
            builder: (context, child) {
              return Transform(
                alignment: Alignment.center,
                transform: Matrix4.rotationZ(_animation.value),
                child: SizedBox(
                  width: 200,
                  height: 200,
                  child: Stack(
                    children: [
                      AnimatedBuilder(
                        animation: _rotationAnimation,
                        builder: (context, child) {
                          //left quadrant
                          return Transform(
                            alignment: Alignment.center,
                            transform: Matrix4.rotationY(
                              _rotationAnimation.value,
                            ),
                            child: ClipPath(
                              clipper: const QuadrantClipper(
                                quadrant: Quadrant.topLeft,
                              ),
                              child: Container(color: Colors.red),
                            ),
                          );
                        },
                      ),
                      AnimatedBuilder(
                        animation: _rotationAnimation,
                        builder: (context, child) {
                          // top right quadrant
                          return Transform(
                            alignment: Alignment.center,
                            transform: Matrix4.rotationY(
                              _rotationAnimation.value,
                            ),
                            child: ClipPath(
                              clipper: const QuadrantClipper(
                                quadrant: Quadrant.topRight,
                              ),
                              child: Container(color: Colors.green),
                            ),
                          );
                        },
                      ),
                      AnimatedBuilder(
                        animation: _rotationAnimation,
                        builder: (context, child) {
                          // bottom left quadrant
                          return Transform(
                            alignment: Alignment.center,
                            transform: Matrix4.rotationY(
                              _rotationAnimation.value,
                            ),
                            child: ClipPath(
                              clipper: const QuadrantClipper(
                                quadrant: Quadrant.bottomLeft,
                              ),
                              child: Container(color: Colors.blue),
                            ),
                          );
                        },
                      ),
                      AnimatedBuilder(
                        animation: _rotationAnimation,
                        builder: (context, child) {
                          // bottom right quadrant
                          return Transform(
                            alignment: Alignment.center,
                            transform: Matrix4.rotationY(
                              _rotationAnimation.value,
                            ),
                            child: ClipPath(
                              clipper: const QuadrantClipper(
                                quadrant: Quadrant.bottomRight,
                              ),
                              child: Container(color: Colors.yellow),
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
      ),
    );
  }
}

// draw something like a circle with four different colors in a quadrant way
// first create an enum for quadrants
enum Quadrant { topLeft, topRight, bottomLeft, bottomRight }

// create an extension method to convert the enum to a path
extension ToPath on Quadrant {
  Path toPath(Size size) {
    // create the path object
    final path = Path();
    final center = Offset(size.width / 2, size.height / 2);
    final radius = size.width / 2;
    final rect = Rect.fromCircle(center: center, radius: radius);
    double startAngle;

    // start angles (radians) for each quadrant
    path.moveTo(center.dx, center.dy);
    switch (this) {
      case Quadrant.topRight:
        startAngle = -pi / 2;
        break;
      case Quadrant.topLeft:
        startAngle = pi;
        break;
      case Quadrant.bottomLeft:
        startAngle = pi / 2;
        break;
      case Quadrant.bottomRight:
        startAngle = 0;
        break;
    }
    path.arcTo(rect, startAngle, pi / 2, false);
    path.close();
    return path;
  }
}

class QuadrantClipper extends CustomClipper<Path> {
  final Quadrant quadrant;
  const QuadrantClipper({required this.quadrant});

  @override
  Path getClip(Size size) {
    return quadrant.toPath(size);
  }

  @override
  bool shouldReclip(covariant CustomClipper<Path> oldClipper) {
    return oldClipper is! QuadrantClipper || oldClipper.quadrant != quadrant;
  }
}

extension on VoidCallback {
  Future<void> delayed(Duration duration) {
    return Future.delayed(duration, this);
  }
}
