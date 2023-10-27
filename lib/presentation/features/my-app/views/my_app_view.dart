import 'dart:io';

import 'package:device_preview/device_preview.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:upgrader/upgrader.dart';

import '../../../../core/base/views/base_app_lifecycle_view.dart';
import '../../../../core/constants/app/global_key_constants.dart';
import '../../../../core/constants/app/locale_constants.dart';
import '../../../../core/extensions/context_extension.dart';
import '../../../../utils/logic/config/router/config_router.dart';
import '../../../../utils/logic/constants/locale/locale_keys.g.dart';
import '../../../../utils/logic/helpers/package-info/package_info_helper.dart';
import '../../../../utils/logic/helpers/theme/theme_helper.dart';
import '../../../../utils/logic/state/bloc/designer-status/designer_status_bloc.dart';
import '../../../../utils/logic/state/bloc/sign/sign_bloc.dart';
import '../../../../utils/logic/state/bloc/theme/theme_bloc.dart';
import '../../../../utils/logic/state/cubit/home-tab/home_tab_cubit.dart';
import '../../../../utils/logic/state/cubit/network/network_cubit.dart';
import '../../../../utils/logic/state/cubit/purchase/purchase_cubit.dart';
import '../../../../utils/logic/state/cubit/ready/ready_cubit.dart';
import '../../../../utils/logic/state/cubit/settings/settings_cubit.dart';
import '../../../../utils/ui/config/theme/common/common_theme.dart';
import '../../../widgets/have_no.dart';
import '../view-models/my_app_view_model.dart';

class MyAppView extends StatelessWidget {
  MyAppView({super.key});

  final MyAppViewModel viewModel = MyAppViewModel();

  @override
  Widget build(BuildContext context) {
    return EasyLocalization(
      supportedLocales: LocaleConstants.supportedLocales,
      path: LocaleConstants.path,
      startLocale: kDebugMode ? LocaleConstants.trTR : null,
      fallbackLocale: LocaleConstants.enUS,
      child: MultiBlocProvider(
        providers: [
          BlocProvider(
            create: (_) => ThemeBloc(),
          ),
          BlocProvider(
            create: (_) => NetworkCubit(),
          ),
          BlocProvider(
            create: (_) => SignBloc(),
          ),
          BlocProvider(
            create: (_) => HomeTabCubit(),
          ),
          BlocProvider(
            create: (_) => ReadyCubit(),
          ),
          BlocProvider(
            create: (_) => PurchaseCubit(_),
          ),
          BlocProvider(
            create: (_) => SettingsCubit(),
          ),
          BlocProvider(
            create: (_) => DesignerStatusBloc(),
          ),
        ],
        child: DevicePreview(
          enabled: false, // kDebugMode
          builder: (context) => buildThemeBloc(),
        ),
      ),
    );
  }

  Widget buildThemeBloc() {
    return BlocBuilder<ThemeBloc, ThemeState>(
      buildWhen: (ThemeState previous, ThemeState current) {
        return previous != current;
      },
      builder: (BuildContext context, ThemeState state) {
        ThemeHelper.instance
            .setSystemUIOverlayStyleWithAppTheme(state.appTheme);

        return buildApp(context, state);
      },
    );
  }

  Widget buildApp(BuildContext context, ThemeState themeState) {
    return BaseAppLifeCycleView(
      child: MaterialApp(
        scrollBehavior: const ScrollBehavior().copyWith(overscroll: false),
        debugShowCheckedModeBanner: false,
        localizationsDelegates: context.localizationDelegates,
        supportedLocales: context.supportedLocales,
        locale: context.locale,
        themeMode: themeState.themeMode,
        theme: CommonTheme.instance.getTheme(
          appTheme: themeState.appTheme,
          themeMode: ThemeMode.dark,
        ),
        darkTheme: CommonTheme.instance.getTheme(
          appTheme: themeState.appTheme,
          themeMode: ThemeMode.dark,
        ),
        scaffoldMessengerKey: GlobalKeyConstants.scaffoldMessengerKey,
        navigatorKey: GlobalKeyConstants.navigatorKey,
        onGenerateRoute: ConfigRouter.instance.generateRoute,
        initialRoute: viewModel.getInitialRoute(),
        builder: (context, Widget? child) {
          return MediaQuery(
            data: context.mediaQuery.copyWith(
              textScaleFactor: context.textScaleFactor(baseWidth: 414),
            ),
            child: UpgradeAlert(
              upgrader: Upgrader(
                dialogStyle: Platform.isIOS
                    ? UpgradeDialogStyle.cupertino
                    : UpgradeDialogStyle.material,
                minAppVersion: PackageInfoHelper.instance.packageInfo?.version,
              ),
              child: buildNetworkCubit(context, child),
            ),
          );
        },
      ),
    );
  }

  Widget buildNetworkCubit(BuildContext context, Widget? child) {
    return BlocBuilder<NetworkCubit, NetworkState>(
      buildWhen: (NetworkState previous, NetworkState current) {
        return previous != current;
      },
      builder: (context, NetworkState state) {
        if (child == null) {
          return const SizedBox();
        }

        if (state is! NetworkInitial) {
          viewModel.initAndRemoveSplashScreen(context);
        }

        if (state is ConnectionSuccess) {
          return child;
        }

        if (state is ConnectionFailure) {
          //return buildNoInternetWidget();
          return child;
        }

        return const SizedBox();
      },
    );
  }

  Widget buildNoInternetWidget() {
    return Scaffold(
      body: HaveNo(
        description: LocaleKeys.noInternet.tr(),
        iconData: Icons.wifi_off_rounded,
      ),
    );
  }
}
