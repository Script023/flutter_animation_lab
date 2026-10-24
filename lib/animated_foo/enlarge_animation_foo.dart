// create an animated container that expands on clicking it
import 'package:flutter/material.dart';

class EnlargeAnimationFoo extends StatefulWidget {
  final String assetPath;
  const EnlargeAnimationFoo({super.key, required this.assetPath});

  @override
  State<EnlargeAnimationFoo> createState() => _EnlargeAnimationFooState();
}

bool _isClicked = false;
// null check operator for the height and width
double? _imageWidth;
double? _imageHeight;

class _EnlargeAnimationFooState extends State<EnlargeAnimationFoo> {
  @override
  void initState() {
    super.initState();
    _getImageDimensions();
  }

  void _getImageDimensions() {
    // set the image path to an assetImage variable
    final AssetImage assetImage = AssetImage(widget.assetPath);
    // getting the image dimensions asynchronously
    assetImage
        .resolve(const ImageConfiguration())
        .addListener(
          ImageStreamListener((ImageInfo info, bool_) {
            if (mounted) {
              setState(() {
                _imageWidth = info.image.width.toDouble();
                _imageHeight = info.image.height.toDouble();
              });
            }
          }),
        );
  }

  @override
  Widget build(BuildContext context) {
    // safety check
    if (_imageWidth == null || _imageHeight == null) {
      return Scaffold(
        backgroundColor: Colors.black,
        body: Center(child: CircularProgressIndicator()),
      );
    }
    // we can now do this because we know that the image height and image width will not the null
    final aspectRatio = _imageWidth! / _imageHeight!;

    return Scaffold(
      backgroundColor: Colors.black,
      body: SafeArea(
        child: SingleChildScrollView(
          child: Center(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 30),

                GestureDetector(
                  onTap: () {
                    setState(() {
                      _isClicked = !_isClicked;
                    });
                  },
                  child: AnimatedContainer(
                    duration: Duration(milliseconds: 70),
                    //add curves
                    curve: Curves.bounceInOut,
                    // what then happens to the height and width in the clicking process
                    // using a tenary operator to create a 6x enlargement effect
                    width: _isClicked
                        ? _imageWidth! * 0.75
                        : _imageWidth! * 0.25,
                    height: _isClicked
                        ? (_imageWidth! * 0.75) / aspectRatio
                        : _imageHeight! * 0.25,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(_isClicked ? 24 : 12),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withValues(
                            alpha: _isClicked ? 0.25 : 0.042,
                          ),
                          blurRadius: _isClicked ? 20 : 3.33,
                          offset: _isClicked
                              ? const Offset(0, 12)
                              : const Offset(0, 3),
                        ),
                      ],
                    ),
                    // the sun image itself
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(_isClicked ? 24 : 12),
                      child: Image.asset(widget.assetPath, fit: BoxFit.contain),
                    ),
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
