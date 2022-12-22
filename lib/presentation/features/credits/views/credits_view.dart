import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hexcolor/hexcolor.dart';
import '../../../../utils/logic/state/bloc/sign/sign_bloc.dart';

import '../../../../core/extensions/context_extension.dart';
import '../../../../core/extensions/widget_extension.dart';
import '../../../../utils/logic/constants/locale/locale_keys.g.dart';
import '../../../../utils/ui/constants/colors/app_colors.dart';
import '../components/buy_item.dart';
import '../components/subscribe_item.dart';

class CreditsView extends StatefulWidget {
  const CreditsView({Key? key}) : super(key: key);

  @override
  State<CreditsView> createState() => _CreditsViewState();
}

class _CreditsViewState extends State<CreditsView> {
  final List<Map<String, Object>> _subscriptionList = [
    {
      "price": 119.99,
      "count": 150,
      "isAdvantageous": false,
    },
    {
      "price": 214.99,
      "count": 300,
      "isAdvantageous": true,
    },
    {
      "price": 384.99,
      "count": 600,
      "isAdvantageous": false,
    },
    {
      "price": 519.99,
      "count": 900,
      "isAdvantageous": false,
    },
    {
      "price": 934.99,
      "count": 1800,
      "isAdvantageous": false,
    },
  ];
  final List<Map<String, Object>> _buyList = [
    {
      "price": 29.99,
      "count": 30,
      "isAdvantageous": false,
    },
    {
      "price": 82.99,
      "count": 90,
      "isAdvantageous": false,
    },
    {
      "price": 129.99,
      "count": 150,
      "isAdvantageous": false,
    },
    {
      "price": 238.99,
      "count": 300,
      "isAdvantageous": true,
    },
    {
      "price": 438.99,
      "count": 600,
      "isAdvantageous": false,
    },
    {
      "price": 604.99,
      "count": 900,
      "isAdvantageous": false,
    },
    {
      "price": 1112.99,
      "count": 1800,
      "isAdvantageous": false,
    },
  ];

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: SingleChildScrollView(
          child: Column(
            children: [
              widget.verticalSpace(10),
              Text(
                LocaleKeys.balance.tr(),
                style: const TextStyle(fontSize: 18),
              ),
              widget.verticalSpace(10),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    "${context.watch<SignBloc>().state.userModel.balance ?? 0}",
                    style: const TextStyle(fontSize: 25),
                  ),
                  Icon(
                    Icons.star,
                    color: HexColor("#77BD52"),
                  ),
                ],
              ),
              widget.verticalSpace(10),
              Text(
                LocaleKeys.creditsDescription.tr(),
                textAlign: TextAlign.center,
              ),
              widget.verticalSpace(30),
              buildSubWidget(),
              widget.verticalSpace(40),
              buildBuyWidget(),
              widget.verticalSpace(20),
            ],
          ),
        ),
      ),
    );
  }

  Wrap buildBuyWidget() {
    return Wrap(
      alignment: WrapAlignment.spaceEvenly,
      spacing: 10,
      runSpacing: 10,
      direction: Axis.horizontal,
      children: _buyList.map((item) {
        return SizedBox(
          width: context.width / 2 - 15,
          child: InkWell(
            onTap: () {},
            borderRadius: const BorderRadius.all(
              Radius.circular(5),
            ),
            child: BuyItem(
              buyMap: item,
            ),
          ),
        );
      }).toList(),
    );
  }

  ListView buildSubWidget() {
    return ListView.separated(
      physics: const NeverScrollableScrollPhysics(),
      shrinkWrap: true,
      padding: const EdgeInsets.all(10),
      itemCount: _subscriptionList.length + 1,
      itemBuilder: (context, index) {
        return Container(
          decoration: BoxDecoration(
            color: Colors.lightGreen.withAlpha(150),
            borderRadius: index == 0
                ? const BorderRadius.vertical(
                    top: Radius.circular(10),
                  )
                : index == _subscriptionList.length
                    ? const BorderRadius.vertical(
                        bottom: Radius.circular(10),
                      )
                    : null,
          ),
          child: index == 0
              ? buildSubHeader()
              : InkWell(
                  onTap: () {},
                  borderRadius: index == _subscriptionList.length
                      ? const BorderRadius.vertical(
                          bottom: Radius.circular(10),
                        )
                      : null,
                  child: SubscribeItem(
                    subscriptionMap: _subscriptionList[index - 1],
                  ),
                ),
        );
      },
      separatorBuilder: (context, index) {
        return const Divider(
          color: Colors.green,
          height: 0,
        );
      },
    );
  }

  ListTile buildSubHeader() {
    return ListTile(
      leading: Text(
        LocaleKeys.packets.tr(),
        style: TextStyle(
          color: AppColors.secondColor,
          fontSize: 18,
        ),
      ),
      trailing: Text(
        LocaleKeys.monthlySub.tr(),
        style: TextStyle(
          color: AppColors.secondColor,
          fontSize: 12,
        ),
      ),
    );
  }
}
