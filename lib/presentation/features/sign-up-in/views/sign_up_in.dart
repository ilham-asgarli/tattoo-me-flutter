import 'package:centered_singlechildscrollview/centered_singlechildscrollview.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:hexcolor/hexcolor.dart';

import '../../../../core/extensions/context_extension.dart';
import '../../../../core/extensions/widget_extension.dart';
import '../../../../utils/logic/constants/locale/locale_keys.g.dart';
import '../../../../utils/logic/state/bloc/sign/sign_bloc.dart';
import '../../../../utils/ui/constants/colors/app_colors.dart';
import '../../../../utils/ui/validators/email_validator.dart';
import '../../../../utils/ui/validators/password_validator.dart';
import '../../../widgets/fractionally_sized_circular_progress_indicator.dart';
import '../components/forgot_password_alert.dart';
import '../view-models/sign_up_in_view_model.dart';

class SignUpIn extends StatefulWidget {
  const SignUpIn({super.key});

  @override
  State<SignUpIn> createState() => _SignUpInState();
}

class _SignUpInState extends State<SignUpIn> {
  final SignUpInViewModel viewModel = SignUpInViewModel();
  final GlobalKey<FormState> _signFormKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<SignBloc, SignState>(
      builder: (context, state) {
        return WillPopScope(
          onWillPop: () {
            FocusManager.instance.primaryFocus?.unfocus();
            return viewModel.onBackPressed(context);
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
          viewModel.onBackPressed(context);
        },
      ),
    );
  }

  Widget buildSignDescription(SignState state) {
    return Text(
      !viewModel.isSignIn(context)
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
              keyboardType: TextInputType.emailAddress,
              textInputAction: TextInputAction.next,
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
              onSaved: viewModel.onSavedEmail,
              validator: (value) {
                return EmailValidator(value).validate();
              },
            ),
            widget.verticalSpace(10),
            TextFormField(
              autovalidateMode: AutovalidateMode.onUserInteraction,
              obscureText: !viewModel.isPasswordVisible,
              enableSuggestions: false,
              autocorrect: false,
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
                suffixIcon: IconButton(
                  onPressed: () {
                    setState(() {
                      viewModel.isPasswordVisible =
                          !viewModel.isPasswordVisible;
                    });
                  },
                  icon: const Icon(
                    Icons.remove_red_eye_rounded,
                    color: Colors.white,
                  ),
                ),
              ),
              onSaved: viewModel.onSavedPassword,
              validator: (value) {
                return PasswordValidator(value).validate();
              },
            ),
            widget.verticalSpace(15),
            GestureDetector(
              onTap: forgotPassword,
              child: Visibility(
                visible: viewModel.isSignIn(context),
                maintainState: true,
                maintainAnimation: true,
                maintainSize: true,
                child: Text(LocaleKeys.forgotPassword.tr()),
              ),
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
          await viewModel.signInUp(context, mounted);
        }
      },
      child: (state is SigningIn || state is SigningUp)
          ? const FractionallySizedCircularProgressIndicator(
              factor: 0.5,
              color: Colors.black,
            )
          : Text(
              !viewModel.isSignIn(context)
                  ? LocaleKeys.signUp.tr()
                  : LocaleKeys.signIn.tr(),
              style: const TextStyle(color: Colors.black),
            ),
    );
  }

  Widget buildChangeSign(SignState state) {
    return Visibility(
      visible: viewModel.isSignIn(context),
      maintainState: true,
      maintainAnimation: true,
      maintainSize: true,
      child: GestureDetector(
        onTap: () {
          viewModel.changeSign(context);
        },
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                !viewModel.isSignIn(context)
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
                !viewModel.isSignIn(context)
                    ? LocaleKeys.signIn.tr()
                    : LocaleKeys.signUp.tr(),
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void forgotPassword() {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) {
        return const ForgotPasswordAlert();
      },
    );
  }
}
