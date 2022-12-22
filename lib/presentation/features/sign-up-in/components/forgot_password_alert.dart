import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:hexcolor/hexcolor.dart';
import '../../../../domain/repositories/auth/implementations/email_auth_repository.dart';
import '../../../../utils/logic/constants/locale/locale_keys.g.dart';
import '../../../../utils/ui/validators/email_validator.dart';

import '../../../../core/base/models/base_response.dart';

class ForgotPasswordAlert extends StatefulWidget {
  const ForgotPasswordAlert({Key? key}) : super(key: key);

  @override
  State<ForgotPasswordAlert> createState() => _ForgotPasswordAlertState();
}

class _ForgotPasswordAlertState extends State<ForgotPasswordAlert> {
  final alertKey = UniqueKey();
  final GlobalKey<FormState> _forgotPasswordFormKey = GlobalKey<FormState>();
  String? email;

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      key: alertKey,
      backgroundColor: HexColor("#e6e6e6"),
      titlePadding: const EdgeInsets.all(5),
      actionsPadding: const EdgeInsets.all(0),
      contentPadding: const EdgeInsets.all(0),
      insetPadding: EdgeInsets.zero,
      actionsAlignment: MainAxisAlignment.center,
      title: buildTitle(context),
      actions: buildActions(context),
      content: buildContent(),
    );
  }

  Row? buildTitle(BuildContext context) {
    return Row(
      children: [
        InkWell(
          onTap: () {
            FocusManager.instance.primaryFocus?.unfocus();
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

  Widget buildContent() {
    return Form(
      key: _forgotPasswordFormKey,
      child: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Padding(
              padding: const EdgeInsets.all(15),
              child: Text(
                LocaleKeys.forgotPassword.tr(),
                style: const TextStyle(color: Colors.black),
                textAlign: TextAlign.center,
              ),
            ),
            Card(
              elevation: 0,
              color: Colors.white,
              margin: EdgeInsets.zero,
              child: Padding(
                padding: const EdgeInsets.all(15),
                child: TextFormField(
                  keyboardType: TextInputType.emailAddress,
                  cursorColor: Colors.black,
                  style: const TextStyle(color: Colors.black),
                  decoration: InputDecoration(
                    border: InputBorder.none,
                    hintText: LocaleKeys.email.tr(),
                    hintStyle: const TextStyle(
                      color: Colors.grey,
                      fontSize: 15,
                    ),
                  ),
                  onSaved: (String? value) {
                    email = value;
                  },
                  validator: (value) {
                    return EmailValidator(value).validate();
                  },
                ),
              ),
            ),
          ],
        ),
      ),
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
                onPressed: () async {
                  if (_forgotPasswordFormKey.currentState!.validate()) {
                    _forgotPasswordFormKey.currentState?.save();

                    FocusManager.instance.primaryFocus?.unfocus();

                    if (email != null) {
                      await sendPasswordResetEmail(email!);
                    }
                  }
                },
                child: Text(
                  LocaleKeys.sendForgotPasswordEmail.tr(),
                ),
              ),
            ),
          ],
        ),
      ),
    ];
  }

  Future<void> sendPasswordResetEmail(String email) async {
    if (mounted) {
      Navigator.pop(context);
    }

    EmailAuthRepository emailAuthRepository = EmailAuthRepository();
    BaseResponse baseResponse =
        await emailAuthRepository.sendPasswordResetEmail(email);
  }
}
