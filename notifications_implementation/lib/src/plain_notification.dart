import 'package:flutter/material.dart';
import 'package:notifications_interface/notifications_interface.dart';

class PlainNotification extends StatelessWidget {
  const PlainNotification({
    Key? key,
    required this.notification,
  }) : super(key: key);

  final AppNotification notification;

  @override
  Widget build(BuildContext context) {
    return Material(
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(8.0),
          color: Colors.green,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text(notification.text),
          ],
        ),
      ),
    );
  }
}
