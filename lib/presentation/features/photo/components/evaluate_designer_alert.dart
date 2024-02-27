import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:hexcolor/hexcolor.dart';
import '../../../../utils/logic/constants/locale/locale_keys.g.dart';

import '../../../../backend/utils/constants/app/app_constants.dart';
import '../../../../domain/models/design-response/design_response_model.dart';
import '../../../../domain/repositories/design-responses/implementations/design_responses_repository.dart';

class EvaluateDesignerAlert extends StatelessWidget {
  final DesignResponseModel designModel;

  EvaluateDesignerAlert({required this.designModel, super.key});

  final alertKey = UniqueKey();
  int rating = 1;

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
              onPressed: () async {
                if (rating >= AppBackConstants.minRating &&
                    rating <= AppBackConstants.maxRating) {
                  Navigator.pop(context);
                  if (designModel.id != null) {
                    DesignResponseRepository designResponseRepository =
                        DesignResponseRepository();
                    await designResponseRepository.evaluateDesigner(
                        designModel.id!, rating);
                  }
                }
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
          initialRating: designModel.rating?.toDouble() ?? 1,
          minRating: AppBackConstants.minRating,
          unratedColor: HexColor("#e6e6e6"),
          itemPadding: const EdgeInsets.symmetric(horizontal: 4.0),
          itemBuilder: (context, _) => const Icon(
            Icons.star,
            color: Colors.green,
          ),
          onRatingUpdate: (rating) {
            this.rating = rating.toInt();
          },
        ),
      ],
    );
  }
}
