import 'package:flutter_local_notifications/flutter_local_notifications.dart';

import 'notification_model.dart';

class LocaleNotificationsHelper {
  static LocaleNotificationsHelper instance = LocaleNotificationsHelper._init();

  LocaleNotificationsHelper._init();

  final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
      FlutterLocalNotificationsPlugin();

  AndroidNotificationChannel androidNotificationChannel =
      const AndroidNotificationChannel(
    'tattoo_me',
    'Tattoo Me',
    importance: Importance.max,
  );

  Future<void> init({
    Function(NotificationResponse)? onDidReceiveNotificationResponse,
    Function(NotificationResponse)? onDidReceiveBackgroundNotificationResponse,
    Function(NotificationResponse)? onNotificationAppLaunchDetails,
  }) async {
    const AndroidInitializationSettings initializationSettingsAndroid =
        AndroidInitializationSettings("@mipmap/ic_launcher");
    const DarwinInitializationSettings initializationSettingsDarwin =
        DarwinInitializationSettings();
    const InitializationSettings initializationSettings =
        InitializationSettings(
      android: initializationSettingsAndroid,
      iOS: initializationSettingsDarwin,
    );

    await flutterLocalNotificationsPlugin.initialize(
      initializationSettings,
      onDidReceiveNotificationResponse: onDidReceiveNotificationResponse,
      onDidReceiveBackgroundNotificationResponse:
          onDidReceiveBackgroundNotificationResponse,
    );

    final NotificationAppLaunchDetails? notificationAppLaunchDetails =
        await flutterLocalNotificationsPlugin.getNotificationAppLaunchDetails();
    final didNotificationLaunchApp =
        notificationAppLaunchDetails?.didNotificationLaunchApp ?? false;

    if (didNotificationLaunchApp && onNotificationAppLaunchDetails != null) {
      onNotificationAppLaunchDetails(
        notificationAppLaunchDetails!.notificationResponse!,
      );
    }

    await flutterLocalNotificationsPlugin
        .resolvePlatformSpecificImplementation<
            AndroidFlutterLocalNotificationsPlugin>()
        ?.createNotificationChannel(androidNotificationChannel);
  }

  void showNotification(
    NotificationModel? notification, {
    String? payload,
  }) async {
    if (notification != null) {
      flutterLocalNotificationsPlugin.show(
        notification.id,
        notification.title,
        notification.body,
        NotificationDetails(
          android: AndroidNotificationDetails(
            androidNotificationChannel.id,
            androidNotificationChannel.name,
            icon: notification.android?.smallIcon ?? "@mipmap/ic_launcher",
          ),
        ),
        payload: payload,
      );
    }
  }
}
