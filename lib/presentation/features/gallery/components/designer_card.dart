import 'package:flutter/material.dart';

import '../../../../core/extensions/context_extension.dart';
import '../../../../utils/ui/constants/colors/app_colors.dart';

class DesignerCard extends StatelessWidget {
  final Widget? child;
  const DesignerCard({
    super.key,
    this.child,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      color: AppColors.tertiary,
      child: Padding(
        padding: EdgeInsets.symmetric(
          vertical: context.lowValue * 0.8,
          horizontal: context.normalValue,
        ),
        child: child,
      ),
    );
  }
}
