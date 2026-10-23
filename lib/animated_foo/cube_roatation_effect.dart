//lets create a cube with a 360 effect
import 'package:flutter/material.dart';
import 'dart:math';
import 'package:vector_math/vector_math_64.dart' show Vector3;

class CubicMaster extends StatefulWidget {
  const CubicMaster({super.key});

  @override
  State<CubicMaster> createState() => _CubicMasterState();
}

late AnimationController _xController;
late AnimationController _yController;
late AnimationController _zController;

class _CubicMasterState extends State<CubicMaster>
    with TickerProviderStateMixin {
  @override
  void initState() {
    super.initState();
    _xController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 20),
    )..repeat();
    _yController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 30),
    )..repeat();
    _zController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 40),
    )..repeat();
  }

  @override
  void dispose() {
    _xController.dispose();
    _yController.dispose();
    _zController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    const double cubeSize = 100.0;

    return Scaffold(
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            SizedBox(height: cubeSize, width: double.infinity),
            AnimatedBuilder(
              animation: Listenable.merge([
                _xController,
                _yController,
                _zController,
              ]),
              builder: (context, child) {
                return Transform(
                  alignment: Alignment.center,
                  transform: Matrix4.identity()
                    ..rotateX(_xController.value * 2 * pi)
                    ..rotateY(_yController.value * 2 * pi)
                    ..rotateZ(_zController.value * 2 * pi),
                  child: child,
                );
              },
              child: Stack(
                children: [
                  //back side
                  Transform(
                    alignment: Alignment.center,
                    transform: Matrix4.identity()
                      ..translateByVector3(Vector3(0, 0, -100)),
                    child: Container(
                      color: Colors.green,
                      width: cubeSize,
                      height: cubeSize,
                    ),
                  ),

                  //front side
                  Container(
                    color: Colors.blue,
                    width: cubeSize,
                    height: cubeSize,
                  ),

                  //left side
                  Transform(
                    alignment: Alignment.centerLeft,
                    transform: Matrix4.identity()..rotateY(pi / 2),
                    child: Container(
                      color: Colors.purple,
                      width: cubeSize,
                      height: cubeSize,
                    ),
                  ),

                  // right side
                  Transform(
                    alignment: Alignment.centerRight,
                    transform: Matrix4.identity()..rotateY(-pi / 2),
                    child: Container(
                      color: Colors.yellow,
                      width: cubeSize,
                      height: cubeSize,
                    ),
                  ),

                  // bottom side
                  Transform(
                    alignment: Alignment.bottomCenter,
                    transform: Matrix4.identity()..rotateX(pi / 2),
                    child: Container(
                      color: Colors.pink,
                      width: cubeSize,
                      height: cubeSize,
                    ),
                  ),

                  // ontop side
                  Transform(
                    alignment: Alignment.topCenter,
                    transform: Matrix4.identity()..rotateX(-pi / 2),
                    child: Container(
                      color: Colors.indigo,
                      width: cubeSize,
                      height: cubeSize,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
