import 'package:flutter/material.dart';

class MyAnimatedContainer extends StatefulWidget {
  const MyAnimatedContainer({super.key});

  @override
  State<MyAnimatedContainer> createState() => _MyAnimatedContainerState();
}

// floating button
bool _isSunny = false;

class _MyAnimatedContainerState extends State<MyAnimatedContainer> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        backgroundColor: Colors.black,
        title: Text(
          'Sunny Days',
          style: TextStyle(color: Colors.white, fontWeight: FontWeight(500)),
        ),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const SizedBox(height: 45),
                AnimatedContainer(
                  duration:  Duration.zero,
                  curve: Curves.elasticOut,
                  width: _isSunny ? 300 : 200,
                  height: _isSunny ? 300 : 200,
                  decoration: BoxDecoration(
                    color: _isSunny ? Colors.orange : Colors.blueGrey,
                    borderRadius: BorderRadius.circular(_isSunny ? 150 : 20),
                  ),
                  child: Icon(
                    _isSunny ? Icons.wb_sunny : Icons.cloud,
                    size: 80,
                    color: Colors.white,
                  ),
                ),
                const SizedBox(height: 30),
                ElevatedButton(
                  onPressed: () {
                    setState(() {
                      _isSunny = !_isSunny;
                    });
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.blue,
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(
                      horizontal: 32,
                      vertical: 16,
                    ),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(30.0),
                    ),
                  ),
                  child: const Text(
                    'Change Weather',
                    style: TextStyle(fontSize: 16),
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
