import 'package:device_preview/device_preview.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_downloader/flutter_downloader.dart';
import 'package:flutter_native_splash/flutter_native_splash.dart';
import 'package:hydrated_bloc/hydrated_bloc.dart';
import 'package:path_provider/path_provider.dart';

import 'core/cache/shared_preferences_manager.dart';
import 'core/constants/app/locale_constants.dart';
import 'core/extensions/string_extension.dart';
import 'firebase_options.dart';
import 'presentation/features/my-app/views/my_app_view.dart';
import 'utils/logic/constants/env/env_constants.dart';
import 'utils/logic/helpers/downloader/downloader_helper.dart';
import 'utils/logic/helpers/package-info/package_info_helper.dart';
import 'utils/logic/state/bloc/designer-status/designer_status_bloc.dart';
import 'utils/logic/state/bloc/sign/sign_bloc.dart';
import 'utils/logic/state/bloc/theme/theme_bloc.dart';
import 'utils/logic/state/cubit/home-tab/home_tab_cubit.dart';
import 'utils/logic/state/cubit/network/network_cubit.dart';
import 'utils/logic/state/cubit/purchase/purchase_cubit.dart';
import 'utils/logic/state/cubit/ready/ready_cubit.dart';
import 'utils/logic/state/cubit/settings/settings_cubit.dart';

void main() async {
  WidgetsBinding widgetsBinding = WidgetsFlutterBinding.ensureInitialized();
  FlutterNativeSplash.preserve(widgetsBinding: widgetsBinding);
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  await EasyLocalization.ensureInitialized();
  await SharedPreferencesManager.preferencesInit();
  await dotenv.load(fileName: EnvConstants.encrypt.toEnv);
  await PackageInfoHelper.initPackageInfo();
  await FlutterDownloader.initialize(debug: kDebugMode);
  await FlutterDownloader.registerCallback(
    DownloaderHelper.downloadCallback,
  );

  HydratedBloc.storage = await HydratedStorage.build(
    storageDirectory: kIsWeb
        ? HydratedStorage.webStorageDirectory
        : await getApplicationDocumentsDirectory(),
  );

  runApp(app());
}

Widget app() {
  return EasyLocalization(
    supportedLocales: LocaleConstants.supportedLocales,
    path: LocaleConstants.path,
    startLocale: kDebugMode ? LocaleConstants.esES : null,
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
        enabled: false, //!kReleaseMode
        builder: (context) => MyAppView(),
      ),
    ),
  );
}
