part of 'notifications_bloc.dart';

abstract class NotificationsEvent extends Equatable {
  const NotificationsEvent();

  @override
  List<Object?> get props => [];
}

class LoadNotifications extends NotificationsEvent {
  const LoadNotifications();
}

class MarkAsRead extends NotificationsEvent {
  final String notificationId;

  const MarkAsRead(this.notificationId);

  @override
  List<Object> get props => [notificationId];
}

class GetFCMToken extends NotificationsEvent {
  const GetFCMToken();
}

