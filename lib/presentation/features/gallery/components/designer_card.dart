import 'package:flutter/material.dart';
import 'package:hexcolor/hexcolor.dart';

import '../../../../core/extensions/context_extension.dart';

class DesignerCard extends StatelessWidget {
  final Widget? child;

  const DesignerCard({
    super.key,
    this.child,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.all(3),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(5),
      ),
      color: HexColor("161616"),
      child: Padding(
        padding: EdgeInsets.symmetric(
          vertical: context.lowValue * 0.8,
          horizontal: context.lowValue,
        ),
        child: child,
      ),
    );
  }
}
