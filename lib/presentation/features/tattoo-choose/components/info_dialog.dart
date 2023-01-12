import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:tattoo/core/extensions/context_extension.dart';
import 'package:tattoo/core/extensions/widget_extension.dart';
import 'package:tattoo/utils/ui/constants/colors/app_colors.dart';

class InfoDialog extends StatelessWidget {
  final String message;

  const InfoDialog({Key? key, this.message = ""}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      backgroundColor: AppColors.secondColor,
      actionsPadding: EdgeInsets.zero,
      contentPadding: context.paddingMedium,
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            message,
            style: const TextStyle(
              color: Colors.black,
              fontSize: 15,
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
      actions: [
        Row(
          children: [
            Expanded(
              child: TextButton(
                style: ButtonStyle(
                  tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                  padding: MaterialStateProperty.all(const EdgeInsets.all(15)),
                ),
                onPressed: () {
                  Navigator.pop(context);
                },
                child: Text(
                  "Kredi al",
                  style: TextStyle(color: Colors.black),
                ),
              ),
            ),
            Expanded(
              child: TextButton(
                style: ButtonStyle(
                  tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                  padding: MaterialStateProperty.all(const EdgeInsets.all(15)),
                ),
                onPressed: () {
                  Navigator.pop(context);
                },
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      "Değerlendir",
                      style: TextStyle(color: Colors.black),
                    ),
                    context.widget.horizontalSpace(10),
                    FaIcon(
                      FontAwesomeIcons.star,
                      size: 20,
                      color: Colors.amber.withOpacity(0.6),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }
}
