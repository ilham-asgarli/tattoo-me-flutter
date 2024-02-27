import 'dart:ui';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';

class RetouchBackground extends StatelessWidget {
  final String? image;
  final Color? backgroundColor;
  final double? sigmaX, sigmaY;

  const RetouchBackground(
      {required this.image,
      this.backgroundColor,
      this.sigmaX,
      this.sigmaY,
      super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        image: DecorationImage(
          image: (image ?? "").startsWith("http")
              ? CachedNetworkImageProvider(
                  image ?? "",
                )
              : AssetImage(image ?? "") as ImageProvider,
          fit: BoxFit.cover,
        ),
      ),
      child: ClipRRect(
        child: BackdropFilter(
          filter: ImageFilter.blur(
            sigmaX: sigmaX ?? 40.0,
            sigmaY: sigmaY ?? 40.0,
          ),
          child: Container(
            decoration: BoxDecoration(
              color: backgroundColor ?? Colors.white.withOpacity(0.3),
            ),
          ),
        ),
      ),
    );
  }
}
