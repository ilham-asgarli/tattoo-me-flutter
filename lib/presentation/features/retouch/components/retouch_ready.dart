import 'package:flutter/material.dart';
import '../../../../core/extensions/context_extension.dart';

class RetouchReady extends StatelessWidget {
  const RetouchReady({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: context.dynamicWidth(0.3),
      height: context.dynamicWidth(0.3),
      alignment: Alignment.center,
      decoration: BoxDecoration(
        color: Colors.grey,
        shape: BoxShape.circle,
        border: Border.all(color: Colors.white),
      ),
      child: const Icon(
        Icons.check,
        size: 50,
      ),
    );
  }
}
