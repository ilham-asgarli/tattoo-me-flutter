import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../core/extensions/context_extension.dart';
import '../../../../core/extensions/widget_extension.dart';

import '../../../../utils/logic/constants/locale/locale_keys.g.dart';
import '../../../../utils/logic/state/cubit/home-tab/home_tab_cubit.dart';

class EmptyView extends StatelessWidget {
  const EmptyView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            LocaleKeys.nothingYetHere.tr(),
            textAlign: TextAlign.center,
            style: const TextStyle(
              fontWeight: FontWeight.w500,
              fontSize: 20,
            ),
          ),
          context.widget.verticalSpace(10),
          SizedBox(
            width: context.width / 1.5,
            child: Text(
              LocaleKeys.readyDescription.tr(),
              textAlign: TextAlign.center,
            ),
          ),
          context.widget.verticalSpace(10),
          buildAddPhoto(context),
        ],
      ),
    );
  }

  Widget buildAddPhoto(BuildContext context) {
    return ElevatedButton.icon(
      style: ButtonStyle(
        fixedSize: MaterialStateProperty.all(
          Size.fromWidth(context.width / 2),
        ),
        backgroundColor: MaterialStateProperty.all<Color>(Colors.white),
        shape: MaterialStateProperty.all<RoundedRectangleBorder>(
          RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(18.0),
          ),
        ),
      ),
      onPressed: () {
        BlocProvider.of<HomeTabCubit>(context).changeTab(0);
      },
      icon: const Icon(
        Icons.add,
        color: Colors.black,
        size: 20,
      ),
      label: Text(
        LocaleKeys.choosePhoto.tr(),
        style: const TextStyle(color: Colors.black),
      ),
    );
  }
}
