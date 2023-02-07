import 'dart:io';

import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:in_app_purchase/in_app_purchase.dart';
import 'package:tattoo/utils/logic/constants/enums/app_enum.dart';
import 'package:tattoo/utils/logic/constants/purchase/purchase_constants.dart';
import 'package:tattoo/utils/logic/helpers/purchase/purchase_helper.dart';
import 'package:tattoo/utils/logic/state/cubit/purchase/purchase_cubit.dart';

import '../../../../core/extensions/context_extension.dart';
import '../../../../core/extensions/widget_extension.dart';
import '../../../../core/router/core/router_service.dart';
import '../../../../utils/logic/constants/locale/locale_keys.g.dart';
import '../../../../utils/logic/constants/router/router_constants.dart';
import '../../../../utils/logic/state/bloc/sign/sign_bloc.dart';
import '../../../../utils/ui/constants/colors/app_colors.dart';
import '../components/buy_item.dart';
import '../components/subscribe_item.dart';

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
              Text(
                widget.creditViewType == CreditsViewType.balance
                    ? LocaleKeys.balance.tr()
                    : (context.read<SignBloc>().state.userModel.balance ?? 0) >
                            0
                        ? LocaleKeys.balance.tr()
                        : LocaleKeys.insufficientBalance.tr(),
                style: const TextStyle(fontSize: 15),
              ),
              widget.verticalSpace(10),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    "${context.watch<SignBloc>().state.userModel.balance ?? 0}",
                    style: GoogleFonts.questrial(
                      textStyle: const TextStyle(fontSize: 35),
                    ),
                  ),
                  /*Icon(
                    Icons.star,
                    color: HexColor("#77BD52"),
                  ),*/
                  widget.horizontalSpace(5),
                  const Icon(
                    Icons.stars_rounded,
                    color: Colors.green,
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
              Visibility(
                visible: Platform.isIOS,
                child: Row(
                  children: [
                    buildIosStoreArea(),
                    widget.verticalSpace(20),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Row buildIosStoreArea() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      children: [
        TextButton(
          onPressed: () {
            RouterService.instance.pushNamed(
              path: RouterConstants.privacyPolicy,
            );
          },
          child: Text(
            LocaleKeys.privacyPolicy.tr(),
            style: TextStyle(color: AppColors.secondColor),
          ),
        ),
        TextButton(
          onPressed: () {
            RouterService.instance.pushNamed(
              path: RouterConstants.termOfUse,
            );
          },
          child: Text(
            LocaleKeys.termOfUse.tr(),
            style: TextStyle(color: AppColors.secondColor),
          ),
        ),
      ],
    );
  }

  Widget buildBuyWidget() {
    List<ProductDetails> products =
        context.watch<PurchaseCubit>().state.products;
    Iterable<ProductDetails> productsIterable = products.where((element) {
      return PurchaseConstants.inAppProducts.keys.contains(element.id);
    });

    products = productsIterable.toList();
    products.sort(
      (a, b) {
        return PurchaseConstants.inAppProducts[a.id]!
            .compareTo(PurchaseConstants.inAppProducts[b.id]!);
      },
    );

    return Wrap(
      alignment: WrapAlignment.spaceEvenly,
      spacing: 10,
      runSpacing: 10,
      direction: Axis.horizontal,
      children: products.map((item) {
        return SizedBox(
          width: context.width / 2 - 15,
          child: InkWell(
            onTap: () {
              PurchaseHelper.instance.onTap(context, item);
            },
            borderRadius: const BorderRadius.all(
              Radius.circular(5),
            ),
            child: BuyItem(
              productDetails: item,
            ),
          ),
        );
      }).toList(),
    );
  }

  Widget buildSubWidget() {
    List<ProductDetails> products =
        context.watch<PurchaseCubit>().state.products;
    Iterable<ProductDetails> productsIterable = products.where((element) {
      return PurchaseConstants.subscriptions.keys.contains(element.id);
    });

    products = productsIterable.toList();
    products.sort(
      (a, b) {
        return PurchaseConstants.subscriptions[a.id]!
            .compareTo(PurchaseConstants.subscriptions[b.id]!);
      },
    );

    return ListView.separated(
      physics: const NeverScrollableScrollPhysics(),
      shrinkWrap: true,
      padding: const EdgeInsets.all(10),
      itemCount: products.length + 1,
      itemBuilder: (context, index) {
        return Container(
          decoration: BoxDecoration(
            color: Colors.lightGreen.withAlpha(150),
            borderRadius: index == 0
                ? const BorderRadius.vertical(
                    top: Radius.circular(10),
                  )
                : index == products.length
                    ? const BorderRadius.vertical(
                        bottom: Radius.circular(10),
                      )
                    : null,
          ),
          child: index == 0
              ? buildSubHeader()
              : InkWell(
                  onTap: () {
                    PurchaseHelper.instance.onTap(context, products[index - 1]);
                  },
                  borderRadius: index == products.length
                      ? const BorderRadius.vertical(
                          bottom: Radius.circular(10),
                        )
                      : null,
                  child: SubscribeItem(
                    productDetails: products[index - 1],
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
