import 'dart:async';

import 'package:equatable/equatable.dart';

class Notifier {
  factory Notifier() => _instance;
  Notifier._();

  static final Notifier _instance = Notifier._();
  final _notificationStreamController = StreamController<Notification>.broadcast();

  Stream<Notification> get notifications => _notificationStreamController.stream;

  void send(Notification notification) => _notificationStreamController.add(notification);

  void dispose() => _notificationStreamController.close();
}

class Notification extends Equatable {
  const Notification({
    required this.level,
    required this.text,
    this.dismissible = true,
  });

  final NotificationLevel level;
  final String text;
  final bool dismissible;

  @override
  List<Object?> get props => [level, text, dismissible];
}

enum NotificationLevel {
  info,
  warning,
  error,
}
