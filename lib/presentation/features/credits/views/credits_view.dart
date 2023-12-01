import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../../core/extensions/num_extension.dart';
import '../../../../core/extensions/string_extension.dart';
import '../../../../utils/logic/constants/enums/app_enums.dart';
import '../../../../utils/logic/constants/locale/locale_keys.g.dart';
import '../../../../utils/logic/state/bloc/sign/sign_bloc.dart';
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
        appBar: creditViewType == CreditsViewType.insufficient
            ? AppBar(
                centerTitle: true,
              )
            : null,
        body: DefaultTabController(
          length: 2,
          child: Column(
            children: [
              if (creditViewType == CreditsViewType.insufficient) ...[
                Text(
                  LocaleKeys.insufficientBalance.tr(),
                  style: const TextStyle(
                    fontSize: 16,
                  ),
                ),
              ],
              if (creditViewType == CreditsViewType.balance) ...[
                40.verticalSpace,
                buildBalance(context),
              ],
              10.verticalSpace,
              const CreditTabBar(),
              30.verticalSpace,
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
        Image.asset(
          "ic_credit".toPNG,
          width: 20,
          height: 20,
        ),
      ],
    );
  }
}
