import 'package:flutter/widgets.dart' hide Notification;
import 'package:notifications_interface/notifications_interface.dart';

import 'plain_notification.dart';

typedef NotificationUIStrategy = NotificationUI Function(Notification);

class NotificationUI {
  NotificationUI(this.widgetBuilder, this.settings);

  final WidgetBuilder widgetBuilder;
  final NotificationSettings settings;
}

class NotificationSettings {
  NotificationSettings({
    this.presenceTime = const Duration(seconds: 5),
    this.place = NotificationPlace.bottom,
  });

  final Duration presenceTime;
  final NotificationPlace place;
}

enum NotificationPlace {
  bottom,
  top,
}

NotificationUI defaultNotificationUIStrategy(Notification notification) {
  return NotificationUI(
    (BuildContext buildContext) => PlainNotification(notification: notification),
    NotificationSettings(),
  );
}
