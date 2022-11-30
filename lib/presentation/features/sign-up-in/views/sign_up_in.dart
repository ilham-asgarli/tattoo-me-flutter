import 'package:centered_singlechildscrollview/centered_singlechildscrollview.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:tattoo/presentation/features/sign-up-in/view-models/sign_up_in_view_model.dart';
import 'package:tattoo/presentation/widgets/fractionally_sized_circular_progress_indicator.dart';
import 'package:tattoo/utils/logic/state/bloc/sign/sign_bloc.dart';
import 'package:tattoo/utils/ui/validators/email_validator.dart';

import '../../../../core/extensions/context_extension.dart';
import '../../../../core/extensions/widget_extension.dart';
import '../../../../utils/logic/constants/locale/locale_keys.g.dart';
import '../../../../utils/ui/constants/colors/app_colors.dart';
import '../../../../utils/ui/validators/password_validator.dart';

class SignUpIn extends StatefulWidget {
  const SignUpIn({Key? key}) : super(key: key);

  @override
  State<SignUpIn> createState() => _SignUpInState();
}

class _SignUpInState extends State<SignUpIn> {
  late SignUpInViewModel _signUpInViewModel;
  final GlobalKey<FormState> _signFormKey = GlobalKey<FormState>();

  @override
  void initState() {
    _signUpInViewModel = SignUpInViewModel(context: context);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<SignBloc, SignState>(
      builder: (context, state) {
        return WillPopScope(
          onWillPop: () {
            FocusManager.instance.primaryFocus?.unfocus();
            return _signUpInViewModel.onBackPressed();
          },
          child: Scaffold(
            appBar: buildAppBar(),
            body: CenteredSingleChildScrollView(
              children: [
                const FaIcon(
                  FontAwesomeIcons.user,
                  size: 50,
                ),
                widget.verticalSpace(20),
                buildSignDescription(state),
                widget.dynamicVerticalSpace(context, 0.05),
                buildMoreDescription(),
                widget.dynamicVerticalSpace(context, 0.05),
                buildSignArea(state),
                widget.verticalSpace(20),
                buildSignButton(state),
                widget.dynamicVerticalSpace(context, 0.15),
                buildChangeSign(state),
              ],
            ),
          ),
        );
      },
    );
  }

  AppBar buildAppBar() {
    return AppBar(
      leading: BackButton(
        onPressed: () {
          FocusManager.instance.primaryFocus?.unfocus();
          _signUpInViewModel.onBackPressed();
        },
      ),
    );
  }

  Widget buildSignDescription(SignState state) {
    return Text(
      (state is SignUp || state is SigningUp)
          ? LocaleKeys.signUp.tr()
          : LocaleKeys.signInDescription.tr(),
      textAlign: TextAlign.center,
      style: const TextStyle(
        fontSize: 22,
        fontWeight: FontWeight.w500,
      ),
    );
  }

  Widget buildMoreDescription() {
    return Padding(
      padding: EdgeInsets.only(
        left: context.mediumValue,
        right: context.mediumValue,
      ),
      child: Text(
        LocaleKeys.moreDescription.tr(),
        style: TextStyle(
          fontSize: 10,
          color: HexColor("#737373"),
        ),
        textAlign: TextAlign.center,
      ),
    );
  }

  Widget buildSignArea(SignState state) {
    return Form(
      key: _signFormKey,
      child: Padding(
        padding: EdgeInsets.only(
          left: context.mediumValue,
          right: context.mediumValue,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            TextFormField(
              autovalidateMode: AutovalidateMode.onUserInteraction,
              decoration: InputDecoration(
                isCollapsed: true,
                contentPadding: const EdgeInsets.all(12),
                filled: true,
                fillColor: AppColors.tertiary,
                hintText: LocaleKeys.email.tr(),
                border: const OutlineInputBorder(),
                focusedBorder: const OutlineInputBorder(
                  borderSide: BorderSide(color: Colors.white),
                ),
                enabledBorder: OutlineInputBorder(
                  borderSide: BorderSide(
                    color: HexColor("#595959"),
                  ),
                ),
              ),
              onSaved: _signUpInViewModel.onSavedEmail,
              validator: (value) {
                return EmailValidator(value).validate();
              },
            ),
            widget.verticalSpace(10),
            TextFormField(
              autovalidateMode: AutovalidateMode.onUserInteraction,
              decoration: InputDecoration(
                isCollapsed: true,
                contentPadding: const EdgeInsets.all(12),
                filled: true,
                fillColor: AppColors.tertiary,
                hintText: LocaleKeys.password.tr(),
                border: const OutlineInputBorder(),
                focusedBorder: const OutlineInputBorder(
                  borderSide: BorderSide(color: Colors.white),
                ),
                enabledBorder: OutlineInputBorder(
                  borderSide: BorderSide(
                    color: HexColor("#595959"),
                  ),
                ),
              ),
              onSaved: _signUpInViewModel.onSavedPassword,
              validator: (value) {
                return PasswordValidator(value).validate();
              },
            ),
            widget.verticalSpace(15),
            Visibility(
              visible: (state is! SignUp && state is! SigningUp),
              maintainState: true,
              maintainAnimation: true,
              maintainSize: true,
              child: Text(LocaleKeys.forgotPassword.tr()),
            ),
          ],
        ),
      ),
    );
  }

  Widget buildSignButton(SignState state) {
    return ElevatedButton(
      style: ButtonStyle(
        elevation: MaterialStateProperty.all<double>(0),
        fixedSize: MaterialStateProperty.all<Size>(
          Size(context.width / 1.5, 40),
        ),
        backgroundColor:
            MaterialStateProperty.all<Color>(AppColors.secondColor),
        shape: MaterialStateProperty.all<RoundedRectangleBorder>(
          RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10.0),
          ),
        ),
      ),
      onPressed: () async {
        FocusManager.instance.primaryFocus?.unfocus();
        if (_signFormKey.currentState!.validate()) {
          _signFormKey.currentState?.save();
          await _signUpInViewModel.signInUp(mounted);
        }
      },
      child: (state is SigningIn || state is SigningUp)
          ? const FractionallySizedCircularProgressIndicator(
              factor: 0.5,
              color: Colors.black,
            )
          : Text(
              state is SignUp ? LocaleKeys.signUp.tr() : LocaleKeys.signIn.tr(),
              style: const TextStyle(color: Colors.black),
            ),
    );
  }

  Widget buildChangeSign(SignState state) {
    return Visibility(
      visible: (state is! SignUp && state is! SigningUp),
      maintainState: true,
      maintainAnimation: true,
      maintainSize: true,
      child: GestureDetector(
        onTap: () {
          _signUpInViewModel.changeSign();
        },
        child: Padding(
          padding: const EdgeInsets.all(12),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                (state is SignUp || state is SigningUp)
                    ? LocaleKeys.haveAccount.tr()
                    : LocaleKeys.haveNoAccount.tr(),
              ),
              widget.horizontalSpace(10),
              const FaIcon(
                FontAwesomeIcons.user,
                size: 15,
              ),
              widget.horizontalSpace(5),
              Text(
                (state is SignUp || state is SigningUp)
                    ? LocaleKeys.signIn.tr()
                    : LocaleKeys.signUp.tr(),
                style: const TextStyle(fontWeight: FontWeight.bold),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
