import 'package:easy_localization/easy_localization.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_downloader/flutter_downloader.dart';
import 'package:flutter_native_splash/flutter_native_splash.dart';
import 'package:hydrated_bloc/hydrated_bloc.dart';
import 'package:path_provider/path_provider.dart';

import 'core/cache/shared_preferences_manager.dart';
import 'core/extensions/string_extension.dart';
import 'firebase_options.dart';
import 'presentation/features/my-app/views/my_app_view.dart';
import 'utils/logic/constants/env/env_constants.dart';
import 'utils/logic/helpers/downloader/downloader_helper.dart';
import 'utils/logic/helpers/package-info/package_info_helper.dart';

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

  runApp(MyAppView());
}
