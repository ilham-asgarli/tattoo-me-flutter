import 'package:flutter/material.dart';

import '../../core/extensions/string_extension.dart';

class CreditIcon extends StatelessWidget {
  const CreditIcon({super.key});

  @override
  Widget build(BuildContext context) {
    return Image.asset(
      "ic_star".toPNG,
      width: 15,
      height: 15,
    );
  }
}
