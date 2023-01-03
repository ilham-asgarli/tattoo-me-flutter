import 'package:flutter_downloader/flutter_downloader.dart';

class DownloaderHelper {
  static final DownloaderHelper instance = DownloaderHelper._init();

  DownloaderHelper._init();

  static void downloadCallback(
      String id, DownloadTaskStatus status, int progress) {}
}
