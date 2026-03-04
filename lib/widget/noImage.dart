import 'package:flutter/material.dart';

class NoImage extends StatelessWidget {
  final double width;
  final double height;
  final bool isCircle;
  final bool isShowRadius;

  const NoImage({super.key, this.width = 70, this.height = 70, this.isCircle = true, this.isShowRadius = false});

  @override
  Widget build(BuildContext context) {
    // Determine the shape based on isCircle
    final BoxShape shape = isCircle ? BoxShape.circle : BoxShape.rectangle;

    // Determine borderRadius only if the shape is rectangle and isShowRadius is true
    final BorderRadius? borderRadius = (!isCircle && isShowRadius) ? const BorderRadius.all(Radius.circular(4)) : null;

    // Determine border only if the shape is rectangle and isShowRadius is true
    final Border border = (!isCircle && isShowRadius) ? Border.all(color: Colors.grey) : Border.all(color: Colors.transparent);

    return Container(
      width: width,
      height: height,
      decoration: BoxDecoration(
        shape: shape,
        borderRadius: borderRadius, // Null if shape is circle
        border: border,
        image: const DecorationImage(image: AssetImage("images/noimage.png"), fit: BoxFit.cover),
      ),
    );
  }
}
