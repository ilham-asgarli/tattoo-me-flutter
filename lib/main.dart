import 'package:device_preview/device_preview.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_native_splash/flutter_native_splash.dart';
import 'package:hydrated_bloc/hydrated_bloc.dart';
import 'package:path_provider/path_provider.dart';
import 'package:tattoo/core/extensions/string_extension.dart';
import 'package:tattoo/utils/logic/constants/env/env_constants.dart';
import 'package:tattoo/utils/logic/state/bloc/sign/sign_bloc.dart';
import 'package:tattoo/utils/logic/state/cubit/home-tab/home_tab_cubit.dart';

import 'core/cache/shared_preferences_manager.dart';
import 'core/constants/app/locale_constants.dart';
import 'firebase_options.dart';
import 'presentation/features/my-app/views/my_app_view.dart';
import 'utils/logic/state/bloc/theme/theme_bloc.dart';
import 'utils/logic/state/cubit/network/network_cubit.dart';

void main() async {
  WidgetsBinding widgetsBinding = WidgetsFlutterBinding.ensureInitialized();
  FlutterNativeSplash.preserve(widgetsBinding: widgetsBinding);
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  await EasyLocalization.ensureInitialized();
  await SharedPreferencesManager.preferencesInit();
  await dotenv.load(fileName: EnvConstants.encrypt.toEnv);

  final storage = await HydratedStorage.build(
    storageDirectory: kIsWeb
        ? HydratedStorage.webStorageDirectory
        : await getApplicationDocumentsDirectory(),
  );
  HydratedBlocOverrides.runZoned(
    () => runApp(
      app(),
    ),
    storage: storage,
  );
}

Widget app() {
  return EasyLocalization(
    supportedLocales: LocaleConstants.supportedLocales,
    path: LocaleConstants.path,
    startLocale: LocaleConstants.trTR,
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
      ],
      child: DevicePreview(
        enabled: false, //!kReleaseMode
        builder: (context) => MyAppView(),
      ),
    ),
  );
}
