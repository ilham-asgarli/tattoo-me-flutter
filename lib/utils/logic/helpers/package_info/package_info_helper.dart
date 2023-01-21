import 'package:package_info_plus/package_info_plus.dart';

class PackageInfoHelper {
  static final PackageInfoHelper instance = PackageInfoHelper._init();

  PackageInfoHelper._init();

  PackageInfo? packageInfo;

  static Future<void> initPackageInfo() async {
    instance.packageInfo ??= await PackageInfo.fromPlatform();
  }
}
