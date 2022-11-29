import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:tattoo/core/extensions/context_extension.dart';

class ProgressDialog extends StatelessWidget {
  const ProgressDialog({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      child: AlertDialog(
        alignment: Alignment.center,
        insetPadding: EdgeInsets.all(context.width / 3),
        shape: const CircleBorder(),
        backgroundColor: Colors.transparent,
        contentPadding: EdgeInsets.zero,
        content: SizedBox(
          height: 150,
          width: 150,
          child: BackdropFilter(
            filter: ImageFilter.blur(
              sigmaX: 20.0,
              sigmaY: 20.0,
            ),
            child: Stack(
              alignment: Alignment.center,
              children: [
                Container(
                  width: 140,
                  height: 140,
                  decoration: const BoxDecoration(
                    shape: BoxShape.circle,
                  ),
                ),
                const SizedBox(
                  width: 140,
                  height: 140,
                  child: CircularProgressIndicator(
                    valueColor: AlwaysStoppedAnimation<Color>(
                      Colors.grey,
                    ),
                  ),
                ),
                Container(
                  width: 140,
                  height: 140,
                  alignment: Alignment.center,
                  child: const FaIcon(
                    FontAwesomeIcons.paperPlane,
                    color: Colors.grey,
                    size: 30,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
      onWillPop: () async {
        return false;
      },
    );
  }
}
