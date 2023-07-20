class NotificationModel {
  int id;

  String? title;
  String? body;
  Android? android;

  NotificationModel({
    required this.id,
    this.title,
    this.body,
    this.android,
  });
}

class Android {
  String? smallIcon;

  Android({this.smallIcon});
}
