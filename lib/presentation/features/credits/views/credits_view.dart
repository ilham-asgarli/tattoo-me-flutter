import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:tattoo/presentation/features/credits/components/ios_store_area.dart';
import 'package:tattoo/utils/logic/constants/enums/app_enum.dart';

import '../../../../core/extensions/widget_extension.dart';
import '../../../../utils/logic/constants/locale/locale_keys.g.dart';
import '../../../../utils/logic/state/bloc/sign/sign_bloc.dart';
import '../components/buy.dart';
import '../components/subscribe.dart';

class CreditsView extends StatefulWidget {
  final CreditsViewType creditViewType;

  const CreditsView({
    Key? key,
    this.creditViewType = CreditsViewType.balance,
  }) : super(key: key);

  @override
  State<CreditsView> createState() => _CreditsViewState();
}

class _CreditsViewState extends State<CreditsView> {
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: widget.creditViewType == CreditsViewType.balance
            ? null
            : AppBar(
                title: Text(LocaleKeys.appName.tr()),
                centerTitle: true,
              ),
        body: SingleChildScrollView(
          child: Column(
            children: [
              widget.verticalSpace(10),
              buildTitle(context),
              widget.verticalSpace(10),
              buildBalance(context),
              widget.verticalSpace(10),
              Text(
                LocaleKeys.creditsDescription.tr(),
                textAlign: TextAlign.center,
              ),
              widget.verticalSpace(30),
              const Subscribe(),
              widget.verticalSpace(40),
              const Buy(),
              widget.verticalSpace(20),
              const IosStoreArea()
            ],
          ),
        ),
      ),
    );
  }

  Row buildBalance(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(
          "${context.watch<SignBloc>().state.userModel.balance ?? 0}",
          style: GoogleFonts.questrial(
            textStyle: const TextStyle(fontSize: 35),
          ),
        ),
        widget.horizontalSpace(5),
        const Icon(
          Icons.stars_rounded,
          color: Colors.green,
        ),
      ],
    );
  }

  Text buildTitle(BuildContext context) {
    return Text(
      widget.creditViewType == CreditsViewType.balance
          ? LocaleKeys.balance.tr()
          : (context.read<SignBloc>().state.userModel.balance ?? 0) > 0
              ? LocaleKeys.balance.tr()
              : LocaleKeys.insufficientBalance.tr(),
      style: const TextStyle(fontSize: 15),
    );
  }
}
