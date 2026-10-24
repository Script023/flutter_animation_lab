import 'package:flutter/material.dart';
import 'package:animation_project_1/animated_foo/enlarge_animation_foo.dart';

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
      home: const EnlargeAnimationFoo(assetPath: 'assets/image/real_sun.png'),
      debugShowCheckedModeBanner: false,
    );
  }
}
