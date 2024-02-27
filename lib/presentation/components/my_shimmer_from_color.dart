import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';

import '../../utils/ui/constants/colors/app_colors.dart';

class MyShimmerFromColor extends StatelessWidget {
  final Widget child;
  const MyShimmerFromColor({required this.child, super.key});

  @override
  Widget build(BuildContext context) {
    return Shimmer.fromColors(
      baseColor: AppColors.shimmerBaseColor,
      highlightColor: AppColors.shimmerHighLightColor,
      child: child,
    );
  }
}
