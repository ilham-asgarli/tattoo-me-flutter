import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:tattoo/utils/logic/constants/locale/locale_keys.g.dart';

class RetouchAlert extends StatefulWidget {
  const RetouchAlert({Key? key}) : super(key: key);

  @override
  State<RetouchAlert> createState() => _RetouchAlertState();
}

class _RetouchAlertState extends State<RetouchAlert> {
  final alertKey = UniqueKey();

  bool isSent = false;
  bool isSending = false;

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      key: alertKey,
      backgroundColor: HexColor("#e6e6e6"),
      titlePadding: const EdgeInsets.all(5),
      actionsPadding: const EdgeInsets.all(0),
      contentPadding: const EdgeInsets.all(0),
      actionsAlignment: MainAxisAlignment.center,
      title: buildTitle(context),
      actions: buildActions(context),
      content: buildContent(),
    );
  }

  Row? buildTitle(BuildContext context) {
    return isSent
        ? null
        : Row(
            children: [
              InkWell(
                onTap: () {
                  Navigator.pop(context);
                },
                child: const Icon(
                  Icons.close,
                  color: Colors.black,
                ),
              ),
            ],
          );
  }

  Column buildContent() {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Padding(
          padding: const EdgeInsets.all(15),
          child: Text(
            LocaleKeys.retouchAlertTitle.tr(),
            style: const TextStyle(color: Colors.black),
          ),
        ),
        Card(
          elevation: 0,
          color: Colors.white,
          margin: EdgeInsets.zero,
          child: Padding(
            padding: const EdgeInsets.all(15),
            child: isSent
                ? Text(
                    LocaleKeys.sentForRetouch.tr(),
                    style: const TextStyle(color: Colors.black),
                    textAlign: TextAlign.center,
                  )
                : TextField(
                    minLines: 5,
                    maxLines: 5,
                    cursorColor: Colors.black,
                    style: const TextStyle(color: Colors.black),
                    decoration: InputDecoration(
                      border: InputBorder.none,
                      hintText: LocaleKeys.writeNoteHere.tr(),
                      hintStyle: const TextStyle(
                        color: Colors.grey,
                        fontSize: 15,
                      ),
                    ),
                  ),
          ),
        ),
      ],
    );
  }

  List<Widget> buildActions(BuildContext context) {
    return [
      Container(
        color: Colors.white,
        child: Row(
          children: [
            Expanded(
              child: TextButton(
                style: ButtonStyle(
                  tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                  padding: MaterialStateProperty.all(const EdgeInsets.all(15)),
                ),
                onPressed: () {
                  if (isSent && isSending) {
                    Navigator.pop(context);
                    return;
                  }

                  if (!isSending) {
                    setState(() {
                      isSending = true;
                    });

                    Future.delayed(const Duration(seconds: 1)).then((value) {
                      setState(() {
                        isSent = true;
                      });
                    });
                  }
                },
                child: (!isSent && isSending)
                    ? SizedBox(
                        height: 20,
                        width: 20,
                        child: CircularProgressIndicator.adaptive(
                          backgroundColor: Colors.grey,
                          valueColor: AlwaysStoppedAnimation<Color>(
                            HexColor("#666666"),
                          ),
                        ),
                      )
                    : Text(
                        isSent ? LocaleKeys.close.tr() : LocaleKeys.send.tr(),
                      ),
              ),
            ),
          ],
        ),
      ),
    ];
  }
}
