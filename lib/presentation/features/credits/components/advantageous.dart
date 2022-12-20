import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';

import '../../../../utils/logic/constants/locale/locale_keys.g.dart';

class Advantageous extends StatelessWidget {
  final bool? isAdvantageous;

  const Advantageous({this.isAdvantageous, Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Visibility(
      visible: isAdvantageous ?? false,
      child: Container(
        decoration: const BoxDecoration(
          color: Colors.deepPurple,
          borderRadius: BorderRadius.only(
            bottomRight: Radius.circular(10),
          ),
        ),
        child: Padding(
          padding: const EdgeInsets.only(right: 10),
          child: Text(
            LocaleKeys.advantageous.tr(),
            style: const TextStyle(fontSize: 11),
          ),
        ),
      ),
    );
  }
}
