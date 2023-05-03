import 'dart:convert';
import 'dart:ui' as ui;

import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:permission_handler/permission_handler.dart';

import '../../../../core/base/models/base_response.dart';
import '../../../../core/base/models/base_success.dart';
import '../../../../core/router/core/router_service.dart';
import '../../../../domain/models/design-response/design_response_model.dart';
import '../../../../domain/repositories/design-responses/implementations/get_design_response_repository.dart';
import '../../../../firebase_options.dart';
import '../../constants/router/router_constants.dart';
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
    Permission.notification.request();

    if (settings.authorizationStatus == AuthorizationStatus.authorized) {
      await LocaleNotificationsHelper.instance.init(
        onDidReceiveNotificationResponse: onTap,
        onDidReceiveBackgroundNotificationResponse: onTap,
        onNotificationAppLaunchDetails: onTap,
      );

      FirebaseMessaging.onMessage.listen((message) {
        LocaleNotificationsHelper.instance.showNotification(
          getNotification(message),
          payload: json.encode(message.data),
        );
      });

      //FirebaseMessaging.onMessageOpenedApp.listen((message) async {});

      /*RemoteMessage? initialMessage = await _messaging.getInitialMessage();
      if (initialMessage != null) {}*/
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
          notificationModel.title = "Your tattoo design is complete!";
          notificationModel.body = "Do you want to see it?";
          break;
        case 'tr':
          notificationModel.title = "Dövme tasarımınız hazırlandı!";
          notificationModel.body = "Görmek ister misiniz?";
          break;
        default:
          notificationModel.title = "Your tattoo design is complete!";
          notificationModel.body = "Do you want to see it?";
          break;
      }
    }

    return notificationModel;
  }
}

@pragma('vm:entry-point')
Future<void> onTap(NotificationResponse notificationResponse) async {
  GetDesignResponseRepository getDesignResponseRepository =
      GetDesignResponseRepository();
  BaseResponse<DesignResponseModel> baseResponse =
      await getDesignResponseRepository.getDesignResponse(
          json.decode(notificationResponse.payload ?? "")["designResponseId"]);

  if (baseResponse is BaseSuccess<DesignResponseModel>) {
    RouterService.instance.pushNamedAndRemoveUntil(
      path: RouterConstants.photo,
      data: baseResponse.data,
      removeUntilPageName: RouterConstants.home,
    );
  }
}

@pragma('vm:entry-point')
Future<void> firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);

  LocaleNotificationsHelper.instance.showNotification(
    FCMService.instance.getNotification(message),
    payload: json.encode(message.data),
  );
}
