import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../../core/extensions/num_extension.dart';
import '../../../../utils/logic/constants/enums/app_enum.dart';
import '../../../../utils/logic/constants/locale/locale_keys.g.dart';
import '../../../../utils/logic/state/bloc/sign/sign_bloc.dart';
import '../../../components/credit_icon.dart';
import '../components/buy_tab.dart';
import '../components/credit_tab_bar.dart';
import '../components/earn_tab.dart';

class CreditsView extends StatelessWidget {
  final CreditsViewType creditViewType;
  const CreditsView({
    super.key,
    this.creditViewType = CreditsViewType.balance,
  });

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: creditViewType == CreditsViewType.balance
            ? null
            : AppBar(
                title: Text(LocaleKeys.appName.tr()),
                centerTitle: true,
              ),
        body: DefaultTabController(
          length: 2,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              10.verticalSpace,
              buildBalance(context),
              10.verticalSpace,
              const CreditTabBar(),
              20.verticalSpace,
              const Expanded(
                child: TabBarView(
                  children: [
                    BuyTab(),
                    EarnTab(),
                  ],
                ),
              ),
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
          "${LocaleKeys.balance.tr()}:",
          style: const TextStyle(fontSize: 15),
        ),
        5.horizontalSpace,
        Text(
          "${context.watch<SignBloc>().state.userModel.balance ?? 0}",
          style: GoogleFonts.questrial(
            textStyle: const TextStyle(
              fontSize: 23,
            ),
          ),
        ),
        5.horizontalSpace,
        const CreditIcon(),
      ],
    );
  }
}
