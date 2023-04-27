import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';

class FCMService {
  static final FCMService instance = FCMService._init();

  FCMService._init();

  final FirebaseMessaging _messaging = FirebaseMessaging.instance;

  Future<void> registerNotification() async {
    NotificationSettings settings = await _messaging.requestPermission();

    if (settings.authorizationStatus == AuthorizationStatus.authorized) {
      FirebaseMessaging.onMessage.listen((event) {
        print(event.notification?.title);
        print(event.notification?.body);
      });
    }
  }
}

@pragma('vm:entry-point')
Future<void> firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  await Firebase.initializeApp();
}
