import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:hexcolor/hexcolor.dart';

import '../../../../core/extensions/context_extension.dart';
import '../../../../utils/logic/constants/locale/locale_keys.g.dart';

class CreditTabBar extends StatelessWidget {
  const CreditTabBar({super.key});

  @override
  Widget build(BuildContext context) {
    return Theme(
      data: ThemeData(
        splashColor: Colors.transparent,
        highlightColor: Colors.transparent,
      ),
      child: TabBar(
        isScrollable: true,
        tabs: [
          Ink(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(5),
              color: HexColor("#2E2E2E"),
            ),
            height: 30,
            width: context.width / 3,
            child: Tab(
              text: LocaleKeys.creditsTab_buy.tr(),
            ),
          ),
          Ink(
            height: 45,
            child: Stack(
              alignment: Alignment.center,
              children: [
                Ink(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(5),
                    color: HexColor("#2E2E2E"),
                  ),
                  height: 30,
                  width: context.width / 3,
                  child: Tab(
                    text: LocaleKeys.creditsTab_earn.tr(),
                  ),
                ),
                Positioned(
                  top: 2,
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 5,
                      vertical: 1,
                    ),
                    decoration: const BoxDecoration(
                      color: Colors.deepPurple,
                      borderRadius: BorderRadius.only(
                        bottomRight: Radius.circular(8),
                        topLeft: Radius.circular(8),
                      ),
                    ),
                    child: Text(
                      LocaleKeys.free.tr(),
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 8,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
        dividerColor: Colors.transparent,
        unselectedLabelColor: Colors.white,
        labelColor: Colors.black,
        labelStyle: const TextStyle(
          fontSize: 11,
          fontWeight: FontWeight.w500,
        ),
        indicator: BoxDecoration(
          borderRadius: BorderRadius.circular(5),
          color: Colors.white,
        ),
        indicatorPadding: const EdgeInsets.symmetric(
          horizontal: 1,
          vertical: 10,
        ),
        indicatorSize: TabBarIndicatorSize.label,
      ),
    );
  }
}
