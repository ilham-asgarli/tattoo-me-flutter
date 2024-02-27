import 'package:flutter/material.dart';

class ImagePlaceholder extends StatelessWidget {
  final ImageProvider? imageProvider;
  final double radius;

  const ImagePlaceholder({
    super.key,
    required this.imageProvider,
    this.radius = 20,
  });

  @override
  Widget build(BuildContext context) {
    return CircleAvatar(
      radius: radius,
      //backgroundColor: MyColors.mainColor,
      backgroundImage: imageProvider,
    );
  }
}
