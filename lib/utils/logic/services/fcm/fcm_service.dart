import 'dart:ui' as ui;

import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';

import '../../../../firebase_options.dart';
import '../../helpers/locale_notifications/locale_notifications_helper.dart';
import '../../helpers/locale_notifications/notification_model.dart';

class FCMService {
  static final FCMService instance = FCMService._init();

  FCMService._init();

  final FirebaseMessaging _messaging = FirebaseMessaging.instance;

  Future<void> registerNotification() async {
    _messaging.setForegroundNotificationPresentationOptions(
      alert: true,
      badge: true,
      sound: true,
    );

    NotificationSettings settings = await _messaging.requestPermission();

    if (settings.authorizationStatus == AuthorizationStatus.authorized) {
      FirebaseMessaging.onMessage.listen((message) {
        LocaleNotificationsHelper.instance.showNotification(
          getNotification(message),
        );
      });

      FirebaseMessaging.onMessageOpenedApp.listen((message) {});

      RemoteMessage? initialMessage = await _messaging.getInitialMessage();
      if (initialMessage != null) {}
    }

    FirebaseMessaging.onBackgroundMessage(
      firebaseMessagingBackgroundHandler,
    );
  }

  NotificationModel getNotification(RemoteMessage message) {
    NotificationModel notificationModel = NotificationModel(
      id: message.data.hashCode,
    );

    if (message.data["type"] == "design_finished") {
      String locale = ui.window.locale.languageCode;
      switch (locale) {
        case 'en':
          notificationModel.title = "Your design is complete!";
          notificationModel.body = "Do you want to see it?";
          break;
        case 'tr':
          notificationModel.title = "Tasarımınız hazırlandı!";
          notificationModel.body = "Görmek ister misiniz?";
          break;
        default:
          notificationModel.title = "Your design is complete!";
          notificationModel.body = "Do you want to see it?";
          break;
      }
    }

    return notificationModel;
  }
}

@pragma('vm:entry-point')
Future<void> firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);

  await LocaleNotificationsHelper.instance.init();
  LocaleNotificationsHelper.instance.showNotification(
    FCMService.instance.getNotification(message),
  );
}
