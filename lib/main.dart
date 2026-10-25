import 'package:flutter/material.dart';

import 'package:animation_project_1/tween_animated_foo/circle_color_animation.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData.dark(),
      home: const CircleColorAnimation(),
      debugShowCheckedModeBanner: false,
    );
  }
}
