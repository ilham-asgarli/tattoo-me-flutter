import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:tattoo/utils/logic/constants/locale/locale_keys.g.dart';

class EvaluateDesignerAlert extends StatelessWidget {
  EvaluateDesignerAlert({Key? key}) : super(key: key);

  final alertKey = UniqueKey();

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      key: alertKey,
      backgroundColor: Colors.white,
      actionsAlignment: MainAxisAlignment.spaceAround,
      actionsPadding: EdgeInsets.zero,
      title: buildTitle(),
      actions: buildActions(context),
      content: buildContent(),
    );
  }

  Widget buildTitle() {
    return Text(
      LocaleKeys.evaluateDesignerAlertTitle.tr(),
      style: const TextStyle(
        color: Colors.black,
        fontSize: 18,
      ),
      textAlign: TextAlign.center,
    );
  }

  List<Widget> buildActions(BuildContext context) {
    return [
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
              child: Text(LocaleKeys.close.tr()),
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
              child: Text(LocaleKeys.send.tr()),
            ),
          ),
        ],
      ),
    ];
  }

  Widget buildContent() {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        RatingBar.builder(
          initialRating: 0,
          minRating: 1,
          direction: Axis.horizontal,
          allowHalfRating: false,
          itemCount: 5,
          unratedColor: HexColor("#e6e6e6"),
          itemPadding: const EdgeInsets.symmetric(horizontal: 4.0),
          itemBuilder: (context, _) => const Icon(
            Icons.star,
            color: Colors.green,
          ),
          onRatingUpdate: (rating) {},
        ),
      ],
    );
  }
}
