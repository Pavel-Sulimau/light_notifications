import 'dart:async';

import 'package:flutter/material.dart' hide Notification;
import 'package:notifications_interface/notifications_interface.dart';
import 'package:overlay_support/overlay_support.dart';

import 'notification_ui_strategy.dart';

class NotificationOverlay extends StatefulWidget {
  const NotificationOverlay({
    Key? key,
    required this.child,
    required this.notifier,
    this.notificationUIStrategy = defaultNotificationUIStrategy,
  }) : super(key: key);

  final Widget child;
  final Notifier notifier;
  final NotificationUIStrategy notificationUIStrategy;

  @override
  _NotificationOverlayState createState() => _NotificationOverlayState();
}

class _NotificationOverlayState extends State<NotificationOverlay> {
  late StreamSubscription<Notification> _notificationsSubscription;

  @override
  void initState() {
    super.initState();
    _notificationsSubscription = widget.notifier.notifications.listen(_showNotification);
  }

  @override
  void dispose() {
    _notificationsSubscription.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) => OverlaySupport(
        child: Builder(
          builder: (context) => widget.child,
        ),
      );

  void _showNotification(Notification appNotification) {
    late OverlaySupportEntry overlay;

    final strategy = widget.notificationUIStrategy(appNotification);

    overlay = showOverlay(
      (context, t) {
        final showAtTop = strategy.settings.place == NotificationPlace.top;

        final notification = showAtTop
            ? TopSlideNotification(
                builder: (context) => strategy.widgetBuilder(context),
                progress: t,
              )
            : BottomSlideNotification(
                builder: (context) => strategy.widgetBuilder(context),
                progress: t,
              );

        return Stack(
          children: [
            if (!appNotification.dismissible)
              Positioned.fill(
                child: GestureDetector(
                  behavior: HitTestBehavior.opaque,
                ),
              ),
            Positioned(
              left: 0.0,
              top: showAtTop ? 0.0 : null,
              bottom: showAtTop ? null : 0.0,
              right: 0.0,
              child: appNotification.dismissible
                  ? Dismissible(
                      direction: showAtTop ? DismissDirection.up : DismissDirection.down,
                      onDismissed: (_) => overlay.dismiss(animate: false),
                      key: ModalKey(appNotification.hashCode),
                      child: notification,
                    )
                  : notification,
            ),
          ],
        );
      },
      duration: strategy.settings.presenceTime,
      key: ModalKey(appNotification.hashCode),
    );
  }
}
