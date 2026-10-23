import 'package:flutter/material.dart';

class SunTweenAnimated extends StatefulWidget {
  const SunTweenAnimated({super.key});

  @override
  State<SunTweenAnimated> createState() => _SunTweenAnimatedState();
}

class _SunTweenAnimatedState extends State<SunTweenAnimated> {
  bool _isEclipse = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: SafeArea(
        child: Stack(
          children: [
            // Background image — full screen
            Positioned.fill(
              child: Image.asset(
                'assets/image/star_background.png',
                fit: BoxFit.cover,
              ),
            ),
            // Foreground content
            Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 35),
                    child: TweenAnimationBuilder<Color?>(
                      tween: ColorTween(
                        begin: Colors.red,
                        end: _isEclipse ? Colors.blue : Colors.transparent,
                      ),
                      duration: const Duration(seconds: 60),
                      curve: Curves.bounceInOut,
                      builder: (context, animatedColor, child) {
                        return ColorFiltered(
                          colorFilter: ColorFilter.mode(
                            animatedColor ?? Colors.transparent,
                            BlendMode.modulate,
                          ),
                          child: Image.asset(
                            'assets/image/real_sun.png',
                            width: 100,
                            height: 100,
                          ),
                        );
                      },
                    ),
                  ),
                  const SizedBox(height: 40),
                  ElevatedButton(
                    onPressed: () => setState(() => _isEclipse = !_isEclipse),
                    child: const Text('Transcend'),
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
